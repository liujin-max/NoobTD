/*
* 与服务器通讯类
* user: echo
*/
using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Net.Sockets;
using System.Collections;
using System;
using zlib;
using LuaFramework;

namespace NoobTD
{
    public class SocketConnection
    {
        public static readonly SocketConnection instance = new SocketConnection();

        private const int STREAM_BUF_LEN = 8193 + 4096;

        public delegate void SocketEventHandler(SocketEvent evt);
        private SocketEventHandler _socketEventHandler;
        public SocketEventHandler socketEventHandler
        {
            get
            {
                return _socketEventHandler;
            }
            set
            {
                _socketEventHandler = value;
            }
        }


        public delegate void ProtocolEventHandler(ProtocolEvent evt);
        public ProtocolEventHandler protocolEventHandler;

        // socket对象
        private TcpClient _socket;
        public TcpClient socket
        {
            get
            {
                return _socket;
            }
        }
        // 是否和服务器保持连接
        private volatile bool _connected;
        public bool connected
        {
            get
            {
                return _connected;
            }
        }
        // 服务器地址
        private string _serverIp;
        // 服务器端口
        private int _serverPort;
        // 流水号
        private int _messageSn = 1;
        // 接收到的流水号， 用于断线重连时的补发消息
        // 这里的逻辑是，当请求流水号到N时，假设当前接收到的流水号为M，
        // 则服务器需要补发M后的所有包过来
        private int _receivedMessageSn;
        // 读取的二进制数据缓冲区
        private SocketLoopStream _buf_stream;

        public int ReceiveMessgeSn
        {
            get { return _receivedMessageSn;  }
            set { _receivedMessageSn = value; }
        }

        // 请求返回队列
        private Queue _responses;
        private List<Request> _reqeust_records;

        /// <summary>
        /// 获取队列信息
        /// </summary>
        public Queue responses
        {
            get
            {
                return _responses;
            }
        }

        public int GetResponsesCount
        {
            get
            {
                if (_responses == null)
                {
                    return 0;
                }
                return _responses.Count;
            }
        }

        // 单帧最大请求派发数
        private const int MAX_RESPONSE_HANDLE_NUM = 30;

        //发送snId
        private int _sendMessgeSnId;

        //重新连接的次数
        private int _connectMaxTimes = 3;

        //当前重新连接的次数
        private int _currentConnectedTime = 0;

        //socket线程类
        private SocketThread _socketThread;

        private int mainThread = 0;

        //socket的后台状态
        private volatile bool _backType = false;
        public bool backType
        {
            get
            {
                return _backType;
            }
            set
            {
                _backType = value;
            }
        }


        public bool isMainThread()
        {
            return System.Threading.Thread.CurrentThread.ManagedThreadId == mainThread;
        }


        public SocketConnection()
        {
            _connected = false;
            _buf_stream = new SocketLoopStream(STREAM_BUF_LEN);

            //Response
            _responses          = Queue.Synchronized(new Queue());
            _reqeust_records    = new List<Request>();

            mainThread = System.Threading.Thread.CurrentThread.ManagedThreadId;
        }

        public void ClearEvent()
        {
            socketEventHandler = null;
            protocolEventHandler = null;
        }

