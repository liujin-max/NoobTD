using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

//Bundle处理器:
//1. 管理bundle缓存
//-当关联的AssetTracker没有被销毁时, 对应的AssetBundle也始终存在

//2. 之后可能会添加一些复杂的规则, 负责处理AssetBundle的存在时间
//-例如Common类的, 存在时间较长

//这个Manager, lua代码并不直接操作

namespace NoobTD
{
    public class BundleManager : MonoBehaviour, IManager
    {
        public static float RECYCLE_TIME = 20 * 60f;    //初始是10分钟回收一次

        private float _Last_Recycle_Stamp = 0;

        public delegate void BundleLoadCallback(AssetBundle bundle);
        //通过查询路径 => 找到对应的Bundle
        private Dictionary<string, BundleRoute> _PrefabPathSearcher = new Dictionary<string, BundleRoute>();

        //记录AssetBundle的缓存
        //string: 对应的Bundle加载路径
        private Dictionary<string, BundleContainer> _BundleCache = new Dictionary<string, BundleContainer>();

        //string: 场景对应的Bundle Cache
        private Dictionary<string, AssetBundle> _SceneCache = new Dictionary<string, AssetBundle>();

        //总体的Manifest
        private AssetBundleManifest _Manifest = null;
        
        private class BundleRoute
        {
            private string _route_path  = null;
            private string _bundle_name = null;
            private bool   _exist_streaming = false;

            public BundleRoute(string route_path, string bundle_name, bool exist)
            {
                this._route_path        = route_path;
                this._bundle_name       = bundle_name;
                this._exist_streaming   = exist;
            }

            public string GetBundleName()
            {
                return this._bundle_name;
            }

            public string GetWWWBundlePath()
            {
                string path = GetPersistentPath() + "/AssetBundles/" + this._bundle_name;
                if(System.IO.File.Exists(path) == true)
                {
#if UNITY_EDITOR
                    return "file:///" + path;
#else
                    return "file://" + path;
#endif
                }
                else if (this._exist_streaming == true)
                {
#if UNITY_ANDROID && !UNITY_EDITOR
                    return GetStreamingPath() + "AssetBundles/" + this._bundle_name;
#elif UNITY_EDITOR
                    return "file:///" + GetStreamingPath() + "AssetBundles/" + this._bundle_name;
#else
                    return "file://" + GetStreamingPath() + "AssetBundles/" + this._bundle_name;
#endif
                }
                else
                {
                    Debug.LogError("AssetBundle Not Exist " + this._bundle_name);
                    return null;
                }
            }
            
            public string GetBundlePath()
            {
                string path = GetPersistentPath() + "/AssetBundles/" + this._bundle_name;
                if(System.IO.File.Exists(path) == true)
                {
                    return path;
                }
                else if (this._exist_streaming == true)
                {
                    return GetStreamingPath() + "AssetBundles/" + this._bundle_name;
                }
                else
                {
                    Debug.LogError("AssetBundle Not Exist " + this._bundle_name);
                    return null;
                }
            }
        }

        public class BundleContainer
        {
            private List<AssetManager.AssetTracker> _linked_assets = new List<AssetManager.AssetTracker>();
            //Path作为Key
            private string _path = null;        
            //对应的AssetBundle
            private AssetBundle _bundle = null;
            //是否被依赖
            private List<string> _Dependented = new List<string>();
           

            public BundleContainer(string path, AssetBundle bundle)
            {
                this._path      = path;
                this._bundle    = bundle;
            }

            public AssetBundleRequest LoadAsync(string route)
            {
                var sections = route.Split('/', '\\');
                return _bundle.LoadAssetAsync(sections[sections.Length - 1]);
            }

            public UnityEngine.Object Load(string route)
            {
               var sections = route.Split('/', '\\');
               return _bundle.LoadAsset(sections[sections.Length - 1]);
            }

            public UnityEngine.Sprite LoadSprite(string route)
            {
                var sections = route.Split('/', '\\');
                return _bundle.LoadAsset<Sprite>(sections[sections.Length - 1]);
            }

            public void AddLinkedAsset(AssetManager.AssetTracker tracker)
            {
                _linked_assets.Add(tracker);
            }

            public void AddRefCount(string bundle_name)
            {
                if(_Dependented.Contains(bundle_name) == false)
                {
                    _Dependented.Add(bundle_name);
                }
            }

            public void RemoveRefCount(string bundle_name)
            {
                _Dependented.Remove(bundle_name);
            }

