using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

//目前版本：
//1. 支持Sync和Async两种模式;
//2. 拥有一个接口，定期清理数据, UnloadUnusedAssets

namespace NoobTD
{

    public class AssetManager : MonoBehaviour, IManager
    {
        public delegate void OnLoadCallback(Object asset);
        public bool IsDebugMode = false;

        private float _LastTimeStamp = 0;

        private void Awake()
        {
            _LastTimeStamp = Time.realtimeSinceStartup;
        }

        //加载请求
        public class AssetLoadRequest
        {
            private string _route = null;                         //路由, 其实就是加载路径
            private List<OnLoadCallback> _callbacks = new List<OnLoadCallback>();   //回调函数


            //路由信息
            public string Route
            {
                get { return _route; }
            }

            public AssetLoadRequest(string route)
            {
                this._route = route;
            }

            public void AddCallback(OnLoadCallback callback)
            {
                this._callbacks.Add(callback);
            }

            public List<OnLoadCallback> GetCallbacks()
            {
                return this._callbacks;
            }

            public void Clear()
            {
                this._callbacks.Clear();
            }
        }

        //资源加载的追踪器
        public class AssetTracker
        {
            //#########################     PRIVATE     ########################/
            private Object _asset = null;                     //最终加载到的资源
            private string _route = null;                     //路由, 其实就是加载路径

            //使用时所产生的实例，或者是_asset所附着的obj, 一旦这个表为空, 说明当前没有引用
            private List<GameObject> _references = new List<GameObject>();

            //##########################    PUBLIC  ########################/
            //被加载出来的对象
            public Object Asset
            {
                get { return _asset; }
            }

            //路由信息
            public string Route
            {
                get { return _route; }
            }

            private bool _Trashed = false;
            public bool Trashed
            {
                get
                {
                    return _Trashed;
                }
            }

            //引用计数
            public int RefCount
            {
                get
                {
                    for (int i = _references.Count - 1; i >= 0; i--)
                    {
                        if (_references[i] == null)
                        {
                            _references.RemoveAt(i);
                        }
                    }
                    return _references.Count;
                }
            }

            public List<GameObject> GetReferences()
            {
                return _references;
            }

            public void MarkAsTrashed()
            {
                _Trashed = true;
            }

            public GameObject AddReference()
            {
                if (this.Asset == null) Debug.LogError("NULL ! " + this._route);
                GameObject instance = GameObject.Instantiate(this.Asset) as GameObject;
                _references.Add(instance);
                return instance;
            }

            public GameObject AddAtlasRef(string tag)
            {
                GameObject taggloo = new GameObject(tag);
                UnityEngine.Object.DontDestroyOnLoad(taggloo);

                _references.Add(taggloo);
                return taggloo;
            }

            public List<GameObject> GetGlooRefs()
            {
                return _references;
            }

            public void ClearGloo()
            {
                _references.Clear();
            }

            public void RemoveGloo(GameObject gloo)
            {
                if (gloo == null)
                {
                    //Debug.LogError("Gloo is null " + this.Route);
                    return;
                }

                if (_references.Contains(gloo) == false)
                {
                    //Debug.LogError("Not Found GLOO " + gloo.name + " " + this.Route);
                }
                else
                {
                    //Debug.Log("ASSET Remove GLOO " + gloo.name + " " + this.Route);
                    _references.Remove(gloo);
                }
            }

            public void AddGloo(GameObject gloo)
            {
                if (_references.Contains(gloo) == false)
                    _references.Add(gloo);
            }

            public AssetTracker(string route, Object asset)
            {
                this._route = route;
                this._asset = asset;
            }
        }

        public Dictionary<string, AssetLoadRequest> RequestCache = new Dictionary<string, AssetLoadRequest>();
        private Dictionary<string, AssetTracker> AssetCache = new Dictionary<string, AssetTracker>();
        //<HashCode, sprite_res>
        private Dictionary<int, List<string>> NoAtlasRef = new Dictionary<int, List<string>>();


