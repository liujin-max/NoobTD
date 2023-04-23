using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

/// <summary>
/// 计时器管理器此计时器的侦听派发的计算频率为1S一次
/// </summary>
namespace NoobTD
{
    public class ServerTimeManager
    {
        //public static readonly ServerTimeManager instance = new ServerTimeManager();

        //private Dictionary<string, object> _timeCountParm = new Dictionary<string, object>();
        //private Dictionary<string, Action<object>> _timeCountAction = new Dictionary<string, Action<object>>();


        //// 上一次检测socket发送的时间
        //private long sendTime = 0;
        //// 心跳时间
        //public uint updateTime = 15000;

        ////当前的时间(毫秒)

        //public double curTime
        //{
        //    get
        //    {
        //        return _lastUpdateTime > 0 ? _lastUpdateTime + passUpdateTime : 0;
        //    }
        //}

        //private int passUpdateTime
        //{
        //    get
        //    {
        //        return (int)((TimeUtil.unscaledTime - _lastUpdateClientTime) * 1000);
        //    }
        //}

        //private double _lastUpdateClientTime = 0;

        //private double _lastUpdateTime = 0;

        //// 是否正在发送请求
        //private bool _isSending = true;


        //private vp_Timer.Handle _timeHandler;

        //public ServerTimeManager()
        //{
        //    _timeHandler = new vp_Timer.Handle();
        //}

        //public void InitTime()
        //{
        //    _timeHandler.Cancel();
        //    vp_Timer.In(1, TimeCount, -1, _timeHandler, true);
        //}

        ///// <summary>
        ///// 更新计时器的时间 此方法业务请勿调用 内部直接会调用更新
        ///// </summary>
        ///// <param name="time"></param>
        //public void UpdateTime(double time)
        //{
        //    _isSending = false;
        //    if (time <= 0)
        //        return;

        //    _lastUpdateTime = time;

        //    _lastUpdateClientTime = TimeUtil.unscaledTime;
        //}

        //public void AddTimeCountEvent(string key, Action<object> action, object parm)
        //{
        //    if (!_timeCountAction.ContainsKey(key))
        //    {
        //        _timeCountAction.Add(key, action);
        //        _timeCountParm.Add(key, parm);
        //    }
        //    else
        //    {
        //        _timeCountAction[key] = action;
        //        _timeCountParm[key] = parm;
        //    }
        //}

        //public void RemoveTimeCountEvent(string key)
        //{
        //    _timeCountAction.Remove(key);
        //    _timeCountParm.Remove(key);
        //}


        //private void TimeCount()
        //{
        //    LogManager.instance.WriteLog();

        //    foreach (string key in new List<string>(_timeCountAction.Keys))
        //    {
        //        _timeCountAction[key](_timeCountParm[key]);
        //    }

        //    if (_lastUpdateTime <= 0 || _isSending)
        //        return;

        //    ////每3S 检测一次 socket层发送的情况
        //    //if ( Math.Abs(passUpdateTime - sendTime) > 3000)
        //    //{
        //    //    sendTime = passUpdateTime;
        //    //    SocketConnection.instance.CheckSendState();
        //    //}

        //    if (passUpdateTime > updateTime)
        //    {
        //        _isSending = true;
        //        EventManager.instance.SendEvent(GameEventType.GAME_SERVER_TIME_UPDATE, null, null);
        //    }
        //}

    }
}
