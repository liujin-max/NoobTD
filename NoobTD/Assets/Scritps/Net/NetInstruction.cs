
namespace NoobTD
{
    public class NetInstruction
    {
        private int _moduleId;              //模块号
        private int _cmd;                   //指令编号
        private string _type;               //指令发送类型
        private double _sysTime;            //当前系统时间
        private bool _sended = false;       //已发送 
        private object _serverData;         //指令数据
        private SocketClientVO _socketClientVO = new SocketClientVO();  // 客户端附带数据类

        public string socketName;

        //客户端发送请求的时间
        public double clientSendTime
        {
            get
            {
                return _socketClientVO.clientSendTime;
            }
            set
            {
                _socketClientVO.clientSendTime = value;
            }
        }

        //服务器接收到请求的时间
        private double _requestSeverTime = 0;
        public double requestServerTime
        {
            get
            {
                return _requestSeverTime;
            }
            set
            {
                _requestSeverTime = value;
            }
        }

        //服务器响应的时间
        private double _serverDoTime = 0;
        public double serverDoTime
        {
            get
            {
                return _serverDoTime;
            }
            set
            {
                _serverDoTime = value;
            }
        }



        //是否后台的通知
        private bool _backType = false;
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

        /**
         * 指令对象构造函数
         * @param mId               指令所属模块号
         * @param key				指令编号
         * @param serverData	    服务端业务所需数据
         * @param type				指令类型
         * @param sysTime			服务器时间
         * @param clientData	    客户端业务所需数据
         * @param isShowLoading     显示loading条
         * @param duration          发送间隔
         */
        public NetInstruction(int mId = 0, int key = 0, object serverData = null, string type = "0", double sysTime = 0, object clientData = null, bool isShowLoading = false,
            int duration = -1, string sName = "")
        {
            _moduleId = mId;
            _cmd = key;
            _serverData = serverData;
            _sysTime = sysTime;
            _socketClientVO.clientData = clientData;
            _socketClientVO.isShowLoading = isShowLoading;
            _socketClientVO.duration = duration;
            _type = type;
            socketName = sName;
        }


        /**
         * 指令编号
         * */
        public int cmd
        {
            get
            {
                return _cmd;
            }
            set
            {
                _cmd = value;
            }
        }

        /**
         * 指令编号
         * */
        public int moduleId
        {
            get
            {
                return _moduleId;
            }
            set
            {
                _moduleId = value;
            }
        }

        /**
        * 指令发送类型
        * */
        public string type
        {
            get
            {
                return _type;
            }
            set
            {
                _type = value;
            }
        }

        /**
        * 当前系统时间
        * */
        public double sysTime
        {
            get
            {
                return _sysTime;
            }
            set
            {
                _sysTime = value;
            }
        }

        /**
       *  是否已经发送
       * */
        public bool sended
        {
            get
            {
                return _sended;
            }
            set
            {
                _sended = value;
            }
        }

        /**
        *  指令数据
       * */
        public object serverData
        {
            get
            {
                return _serverData;
            }
            set
            {
                _serverData = value;
            }
        }

        public object clientData
        {
            get
            {
                return _socketClientVO.clientData;
            }
            set
            {
                _socketClientVO.clientData = value;
            }
        }

        /**
        *  客户端附带数据类
       * */
        public SocketClientVO socketClientVO
        {
            get
            {
                return _socketClientVO;
            }
            set
            {
                _socketClientVO = value;
            }
        }

    }
}