        private IEnumerator AsyncProcess(string route, OnLoadCallback callback)
        {
            if (AssetCache.ContainsKey(route))
            {
                AssetTracker tracker = AssetCache[route];
                if (callback != null)
                {
                    callback(tracker.AddReference());
                }
                yield break;
            }
            else if (RequestCache.ContainsKey(route) == true)
            {
                AssetLoadRequest request = RequestCache[route];
                if (callback != null)
                {
                    request.AddCallback(callback);
                }
            }
            else
            {
                BundleManager.BundleContainer container = GameFacade.Instance.BundleManager.LoadSync(route);
                AssetBundleRequest asset_request = container.LoadAsync(route);
                AssetLoadRequest load_request = new AssetLoadRequest(route);
                RequestCache.Add(route, load_request);
                if (callback != null)
                {
                    load_request.AddCallback(callback);
                }

                while (asset_request.isDone == false)
                {
                    yield return null;
                }

                var prefab = (GameObject)asset_request.asset;
                AssetTracker tracker = new AssetTracker(route, prefab);
                AssetCache.Add(route, tracker);
                container.AddLinkedAsset(tracker);

                foreach (OnLoadCallback clk in load_request.GetCallbacks()) clk(tracker.AddReference());
                load_request.Clear();
                RequestCache.Remove(route);
                yield break;
            }
        }

        public GameObject LoadLocal(string route)
        {
            var prefab = Resources.Load(route) as GameObject;
            return GameObject.Instantiate<GameObject>(prefab);
        }

        public GameObject LoadSync(string route)
        {
            if (AssetCache.ContainsKey(route))
            {
                AssetTracker tracker = AssetCache[route];
                return tracker.AddReference();
            }
            else
            {
                if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
                {
                    BundleManager.BundleContainer container = GameFacade.Instance.BundleManager.LoadSync(route);
                    GameObject prefab = container.Load(route) as GameObject;
                    AssetTracker tracker = new AssetTracker(route, prefab);
                    AssetCache.Add(route, tracker);
                    container.AddLinkedAsset(tracker);
                    return tracker.AddReference();
                }
                else
                {
                    // #if UNITY_EDITOR
                    GameObject prefab =  UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/" + route + ".prefab");
                    //GameObject prefab = Resources.Load(route) as GameObject;
                    AssetTracker tracker = new AssetTracker(route, prefab);
                    AssetCache.Add(route, tracker);
                    return tracker.AddReference();
                    // #else
                    // return null;
                    // #endif
                }
            }
        }

        public void LoadAsync(string route, OnLoadCallback callback)
        {
            if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
            {
                StartCoroutine(AsyncProcess(route, callback));
            }
            else
            {
#if UNITY_EDITOR
                if (AssetCache.ContainsKey(route))
                {
                    AssetTracker tracker = AssetCache[route];
                    if (callback != null)
                    {
                        callback(tracker.AddReference());
                    }
                }
                else if (RequestCache.ContainsKey(route) == true)
                {
                    AssetLoadRequest request = RequestCache[route];
                    if (callback != null)
                    {
                        request.AddCallback(callback);
                    }
                }
                else
                {
                    GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/" + route + ".prefab");
                    AssetTracker tracker = new AssetTracker(route, prefab);
                    AssetLoadRequest load_request = new AssetLoadRequest(route);
                    if (callback != null)
                    {
                        load_request.AddCallback(callback);
                    }
                    AssetCache.Add(route, tracker);

                    foreach (OnLoadCallback clk in load_request.GetCallbacks())
                    {
                        clk(tracker.AddReference());
                    }
                    load_request.Clear();
                    RequestCache.Remove(route);
                }
#endif
            }
        }

        //######################################这两个肯定是临时方案################################//
        public bool FileExist(string path)
        {
            return File.Exists(path);
        }

        public void DeleteFile(string path)
        {
            File.Delete(path);
        }

        public void CreateTextFile(string path, string content)
        {
            StreamWriter sw;
            FileInfo t = new FileInfo(path);
            if (!t.Exists)
            {                               //判断文件是否存在
                sw = t.CreateText();        //不存在，创建
            }
            else
            {
                sw = t.CreateText();        //存在，则打开
            }
            sw.Write(content);              //以行的形式写入信息
            sw.Close();                     //关闭流
            sw.Dispose();                   //销毁流
        }

        public string LoadText(string path)
        {
            var asset = Resources.Load<TextAsset>(path);
            return asset.text;
        }

        private void AddUniqueNoAtlas(GameObject gloo, string route)
        {
            if (NoAtlasRef.ContainsKey(gloo.GetHashCode()) == false)
            {
                NoAtlasRef.Add(gloo.GetHashCode(), new List<string>());
            }

            var ref_list = NoAtlasRef[gloo.GetHashCode()];
            if (ref_list.Contains(route) == false)
            {
                ref_list.Add(route);
            }
        }