        // 与服务端建立连接
        public void Connect(string serIp, int serPort)
        {
            _serverIp = serIp;
            _serverPort = serPort;


            if(_buf_stream != null)
            {
                Debug.Log("### 清空网络缓存 ###");
                _buf_stream.Reset();
            }

            // 如果已经连接，就先断开连接
            if (_connected)
            {
                Disconnect(false, true, SocketEvent.SOCKET_ERROR_CONNECT_CHECK);
            }

            //Debug.Log("CONNECTING [" + _serverIp + ":" + _serverPort + "] ...");

            // 连接服
            try
            {
                //socket链接的时候 ios需要支持 ipv6  因为dns获取域名对应的ip地址比较耗时 所以只在ios下才处理
/*#if UNITY_IPHONE
                IPAddress connectIP = null;
                try
                {
                    IPAddress[] IPs = Dns.GetHostAddresses(_serverIp);
                    if (IPs.Length > 0)
                    {
                        connectIP = IPs[0];
                    }
                }
                catch(Exception e)
                {

                }

                if(connectIP == null)
                {
                    //这里抛出无网络的情况
                    if (socketEventHandler != null)
                    {
                        SocketEvent connectFailEvent = new SocketEvent(SocketEvent.CONNECT_FAIL);
                        connectFailEvent.errorCodeId = SocketEvent.SOCKET_CONNECT_GET_DNS_FAIL;
                        _responses.Enqueue(connectFailEvent);
                    }
                    return;
                }

                bool ipv6 = false;
                if(connectIP.AddressFamily == AddressFamily.InterNetworkV6)
                {
                    ipv6 = true;
                }

                if (_socket == null)
                {
                    if(ipv6 == true)
                    {
                        _socket = new TcpClient(AddressFamily.InterNetworkV6);
                    }
                    else
                    {
                        _socket = new TcpClient(AddressFamily.InterNetwork);
                    }
                    _socket.NoDelay = true;
                    _socket.Client.SendBufferSize = 65000;
                    _socket.ReceiveBufferSize = 65000;
                    _socket.SendTimeout = 5000;
                }
                _socket.BeginConnect(connectIP, _serverPort, new AsyncCallback(OnConnect), _socket);
#else */

                if (_socket == null)
                {
                    _socket = new TcpClient();
                    _socket.NoDelay = true;
                    _socket.Client.SendBufferSize = 65000;
                    _socket.ReceiveBufferSize = 65000;
                    _socket.SendTimeout = 5000;
                }
                _socket.BeginConnect(_serverIp, _serverPort, new AsyncCallback(OnConnect), _socket);
//#endif
            }
            catch (Exception e)
            {
                _currentConnectedTime++;
                if (_currentConnectedTime >= this._connectMaxTimes)
                {
                    //抛出连接失败 不再重新连接的接口到lua层
                    _currentConnectedTime = 0;
                    if (socketEventHandler != null)
                    {
                        SocketEvent connectFailEvent = new SocketEvent(SocketEvent.RE_CONECT_FAIL);
                        if (e is SocketException)
                        {
                            connectFailEvent.errorCodeId = (e as SocketException).ErrorCode;
                        }
                        _responses.Enqueue(connectFailEvent);
                    }
                }
                else
                {
                    if (socketEventHandler != null)
                    {
                        SocketEvent connectFailEvent = new SocketEvent(SocketEvent.CONNECT_FAIL);
                        if (e is SocketException)
                        {
                            connectFailEvent.errorCodeId = (e as SocketException).ErrorCode;
                        }
                        _responses.Enqueue(connectFailEvent);
                    }
                }

                //LogManager.instance.Log("Socket开始Connect错误: " + e.Message + e.StackTrace, LogManager.NORMAL);
            }
        }

        // 线程执行连接
        private void OnConnect(IAsyncResult ar)
        {
            try
            {
                // 与服务器取得连接，如果连接失败这里将抛出异常
                _socket.EndConnect(ar);
                //连接成功的时候 重置次数
                _currentConnectedTime = 0;
                //初始化socket的发送线程
                _socketThread = new SocketThread();

                _socketThread.Init(_socket.Client);

                _socketThread.Start();
                // 连接成功
                Debug.Log("SERVER [" + _serverIp + ":" + _serverPort + "] CONNECTED SUCCESS...");
                _connected = true;
                if (socketEventHandler != null)
                {
                    SocketEvent connectEvent = new SocketEvent(SocketEvent.CONNECT);
                    _responses.Enqueue(connectEvent);
                }
            }
            catch (Exception e)
            {
                _currentConnectedTime++;
                if (_currentConnectedTime >= this._connectMaxTimes)
                {
                    //抛出连接失败 不再重新连接的接口到lua层
                    _currentConnectedTime = 0;
                    if (socketEventHandler != null)
                    {
                        SocketEvent connectFailEvent = new SocketEvent(SocketEvent.RE_CONECT_FAIL);
                        if (e is SocketException)
                        {
                            connectFailEvent.errorCodeId = (e as SocketException).ErrorCode;
                        }
                        _responses.Enqueue(connectFailEvent);
                    }
                }
                else
                {
                    if (socketEventHandler != null)
                    {
                        SocketEvent connectFailEvent = new SocketEvent(SocketEvent.CONNECT_FAIL);
                        if (e is SocketException)
                        {
                            connectFailEvent.errorCodeId = (e as SocketException).ErrorCode;
                        }
                        _responses.Enqueue(connectFailEvent);
                    }
                }

                //LogManager.instance.Log("Socket回调Connect后错误: " + e.Message + e.StackTrace, LogManager.NORMAL);
            }
        }