            //查看是否没有相关的引用了
            public bool CheckEmpty()
            {
                for(int i = _linked_assets.Count - 1; i >= 0; i--)
                {
                    var asset = _linked_assets[i];
                    if(asset.Trashed == true)
                    {
                        _linked_assets.Remove(asset);
                    }
                }

                //Debug.Log("RECYCLE KEY ==>" + this._path + " " + _Dependented + " " + _linked_assets.Count);

                return _linked_assets.Count == 0 && _Dependented.Count == 0;
            }
            
            public void Dispose(bool unloadAll = false)
            {
                this._bundle.Unload(unloadAll);
            }
        }

        private const string MATCHER_PATH = "PathMatcher.txt";
        //=====> 加载PathMatcher,  用于指导路径与bundle的对应关系
        public IEnumerator LoadSearcher()
        {
            string final_path = null;
            string path_1st = "file:///" + Application.persistentDataPath + "/" + MATCHER_PATH;
#if UNITY_ANDROID && !UNITY_EDITOR
            string path_2nd =  NoobTD.FileUtility.StreamingPath() + MATCHER_PATH;
#else
            string path_2nd = "file://" + NoobTD.FileUtility.StreamingPath() + MATCHER_PATH;

#endif
            final_path = (System.IO.File.Exists(Application.persistentDataPath + "/" + MATCHER_PATH) == true) ? path_1st : path_2nd;  //=>最终版本路径

            WWW www = new WWW(final_path);
            yield return www;

            if (www.error != null)
            {
                Debug.LogError("Reading " + final_path + " Error " + www.error);
            }

            if (www.isDone == true)
            {
                string text = www.text;
                text = text.Replace("\r", "");

                var lines = text.Split('\n');

                foreach (string line in lines)
                {
                    if (string.IsNullOrEmpty(line) == false)
                    {
                        string[] sections = line.Split('|');
                        if(sections.Length == 3)
                        {
                            bool exist = int.Parse(sections[2]) == 1;
                            BundleRoute br = new BundleRoute(sections[0], sections[1], exist);
                            // Debug.Log("_PrefabPathSearcher add " + sections[0]);
                            _PrefabPathSearcher.Add(sections[0], br);
                        }
                    }
                }
            }

            yield return null;
        }

        //Init的执行, 需要等待GameLogicManager处理完毕, 热更完成/判断出无热更
        public void Init()
        {
            if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
            {
                var p_path = GetPersistentPath() + "/AssetBundles/AssetBundles";

                if (System.IO.File.Exists(p_path) == true)
                {
                    AssetBundle manifestAB = AssetBundle.LoadFromFile(p_path);
                    _Manifest = manifestAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
                }
                else
                {
                    var s_path = GetStreamingPath() + "AssetBundles/AssetBundles";

                    AssetBundle manifestAB = AssetBundle.LoadFromFile(s_path);
                    _Manifest = manifestAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
                }
            }

            _Last_Recycle_Stamp = Time.realtimeSinceStartup;
        }

        //=====> 同步加载
        public BundleContainer LoadSync(string route_path)
        {
            if(_PrefabPathSearcher.ContainsKey(route_path) == false)
            {
                Debug.Log("<color=red>AssetBundle Route Not Found: " + route_path + "</color>");
                return null;
            }

            BundleRoute br  = _PrefabPathSearcher[route_path];
            var bundle_name = br.GetBundleName();

            if (_BundleCache.ContainsKey(bundle_name) == false)
            {
                var path = br.GetBundlePath();
                AssetBundle ab = AssetBundle.LoadFromFile(path);
                BundleContainer con = new BundleContainer(path, ab);
                _BundleCache.Add(bundle_name, con);

                //获取所有的依赖
                string[] deps = _Manifest.GetAllDependencies(bundle_name);

                //Debug.Log("Load Bundle " + bundle_name + " " + path + " " + deps.Length);


                foreach (string dep_name in deps)
                {
                    if (_BundleCache.ContainsKey(dep_name) == false)
                    {
                        string dep_path = GetBundlePath(dep_name);
                        //Debug.Log("Load Dep Bundle " + dep_name + " " + dep_path);
                        AssetBundle dep_ab = AssetBundle.LoadFromFile(dep_path);
                        BundleContainer dep_con = new BundleContainer(dep_path, dep_ab);

                        _BundleCache.Add(dep_name, dep_con);
                    }
                    _BundleCache[dep_name].AddRefCount(bundle_name);

                }

                return con;
            }
            else
            {
                return _BundleCache[bundle_name];
            }
        }

        //=====> 异步加载
        public IEnumerator LoadAsync(string route_path, BundleLoadCallback callback)
        {
            yield return null;
        }

        private bool _DelayRecycle = false;

        private void Update()
        {
            if(_DelayRecycle == true)
            {
                if (GameFacade.Instance.AssetManager.RequestCache.Count == 0)
                {
                    Recycle();
                    _DelayRecycle = false;
                }
            }
        }

