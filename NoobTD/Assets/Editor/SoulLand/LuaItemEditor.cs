using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NoobTD
{
    [CustomEditor(typeof(LuaItems))]
    public class LuaItemEditor : Editor
    {
        private Vector2 _ScrollPosition = Vector2.zero;
        private UnityEngine.Object _Current = null;
        private int _CurrentIndex = 0;
        //private int _Count = 0;

        public string[] _TypeEnum = new string[] {"Animator", "Image", "Button", "Text", "TextMeshProUGUI", "TextMeshPro", "GameObject", "SpriteRenderer", "RedDot"};

        public override void OnInspectorGUI()
        {
            var target = (LuaItems)(serializedObject.targetObject);
            int itemLength =  target.ItemList.Length;

            List<GameObject> tempItemList = new List<GameObject>();
            List<string> tempTypeList = new List<string>();
            for(int i = 0; i < target.ItemList.Length; i++)
            {
                GameObject go = target.ItemList[i];
                string type = target.TypeList[i];
                tempTypeList.Add(type);
                tempItemList.Add(go);
            }

            EditorGUILayout.BeginHorizontal();
            target.ScriptPath = EditorGUILayout.TextField(target.ScriptPath);
            if(GUILayout.Button("选择文件"))
            {
                target.ScriptPath = EditorUtility.OpenFilePanel("读取文件路径", "", "");
                string[] seps = target.ScriptPath.Split('/');
                target.ScriptPath = "";
                bool beforeLua = true;
                for(int i = 0; i < seps.Length; i++)
                {
                    if (beforeLua == false)
                    {
                        if (i != seps.Length - 1)
                            target.ScriptPath += seps[i] + "/";
                        else
                            target.ScriptPath += seps[i];
                    }
                    if (seps[i].Equals("Lua"))
                    {
                        beforeLua = false;
                    }
                }
                
                string last = seps[seps.Length - 1];
                target.ScriptName = last.Substring(0, last.Length - 4);
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.LabelField("类名: " + target.ScriptName);
            EditorGUILayout.BeginHorizontal();
            _Current = EditorGUILayout.ObjectField(_Current, typeof(UnityEngine.Object));
            _CurrentIndex = EditorGUILayout.Popup(_CurrentIndex, _TypeEnum);
            EditorGUILayout.EndHorizontal();
            if(GUILayout.Button("添加"))
            {
                if(!tempItemList.Contains((GameObject)_Current))
                {
                    tempItemList.Add((GameObject)_Current);
                    tempTypeList.Add(_TypeEnum[_CurrentIndex]);
                }
                else
                {
                    EditorUtility.DisplayDialog("注意", "已添加过这个空间", "好！");
                }
            }
            _ScrollPosition = EditorGUILayout.BeginScrollView(_ScrollPosition);
            for(int i = 0; i < tempItemList.Count; i++)
            {
                EditorGUILayout.BeginHorizontal();
                if(tempItemList[i] != null)
                {
                    EditorGUILayout.LabelField(tempItemList[i].name + "(" + tempTypeList[i] + ")");
                    if (GUILayout.Button("删除"))
                    {
                        tempItemList.RemoveAt(i);
                        tempTypeList.RemoveAt(i);
                    }
                }
                EditorGUILayout.EndHorizontal();
            }
            for (int i = tempItemList.Count - 1; i >= 0; i--)
            {
                if(tempItemList[i] == null)
                {
                    tempItemList.RemoveAt(i);
                    tempTypeList.RemoveAt(i);
                }
            }
            EditorGUILayout.EndScrollView();

            target.ItemList = tempItemList.ToArray();
            target.TypeList = tempTypeList.ToArray();

        }
    }
}
