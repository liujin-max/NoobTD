using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace NoobTD
{
    public class ConstManager : MonoBehaviour
    {
        public bool Reboot = false;


        public bool TestScene = false;
        public int Scene = 0;

        public bool Console = false;
        public bool NoGuide = false;


        public bool ToPTRServer = false;

        public string Version = "";

        public bool LoadFromBundle = false;     //是否从AB包加载
        public bool UseSDK = false;

        public bool PTR = false;



        public void Init(GameEntry entry)
        {
            this.Reboot     = entry.Reboot;

            this.TestScene  = entry.TestScene;
            this.Scene      = entry.Scene;

            this.Console    = entry.Console;


            this.NoGuide    = entry.NoGuide;

            this.ToPTRServer = entry.ToPTRServer;

            this.Version    = entry.Version;

            this.LoadFromBundle = entry.LoadFromBundle;
            this.PTR            = entry.PTR;
            this.UseSDK         = entry.UseSDK;

        }
    }
}
