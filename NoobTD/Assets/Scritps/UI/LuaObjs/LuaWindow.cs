/**
*      LuaWindow
* 1.首先，有一个Script的对应路径
* 2.每次加载的时候，判断下lua脚本是否已经DoFile
* 3.如果没有DoFile，DoFile
* 4.将所需要的UI的列表组成一个list，将该list组成一个LuaTable，作为new时的参入传入
* 5.然后在lua中绑定各个UI控件
* --这样操作性能比较高；缺点是修改时需要维护一个序列化列表
* --限制，不能同名
*/
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using LuaInterface;

namespace NoobTD
{
    public class LuaWindow : MonoBehaviour
    {
        public GameObject[] ItemList = new GameObject[0] { };
        public string[] TypeList = new string[0] { };
        public string ScriptPath = null;    //脚本路径
        public string ScriptName = "";

        private void Awake()
        {
            Debug.Log(ScriptName);
            this.gameObject.name = ScriptName;
            //Debug.Log("+++++++++++++ " + ScriptName);
            LuaTable container          = GameFacade.Instance.LuaManager.GetFunction("Utility.GetEmptyTable").Invoke<LuaTable>();
            LuaTable reddot_container          = GameFacade.Instance.LuaManager.GetFunction("Utility.GetEmptyTable").Invoke<LuaTable>();
            int red_dot_index = 1;
            for (int i = 0; i < ItemList.Length; i++)
            {
                if (TypeList[i] == "GameObject")
                {
                    var c = ItemList[i];
                    container[ItemList[i].name] = c;
                }
                else if(TypeList[i] == "RedDot")
                {
                    var c = ItemList[i].GetComponent(TypeList[i]) as RedDot;
                    reddot_container[red_dot_index] = c;
                    red_dot_index++;
                }
                else
                {
                    var c = ItemList[i].GetComponent(TypeList[i]);
                    container[ItemList[i].name] = c;
                }
            }
            container["This"] = this.gameObject;
            LuaTable window_obj = GameFacade.Instance.LuaManager.GetFunction("UI.Manager.GetWindow").Invoke<string, LuaTable>(ScriptName);
            var func = GameFacade.Instance.LuaManager.GetFunction("WindowBase.PreAwake");
            func.Call<LuaTable, LuaTable, LuaTable>(window_obj, container, reddot_container);
            func.Dispose();
            container.Dispose();
            window_obj.Dispose();
        }

        private void OnDestroy()
        {
            gameObject.SetActive(false);
        }
    }
}
