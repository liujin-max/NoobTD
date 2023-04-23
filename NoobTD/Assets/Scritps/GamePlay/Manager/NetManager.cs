//网络模块: 先不接入复杂的网络逻辑, 而是模拟网络的回调/调用过程
//(*)中间可以做一些适当的假延迟，来达到模拟网络延迟的效果
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
// using FoodWar.Net;

namespace NoobTD
{
    public class NetManager : MonoBehaviour, IManager
    {
//         public string IP
//         {
//             get
//             {
//                 if(GameFacade.Instance.ConstManager.PTR == true)
//                 {
//                     //return "8.136.7.10";                              
//                     return "lhbjan.tanyu.mobi";                         //商业付费测试
//                 }
//                 else
//                 {
//                     return "47.96.5.236";
//                 }
//             }
//         }
//         public  const int       PORT = 9600;                        //端口号
//         private const float     BACKGROUND_MAX  = 15000f;           //切到背景后的最大socket维持时间
//         public  const float     HEART_BEAT_MAX  = 8000f;            //每隔多久发送一次心跳
//         public  const float     RECONNECT_MAX   = 3000f;            //5秒钟后, 如果没有回包, 判定重连失败
//         public int State = 0;

//         public int ReceivedSN
//         {
//             get
//             {
//                 return _socket_connection.ReceiveMessgeSn;
//             }
//         }

//         //如果没有登录前, 该变量一直保持false
//         private bool _BeforeConnecting = true;
//         public bool BeforeConnecting
//         {
//             get
//             {
//                 return _BeforeConnecting;
//             }
//             set
//             {
//                 _BeforeConnecting = value;
//             }
//         }

//         private bool _GameEntered = false;
//         public bool GameEntered
//         {
//             get { return _GameEntered;      }
//             set
//             {
//                 _GameEntered = value;
//             }
//         }

//         private bool _WaitingManualReconnect = false;
//         private bool _ReconnectFailed = false;
//         private bool _IsReconnecting = false;
//         private bool IsReconnecting
//         {
//             get
//             {
//                 return _IsReconnecting;
//             }
//             set
//             {
//                 _IsReconnecting = value;
//             }
//         }

//         private bool _NeedReconnect = false;
//         private bool NeedReconnect
//         {
//             get
//             {
//                 var r = _NeedReconnect;
//                 if (_NeedReconnect == true)
//                 {
//                     _NeedReconnect = false;
//                 }
//                 return r;
//             }
//         }

//         // 接收到的流水号， 用于断线重连时的补发消息
//         // 这里的逻辑是，当请求流水号到N时，假设当前接收到的流水号为M，
//         // 则服务器需要补发M后的所有包过来
//         private bool _NeedDisconnect = false;
//         private bool NeedDisconnect
//         {
//             get
//             {
//                 var r = _NeedDisconnect;
//                 if (_NeedDisconnect == true)
//                 {
//                     _NeedDisconnect = false;
//                 }
//                 return r;
//             }
//         }

//         //是否在后台
//         private bool _IsInBackGround = false;
//         public bool IsInBackGround
//         {
//             get
//             {
//                 return _IsInBackGround;
//             }
//         }

//         private Queue<Instruction> _requestQueue	        = new Queue<Instruction>();
//         private Queue<Instruction> _responseQueue	        = new Queue<Instruction>();
//         private Queue<string> _net_logQueue                 = new Queue<string>();     //缓存发送消息

//         private SocketConnection _socket_connection = null;

//         private System.Timers.Timer _tickTimer = new System.Timers.Timer(100);
//         private long _LastTimeInMilliseconds = 0;

//         //如果15秒钟之内，没有收到服务器的同步心跳，则断开重连
//         private long _LastHeartBeatMilliStamp = 0;

//         //开始重连的时间戳
//         private long _BeginReconnectStamp = 0;

//         private Reachability _Reachablity = null;

//         private NetFSM _FSM = new NetFSM();

//         private void Awake()
//         {
//             _socket_connection = new SocketConnection();
//             _socket_connection.socketEventHandler = SocketEventProcess;

//             // 初始化各种状态 -----------------------------------------
//             DisconnectState ST_Disconnect   = new DisconnectState();
//             Reconnecting ST_Reconnecting    = new Reconnecting();
//             Normal ST_Normal                = new Normal();
//             ReconnectFail ST_ReconnectFail  = new ReconnectFail();
//             NotLogin ST_NotLogin            = new NotLogin();

//             _FSM.AddState(ST_Disconnect);
//             _FSM.AddState(ST_Reconnecting);
//             _FSM.AddState(ST_Normal);
//             _FSM.AddState(ST_ReconnectFail);
//             _FSM.AddState(ST_NotLogin);
//             _FSM.SetCurrent(ST_NotLogin);
//             //---------------------------------------------------------

//             _tickTimer.Elapsed += (object sender, global::System.Timers.ElapsedEventArgs e) => Tick();
//             _tickTimer.AutoReset = true;
//             _tickTimer.Start();

//             _Reachablity = this.gameObject.AddComponent<Reachability>();
//         }

//         private void Tick()
//         {
//             //1. 激活阶段
//             var currentTimeInMilliseconds = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//             if (_IsInBackGround == false)
//             {
//                 _socket_connection.DispatchResponse();
//             }


//             //如果处于连线中
//             if (_IsInBackGround == true && _BeforeConnecting == false)
//             {
//                 var p = currentTimeInMilliseconds - _LastTimeInMilliseconds;
//                 if (currentTimeInMilliseconds - _LastTimeInMilliseconds > BACKGROUND_MAX && _socket_connection.connected == true)
//                 {
//                     Debug.Log("==== INTO DISCONNECT0 ===");
//                     _NeedDisconnect = true;
//                     _LastTimeInMilliseconds = currentTimeInMilliseconds;
//                 }
//             }

//             //如果Socket收不到心跳了
//             if (_IsInBackGround == false && _BeforeConnecting == false && SocketAlive() == true)
//             {
//                 if (currentTimeInMilliseconds - _LastHeartBeatMilliStamp > HEART_BEAT_MAX)
//                 {
//                     Debug.Log("==== INTO DISCONNECT1 ===");
//                     _NeedDisconnect = true;
//                 }
//             }

//             //如果物理断线了, 网络却连着, 而没有断线重连
//             if (_Reachablity.CheckNetworkDisconnected() == true && _NeedDisconnect == false && SocketAlive() == true)
//             {
//                 Debug.Log("==== INTO DISCONNECT2 ===");
//                 _NeedDisconnect = true;
//             }

//             if (_ReconnectFailed == false && _NeedDisconnect == false && _IsReconnecting == false && _IsInBackGround == false && _BeforeConnecting == false && SocketAlive() == false)
//             {
//                 Debug.Log("==== INTO RECONNECT ===");
//                 _NeedReconnect = true;
//                 _WaitingManualReconnect = false;
//                 _LastHeartBeatMilliStamp = currentTimeInMilliseconds;
//             }

//             if (_ReconnectFailed == false && _IsReconnecting == true && _IsInBackGround == false && _BeforeConnecting == false)
//             {
//                 if (currentTimeInMilliseconds - _BeginReconnectStamp > RECONNECT_MAX)
//                 {
//                     Debug.Log("==== INTO RECONNECT FAILED ===");
//                     _ReconnectFailed = true;
//                 }
//             }
//         }

//         public bool SocketAlive()
//         {
//             return _socket_connection.connected;
//         }

//         public void RetryReconnect()
//         {
//             _IsReconnecting = false;
//             _ReconnectFailed = false;
//             _WaitingManualReconnect = false;
//             _BeginReconnectStamp = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//         }

//         //重连
//         public void FinishReconnect()
//         {
//             _IsReconnecting     = false;
//             _ReconnectFailed    = false;
//             GameEntered        = true;     //说明真正进入了游戏
//             //=== 重发余下的包 ===
//             ReSendRequest();
//         }

//         //第一次连接
//         public void FinishConnect()
//         {
//             GameEntered = true;     //说明真正进入了游戏
//         }

//         public void BackToBeginning()
//         {
//             _NeedReconnect      = false;
//             _BeforeConnecting   = true;
//             _ReconnectFailed    = false;
//             _IsReconnecting     = false;
//             SocketConnection.instance.ClearStoredMsg();
//         }
        
//         public void ResetHeartBeat()
//         {
//             Debug.Log("#### Reset Heart Beat ####");
//             _LastHeartBeatMilliStamp = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//         }

//         //断开Socket
        public void DisconnectSocket(bool isDispathEvent, bool isClearBufResponses, int errorId = 0)
        {
            // _socket_connection.Disconnect(isDispathEvent, isClearBufResponses, errorId);
            // GameEntered = false;
        }

//         private void OnApplicationQuit()
//         {
//             DisconnectSocket(true, true);
//             _tickTimer.Close();
//         }

//         //连接Socket
//         public void ConnectSocket(string serverIP, int serverPort, LuaFunction callback)
//         {
//             if(_Reachablity.CheckNetworkDisconnected() == false)
//             {
//                 _socket_connection.Connect(serverIP, serverPort);
//                 StartCoroutine(OnSocketConnect(callback));
//             }
//         }

//         //处理
        public bool ProcessRawResponse(SocketStream stream)
        {
            return false;
            // return _socket_connection.OnResponse(stream);
        }

//         private void OnApplicationFocus(bool focus)
//         {
//             if (focus == true) //启动游戏
//             {
//                 Debug.Log("<color=red>############回到app###############</color>");
//                 _IsInBackGround = false;
//             }
//             else
//             {
//                 _LastTimeInMilliseconds = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//                 Debug.Log("<color=red>############进入后台###############</color>");
//                 _IsInBackGround = true;
//             }
//         }

//         //#################################################### 几个主要方法 ######################################################//

