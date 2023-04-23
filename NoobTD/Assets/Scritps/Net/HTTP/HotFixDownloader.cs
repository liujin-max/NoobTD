using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace SoulLand
{
    public class HotFixDownloader
    {
        public List<ThreadHTTP> _Queue    = new List<ThreadHTTP>();
        public const int EXECUTION_LIMIT = 3;
        public List<ThreadHTTP> _Running = new List<ThreadHTTP>(EXECUTION_LIMIT);

        
        public float _Progress = 0;
        public float _Total     = 0;

        public float _TotalCount = 0;

        public float Progress{ get { return _Progress; } }
        public float Total { get { return _Total; } }

        public void AddTask(ThreadHTTP task)
        {
            _Queue.Add(task);
        }

        public bool IsEmpty()
        {
            return _Queue.Count == 0;
        }

        public float CountProgress()
        {
            return (_TotalCount - _Queue.Count) / (_TotalCount + 0.01f);
        }

        public void Process()
        {
            for (int i = _Queue.Count - 1; i >= 0; i--)
            {
                ThreadHTTP task = _Queue[i];
                if (_Running.Capacity > _Running.Count)
                {
                    _Running.Add(task);
                    task.AsyDownLoad();
                    _Queue.Remove(task);
                }
                else
                {
                    break;
                }
            }
        }

        public void Execute()
        {
            _TotalCount = _Queue.Count;
            for (int i = _Queue.Count - 1; i >= 0; i--)
            {
                ThreadHTTP task = _Queue[i];
                _Total += task.Weight;
            }
        }

        public void Clear()
        {
            for (int i = _Running.Count - 1; i >= 0; i--)
            {
                ThreadHTTP task = _Running[i];
                task.Stop();
            }
            _Running.Clear();
        }

        public bool Check()
        {
            if(Time.frameCount % 30 == 0)
            {
                Debug.Log("CHECK ====> " + _Running.Count);
                Debug.Log(" ================================================ ");
                for (int i = _Running.Count - 1; i >= 0; i--)
                {
                    ThreadHTTP task = _Running[i];
                    Debug.Log("TASK " + task.trial_time + " " + task.Weight + " " + task.url);
                }
                Debug.Log(" ================================================ ");
            }
            for (int i = _Running.Count - 1; i >= 0; i--)
            {
                ThreadHTTP task = _Running[i];
                if(task.GetState() == ThreadHTTP.State.Finished)
                {
                    _Running.Remove(task);
                    _Progress += task.Weight;
                }
                else if(task.GetState() == ThreadHTTP.State.Error)
                {
                    task.Stop();
                    ThreadHTTP replace_task = new ThreadHTTP(task.tag, task.destination, task.url, task.Weight, task.md5);
                    _Running[i] = replace_task;
                    replace_task.AsyDownLoad();     //如果出现错误, 进行重连
                }
                else
                {
                    if(task.HasResponse() == false)
                    {
                        task.StockTime += Time.deltaTime;
                        //Debug.Log("TASK " + task.StockTime + " " + task.url);
                        if(task.StockTime > ThreadHTTP.STOCK_TIME)
                        {
                            Debug.Log("============ STOP ============");
                            task.Stop();
                            ThreadHTTP replace_task = new ThreadHTTP(task.tag, task.destination, task.origin_url, task.Weight, task.md5);
                            _Running[i] = replace_task;
                            replace_task.AsyDownLoad();     //如果出现错误, 进行重连
                        }
                    }
                }
            }

            Process();


            return (_Running.Count == 0) && (_Queue.Count == 0);
        }
    }
}