        /// <summary>
        /// 接收socket返回的信息 
        /// </summary>
        /// <param name="stream"></param>
        public bool OnResponse(SocketStream stream)
        {
            int dest = 0;
            int cmd = 0;
            int bufSize = 0;
            bool error = false;
            try
            {
                stream.Decode();
                bufSize = stream.position;
                ParseResponse(stream.srcBuf, bufSize);
            }
            catch (Exception e)
            {
                error = true;
                //Debug.Log("Socket解析发送过来的数据包错误  包大小=" + bufSize + " : " + e.Message + "," + e.StackTrace);
                Disconnect(true, true,SocketEvent.SOCKET_ERROR_RESPONSE_ERROR);
            }
            return error;
        }

        private void ParseResponse(byte[] srcBytes, int newDataRecivedLength)
        {
            //Debug.Log("####### ParseResponse origin " + _buf_stream.Length + " add " + newDataRecivedLength + " length " + srcBytes.Length);
            // 数据初始化

            _buf_stream.LoopCopy(srcBytes, newDataRecivedLength);

            //如果现在的_buf_stream的长度大于包头长度, 意味着存在解包可能
            //Debug.Log("####### Length Compare " + _buf_stream.Length + "  " + ResponseType.PACKET_HEAD_ID_LENGTH);
            while(_buf_stream.Length >= ResponseType.PACKET_HEAD_ID_LENGTH)
            {
                int demand_length = _buf_stream.ReadInt();

                if (demand_length > (_buf_stream.Length + ResponseType.PACKET_HEAD_ID_LENGTH)) //如果数据不足, 则回退, 其中包括int4字节
                {
                    _buf_stream.Revert(ResponseType.PACKET_HEAD_ID_LENGTH);
                    break;
                }
                else
                {
                    
                    _buf_stream.ReadByte(); // FLAG
                    byte check_byte = _buf_stream.ReadByte(); // CHECK
                    
                    int MsgIndex    = _buf_stream.ReadShort(); // MSGINDEX
                    int ErrCode     = _buf_stream.ReadShort();  // ErrCode
                    int MainId      = _buf_stream.ReadShort();   // 主消息
                    int SubId       = _buf_stream.ReadShort();    // 子消息

                    //Debug.Log("####### DEMAND LENGTH " +  "  " + demand_length + " " + _buf_stream.Length + " " + MainId + " " + SubId);

                    int DataLen = demand_length - ResponseType.PACKET_HEAD_LENGTH;

                    byte[] datas = _buf_stream.ReadDataBlock(DataLen);

                    string JsonData = null;
                    if (check_byte == 1)
                    {
                        //Debug.Log("Need Decompressed! " + MainId + " " + SubId);
                        JsonData = ZipUtility.DecompressBytes(datas);
                    }
                    else
                    {
                        //Debug.Log("No Decompressed! " + MainId + " " + SubId);
                        JsonData = Encoding.UTF8.GetString(datas);
                    }

                    Response rd = new Response();
                    rd.MainId = MainId;
                    rd.SubId = SubId;
                    rd.MsgIndex = MsgIndex;
                    rd.ErrCode = ErrCode;
                    rd.Datas = JsonData;


                    if (MainId == 0 && SubId == 10)
                    {
                        SocketEvent heartBeatEvent = new SocketEvent(SocketEvent.HEARTBEAT);
                        responses.Enqueue(heartBeatEvent);
                    }
                    else
                    {
                        responses.Enqueue(rd);
                    }
                }
            }
        }

