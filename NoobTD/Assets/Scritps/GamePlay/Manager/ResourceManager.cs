using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//ResourceManager:
//---------------------------------------------------------------------------------------------
//
//封装一个Request，有两块：Async, Sync.
//同时Request的加载对象，包括几种：
//1. 直接从Resource里加载，真实打包的时候不需要;
//2. 从StreammingAssets加载，这些AB包相当于天生带的AB包, 这个文件夹下的AB包是不能删除/修改的;
//3. 从PersistentPath里加载，这些AB包是热更新下载的AB包;
//
//---------------------------------------------------------------------------------------------
//
//函数式的Request怎么写呢? 
//
//
//
//---------------------------------------------------------------------------------------------

namespace NoobTD
{
    public class ResourceManager : MonoBehaviour, IManager
    {
        private enum LoadingState : int
        {
            NotStarted = 0,
            Loading = 1,
        }

        private class LoadingRequest
        {
            public string Path = null;
            public List<Action<UnityEngine.Object>> Action = new List<Action<UnityEngine.Object>>();
            public ResourceRequest Request = null;

            public LoadingRequest(string path, ResourceRequest request, Action<UnityEngine.Object> action)
            {
                Request = request;
                Path = path;
                Action.Add(action);
            }
        }

        private Dictionary<string, UnityEngine.Object> LoadPaths = new Dictionary<string, UnityEngine.Object>();
        private Dictionary<UnityEngine.Object, string> LoadAssets = new Dictionary<UnityEngine.Object, string>();
        private Dictionary<string, LoadingRequest> AsyncLoadingQueue = new Dictionary<string, LoadingRequest>();
        private Dictionary<string, LoadingRequest> NeedRemoveLoadingQueue = new Dictionary<string, LoadingRequest>();

        private void Update()
        {
            while (AsyncLoadingQueue.Count > 0)
            {
                foreach (KeyValuePair<string, LoadingRequest> pair in AsyncLoadingQueue)
                {
                    if (pair.Value.Request.isDone)
                    {
                        var asset = pair.Value.Request.asset;
                        for (int i = 0; i < pair.Value.Action.Count; i++)
                        {
                            pair.Value.Action[i](asset);
                        }
                        NeedRemoveLoadingQueue.Add(pair.Key, pair.Value);
                        LoadPaths.Add(pair.Key, asset);
                    }
                }

                foreach (KeyValuePair<string, LoadingRequest> pair in NeedRemoveLoadingQueue)
                {
                    AsyncLoadingQueue.Remove(pair.Key);
                }
                NeedRemoveLoadingQueue.Clear();
            }
        }

        public void LoadAsync(string path, Action<UnityEngine.Object> onComplete)
        {
            if(LoadPaths.ContainsKey(path) == true)
            {
                onComplete(LoadPaths[path]);
            }
            else
            {
                if(AsyncLoadingQueue.ContainsKey(path) == true)
                {
                    AsyncLoadingQueue[path].Action.Add(onComplete);
                }
                else
                {
                    LoadingRequest request = new LoadingRequest(path, Resources.LoadAsync<UnityEngine.Object>(path), onComplete);
                    AsyncLoadingQueue.Add(path, request);
                }
            }
        }

        public bool FileExist(string path)
        {
            return File.Exists(path);
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

        public Sprite LoadSprite(string path)
        {
            if (LoadPaths.ContainsKey(path) == true)
            {
                return LoadPaths[path] as Sprite;
            }
            else
            {
                //暂时不走打包，需要等一定体量再打包
                Sprite prefab = Resources.Load<Sprite>(path);
                if (prefab == null)
                {
                    Debug.LogWarning("Cannot Load " + path + ": not found");
                    return null;
                }

                LoadPaths.Add(path, prefab);
                LoadAssets.Add(prefab, path);
                return prefab;
            }
        }

        public GameObject LoadSync(string path)
        {
            UnityEngine.Object t_prefab = null;
            if (LoadPaths.ContainsKey(path) == true)
            {
                t_prefab = LoadPaths[path];
            }
            else
            {
                //暂时不走打包，需要等一定体量再打包
                UnityEngine.Object prefab = Resources.Load(path);
                if (prefab == null)
                {
                    Debug.LogError("Cannot Load " + path + ": not found");
                    return null;
                }
                LoadPaths.Add(path, prefab);
                LoadAssets.Add(prefab, path);
                t_prefab = prefab;
            }
            return GameObject.Instantiate(t_prefab) as GameObject;
        }

        public void UnLoad(UnityEngine.Object obj)
        {
            if(LoadAssets.ContainsKey(obj))
            {
                string path = LoadAssets[obj];
                LoadAssets.Remove(obj);
                LoadPaths.Remove(path);
                UnityEngine.Object.Destroy(obj);
            }
        }
    }
}