        //逻辑: 同一个Gloo，可能对应多个route
        //      同一个route,也可能存在多个gloo
        //      所以这里要考虑一个逻辑
        //      当一个对应的gloo被标记为清理时
        //      需要让对应的AssetCache里对应的refList都清理一下

        public void UnloadNoAtlasSpriteByGloo(GameObject gloo)
        {
            if (gloo == null) return;

            //根据这个gloo, 寻找他对应的那些sprite
            if (NoAtlasRef.ContainsKey(gloo.GetHashCode()) == true)
            {
                var ref_list = NoAtlasRef[gloo.GetHashCode()];
                ref_list.ForEach((route) =>
                {
                    if (AssetCache.ContainsKey(route) == true)
                    {
                        AssetCache[route].RemoveGloo(gloo);
                    }
                    else
                    {
                        //Debug.LogError("Not Found For Gloo " + route);
                    }
                    NoAtlasRef[gloo.GetHashCode()].Remove(route);
                });
            }
            else
            {
                //Debug.LogError("不应该进到这里 " + gloo.name);
            }
        }

        //NoAtlas是替换型的, 如果
        public Sprite LoadNoAtlasSprite(string route, GameObject gloo)
        {
            if (string.IsNullOrEmpty(route)) return null;
            if (AssetCache.ContainsKey(route))
            {
                AssetTracker tracker = AssetCache[route];
                tracker.AddGloo(gloo);

                AddUniqueNoAtlas(gloo, route);

                return (Sprite)tracker.Asset;
            }
            else
            {
                // if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
                // {
                //     // BundleManager.BundleContainer container = GameFacade.Instance.BundleManager.LoadSync(route);
                //     // if (container == null) return null;
                //     // var sections = route.Split('/');
                //     // var SpriteName = sections[sections.Length - 1];
                //     // var p = container.LoadSprite(SpriteName);
                //     // Sprite sprite = p as Sprite;
                //     // AssetTracker tracker = new AssetTracker(route, sprite);
                //     // AssetCache.Add(route, tracker);
                //     // tracker.AddGloo(gloo);
                //     // AddUniqueNoAtlas(gloo, route);

                //     // container.AddLinkedAsset(tracker); 
                //     // return (Sprite)tracker.Asset;
                //     return null;
                // }
                // else
                {
                    // #if UNITY_EDITOR
                    // Sprite sprite = UnityEditor.AssetDatabase.LoadAssetAtPath<Sprite>("Assets/" + route + ".png");
                    Sprite sprite = Resources.Load<Sprite>(route);
                    AssetTracker tracker = new AssetTracker(route, sprite);
                    AssetCache.Add(route, tracker);
                    tracker.AddGloo(gloo);
                    AddUniqueNoAtlas(gloo, route);

                    return (Sprite)tracker.Asset;
                    // #else
                    // return null;
                    // #endif
                }

            }
        }

        public GameObject LoadAtlas(string route)
        {
            if (AssetCache.ContainsKey(route))
            {
                AssetTracker tracker = AssetCache[route];
                return tracker.AddReference();
            }
            else
            {
                if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
                {
                    BundleManager.BundleContainer container = GameFacade.Instance.BundleManager.LoadSync(route);
                    GameObject prefab = container.Load(route) as GameObject;
                    AssetTracker tracker = new AssetTracker(route, prefab);
                    AssetCache.Add(route, tracker);
                    var atlas = tracker.Asset as GameObject;
                    var d = atlas.GetComponent<UIDynamic>();
                    d.Generate();
                    container.AddLinkedAsset(tracker);
                    return tracker.AddAtlasRef(route);
                }
                else
                {
#if UNITY_EDITOR
                    GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/" + route + ".prefab");
                    AssetTracker tracker = new AssetTracker(route, prefab);
                    AssetCache.Add(route, tracker);
                    var atlas = tracker.Asset as GameObject;
                    var d = atlas.GetComponent<UIDynamic>();
                    d.Generate();
                    return tracker.AddAtlasRef(route);
#else
                    return null;
#endif
                }
            }
        }

