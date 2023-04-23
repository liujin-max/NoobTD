namespace NoobTD
{
    public class ResponseType
    {
        // 包头标识
        public const int PACKET_HEAD_ID = -1860168940;

        // 包头占用字节数
        public const int PACKET_HEAD_ID_LENGTH = 4;
        public const int PACKET_HEAD_LENGTH = 14;


        // ------------------------------- 状态码 ----------------------------------------

        // ERROR(程序异常)
        public const sbyte RESPONSE_CODE_ERROR = -1;

        //操作成功
        public const sbyte RESPONSE_CODE_SUCCESS = 0;

        //协议解析错误
        public const sbyte RESPONSE_CODE_RESOLVE_ERROR = 2;

        //没有权限
        public const sbyte RESPONSE_CODE_NO_RIGHT = 3;

        //验证码错
        public const sbyte RESPONSE_CODE_AUTH_CODE_ERROR = 4;

        // 服务器维护（关闭）
        public const sbyte RESPONSE_CODE_SERVER_CLOSED = 5;

        // 超时
        public const sbyte RESPONSE_CODE_TIME_OUT = 6;

        /**
	     * 命令未定义
	     */
        public const sbyte UNKNOWN_CMD = 7;

        /**
	     * 找不到服务器
	     */
        public const sbyte UNKNOWN_SERVER = 8;

        /**
	     * 网络异常
	     */
        public const sbyte NETWORK_ERROR = 9;


    }
}