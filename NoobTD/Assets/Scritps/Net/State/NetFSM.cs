//------------------ NetFSM ------------------//
//               网络的状态控制

// 1. 断开状态;
// 2. 进行重连;
// 3. 连接成功; 
// 4. 进入重连;

//--------------------------------------------//

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public enum NET_STATE
    {
        DISCONNECT = 0,    //断开
        NORMAL = 1,    //连接正常
        RECONNECTING = 2,    //重连中
        RECONNECTFAIL = 3,    //重连失败
        NOTLOGIN = 4,    //尚未登录, 初始的时候都是这个状态
    }

    public class NetState
    {
        public NET_STATE TAG;
        //进入该状态
        public virtual void Enter() { }
        //检查当前状态 
        public virtual void Check() { }
        //离开状态
        public virtual void Leave() { }

        public NetState() { }
    }

    //-----------------------------------------  处于断开状态 ---------------------------------------
    public class DisconnectState : NetState
    {
        public DisconnectState() {   this.TAG = NET_STATE.DISCONNECT;  }

        public override void Enter()
        {

        }

        public override void Check()
        {

        }

        public override void Leave()
        {

        }
    }
    //-----------------------------------------------------------------------------------------------

    //-----------------------------------------  处于重连状态 ---------------------------------------
    public class Reconnecting : NetState
    {
        public Reconnecting() { this.TAG = NET_STATE.RECONNECTING; }

        public override void Enter()
        {

        }

        public override void Check()
        {

        }

        public override void Leave()
        {

        }
    }
    //-----------------------------------------------------------------------------------------------

    //--------------------------------------------  正常状态 ----------------------------------------
    public class Normal : NetState
    {
        public Normal() { this.TAG = NET_STATE.NORMAL; }

        public override void Enter()
        {

        }

        public override void Check()
        {

        }

        public override void Leave()
        {

        }
    }
    //-----------------------------------------------------------------------------------------------

    //-----------------------------------------  重连失败状态 ---------------------------------------
    public class ReconnectFail : NetState
    {
        public ReconnectFail() { this.TAG = NET_STATE.RECONNECTFAIL; }

        public override void Enter()
        {

        }

        public override void Check()
        {

        }

        public override void Leave()
        {

        }
    }
    //-----------------------------------------------------------------------------------------------
    //-----------------------------------------  还未登陆状态 ---------------------------------------
    public class NotLogin : NetState
    {
        public NotLogin() { this.TAG = NET_STATE.NOTLOGIN; }

        public override void Enter()
        {

        }

        public override void Check()
        {

        }

        public override void Leave()
        {

        }
    }
    //-----------------------------------------------------------------------------------------------

    public class NetFSM
    {
        private NetState _CurrentState = null;
        private List<NetState> _States = new List<NetState>();

        public NetFSM() { }

        public void AddState(NetState state)
        {
            _States.Add(state);
        }

        public void SetCurrent(NetState state)
        {
            _CurrentState = state;
        }

        //切换状态, 根据网络当前的情况, 来切换状态
        public void Transist(NET_STATE state)
        {

        }
    }
}

