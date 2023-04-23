using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using LuaFramework;
using LuaInterface;
namespace NoobTD
{
    public class LuaItems : MonoBehaviour
    {
        public GameObject[] ItemList = new GameObject[0] { };
        public string[] TypeList = new string[0] { };
        public string ScriptPath = null;    //脚本路径
        public string ScriptName = "";
        public LuaTable LuaTable = null;

        private void Awake()
        {
            //gameObject.transform.eulerAngles

            this.gameObject.name = ScriptName;
            LuaTable container = GameFacade.Instance.LuaManager.GetFunction("Utility.GetEmptyTable").Invoke<LuaTable>();
            LuaTable reddot_container = GameFacade.Instance.LuaManager.GetFunction("Utility.GetEmptyTable").Invoke<LuaTable>();

            int red_dot_index = 1;
            for (int i = 0; i < ItemList.Length; i++)
            {
                if(TypeList[i] == "GameObject")
                {
                    var c = ItemList[i];
                    container[ItemList[i].name] = c;
                }
                else if (TypeList[i] == "RedDot")
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
            var func = GameFacade.Instance.LuaManager.GetFunction("ItemBase.PreAwake");
            LuaTable item_class = GameFacade.Instance.LuaManager.GetFunction("UI.Manager.GetItem").Invoke<string, LuaTable>(ScriptName);

            this.LuaTable = func.Invoke<LuaTable, LuaTable, LuaTable, LuaTable>(container, item_class, reddot_container);
            container.Dispose();
            item_class.Dispose();
            func.Dispose();
        }

        private void OnDestroy()
        {
            //gameObject.SetActive(false);
            this.LuaTable.Call("OnDestroy", this.LuaTable);
            var func = GameFacade.Instance.LuaManager.GetFunction("ItemBase.OnFinal");
            func.Call<LuaTable>(this.LuaTable);
            this.LuaTable.Dispose();

        }
    }
}