        /// <summary>
        /// 派发返回请求
        /// </summary>
        public void DispatchResponse()
        {
            Response response = null;
            try
            {
                int responseCount = 0;

                // 每帧最多派发30条数据
                while (_responses.Count > 0)
                {
                    if (responseCount >= MAX_RESPONSE_HANDLE_NUM)
                        break;

                    responseCount++;
                    object queueObj = _responses.Dequeue();
                    if (queueObj is Response)
                    {
                        response = queueObj as Response;
                        if (response != null)
                        {
                            DoResponse(response);
                        }
                    }
                    else if (queueObj is SocketEvent)
                    {
                        if (socketEventHandler != null)
                        {
                            SocketEvent socketEvent = queueObj as SocketEvent;
                            socketEventHandler(socketEvent);
                        }
                    }
                    //else if (queueObj is ProtocolEvent)
                    //{
                    //    //GameCommandBase.ClearWait();
                    //    //if (protocolEventHandler != null)
                    //    //{
                    //    //    ProtocolEvent protocolEvent = queueObj as ProtocolEvent;
                    //    //    protocolEventHandler(protocolEvent);
                    //    //}
                    //}
                }
            }
            catch (Exception ex)
            {
                //获取输出的日志
                //if (response != null && response is Response)
                //{
                //    Instruction ins = (response as Response).instruction;
                //    if (ins != null)
                //    {
                //        string error = "【Socket 派发消息错误】:" + ins.moduleId + "_" + ins.cmd + ",解析出现问题 请检查";

                //        //if (response.oriString != "" && response.oriString != null)
                //        //{
                //        //    error += "【" + response.oriString + "】";
                //        //}
                //        error += ex.Message + "," + ex.StackTrace;

                //        //LogManager.instance.Log(error, LogManager.WARNING);
                //    }
                //}
                //else
                //{
                //    // 这里输出日志
                //    //LogManager.instance.Log("Socket 派发消息错误: " + ex.Message + "," + ex.StackTrace, LogManager.WARNING);
                //}
            }
        }

        /// <summary>
        /// 处理响应
        /// </summary>
        /// <param name="response">响应数据对象</param>
        private void DoResponse(Response resp)
        {
            lock(_reqeust_records)
            {
                bool duplicate = true;
                lock (_reqeust_records)
                {
                    for (int i = _reqeust_records.Count - 1; i >= 0; i--)
                    {
                        var r = _reqeust_records[i];
                        if (r.MsgIndex == resp.MsgIndex)
                        {
                            _reqeust_records.RemoveAt(i);
                            duplicate = false;
                        }
                    }
                }

                if (resp.MsgIndex > this.ReceiveMessgeSn)
                {
                    // GameFacade.Instance.NetManager.ReceiveResponse(resp.MsgIndex, resp.MainId, resp.SubId, resp.MsgIndex, resp.ErrCode, resp.Datas);
                    this.ReceiveMessgeSn = resp.MsgIndex;
                }
                else if (resp.SubId == 1001 || resp.SubId == 1004)
                {
                    string log = "####丢弃重复登陆类消息: " + resp.MsgIndex + " " + resp.MainId + " " + resp.SubId;
                    UnityEngine.Debug.Log("<color=cyan>" + log + "</color>");
                    // GameFacade.Instance.NetManager.EnqueueNetLog(log);
                }
                else if (duplicate == false || resp.MsgIndex == 0)
                {
                    // GameFacade.Instance.NetManager.ReceiveResponse(resp.MsgIndex, resp.MainId, resp.SubId, resp.MsgIndex, resp.ErrCode, resp.Datas);
                }
                else
                {
                    string log = "####丢弃重复消息: " + resp.MsgIndex + " " + resp.MainId + " " + resp.SubId;
                    UnityEngine.Debug.Log("<color=cyan>" + log + "</color>");
                    // GameFacade.Instance.NetManager.EnqueueNetLog(log);
                }
            }
        }