        public void Recycle()
        {
            var current_stamp = Time.realtimeSinceStartup;
            if(GameFacade.Instance.AssetManager.RequestCache.Count > 0)
            {
                _DelayRecycle = true;
                return;
            }

            if(current_stamp - _Last_Recycle_Stamp < RECYCLE_TIME)
            {
                return;
            }
            else
            {
                current_stamp = _Last_Recycle_Stamp;
            }

            List<string> keys = new List<string>();
            foreach(var pair in _BundleCache)
            {
                var container = pair.Value;
                if(container.CheckEmpty() == true)
                {
                    keys.Add(pair.Key);
                }
            }

            foreach(string key in keys)
            {
                string bundle_name = key;
                _BundleCache[bundle_name].Dispose(true);
                _BundleCache.Remove(bundle_name);
                //Debug.Log("Unload Bundle " + bundle_name);

                //清理依赖
                string[] deps = _Manifest.GetAllDependencies(bundle_name);
                foreach (string dep_name in deps)
                {
                    if (_BundleCache.ContainsKey(dep_name) == true)
                    {
                        _BundleCache[dep_name].RemoveRefCount(bundle_name);
                        if(_BundleCache[dep_name].CheckEmpty() == true)
                        {
                            _BundleCache[dep_name].Dispose(true);
                            _BundleCache.Remove(dep_name);
                            //Debug.Log("--- Unload Dep Bundle " + dep_name);

                        }
                    }
                }
            }
            keys.Clear();
        }

        public void UnloadScene(string scene_name)
        {
            if (_SceneCache.ContainsKey(scene_name) == true)
            {
                var bundle = _SceneCache[scene_name];
                //Debug.Log("Scene_Name " + scene_name);
                bundle.Unload(true);
                _SceneCache.Remove(scene_name);

                if (_PrefabPathSearcher.ContainsKey(scene_name) == true)
                {
                    BundleRoute br = _PrefabPathSearcher[scene_name];
                    var bundle_name = br.GetBundleName();
                    string[] deps = _Manifest.GetAllDependencies(bundle_name);
                    foreach (string dep_name in deps)
                    {
                        if (_BundleCache.ContainsKey(dep_name) == true)
                        {
                            _BundleCache[dep_name].RemoveRefCount(scene_name);
                        }
                    }
                }
            }
        }

        public IEnumerator LoadScene(string scene_name)
        {
            if (_PrefabPathSearcher.ContainsKey("Scenes/" + scene_name) == true)
            {
                BundleRoute br = _PrefabPathSearcher["Scenes/" + scene_name];
                var bundle_name = br.GetBundleName();

                //获取所有的依赖
                string[] deps = _Manifest.GetAllDependencies(bundle_name);
                foreach (string dep_name in deps)
                {
                    if(_BundleCache.ContainsKey(dep_name) == false)
                    {
                        string dep_path = GetBundlePath(dep_name);
                        AssetBundle ab = AssetBundle.LoadFromFile(dep_path);

                        BundleContainer con = new BundleContainer(dep_path, ab);
                        _BundleCache.Add(dep_name, con);
                    }
                    _BundleCache[dep_name].AddRefCount(bundle_name);
                }

                Debug.Log("=== LOAD SCENE === " + scene_name); 
                WWW bundle = new WWW(br.GetWWWBundlePath());
                yield return bundle;
                if (bundle.error != null)
                {
                    Debug.Log("Bundle Error " + bundle.error);
                }
                if (bundle.isDone == true)
                {
                    var ab = bundle.assetBundle;
                    _SceneCache.Add(scene_name, ab);
                    bundle.Dispose();
                    yield return null;
                }
            }
            else
            {
                yield return null;
            }
        }

        public static string GetBundlePath(string bundle_name)
        {
            var p_path = GetPersistentPath() + "/AssetBundles/" + bundle_name;
            if(System.IO.File.Exists(p_path) == true)
            {
                return p_path;
            }
            return GetStreamingPath() + "AssetBundles/" + bundle_name;
        }

        public static string GetPersistentPath()
        {
#if UNITY_EDITOR
            return  Application.persistentDataPath;
#elif UNITY_ANDROID && !UNITY_EDITOR
            return  Application.persistentDataPath;
#else
            return  Application.persistentDataPath;
#endif
        }

        public static string GetStreamingPath()
        {
#if UNITY_EDITOR
            return Application.streamingAssetsPath + "/";
#elif UNITY_ANDROID && !UNITY_EDITOR
            return Application.streamingAssetsPath + "/";
#else
            return Application.streamingAssetsPath + "/";
#endif
        }
    }
}

