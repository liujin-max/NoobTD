using System.Collections;
using System.Collections.Generic;

/**
 * socket请求管理器
 * user: echo
 */
namespace NoobTD
{
    public class SocketRequestManager
    {
        public static readonly SocketRequestManager instance = new SocketRequestManager();

        // 字典
        private Dictionary<string, RequestData> _dic;
        // 最后一次请求的字典
        private Dictionary<string, float> _lastRequestDic;

        public SocketRequestManager()
        {
            Reset();
        }

        public void Reset()
        {
            _dic = new Dictionary<string, RequestData>();
            _lastRequestDic = new Dictionary<string, float>();
        }

        /**
         * 获取当前的请求可以发送的剩余时间
         * @param moduleId 模块号
         * @param cmd 命令号
         * @param duration 发送间隔
         * return 返回毫秒
         */
        public float GetRequestCanSendTime(int moduleId, int cmd, int duration)
        {
            if (duration == 0)
            {
                return 0;
            }
            return 1;
            //string key = moduleId + "_" + cmd;
            //float nowTime = TimeUtil.unscaledTime * 1000;
            //if (duration > 0)
            //{
            //    if (_lastRequestDic.ContainsKey(key))
            //    {
            //        float lastTime = _lastRequestDic[key];
            //        if (nowTime >= lastTime)
            //        {
            //            return 0;
            //        }
            //        else
            //        {
            //            return lastTime - nowTime;
            //        }
            //    }
            //    else
            //    {
            //        return 0;
            //    }
            //}
            //else
            //{
            //    if (_dic.ContainsKey(key))
            //    {
            //        RequestData rd = _dic[key];
            //        float targetTime = rd.targetTime;
            //        if (targetTime <= nowTime)
            //        {
            //            return 0;
            //        }
            //        else
            //        {
            //            return (nowTime - targetTime);
            //        }
            //    }
            //    else
            //    {
            //        return 0;
            //    }
            //}
        }

        /**
         * 添加请求
         * @param sn 发送出去的sn流水号
         * @param moduleId 模块号
         * @param cmd 命令号
         * @param duration 间隔
         */
        public void AddRequest(int sn, int moduleId, int cmd, int duration)
        {
            // 不做限制的请求
            if (duration == 0)
                return;

            string key = moduleId + "_" + cmd;
            if (duration > 0)
            {
                //_lastRequestDic[key] = TimeUtil.unscaledTime * 1000 + duration;
            }
            else
            {
                RequestData rd = new RequestData();
                rd.sn = sn;
                rd.duration = duration;
                //rd.targetTime = TimeUtil.unscaledTime * 1000 + 5000;
                _dic[key] = rd;
            }
        }

        /**
         * 移除请求
         * @param sn 发送出去的sn流水号
         * @param moduleId 模块号
         * @param cmd 命令号
         */
        public void RemoveRequest(int sn, int moduleId, int cmd)
        {
            string key = moduleId + "_" + cmd;
            if (_dic.ContainsKey(key))
            {
                RequestData rd = _dic[key];
                if (rd.sn == sn)
                {
                    _dic.Remove(key);
                }
            }
        }

    }

    class RequestData
    {
        public int sn;
        public int duration;
        public float targetTime;
    }
}