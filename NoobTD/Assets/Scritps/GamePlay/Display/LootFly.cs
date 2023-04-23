using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace FoodWar
{
    public class LootFly : MonoBehaviour
    {
        private Vector3     To;
        private Vector3     From;
        private ArrayList   Trace;
        public Transform    Entity;

        private LuaFunction Lua_function;

        private int index = 0;

        public void GO(Vector3 from, Vector3 to, LuaFunction call_back)
        {
            //生成一条bezier路径
            index = 0;
            this.From   = from;
            this.To     = to;
            Lua_function = call_back;

            var Center = (From + To) / 2;
            var Distance = Vector3.Distance(From, To);
            var mid1 = NoobTD.BezierUtility.RandomCircle(From, Distance * 0.8f );   
            var mid2 = NoobTD.BezierUtility.RandomCircle(To, Distance * 0.8f / 8f);   
            
            Trace = NoobTD.BezierUtility.BezierBy(from, mid1, mid2, to);
            // Debug.LogError("TRACE " + Trace.Count);
            this.gameObject.transform.localPosition = (Vector3)Trace[0];
        }

        public void Dispose()
        {
            Trace = null;
        }

        public void Update()
        {
            if (Trace == null)
            {
                return;
            }
            if(index < Trace.Count)
            {
                var vec = (Vector3)Trace[index];
                this.gameObject.transform.localPosition = vec;
                if(index < (Trace.Count - 1))
                {
                    Entity.up = (Vector3)Trace[index + 1] - vec;
                }
                index ++;
            }
            else
            {
                //index ++;
                //if(index > Trace.Count * 2f)
                //{
                    if (Lua_function != null)
                    {
                        Lua_function.Call();
                    }
                //}
            }
        }
    }
}

