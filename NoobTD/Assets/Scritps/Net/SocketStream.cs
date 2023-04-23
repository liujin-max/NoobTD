using System;
using System.Text;
using UnityEngine;

/**
 * socket通讯数据流
 * user: echo
 */
namespace NoobTD
{
    public class SocketStream
    {
        // 读取的二进制数据缓冲区
        protected byte[] _buf;
        public byte[] srcBuf
        {
            get
            {
                return _buf;
            }
        }

        public int Length
        {
            get
            {
                return _buf == null ? 0 : _buf.Length;
            }
        }

        protected int _pos;
        public int position
        {
            get
            {
                return _pos;
            }
            set
            {
                _pos = value;
            }
        }

        public SocketStream()
        {
            _buf = null;
            _pos = 0;
        }

        // 初始化数据流大小
        public void InitStream(int size)
        {
            if (size > 0)
                _buf = new byte[size];
            else
                _buf = null;
            _pos = 0;
        }

        public byte[] ReadDataBlock(int len)
        {
            byte[] temp = new byte[len];
            int dataIndex = 0;
            for (int i = _pos; i < _pos + len; i++)
            {
                temp[dataIndex] = _buf[i];
                dataIndex++;
            }
            _pos += len;
            return temp;
        }

        // 获取对应的数据
        public byte[] GetData(int pos, int len)
        {
            byte[] temp = new byte[len];
            int dataIndex = 0;
            for (int i = pos; i < pos + len; i++)
            {
                temp[dataIndex] = _buf[i];
                dataIndex++;
            }
            return temp;
        }

        // 拷贝数据进来
        public void CopyIn(byte[] dataBytes, int index)
        {
            if (dataBytes == null)
                return;

            if (_buf == null)
            {
                InitStream(dataBytes.Length - index);
            }

            _pos = Math.Min(index + dataBytes.Length, _buf.Length);

            int dataIndex = 0;
            for (int i = index; i < _pos; i++)
            {
                _buf[i] = dataBytes[dataIndex];
                dataIndex++;
            }
        }

        public void Decode()
        {   
            for (int i = 0; i < _pos; i++)
            {
                _buf[i] = (byte)(~(_buf[i] - 16) - 16);
            }
        }

        public void Encode()
        {
            for (int i = 0; i < _pos; i++)
            {
                _buf[i] = (byte)(~(_buf[i] + 16) + 16);
            }
        }

        // 读取short值
        public short ReadShort()
        {
            int len = 2;
            byte[] temp = GetData(_pos, len);
            _pos += len;
            return BitConverter.ToInt16(temp, 0);
        }

        // 读取float值
        public float ReadFloat()
        {
            int len = 4;
            byte[] temp = GetData(_pos, len);
            _pos += len;
            return BitConverter.ToSingle(temp, 0);
        }

        // 读取int值
        public int ReadInt()
        {
            int len = 4;
            byte[] temp = GetData(_pos, len);
            _pos += len;
            return BitConverter.ToInt32(temp, 0);
        }

        // 读取long值
        public long ReadLong()
        {
            int len = 8;
            byte[] temp = GetData(_pos, len);
            _pos += len;

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
            byte[] temp = GetData(_pos, len);
            _pos += len;

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
            byte byteValue = _buf[_pos];
            _pos++;
            return byteValue;
        }

        // 读取bool值
        public bool ReadBoolean()
        {
            int len = 1;
            byte[] temp = GetData(_pos, len);
            _pos += len;
            return BitConverter.ToBoolean(temp, 0);
        }

        // 读取字符串
        public string ReadString()
        {
            int len = ReadShort();
            byte[] temp = GetData(_pos, len);
            _pos += len;
            return Encoding.UTF8.GetString(temp);
        }

        // 写入short值
        public void WriteShort(short shortValue)
        {
            byte[] temp = BitConverter.GetBytes(shortValue);
            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入float值
        public void WriteFloat(float floatValue)
        {
            byte[] temp = BitConverter.GetBytes(floatValue);
            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入int值
        public void WriteInt(int intValue)
        {
            byte[] temp = BitConverter.GetBytes(intValue);
            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入long值
        public void WriteLong(long longValue)
        {
            byte[] temp = BitConverter.GetBytes(longValue);
            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入double值
        public void WriteDouble(double doubleValue)
        {
            byte[] temp = BitConverter.GetBytes(doubleValue);
            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入byte值
        public void WriteByte(byte byteValue)
        {
            _buf[_pos] = byteValue;
            _pos++;
        }

        // 写入Boolean值
        public void WriteBoolean(bool boolValue)
        {
            byte[] temp = BitConverter.GetBytes(boolValue);

            int dataIndex = 0;
            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

        // 写入字符串值
        public void WriteString(string stringValue)
        {
            byte[] temp = Encoding.UTF8.GetBytes(stringValue);
            int dataIndex = 0;

            for (int i = _pos; i < _pos + temp.Length; i++)
            {
                _buf[i] = temp[dataIndex];
                dataIndex++;
            }
            _pos += temp.Length;
        }

    }
}