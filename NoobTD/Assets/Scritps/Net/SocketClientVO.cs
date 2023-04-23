
namespace NoobTD
{
    public class SocketClientVO
    {
        // 客户端附带数据
        public object clientData;
        // 是否显示loading条
        public bool isShowLoading = false;
        // 发送到服务器的间隔
        public int duration = 0;
        // 客户端发送请求的时间
        public double clientSendTime = 0;

        public SocketClientVO()
        {

        }
    }
}
