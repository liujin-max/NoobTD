
namespace NoobTD
{
    public class ProtocolEvent
    {
        // 通讯状态错误
        public const string PROTOCOL_STATE_ERROR = "PROTOCOL_STATE_ERROR";

        private string _type;
        public string type
        {
            get
            {
                return _type;
            }
        }

        private int _state;
        public int state
        {
            get
            {
                return _state;
            }
        }

        private string _errorDesc;
        public string errorDesc
        {
            get
            {
                return _errorDesc;
            }
        }

        private Response _response;
        public Response response
        {
            get
            {
                return _response;
            }
        }

        public ProtocolEvent(string type, int state, string errorDesc, Response resp)
        {
            _type = type;
            _state = state;
            _errorDesc = errorDesc;
            _response = resp;
        }

    }
}