using System;
using System.Text;

/**
 * socket通讯数据流
 * user: echo
 */
namespace NoobTD
{
    public class SocketLoopStream
    {
        protected byte[] _buf;
        public byte[] srcBuf
        {
            get
            {
                return _buf;
            }
        }

        private int _begin;
        public int Begin
        {
            get
            {
                return _begin;
            }
            set
            {
                _begin = value;
            }
        }

        private int _end;
        public int End
        {
            get
            {
                return _end;
            }
            set
            {
                _end = value;
            }
        }

        public int Length
        {
            get
            {
                return (_end + _buf.Length - _begin) % _buf.Length;
            }
        }

        public SocketLoopStream(int size)
        {
            _buf = new byte[size];
            _end = 0;
            _begin = 0;
        }

        public void Reset()
        {
            _end = 0;
            _begin = 0;
        }

        public byte[] GetData(int len)
        {
            byte[] temp = new byte[len];
            int dataIndex = 0;
            for (int i = _begin; i < _begin + len; i++)
            {
                var lp = Loop(i);
                temp[dataIndex] = _buf[lp];
                dataIndex++;
            }
            return temp;
        }

        // 获取对应的数据
        public byte[] ReadDataBlock(int len)
        {
            byte[] temp = new byte[len];
            int index = 0;
            for (int i = _begin; i < _begin + len; i++)
            {
                int lp = Loop(i);
                temp[index] = _buf[lp];
                index++;
            }
            _begin = Loop(_begin + len);
            return temp;
        }

        // 读取short值
        public short ReadShort()
        {
            int len = 2;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);
            return BitConverter.ToInt16(temp, 0);
        }

        // 读取float值
        public float ReadFloat()
        {
            int len = 4;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);
            return BitConverter.ToSingle(temp, 0);
        }

        // 读取int值
        public int ReadInt()
        {
            int len = 4;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);
            return BitConverter.ToInt32(temp, 0);
        }

        // 读取long值
        public long ReadLong()
        {
            int len = 8;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);

            if (BitConverter.IsLittleEndian)
            {
                Array.Reverse(temp);
            }
            return BitConverter.ToInt64(temp, 0);
        }

        // 读取double值
        public double ReadDoubld()
        {
            int len = 8;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);

            if (BitConverter.IsLittleEndian)
            {
                Array.Reverse(temp);
            }
            return BitConverter.ToDouble(temp, 0);
        }

        // 读取sbyte值
        public sbyte ReadSByte()
        {
            return (sbyte)ReadByte();
        }

        // 读取byte值
        public byte ReadByte()
        {
            byte byteValue = _buf[_begin];
            _begin = Loop(_begin + 1);
            return byteValue;
        }

        // 读取bool值
        public bool ReadBoolean()
        {
            int len = 1;
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);
            return BitConverter.ToBoolean(temp, 0);
        }

        // 读取字符串
        public string ReadString()
        {
            int len = ReadShort();
            byte[] temp = GetData(len);
            _begin = Loop(_begin + len);
            return Encoding.UTF8.GetString(temp);
        }

        public void Revert(int length)
        {
            _begin = Loop(_begin - length);
        }

        public void LoopCopy(byte[] stream, int size)
        {
            for(int i = 0; i < size; i++)
            {
                _buf[Loop(_end + i)] = stream[i];
            }
            _end = Loop(_end + size);
        }

        private int Loop(int num)
        {
            return num % _buf.Length;
        }
    }
}