        public void EnqueueNetLog(string log)
        {
            // this._net_logQueue.Enqueue(log);
        }

//         //将解析出来的Response数据, 发送给Lua
//         public void ReceiveResponse(int SN, int ModuleID, int MSGID, int MsgIndex, int ErrCode, string JsonData)
//         {
//             //----------------------------------------------------------------------------------------------------------------------------------------------------
//             string log = "===>收到消息: 模块信息" + ModuleID + " 消息名称 " + MSGID + " 消息序列 " + MsgIndex + " 错误信息 " + ErrCode + " 消息体 " + JsonData;
//             print("<color=cyan>" + log + "</color>");
//             _net_logQueue.Enqueue(log);
//             //this.SendHTTPRequest("Public/BuriedPoint", log, true, null);
//             //----------------------------------------------------------------------------------------------------------------------------------------------------
//             Instruction ins = new Instruction();
//             ins.MSG = MSGID;
//             ins.Module = ModuleID;
//             ins.Data = JsonData;
//             ins.ErrorCode = ErrCode;

//             _responseQueue.Enqueue(ins);
//         }

//         public void ReSendRequest()
//         {
//             _socket_connection.ReSendMsg();
//         }

//         private bool IsLoginMSG(int MSGID)
//         {
//             return MSGID == 1001 || MSGID == 1004;
//         }

//         public void SendRequest(int ModuleID, int MSGID, string JsonData)
//         {
//             bool connected = _Reachablity.CheckNetworkDisconnected() == false && this.SocketAlive() == true;
//             //这里要改成真正1004完成后, 再发送

//             // Debug.Log("===> 发送消息: " + MSGID + " " + this.GameEntered);
//             if (connected && (IsLoginMSG(MSGID) || this.GameEntered))
//             {
//                 int MsgIndex = _socket_connection.SendMsg(ModuleID, MSGID, JsonData);
//                 //----------------------------------------------------------------------------------------------------------------------------------------------------
//                 string log = "<===发送消息: 模块信息" + ModuleID + " 消息名称 " + MSGID + " 消息序列 " + MsgIndex + " 消息体 " + JsonData;
//                 print("<color=cyan>" + log + "</color>");
//                 _net_logQueue.Enqueue(log);
//                 //this.SendHTTPRequest("Public/BuriedPoint", log, true, null);
//                 //----------------------------------------------------------------------------------------------------------------------------------------------------
//             }
//             else
//             {
//                 int MsgIndex = _socket_connection.StoreMsg(ModuleID, MSGID, JsonData);
//                 //----------------------------------------------------------------------------------------------------------------------------------------------------
//                 string log = "[===]断网储存消息: 模块信息" + ModuleID + " 消息名称 " + MSGID + " 消息序列 " + MsgIndex + " 消息体 " + JsonData;
//                 print("<color=cyan>" + log + "</color>");
//                 _net_logQueue.Enqueue(log);
//                 //this.SendHTTPRequest("Public/BuriedPoint", log, true, null);
//                 //----------------------------------------------------------------------------------------------------------------------------------------------------
//             }
//         }

//         public void SendHTTPRequest(string URL, string content, bool post, int reconnect_times, LuaFunction callback)
//         {
//             HTTPRequest request = new HTTPRequest(IP, PORT, URL, content, post, reconnect_times, callback);
//         }

// //########################################################################################################################//
    
//         private IEnumerator OnSocketConnect(LuaFunction callback)
//         {
//             while(_socket_connection.connected == false)
//             {
//                 yield return null;
//             }
//             callback.Call();
//         }

