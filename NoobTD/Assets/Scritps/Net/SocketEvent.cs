namespace NoobTD
{
    public class SocketEvent
    {
        //心跳事件
        public const string HEARTBEAT = "HEARTBEAT";

        //掉线处理
        public const string DISCONNECT = "DISCONNECT";

        //连接失败
        public const string CONNECT_FAIL = "CONNECT_FAIL";

        //连接成功处理
        public const string CONNECT = "CONNECT";

        //重新连接失败 超过3次
        public const string RE_CONECT_FAIL = "RE_CONECT_FAIL";

        //发送数据出现异常
        public const string SEND_ERROR = "SEND_ERROR";

        //连接服务器之前检测是否连接的状态 如果连接了 就断开
        public const int SOCKET_ERROR_CONNECT_CHECK = -1001;

        //接受服务器返回的数据 错误 导致的断开
        public const int SOCKET_ERROR_RESPONSE_ERROR = -1002;

        //发送到服务器的数据 错误 导致的断开
        public const int SOCKET_ERROR_SEND_ERROR = -1003;

        //接受服务器返回的数据 未捕获到的通用错误 导致的断开
        public const int SOCKET_ERROR_RECEIVE_UNCATCH_ERROR = -1004;

        //后台回来 检查socket指令未派发 达到条件 导致的断开
        public const int SOCKET_ERROR_CHECK_SOCKET_RESPONSE = -1005;

        //发送指令之后 等待太久 指令仍然没回复的 导致的断开
        public const int SOCKET_ERROR_LONG_TIME_NO_RECEIVE = -1006;

        //系统后台把Socket强行断开，发送时候检测Socket状态异常，执行Socket断开
        public const int SOCKET_ERROR_SYSTEM_DISCONNECT = -1007;

        //系统socket 发送的时候 发送成功的数据 和已发送的数据不一致
        public const int SOCKET_SEND_LENGTH_NOT_FIT = -1008;

        //系统socket 根据dns获取 ip地址的时候 发生错误 获取的ip地址<1
        public const int SOCKET_CONNECT_GET_DNS_FAIL = -1009;

        //后台超过一定时间之后 socket线程主动断开
        public const int SOCKET_BACK_TYPE_TIME_OUT = -10010;

        //socket发送的时候 检测到 线程已经停止运行
        public const int SOCKET_SEND_CHECK_STOP = -10011;

        //socket线程 停止的时候 产生的停止
        public const int SOCKET_THREAD_ERROR = -10012;

        //socke线程 接收到长度为0的数据
        public const int SOCKET_RECEIVE_ZERO_LENGTH = -10013;

        //系统socket 后台线程挂了
        public const int SOCKET_SEND_THREAD_ERROR = -10000;

        //系统socket 后台线程挂了 接收线程挂了
        public const int SOCKET_RECEIVE_THREAD_ERROR = -20000;

        //http VersionTime 链接超时
        public const string HTTP_TIME_OUT_ERROR_VERSION_TIME = "-9";

        //http VersionTime 解析dns失败
        public const string HTTP_NET_DNS_ERROR_VERSION_TIME = "-10";

        //http Version 解析dns失败
        public const string HTTP_NET_DNS_ERROR_VERSION_TXT = "-11";

        //http CSVersionTime 解析dns失败
        public const string HTTP_NEW_DNS_ERROR_CSVERSION_TIME = "-12";

        private string _type;
        public string event_type
        {
            get
            {
                return _type;
            }
        }

        //附带数据
        public object param;

        //错误码id
        public int errorCodeId = 0;

        public SocketEvent(string type)
        {
            _type = type;
        }

        public bool IsDisconnect()
        {
            if (_type == SocketEvent.DISCONNECT || _type == SocketEvent.CONNECT_FAIL || _type == SocketEvent.SEND_ERROR || _type == SocketEvent.RE_CONECT_FAIL)
            {
                return true;
            }
            return false;
        }
    }
}