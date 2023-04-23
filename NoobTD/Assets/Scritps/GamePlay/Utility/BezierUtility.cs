using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public class BezierUtility
    {
        public static Vector3 RandomCircle(Vector3 center, float radius)
        {
            float ang   = UnityEngine.Random.Range(0, 180);
            Vector3 pos = Vector3.zero;
            float delta_x = radius * Mathf.Cos(ang * Mathf.Deg2Rad);
            float delta_y = radius * Mathf.Sin(ang * Mathf.Deg2Rad);

            pos.x = center.x + delta_x;
            pos.y = center.y + delta_y;
            pos.z = center.z;

            return pos;
        }

        public static ArrayList BezierBy(Vector3 begin, Vector3 middle1, Vector3 middle2,  Vector3 end)
        {
            //在这里来计算贝塞尔曲线
            //四个参数 表示当前贝塞尔曲线上的4个点 第一个点和第四个点
            //我们是不需要移动的，中间的两个点是由拖动条来控制的。

             //middle1 = new Vector3((end.x - begin.x) * 0.3f, (end.x - begin.x) * 0.3f, 1);
            // middle2 = new Vector3((end.x - begin.x) * 0.6f, (end.x - begin.x) * 0.6f, 1);

            Bezier myBezier = new Bezier(begin, middle1, middle2, end);

            ArrayList array = new ArrayList();
            //循环100遍来绘制贝塞尔曲线每个线段

            float a = 0.001f;
            float v = 0.02f;
            float move = 0f;
            float sum = 0f;
            float total = 1.0f;
            while(sum <= total)
            {
                //参数的取值范围 0 - 1 返回曲线没一点的位置
                //为了精确这里使用i * 0.01 得到当前点的坐标
                Vector3 vec = myBezier.GetPointAtTime((float)sum);
                array.Add(vec);
                v = UnityEngine.Mathf.Min(0.004f,  v + a);
                move += v;
                sum += move;
            }

            array.Add(myBezier.GetPointAtTime(total));

            return array;
        }
    }
}
