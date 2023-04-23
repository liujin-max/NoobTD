using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using System;

namespace NoobTD
{
    public class GameUtil : MonoBehaviour
    {
        public static void OnExitGame()
        {
#if UNITY_EDITOR//在编辑器模式退出
            UnityEditor.EditorApplication.isPlaying = false;
#else//发布后退出
        Application.Quit();
#endif
        }

        public static void EditorPause()
        {
#if UNITY_EDITOR
            UnityEditor.EditorApplication.isPaused = true;
#endif
        }
        public static bool IsTouchedUI()
        {
            //return EventSystem.current.IsPointerOverGameObject();

            ////实例化点击事件
            PointerEventData eventDataCurrentPosition = new PointerEventData(UnityEngine.EventSystems.EventSystem.current);
            //将点击位置的屏幕坐标赋值给点击事件  
            eventDataCurrentPosition.position = new Vector2(Input.mousePosition.x, Input.mousePosition.y);

            List<RaycastResult> results = new List<RaycastResult>();
            //向点击处发射射线  
            EventSystem.current.RaycastAll(eventDataCurrentPosition, results);

            return results.Count > 0;
        }


        //根据字符串创建一个类
        public static object CreateClassByName(string class_name)
        {
            Type t = Type.GetType(class_name);
            var obj = t.Assembly.CreateInstance(class_name);

            return obj;
        }

        //屏幕坐标转UI坐标
        public static Vector3 ScenePoint2UI(Vector3 finger_pos, GameObject parent)
        {
            Camera Camera = GameObject.Find("UI/GuiCamera").GetComponent<Camera>();

            Vector2 vector2 = finger_pos;

            Vector2 outPos;

            if (RectTransformUtility.ScreenPointToLocalPointInRectangle(parent.transform as RectTransform, vector2, Camera, out outPos))
            {
                return outPos;
            }

            return Vector2.zero;
        }

        //UI转场景坐标
        public static Vector2 UI2Scene(Transform transform)
        {
            RectTransform canvas = GameObject.Find("UI/SceneCanvas").transform.GetComponent<RectTransform>();
            Vector3 sceen_point = Camera.main.WorldToViewportPoint(transform.position) + new Vector3(-0.5f, -0.5f, 0);
            Vector3 final = new Vector3(sceen_point.x * canvas.rect.size.x, sceen_point.y * canvas.rect.size.y, 0);
            return final / 100.0f;



            //RectTransform canvas = GameObject.Find("UI/SceneCanvas").transform.GetComponent<RectTransform>() ;
            //Vector3 sceen_point = Camera.main.WorldToScreenPoint(transform.position);
            //Debug.Log("测试输出 尺寸：" + canvas.rect.size);
            //Vector3 final = new Vector3(sceen_point.x - canvas.rect.size.x / 2, sceen_point.y - canvas.rect.size.y / 2, 0);
            //return final / 100.0f;

        }



        public static float Cross(Vector2 a, Vector2 b)
        {
            return a.x * b.y - b.x * a.y;
        }

        //两条向量相交
        public static Vector2 SegmentsInterPoint(Vector2 a, Vector2 b, Vector2 c, Vector2 d)
        {
            Vector2 invalid = new Vector2(-1000, -1000);
            //v1×v2=x1y2-y1x2 
            //以线段ab为准，是否c，d在同一侧
            Vector2 ab = b - a;
            Vector2 ac = c - a;
            float abXac = Cross(ab, ac);

            Vector2 ad = d - a;
            float abXad = Cross(ab, ad);

            if (abXac * abXad >= 0)
            {
                return invalid;
            }

            //以线段cd为准，是否ab在同一侧
            Vector2 cd = d - c;
            Vector2 ca = a - c;
            Vector2 cb = b - c;

            float cdXca = Cross(cd, ca);
            float cdXcb = Cross(cd, cb);
            if (cdXca * cdXcb >= 0)
            {
                return invalid;
            }
            //计算交点坐标  
            float t = Cross(a - c, d - c) / Cross(d - c, b - a);
            float dx = t * (b.x - a.x);
            float dy = t * (b.y - a.y);

            Vector2 IntrPos = new Vector2() { x = a.x + dx, y = a.y + dy };
            //Debug.Log("测试输出 焦点 ：  " + IntrPos);
            return IntrPos;
        }

        //直线和圆相交
        public static Vector2 BetweenLineAndCircle(Vector2 circleCenter, float circleRadius, Vector2 point1, Vector2 point2)
        {
            Vector2 intersection = new Vector2(-1000, -1000);

            float t;

            var dx = point2.x - point1.x;
            var dy = point2.y - point1.y;

            var a = dx * dx + dy * dy;
            var b = 2 * (dx * (point1.x - circleCenter.x) + dy * (point1.y - circleCenter.y));
            var c = (point1.x - circleCenter.x) * (point1.x - circleCenter.x) + (point1.y - circleCenter.y) * (point1.y - circleCenter.y) - circleRadius * circleRadius;

            var determinate = b * b - 4 * a * c;
            if ((a <= 0.0000001) || (determinate < -0.0000001))
            {
                //没有交点的情况
                return intersection;
            }

            if (determinate < 0.0000001 && determinate > -0.0000001)
            {
                //一个交点的情况
                t = -b / (2 * a);
                intersection = new Vector2(point1.x + t * dx, point1.y + t * dy);
                return intersection;
            }

            //两个交点的情况
            t = ((-b - Mathf.Sqrt(determinate)) / (2 * a));
            intersection = new Vector2(point1.x + t * dx, point1.y + t * dy);


            return intersection;
        }
    }
}