        public void ClearStoredMsg()
        {
            lock(_reqeust_records)
            {
                _reqeust_records.Clear();
            }
        }

        public void ReSendMsg()
        {
            lock(_reqeust_records)
            {
                //----------------------------------------------------------------------------------------------------------------------------------------------------
                string log = "####补发消息条数: " + _reqeust_records.Count;
                UnityEngine.Debug.Log("<color=cyan>" + log + "</color>");
                GameFacade.Instance.NetManager.EnqueueNetLog(log);
                //----------------------------------------------------------------------------------------------------------------------------------------------------
                for (int i = 0; i < _reqeust_records.Count; i++)
                {
                    var request = _reqeust_records[i];
                    //_reqeust_records[i].MsgIndex = GetMessageSN();  //重新赋予一个流水号
                    //SendMsg(request.MainId, request.SubId, request.Data, true, request.MsgIndex); //重发消息
                    SendMsg(request.MainId, request.SubId, request.Data, true, request.MsgIndex); //重发消息

                    //----------------------------------------------------------------------------------------------------------------------------------------------------
                    string log_i = "####补发消息: 模块信息" + request.MainId + " 消息名称 " + request.SubId + " 流水号 " + request.MsgIndex;
                    UnityEngine.Debug.Log("<color=cyan>" + log_i + "</color>");
                    GameFacade.Instance.NetManager.EnqueueNetLog(log_i);
                    //----------------------------------------------------------------------------------------------------------------------------------------------------
                }
                //不需要清除, 等回包
                // _reqeust_records.Clear();
            }
        }

        //网络中断时使用
        public int StoreMsg(int MainId, int SubID, string Data, bool resend = false, int resend_sn = -1)
        {
            int sn = GetMessageSN();
            Request req = new Request();
            if (resend == false)
            {
                req.MsgIndex = sn;
            }
            else
            {
                req.MsgIndex = resend_sn;
            }
            req.MainId = MainId;
            req.SubId = SubID;
            req.ErrCode = 0;
            req.Data = Data;
            // 添加请求限制处理
            if (resend == false)
            {
                //假设是重连和进入游戏, 则不予理会, 那么在这种情况下,
                //因为这两个包将会主动触发
                if (req.SubId != 1004 && req.SubId != 1001)  
                lock (_reqeust_records)
                {
                    _reqeust_records.Add(req);     //压入栈中
                }
            }
            return sn;
        }

        // 发送消息
        public int SendMsg(int MainId, int SubID, string Data, bool resend = false, int resend_sn = -1)
        {
            Request req = new Request();
            int final_sn = -1;
            if (resend == false)
            {
                final_sn = GetMessageSN();
            }
            else
            {
                final_sn = resend_sn;
            }
            req.MsgIndex = final_sn;
            req.MainId = MainId;
            req.SubId = SubID;
            req.ErrCode = 0;
            req.Data = Data;
            // 添加请求限制处理
            //SocketRequestManager.instance.AddRequest(sn, MainId, SubID, 0);
            if (resend == false)
            {
                if (req.SubId != 1004 && req.SubId != 1001)
                {
                    lock (_reqeust_records)
                    {
                        _reqeust_records.Add(req);     //压入栈中
                    }
                }
            }

            if (!_connected || _socket == null)
            {
                Debug.Log("Not Actually Connected!");
                return final_sn;
            }

            if (_connected)
            {
                WriteToSocket(req);
            }

            return final_sn;
        }

