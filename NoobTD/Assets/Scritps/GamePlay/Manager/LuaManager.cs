using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace NoobTD
{
    public class LuaManager : MonoBehaviour, IManager
    {
        private LuaState lua;
        private LuaFramework.LuaLoader loader;
        private LuaLooper loop = null;
        private LuaFunction lua_update_entry = null;

        // Use this for initialization
        void Awake()
        {
            loader = new LuaFramework.LuaLoader();
            lua = new LuaState();
            this.OpenLibs();
            lua.LuaSetTop(0);

            LuaBinder.Bind(lua);
            DelegateFactory.Init();
            LuaCoroutine.Register(lua, this);

        }

        public void InitStart()
        {
            InitLuaPath();
            InitLuaBundle();
            this.lua.Start();    //启动LUAVM
            this.StartMain();
            this.StartLooper();
        }

        void StartLooper()
        {
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;
        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
        protected void OpenCJson()
        {
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");

            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain()
        {
            //通过Main文件, 进入lua逻辑
            //var file = Application.dataPath + "/StreamingAssets/lua/lua/Build.bat";
            ////System.IO.FileStream fs = new System.IO.FileStream(file, System.IO.FileMode.Open);
            //string md5 = FileUtility.GetFileMD5(file);
            //////string md52 = LuaFramework.Util.md5file(file);
            //Debug.Log("MD5 " + md5);

            lua.DoFile("Main.lua");
            LuaFunction main = lua.GetFunction("GameStart");
            lua_update_entry = lua.GetFunction("Update");
            main.Call();
            main.Dispose();
            main = null;
        }

        void Update()
        {
            if(lua_update_entry != null)
            {
                lua_update_entry.Call();
            }
        }

        //==> 回到游戏
        private void OnApplicationFocus(bool focus)
        {
            if( focus == true ) //启动游戏
            {
                EventManager.instance.SendEvent("SERVER_GAME_FOCUS_GAME", null, 1);
                EventManager.instance.SendEvent("GAME_FOCUS_GAME", null, 1);

            }
            else
            {
                EventManager.instance.SendEvent("SERVER_GAME_PAUSE_GAME", null, 1);
                EventManager.instance.SendEvent("GAME_PAUSE_GAME", null, 1);
            }
        }

        //==> 暂停游戏
        private void OnApplicationPause(bool pause)
        {

        }

        //游戏退出
        private void OnApplicationQuit()
        {
            EventManager.instance.SendEvent("SERVER_GAME_CLOSE_GAME", null, 1);
            EventManager.instance.SendEvent("GAME_CLOSE_GAME", null, 1);
        }

        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs()
        {
            lua.OpenLibs(LuaDLL.luaopen_pb);
            lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
            lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();
        }

        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath()
        {
            if (LuaFramework.AppConst.DebugMode)
            {
                string rootPath = LuaFramework.AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "Lua");
                lua.AddSearchPath(rootPath + "ToLua/Lua");
            }
            else
            {
                Debug.Log (LuaFramework.Util.DataPath + "lua");
                lua.AddSearchPath(LuaFramework.Util.DataPath + "lua");


                // if (Application.isMobilePlatform || GameFacade.Instance.ConstManager.LoadFromBundle == true)
                // {
                //     lua.AddSearchPath(LuaFramework.Util.DataPath + "lua", true);
                // }
                // else
                // {
                //     lua.AddSearchPath(LuaFramework.Util.DataPath + "lua");
                // }
            }
        }

        /// <summary>
        /// 初始化LuaBundle
        /// </summary>
        void InitLuaBundle()
        {
            if (loader.beZip)
            {
                loader.AddBundle("lua/lua.unity3d");
                loader.AddBundle("lua/lua_math.unity3d");
                loader.AddBundle("lua/lua_system.unity3d");
                loader.AddBundle("lua/lua_system_reflection.unity3d");
                loader.AddBundle("lua/lua_unityengine.unity3d");
                loader.AddBundle("lua/lua_common.unity3d");
                loader.AddBundle("lua/lua_logic.unity3d");
                loader.AddBundle("lua/lua_view.unity3d");
                loader.AddBundle("lua/lua_controller.unity3d");
                loader.AddBundle("lua/lua_misc.unity3d");

                loader.AddBundle("lua/lua_protobuf.unity3d");
                loader.AddBundle("lua/lua_3rd_cjson.unity3d");
                loader.AddBundle("lua/lua_3rd_luabitop.unity3d");
                loader.AddBundle("lua/lua_3rd_pbc.unity3d");
                loader.AddBundle("lua/lua_3rd_pblua.unity3d");
                loader.AddBundle("lua/lua_3rd_sproto.unity3d");
            }
        }

        public void RequireFile(string filename)
        {
            lua.Require(filename.Substring(0, filename.Length - 4));
        }

        public void DoFile(string filename)
        {
            lua.DoFile(filename);
        }
        
        public LuaFunction GetFunction(string funcName)
        {
            return lua.GetFunction(funcName);
        }

        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args)
        {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null)
            {
                return func.LazyCall(args);
            }
            return null;
        }

        public void LuaGC()
        {
            lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void Close()
        {
            loop.Destroy();
            loop = null;

            lua.Dispose();
            lua = null;
            loader = null;
        }
    }
}
