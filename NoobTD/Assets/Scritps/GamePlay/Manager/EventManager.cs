using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using LuaInterface;

namespace NoobTD
{
    public class EventData
    {
        //回调事件
        public EventManager.EventHandler handler;

        //事件注册的实例
        public object instance;

        //事件注册的self参数
        public object parmSelf;

        //优先级: 响应同一个事件时，复杂情况下这些响应逻辑都有优先级，需要这样去处理
        public int priority = 0;

        //事件的名称
        public string Name = "";

        //清理
        public void Clear()
        {
            this.handler = null;
            this.instance = null;
            this.parmSelf = null;
            this.priority = 0;
        }

    }

    //事件管理器  监听派发 所有全局的事件
    public class EventManager
    {
        public static readonly EventManager instance = new EventManager();

        public delegate void EventHandler(object pSelf, string EventType, params object[] args);

        public LuaFunction lua_event_bridge = null;

        //数据类
        private Hashtable _dataMap;

        public EventManager()
        {
           this._dataMap = new Hashtable();
        }

        public void Init()
        {
           this._dataMap.Clear();
           this._dataMap = new Hashtable();
        }

        public void ClearType(string eventType)
        {
           if (this._dataMap.ContainsKey(eventType) == false)
           {
               return;
           }

           List<EventData> list = (List<EventData>)this._dataMap[eventType];
           list.Clear();
        } 

        // / <summary>
        // / 事件是否已经注册了
        // / </summary>
        // / <param name="eventType"></param>
        // / <param name="handler"></param>
        // / <param name="instance"></param>
        // / <param name="parmSelf"></param>
        // / <returns></returns>
        public bool IsRegister(string eventType, EventHandler handler, object instance = null, object parmSelf = null)
        {
           if (this._dataMap.ContainsKey(eventType) == false)
           {
               return false;
           }

           List<EventData> list = (List<EventData>)this._dataMap[eventType];
           for (int i = 0; i < list.Count; i++)
           {
               EventData d = list[i];
               if (d.instance == instance && d.handler == handler)
               {
                   return true;
               }
           }

           return false;
        }

        // / <summary>
        // / 添加一个回调
        // / </summary>
        // / <param name="eventType">EventDataType的类型请在EventDataType 这个类里面定义一个字符串的常量</param>
        // / <param name="handler">执行的回调</param>
        // / <param name="instance">注册事件的源对象</param>
        // / <param name="parmSelf">自定义self对象，在回调中返回，主要在lua中返回self对象便于操作</param>
        public EventData AddHandler(string eventType, EventHandler handler, object instance = null, object parmSelf = null)
        {
           List<EventData> list;
           if (this._dataMap.ContainsKey(eventType))
           {
               list = (List<EventData>)this._dataMap[eventType];
           }
           else
           {
               list = new List<EventData>();
               this._dataMap.Add(eventType, list);
           }
           EventData eventData = new EventData();
           eventData.Name = eventType;
           eventData.handler = handler;
           eventData.instance = instance;
           eventData.parmSelf = parmSelf;
           list.Add(eventData);
           return eventData;
        }

        // / <summary>
        // / 添加一个回调
        // / </summary>
        // / <param name="eventType">EventDataType的类型请在EventDataType 这个类里面定义一个字符串的常量</param>
        // / <param name="handler">执行的回调</param>
        // / <param name="instance">注册事件的源对象</param>
        // / <param name="parmSelf">自定义self对象，在回调中返回，主要在lua中返回self对象便于操作</param>
        public EventData AddHandlerWithPriority(string eventType, EventHandler handler, int priority, object instance = null, object parmSelf = null)
        {
           List<EventData> list;
           if (this._dataMap.ContainsKey(eventType))
           {
               list = (List<EventData>)this._dataMap[eventType];
           }
           else
           {
               list = new List<EventData>();
               this._dataMap.Add(eventType, list);
           }
           EventData eventData = new EventData();
           eventData.handler = handler;
           eventData.instance = instance;
           eventData.parmSelf = parmSelf;
           eventData.priority = priority;
           list.Add(eventData);
           list.Sort((e1, e2) => { return e2.priority.CompareTo(e1.priority); });
           return eventData;
        }

        public void DelInternalHandler(string eventType, object instance)
        {
            List<EventData> list;
           if (this._dataMap.ContainsKey(eventType))
           {
               list = (List<EventData>)this._dataMap[eventType];
           }
           else
           {
               return;
           }

           int count = list.Count;
           for (int i = 0; i < count; i++)
           {
               EventData data = list[i];
               if (data.instance == instance)
               {
                   list.RemoveAt(i);
                   break;
               }
           }
           list.Sort((e1, e2) => { return e2.priority.CompareTo(e1.priority); });
        }

        // / <summary>
        // / 移除回调
        // / </summary>
        // / <param name="eventType"></param>
        // / <param name="handler"></param>
        public void DelHandler(string eventType, EventData delData)
        {
           List<EventData> list;
           if (this._dataMap.ContainsKey(eventType))
           {
               list = (List<EventData>)this._dataMap[eventType];
           }
           else
           {
               return;
           }

           int count = list.Count;
           for (int i = 0; i < count; i++)
           {
               EventData data = list[i];
               if (data == delData)
               {
                   list.RemoveAt(i);
                   break;
               }
           }
           list.Sort((e1, e2) => { return e2.priority.CompareTo(e1.priority); });
        }

        public void SendInteralEvent(string eventType, object instance = null, params object[] args)
        {
           if (this._dataMap.ContainsKey(eventType) == false)
           {
               return;
           }

           List<EventData> list = (List<EventData>)this._dataMap[eventType];
           for (int i = list.Count - 1; i >=0; i--)
           {
               EventData d = list[i];
            //    if (d.instance == instance)
            //    {
                d.handler(d.parmSelf, eventType, args);
            //    }
           }
        }

        /// <summary>
        /// 发送事件
        /// </summary>
        /// <param name="eventType">EventDataType 类型的常量</param>
        /// <param name="instance">发送事件源对象 如果传入此值 那么事件接收的时候 只会派发给 同样注册了 这个值的回调</param>
        /// <param name="args">回调附带的参数</param>
        public void SendEvent(string eventType, object instance = null, params object[] args)
        {
            if(lua_event_bridge == null)
            {
                lua_event_bridge = GameFacade.Instance.LuaManager.GetFunction("LuaEventManager.SendEvent");
            }

            if (lua_event_bridge == null)
            {
                return;
            }

            if (args == null)
            {
                lua_event_bridge.Call<string, object>(eventType, instance);
            }
            else if (args.Length == 0)
            {
                lua_event_bridge.Call<string, object>(eventType, instance);
            }
            else if(args.Length == 1)
            {
                lua_event_bridge.Call<string, object, object>(eventType, instance, args[0]);
            }
            else if (args.Length == 2)
            {
                lua_event_bridge.Call<string, object, object, object>(eventType, instance, args[0], args[1]);
            }
            else if (args.Length == 3)
            {
                lua_event_bridge.Call<string, object, object, object, object>(eventType, instance, args[0], args[1], args[2]);
            }
            else if (args.Length == 4)
            {
                lua_event_bridge.Call<string, object, object, object, object, object>(eventType, instance, args[0], args[1], args[2], args[3]);
            }
            else if (args.Length == 5)
            {
                lua_event_bridge.Call<string, object, object, object, object, object, object>(eventType, instance, args[0], args[1], args[2], args[3], args[4]);
            }
        }

    }
}