        //加载动态图片
        public Sprite LoadSprite(string route, GameObject gloo)
        {
            if (string.IsNullOrEmpty(route)) return null;
            //1. 根据路径拆解, 找到对应的prefab, 已经该prefab上的sprite
            var sections = route.Split('/');
            var RouteAtlas = sections[sections.Length - 2] + "_Icon";
            var SpriteKey = sections[sections.Length - 1];
            var LoadPath = "Prefab/Icon/" + RouteAtlas;

            if (AssetCache.ContainsKey(LoadPath))
            {
                AssetTracker tracker = AssetCache[LoadPath];
                tracker.AddGloo(gloo);
                var atlas = tracker.Asset as GameObject;
                var d = atlas.GetComponent<UIDynamic>();

                return d.Get(SpriteKey);
            }
            else
            {
                //从AssetBundle加载
                if (GameFacade.Instance.ConstManager.LoadFromBundle == true)
                {
                    BundleManager.BundleContainer container = GameFacade.Instance.BundleManager.LoadSync(LoadPath);
                    GameObject prefab = container.Load(LoadPath) as GameObject;
                    AssetTracker tracker = new AssetTracker(LoadPath, prefab);
                    AssetCache.Add(LoadPath, tracker);
                    container.AddLinkedAsset(tracker);
                    tracker.AddGloo(gloo);
                    var atlas = tracker.Asset as GameObject;
                    var d = atlas.GetComponent<UIDynamic>();
                    d.Generate();
                    return d.Get(SpriteKey);
                }
                //从正常的Resource里加载
                else
                {
#if UNITY_EDITOR
                    GameObject prefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>("Assets/" + LoadPath + ".prefab");
                    AssetTracker tracker = new AssetTracker(LoadPath, prefab);
                    AssetCache.Add(LoadPath, tracker);
                    tracker.AddGloo(gloo);
                    var atlas = tracker.Asset as GameObject;
                    var d = atlas.GetComponent<UIDynamic>();
                    d.Generate();
                    return d.Get(SpriteKey);
#else
                    return null;              
#endif
                }
            }
        }
        //######################################这两个肯定是临时方案################################//

        public void Print()
        {
            string output = "";
            foreach (KeyValuePair<string, AssetTracker> pair in AssetCache)
            {
                if (pair.Value.RefCount != 0)
                {
                    output += "ROUTE: " + pair.Key + " " + pair.Value.RefCount + "\n";
                    for (int i = 0; i < pair.Value.GetReferences().Count; i++)
                    {
                        output += " " + pair.Value.GetReferences()[i].name + " ";
                    }
                    output += "\n";
                }
            }
            Debug.Log("###############################################");
            Debug.Log(output);
            Debug.Log("###############################################");
        }

        //清理 -- OnApplicationQuit --
        private void OnApplicationQuit()
        {
            Recycle();
            AssetCache.Clear();
            NoobTD.GameFacade.Instance.LuaManager.LuaGC();
            System.GC.Collect();
            Resources.UnloadUnusedAssets();
#if UNITY_EDITOR
            UnityEditor.EditorUtility.UnloadUnusedAssets();
#endif
        }

        public void LightRecycle()
        {
            NoobTD.GameFacade.Instance.LuaManager.LuaGC();
        }

        private void Update()
        {
            var current_time = Time.realtimeSinceStartup;
            if (current_time - _LastTimeStamp > 60)
            {
                Debug.Log("===== CLEAN =====");
                Clean();
                _LastTimeStamp = current_time;
            }
        }

        private void Clean()
        {
            //string output = "";
            List<AssetTracker> Dustbin = new List<AssetTracker>();
            foreach (KeyValuePair<string, AssetTracker> pair in AssetCache)
            {
                if (pair.Value.RefCount == 0)
                {
                    //Resources.UnloadAsset(pair.Value.Asset);
                    pair.Value.ClearGloo();
                    if (pair.Value.Asset == null)
                    {
                        Debug.LogError("Try To Delete Null Asset " + pair.Key);
                    }


                    Dustbin.Add(pair.Value);
                }
            }

            foreach (AssetTracker tracker in Dustbin)
            {
                AssetCache.Remove(tracker.Route);


                tracker.MarkAsTrashed();
                if (tracker.Asset != null && tracker.Asset.GetType() != typeof(GameObject))
                {
                    Resources.UnloadAsset(tracker.Asset);
                }
                //output += "RECYCLE: " + tracker.Route + "\n";
            }
            Dustbin.Clear();
            GameFacade.Instance.BundleManager.Recycle();

            //Debug.Log("###############################################");
            //Debug.Log(output);
            //Debug.Log("###############################################");

            NoobTD.GameFacade.Instance.LuaManager.LuaGC();
            Resources.UnloadUnusedAssets();
        }

        //Recycle: 清理效果, 在合适的时机调用
        public void Recycle()
        {
            Clean();
            System.GC.Collect();
        }
    }
}

