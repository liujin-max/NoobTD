using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public class ManagerName
    {
        public const string Const       = "ConstManager";
        public const string Lua         = "LuaManager";
        public const string Game        = "GameLogicManager";
        public const string Resource    = "ResourceManager";
        public const string Level       = "LevelManager";
        public const string Launch      = "LaunchManager";
        public const string Track       = "TrackManager";
        public const string Asset       = "AssetManager";
        public const string Bundle      = "BundleManager";
        public const string Display     = "DisplayManager";
        public const string Net         = "NetManager";
        public const string Platform    = "PlatformManager";
        public const string Ads         = "AdsManager";
    }

    public class GameFacade : MonoBehaviour
    {    
        private static GameFacade _instance = null;
        public static GameFacade Instance
        {
            get
            {
                return _instance;
            }
        }

        public GameEntry Entry = null;

        public bool Reboot = false;

        private Dictionary<string, object> _managers = new Dictionary<string, object>();

        public ResourceManager ResourceManager
        { get { return GetManager<ResourceManager>(ManagerName.Resource);}  }

        public LuaManager LuaManager
        { get { return GetManager<LuaManager>(ManagerName.Lua); } }

        public GameLogicManager GameLogicManager
        { get { return GetManager<GameLogicManager>(ManagerName.Game); } }

        public LevelManager LevelManager
        { get { return GetManager<LevelManager>(ManagerName.Level); } }

        public ConstManager ConstManager
        { get { return GetManager<ConstManager>(ManagerName.Const); } }

        public TrackManager TrackManager
        { get { return GetManager<TrackManager>(ManagerName.Track); } }

        public AssetManager AssetManager
        { get { return GetManager<AssetManager>(ManagerName.Asset); } }

        public DisplayManager DisplayManager
        { get { return GetManager<DisplayManager>(ManagerName.Display); } }

        public NetManager NetManager
        { get { return GetManager<NetManager>(ManagerName.Net); } }

        public BundleManager BundleManager
        { get { return GetManager<BundleManager>(ManagerName.Bundle); } }

        public LaunchManager LaunchManager
        { get { return GetManager<LaunchManager>(ManagerName.Launch); } }


        public PlatformManager PlatformManager
        { get { return GetManager<PlatformManager>(ManagerName.Platform);  } }

        public AdsManager AdsManager
        { get { return GetManager<AdsManager>(ManagerName.Ads); } }

        public void Awake()
        {
            _instance = this;
            InitManagers();
        }

        public void InitConst(GameEntry entry)
        {
            ConstManager.Init(entry);
        }

        private void InitLuaManagers()
        {
            //Call Func
        }

        private void InitManagers()
        {
            //启动C#中的Manager
            AddManager<ConstManager>(ManagerName.Const);
            AddManager<LuaManager>(ManagerName.Lua);
            AddManager<GameLogicManager>(ManagerName.Game);
            AddManager<ResourceManager>(ManagerName.Resource);
            AddManager<LevelManager>(ManagerName.Level);
            AddManager<TrackManager>(ManagerName.Track);
            AddManager<AssetManager>(ManagerName.Asset);
            AddManager<DisplayManager>(ManagerName.Display);
            AddManager<NetManager>(ManagerName.Net);
            AddManager<BundleManager>(ManagerName.Bundle);
            AddManager<LaunchManager>(ManagerName.Launch);
            AddManager<PlatformManager>(ManagerName.Platform);
            AddManager<AdsManager>(ManagerName.Ads);
  

            //发送消息：ManagerInitFinished
        }

        //添加Manager
        public T AddManager<T>(string typeName) where T : Component
        {
            object result = null;
            _managers.TryGetValue(typeName, out result);
            if (result != null)
            {
                return (T)result;
            }
            Component c = this.gameObject.AddComponent<T>();
            _managers.Add(typeName, c);
            return default(T);
        }

        //获取Manager
        private T GetManager<T>(string typeName) where T : Component
        {
            object result = null;
            _managers.TryGetValue(typeName, out result);
            if (result != null)
            {
                return (T)result;
            }
            return default(T);
        }
    }
}