        // 写进Socket
        private void WriteToSocket(Request request)
        {
            NetworkStream ns = null;
            try
            {
                ns = _socket.GetStream();
            }
            catch (Exception e)
            {
                Debug.Log("WriteToSocket: Exception " + e.ToString());
                SocketEvent disconnectEvent = new SocketEvent(SocketEvent.DISCONNECT);
                disconnectEvent.errorCodeId = SocketEvent.SOCKET_ERROR_SYSTEM_DISCONNECT;
                _responses.Enqueue(disconnectEvent);
                return;
            }

            if (ns != null && ns.CanWrite)
            {
                try
                {
                    // 组合要发送的处理数据
                    SocketStream valueByte = new SocketStream();
                    //数据内可能包含中文，就不能直接用request.Data.Length的方式来获取长度了
                    byte[] dataTemp = Encoding.UTF8.GetBytes(request.Data);
                    int valuesLen = ResponseType.PACKET_HEAD_LENGTH + dataTemp.Length; // 包头长度 + 数据长度
                    valueByte.InitStream(valuesLen);
                    // 写入数据
                    valueByte.WriteInt(valuesLen);                      // SIZE 4
                    valueByte.WriteByte((byte)request.Flag);            // FLAG 1
                    valueByte.WriteByte(0);                             // CHECK 1
                    valueByte.WriteShort((short)request.MsgIndex);      // 索引 2 
                    valueByte.WriteShort(0);                            // ERRCODE 2
                    valueByte.WriteShort((short)request.MainId);        // MainId 2
                    valueByte.WriteShort((short)request.SubId);         // SubId 2
                    valueByte.WriteString(request.Data);                // DATA
                    
                    valueByte.Encode();

                    //这里做容错 
                    //每次发送都循环一下 已经发送出去的列表中 是否有 未发出的线程数据 如果发现有超过5S 还没发送成功回调的 直接 抛出线程异常给业务去处理
                    SocketSendState state = new SocketSendState(request, this.GetSocketSendSN());
                    state.bytes = valueByte;

                    try
                    {
                        this._socketThread.SendToSocketByMainThread(state);
                    }
                    catch (Exception e)
                    {
                        Debug.Log("Socket  _socketThread 执行发送出现异常: " + e.Message);
                        //LogManager.instance.Log("Socket  _socketThread 执行发送出现异常: " + e.Message + e.StackTrace, LogManager.WARNING);
                        //这里有可能会有多线程空的问题 比如主线程正要发送一个数据 这个时候 子线程抛出断线 直接将对象清空
                    }
                }
                catch (Exception e)
                {
                    //LogManager.instance.Log("Socket 发送消息错误: " + e.Message + e.StackTrace, LogManager.WARNING);
                    Debug.Log("Socket 发送消息错误: " + e.Message + e.StackTrace);
                }
                finally
                {
                    //Debug.Log("Socket 消息发送 " + request.SubId);
                }
            }
        }

        public void SocketSendError(int errorId)
        {
            SocketEvent socketEvent = new SocketEvent(SocketEvent.SEND_ERROR);
            socketEvent.errorCodeId = errorId;
            socketEventHandler(socketEvent);
        }

        //检测发送的情况 修改为多线程发送 现在不需要检测
        public void CheckSendState()
        {
            //废弃
        }

        // 发送成功返回信息
        private void OnSend(IAsyncResult ar)
        {
            try
            {
                SocketSendState state = (SocketSendState)ar.AsyncState;

                _socket.Client.EndSend(ar);
            }
            catch (Exception e)
            {
                //LogManager.instance.Log("Socket发送成功返回信息错误: " + e.Message + e.StackTrace, LogManager.WARNING);
                Disconnect(true, false, SocketEvent.SOCKET_ERROR_SEND_ERROR);
            }
        }

