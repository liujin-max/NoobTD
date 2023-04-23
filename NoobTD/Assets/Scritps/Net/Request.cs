/**
 * 数据请求命令消息体
 * user: echo
 */
namespace NoobTD
{
    public class Request
    {
        // 流水号，用于表示相同类型的消息
        public int MsgIndex = -1;

        public int ErrCode = 0;

        public int MainId = 0;

        public int SubId   = 0;

        public int Flag = 4; // 发往主服务

        public int Check = 0;

        // 请求的消息参数
        public string Data;
    }
}