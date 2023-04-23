using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace NoobTD
{
    //socket线程的状态
    public class SocketThreadState
    {
        //销毁
        public static int DESTROY = -1;

        //初始化状态
        public static int INIT = 0;

        //运行中
        public static int RUNNING = 1;
    }

    //socket线程类 
    public class SocketThread
    {
        //0 是未启动状态 -1是销毁状态 1是启动状态
        private volatile int _state = 0;
        //线程对象
        private Thread _sendThread;

        //接受数据的线程
        private Thread _receiveThread;

        //是否结束线程的标识
        private bool _isEnd = false;

        //发送队列
        private Queue _sendQueue;

        private SocketStream _receive = new SocketStream();

        private Socket _mSocket;

        //接收的数量
        private int hasCount = 0;

        //后台时间
        private long _backTime = 0;
        public long backTime
        {
            get
            {
                return _backTime;
            }
            set
            {
                _backTime = value;
            }
        }

        private long _nowTime = 0L;

        private long _disTime = 0L;

        //超时时间 1.5分钟  后台只给1.5分钟的时间
        private long _checkOutTime = 180 * 10000000L;

        //构造
        public SocketThread()
        {
            _sendQueue = Queue.Synchronized(new Queue());
            this._receive.InitStream(4096);
        }

        //初始化
        public void Init(Socket sock)
        {
            this._state = SocketThreadState.INIT;
            this._mSocket = sock;
            this._sendQueue.Clear();
            if (this._mSocket != null)
            {
                this._mSocket.SendTimeout = 5000;
            }
        }

        //开始处理
        public void Start()
        {
            this._isEnd = false;

            //发送
            _sendThread = new Thread(this.SendThreadHandler);
            _sendThread.Start();

            _receiveThread = new Thread(this.ReceiveThread);
            _receiveThread.Start();

            this._state = SocketThreadState.RUNNING;
        }

        //销毁的方法
        public void Destroy()
        {
            //sockt对象
            this._mSocket = null;

            this._state = SocketThreadState.DESTROY;

            Stop();

        }

        //抛出断线重连的处理
        private void Disconnect(bool isDispathEvent, bool isClearBufResponses, int errorId = 0)
        {
            if (this._state != SocketThreadState.RUNNING)
            {
                return;
            }
            GameFacade.Instance.NetManager.DisconnectSocket(isDispathEvent, isClearBufResponses, errorId);
        }

        //接收数据线程 
        private void ReceiveThread()
        {
            try
            {
                while (!this._isEnd)
                {
                    try
                    {
                        //只有在后台的时候才计时这个情况
                        //#if UNITY_IPHONE
                        if (SocketConnection.instance.backType == true)
                        {
                            if (backTime == 0)
                            {
                                backTime = System.DateTime.Now.Ticks;
                            }
                            _nowTime = System.DateTime.Now.Ticks;
                            _disTime = _nowTime - _backTime;

                            if (_disTime > _checkOutTime)
                            {
                                _backTime = _nowTime;
                                //超时了 断开线程 不再进行接收 等待回来断线重连
                                try
                                {
                                    //后台导致的断线 需要考虑一下 怎么处理
                                    Disconnect(true, true, SocketEvent.SOCKET_BACK_TYPE_TIME_OUT);
                                    //SocketConnection.instance.Disconnect(true, true, SocketEvent.SOCKET_BACK_TYPE_TIME_OUT);
                                    return;
                                }
                                catch (Exception e)
                                {

                                }
                            }
                        }
                        else
                        {
                            backTime = 0L;
                        }

                        //#endif
                        if (this._mSocket == null || this._mSocket.Connected == false)
                        {
                            Thread.Sleep(500);
                        }
                        else
                        {
                            if (this._receive.position > 0)
                            {
                                this._receive.InitStream(4096);
                                this._receive.position = 0;
                            }
                            //处理接收的情况
                            hasCount = 0;
                            //错误信息
                            int socketError = 9999;

                            try
                            {
                                hasCount = this._mSocket.Receive(this._receive.srcBuf, 0, 4096, SocketFlags.None);
                                UnityEngine.Debug.Log(" HASCOUNT " + hasCount);
                                if (hasCount > 0)
                                {
                                    this._receive.position = hasCount;
                                    bool isError = GameFacade.Instance.NetManager.ProcessRawResponse(this._receive);
                                    if (isError == true)
                                    {
                                        socketError = SocketEvent.SOCKET_ERROR_RESPONSE_ERROR;
                                    }
                                }
                                else if (hasCount <= 0)
                                {
                                    //长度为0的时候 需要断线重连
                                    socketError = SocketEvent.SOCKET_RECEIVE_ZERO_LENGTH;
                                }
                            }
                            catch (SocketException sex)
                            {
                                //Socket类型的错误
                                socketError = sex.ErrorCode;
                            }
                            catch (Exception ex)
                            {
                                //非socket类型导致的错误
                                socketError = SocketEvent.SOCKET_ERROR_RECEIVE_UNCATCH_ERROR;
                            }
                            finally
                            {
                                //发生过错误的情况下 则需要抛出 然后断线
                                if (socketError != 9999)
                                {
                                    UnityEngine.Debug.LogError("SOCKET ERROR " + socketError);
                                    Disconnect(true, true, socketError);
                                }
                                Thread.Sleep(10);
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        //如果发生了的错误 都是非socket的错误 是业务的报错
                        //UnityEngine.Debug.LogError("SOCKET ERROR EXCEPTION " + e.ToString());
                    }
                }
            }
            catch (Exception e)
            {
                //线程死掉的情况 是可控的 不处理
            }
        }

        /// <summary>
        /// 发送信息到socket
        /// </summary>
        public void SendToSocketByMainThread(SocketSendState state)
        {
            //现在使用异步发送的方案来处理
            this.SendToSocketAync(state);
        }

        public ThreadState CheckThreadState(Thread thread)
        {
            ThreadState state = ThreadState.Running;
            if ((thread.ThreadState & ThreadState.Aborted) == ThreadState.Aborted)
            {
                state = ThreadState.Aborted;
            }
            else if ((thread.ThreadState & ThreadState.AbortRequested) == ThreadState.AbortRequested)
            {
                state = ThreadState.AbortRequested;
            }
            else if ((thread.ThreadState & ThreadState.Stopped) == ThreadState.Stopped)
            {
                state = ThreadState.Stopped;
            }
            else if ((thread.ThreadState & ThreadState.StopRequested) == ThreadState.StopRequested)
            {
                state = ThreadState.StopRequested;
            }
            else if ((thread.ThreadState & ThreadState.Suspended) == ThreadState.Suspended)
            {
                state = ThreadState.Suspended;
            }
            else if ((thread.ThreadState & ThreadState.SuspendRequested) == ThreadState.SuspendRequested)
            {
                state = ThreadState.SuspendRequested;
            }
            return state;
        }

        /// <summary>
        /// 发送信息到socket
        /// </summary>
        public void SendToSocketAync(SocketSendState state)
        {
            if (_isEnd == true)
            {
                //线程主动停止
                this.ClearQueue();
                GameFacade.Instance.NetManager.DisconnectSocket(true, true, SocketEvent.SOCKET_SEND_CHECK_STOP);
                return;
            }

            if (_sendThread == null || _sendThread.IsAlive == false)
            {
                //线程挂了
                this.ClearQueue();
                GameFacade.Instance.NetManager.DisconnectSocket(true, true, SocketEvent.SOCKET_SEND_THREAD_ERROR);
                return;
            }
            else
            {
                //判断线程是否被挂起
                ThreadState sendState = this.CheckThreadState(_sendThread);
                if (sendState != ThreadState.Running)
                {
                    this.ClearQueue();
                    int eventCode = SocketEvent.SOCKET_SEND_THREAD_ERROR - Convert.ToInt32(sendState);
                    GameFacade.Instance.NetManager.DisconnectSocket(true, true, eventCode);
                    return;
                }
            }

            //这里判断接收线程
            if (_receiveThread == null || _receiveThread.IsAlive == false)
            {
                GameFacade.Instance.NetManager.DisconnectSocket(true, true, SocketEvent.SOCKET_RECEIVE_THREAD_ERROR);
                return;
            }
            else
            {
                //判断线程是否被挂起
                ThreadState receiveState = this.CheckThreadState(_receiveThread);
                if (receiveState != ThreadState.Running)
                {
                    this.ClearQueue();
                    int receiveEventCode = SocketEvent.SOCKET_RECEIVE_THREAD_ERROR - Convert.ToInt32(receiveState);
                    GameFacade.Instance.NetManager.DisconnectSocket(true, true, receiveEventCode);
                    return;
                }
            }

            this._sendQueue.Enqueue(state);

        }

        //删除发送列表
        public void ClearQueue()
        {
            this._sendQueue.Clear();
        }

        private bool IsSocketConnected(Socket client)
        {
            bool blockingState = client.Blocking;
            try
            {
                byte[] tmp = new byte[1];
                client.Blocking = false;
                client.Send(tmp, 0, 0);
                return true;
            }
            catch (SocketException e)
            {
                // 产生 10035 == WSAEWOULDBLOCK 错误，说明被阻止了，但是还是连接的
                if (e.NativeErrorCode.Equals(10035))
                    return false;
                else
                    return true;
            }
            finally
            {
                client.Blocking = blockingState;    // 恢复状态
            }
        }

        private int _sendCount = 0;
        //线程执行的方法
        private void SendThreadHandler()
        {
            try
            {
                while (!this._isEnd)
                {
                    try
                    {
                        if (this._mSocket == null || this._mSocket.Connected == false)
                        {
                            //如果出现了这个情况 应该清理所有的回调对象
                            //清空所有的数据
                            this._sendQueue.Clear();
                            Thread.Sleep(500);
                        }
                        else
                        {
                            int socketError = 9999;
                            //开始发送线程的资源 一次只发一条
                            while (this._sendQueue.Count > 0)
                            {
                                try
                                {
                                    SocketSendState data = this._sendQueue.Dequeue() as SocketSendState;

                                    _sendCount = 0;
                                    int sendLen = 0;
                                    //这里的循环处理 是为了处理一种情况 当发送到缓冲区的时候 数据量过大的时候 可能会出现一次性发送不成功的情况 但是要考虑到发送数据量过大的情况 
                                    //需要做一个while循环的最大化上限 防止这一次接口发送卡死 影响其他接口 目前设定的阈值

                                    while (sendLen < data.bytes.srcBuf.Length && _sendCount < 100)
                                    {
                                        _sendCount++;
                                        //bool is_connected = IsSocketConnected(this._mSocket);
                                        //UnityEngine.Debug.Log("Send ==> IsSocketConnected : " + is_connected);
                                        sendLen += this._mSocket.Send(data.bytes.srcBuf, sendLen, data.bytes.srcBuf.Length - sendLen, SocketFlags.None);
                                    }

                                    if (sendLen != data.bytes.srcBuf.Length)
                                    {
                                        socketError = SocketEvent.SOCKET_SEND_LENGTH_NOT_FIT;
                                    }
                                }
                                catch (SocketException sex)
                                {
                                    this.ClearQueue();
                                    //socket 异常的处理
                                    socketError = sex.ErrorCode;
                                }
                                catch (Exception ex)
                                {
                                    this.ClearQueue();
                                    // 通用错误的 处理
                                    socketError = SocketEvent.SOCKET_ERROR_SEND_ERROR;
                                }

                                //如果发生了错误的情况下 需要断线重连
                                if (socketError != 9999)
                                {
                                    Disconnect(true, true, socketError);
                                }
                                Thread.Sleep(10);
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        //这里捕获到的错误是业务的错误 和socket无关
                    }
                    finally
                    {
                        Thread.Sleep(30);
                    }
                }
            }
            catch (Exception e)
            {
                //线程死掉的情况 是可控的 不处理
            }
        }

        //停止
        public void Stop()
        {
            _isEnd = true;

            ClearQueue();

            try
            {
                if (_sendThread != null)
                {
                    _sendThread.Abort();
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.Log("关闭SendThread时发生异常: " + e.Message);
            }

            _sendThread = null;

            try
            {
                if (_receiveThread != null)
                {
                    _receiveThread.Abort();
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.Log("关闭ReceiveThread时发生异常: " + e.Message);
            }
            _receiveThread = null;
        }
    }
}