        /// <summary>
        /// Socket连接断开
        /// </summary>
        /// <param name="isDispathEvent"> 是否抛出事件</param>
        /// <param name="isClearBufResponses"> 是否 清除数据</param>
        /// <param name="errorId">错误id  </param>
        public void OnDisconnect(bool isDispathEvent, bool isClearBufResponses, int errorId)
        {
            isClearBufResponses = false;

            //是否已经有断线重连的事件未抛出
            bool hasDisconnectEvent = false;
            ////如果要清除数据 直接清除
            if(isClearBufResponses)
            {
                _responses.Clear();
            }

            //if (isClearBufResponses)
            //{
            //    //这里clear先拿出之前的出来 判断里面是否存在协议层的内容 以及 要抛出的断线的内容
            //    object socketEvent = null;
            //    object queueData = null;
            //    object temp = null;
            //    while (_responses.Count > 0)
            //    {
            //        try
            //        {
            //            temp = _responses.Dequeue();
            //            if (temp is ProtocolEvent)
            //            {
            //                //只取第一个
            //                if (queueData == null)
            //                {
            //                    queueData = temp;
            //                }
            //            }
            //            else if (temp is SocketEvent)
            //            {
            //                //这里判断 socketEvent是不是断线类型
            //                bool isDisconnect = (temp as SocketEvent).IsDisconnect();
            //                if (isDisconnect == true && socketEvent == null)
            //                {
            //                    socketEvent = temp;
            //                }
            //            }
            //            if (queueData != null && socketEvent != null)
            //            {
            //                break;
            //            }
            //        }
            //        catch (Exception e)
            //        {

            //        }
            //    }
            //    _responses.Clear();
            //    //如果是要派发的断线才保留
            //    if (queueData != null && isDispathEvent == true)
            //    {
            //        _responses.Enqueue(queueData);
            //    }
            //    //如果是要派发的断线才保留最后一个断线重连数据
            //    if (socketEvent != null && isDispathEvent == true)
            //    {
            //        hasDisconnectEvent = true;
            //        _responses.Enqueue(socketEvent);
            //    }
            //}

            //if (_connected == true)
            //{
            //    //LogManager.instance.Log("Socket连接断开 errorId:" + errorId, LogManager.NORMAL);
            //}

            //_connected = false;

            //_messageSn = 0;
            //_buf = new SocketStream();
            //_buf.InitStream(0);

            //关闭socket的全部信息
            //这里执行的时候 可能是在子线程里面执行的 所以 需要try catch  finally 整个流程的情况下来进行 事件的处理
            try
            {
                if (_socketThread != null)
                {
                    _socketThread.Destroy();

                    _socketThread = null;
                }
            }
            catch (Exception e)
            {
                //Debug.Log("Exception When Destroy sockeThread " + e.ToString());
            }
            finally
            {
                if (isDispathEvent && socketEventHandler != null && hasDisconnectEvent == false)
                {
                    SocketEvent disconnectEvent = new SocketEvent(SocketEvent.DISCONNECT);
                    disconnectEvent.errorCodeId = errorId;
                    _responses.Enqueue(disconnectEvent);
                }
                if (_socket != null)
                {
                    _socket.Close();
                    _connected = false;
                    _socket = null;
                }
            }
        }

        // 关闭当前连接
        public void Disconnect(bool isDispathEvent, bool isClearBufResponses, int errorId = 0)
        {
            Debug.Log("===> 关闭线程 <===");
#if UNITY_EDITOR
            if(isMainThread() == false)
            {
                Debug.Log("子线程调用关闭当前链接" + isDispathEvent + isClearBufResponses + errorId);
            }
            else
            {
                Debug.Log("主线程调用关闭当前链接" + isDispathEvent + isClearBufResponses + errorId);
            }
#endif
            OnDisconnect(isDispathEvent, isClearBufResponses, errorId);
        }

        // 获取指令对应的编号
        private int GetMessageSN()
        {
            _messageSn++;
            if (_messageSn == Int32.MaxValue)
            {
                _messageSn = 1;
            }
            return _messageSn;
        }

        //获取socketSn回调的信息
        private int GetSocketSendSN()
        {
            _sendMessgeSnId++;
            if (_sendMessgeSnId == Int32.MaxValue)
            {
                _sendMessgeSnId = 1;
            }
            return _sendMessgeSnId;
        }

    }
}