        public void HTTPProgress(IEnumerator ie)
        {
            // StartCoroutine(ie);
        }

//         public void SocketEventProcess(SocketEvent socket_event)
//         {
//             if(socket_event.event_type == SocketEvent.HEARTBEAT)
//             {
//                 _LastHeartBeatMilliStamp = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//                 Debug.Log("<color=green>心跳消息: HEART BEAT ...</color>");
//             }
//         }

//         public void FakeSend(int msg, int module, string msg_entity)
//         {
//             //Debug.Log("##### ===> FAKESEND <=== " + msg + " " + module);
//             Instruction ins = new Instruction();
//             ins.MSG = msg;
//             ins.Module = module;
//             ins.Data = msg_entity;
//             ins.ErrorCode = 0;

//             _requestQueue.Enqueue(ins);
//         }

// 		public void FakeReceive(int msg, int module, string msg_entity)
//         {
//             //Instruction ins = new Instruction();
//             //ins.MSG = msg;
//             //ins.Module = module;
//             //ins.Data = msg_entity;

//             //_responseQueue.Enqueue(ins);
//         }

//         private void ServerProcess(Instruction instruction)
//         {
//             EventManager.instance.SendEvent("SERVER_GATEWAY_RECEIVED", null,
//                 instruction.MSG,
//                 instruction.Module,
//                 instruction.Data,
//                 instruction.ErrorCode
//             );
//         }

// 		private void ClientProcess(Instruction instruction)
//         {
//             if (instruction != null)
//             {
//                 EventManager.instance.SendEvent("CLIENT_NET_RECEIVED", null,
//                    instruction.MSG,
//                    instruction.Module,
//                    instruction.Data,
//                    instruction.ErrorCode
//                );
//             }
//         }

//         private void Update()
//         {
//             if (NeedDisconnect == true)
//             {
//                 Debug.Log("INTO NEED DISCONNECT ==========>");
//                 this.DisconnectSocket(true, true);
//             }

//             if (_ReconnectFailed == true && _WaitingManualReconnect == false)
//             {
//                 _WaitingManualReconnect = true;
//                 Debug.Log("INTO ACCOUNT_RECONNECT_FAILED ==========>");
//                 EventManager.instance.SendEvent("ACCOUNT_RECONNECT_FAILED", null);
//             }

//             if (NeedReconnect == true)
//             {
//                 var currentTimeInMilliseconds = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
//                 _BeginReconnectStamp = currentTimeInMilliseconds;
//                 _IsReconnecting = true;
//                 Debug.Log("INTO RECONNECT ==========>");

//                 EventManager.instance.SendEvent("ACCOUNT_RECONNECT", null);
//             }

//             if(_net_logQueue.Count > 0)
//             {
//                 string log = _net_logQueue.Dequeue();
//                 EventManager.instance.SendEvent("NET_LOG_TRACK", null, log);
//             }

//             //Request => 请求队列
//             while (_requestQueue.Count > 0)
//             {
//                 var instruction = _requestQueue.Dequeue();
//                 ServerProcess(instruction);
//             }

//             //Response => 回应队列
//             while (_responseQueue.Count > 0)
//             {
//                 var instruction = _responseQueue.Dequeue();
//                 ClientProcess(instruction);
//             }
//         }
    }
}
