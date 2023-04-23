/**
 *  游戏启动入口，主要负责：
 *  加载启动资源；
 *  加载各个Manager；
 *  
 * 
 */
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public class GameEntry : MonoBehaviour
    {
        public bool Reboot      = false;


        public bool TestScene = false;
        public int Scene = 0;

        public bool Console = false;

        public bool NoGuide = false;


        public bool LoadFromBundle = false;     //是否从AB包加载

        public bool UseSDK = false;             //使用sdk


        public bool ToPTRServer = false;

        public string Version = "";


        public bool PTR     = false;



        void Awake()
        {
            Input.multiTouchEnabled = false;

            //初始化各个Manager
            InitManager();
        }

        void InitManager()
        {
            GameObject managerGO = GameObject.Find("Facade");
            DontDestroyOnLoad(managerGO);
            var facade = managerGO.AddComponent<GameFacade>();
            facade.InitConst(this);

            DontDestroyOnLoad(GameObject.Find("SceneCam"));
            DontDestroyOnLoad(GameObject.Find("EventSystem"));
            DontDestroyOnLoad(GameObject.Find("UI"));


        }

        private void Start()
        {
            //GameFacade.Instance.HttpTestManager.Begin();
            GameFacade.Instance.LaunchManager.Launch();
        }
    }
}
