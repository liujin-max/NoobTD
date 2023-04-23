using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;

namespace NoobTD
{
    public class SocketSendState
    {
        public int sendSn;

        public Request request;

        public long createTime = 0;

        //发送的二进制数据
        public SocketStream bytes;

        public SocketSendState(Request request, int sendSn)
        {
            this.request = request;
            this.sendSn = sendSn;
            this.createTime = DateTime.Now.Ticks / 10000;
        }
    }
}
