using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System;
using LuaInterface;

namespace NoobTD
{
    /// <summary>
    /// 滑动页面效果
    /// </summary>
    public class PageView : MonoBehaviour, IBeginDragHandler, IEndDragHandler
    {
        private ScrollRect rect;
        private float targethorizontal = 0;
        private List<float> posList = new List<float>();//存四张图片的位置(0, 0.333, 0.666, 1) 
        private bool isDrag = true;
        private float startTime = 0;
        private float startDragHorizontal;
        private int curIndex = 0;

        public float speed = 4;      //滑动速度  
        public float sensitivity = 0;

        public float AppdingWidth;
        public int Spacing;

        private bool IsInit = false;
        private bool IsScrollEnd = false;
        private LuaFunction lua_function;
        private LuaFunction scroll_end_function;


        public void Init(int order,LuaFunction call_func, LuaFunction end_func)
        {
            IsInit = true;

            posList.Clear();
            lua_function = call_func;
            scroll_end_function = end_func;

            rect = GetComponent<ScrollRect>();
            float horizontalLength = rect.content.rect.width - GetComponent<RectTransform>().rect.width - AppdingWidth;
            var _rectWidth = GetComponent<RectTransform>().rect.width;
            //Debug.Log("测试输出 ： " + rect.content.transform.childCount);
            for (int i = 0; i < rect.content.transform.childCount; i++)
            {
                posList.Add((_rectWidth + Spacing) * i / horizontalLength);   //存四张图片的位置(0, 0.333, 0.666, 1) 
            }

            this.pageTo(order);
            //curPage.text = String.Format("当前页码：0");

        }

        void Update()
        {
            if (!IsInit)
            {
                return;
            }

            if (!isDrag)
            {
                startTime += Time.deltaTime;
                float t = startTime * speed;
                //加速滑动效果
                rect.horizontalNormalizedPosition = Mathf.Lerp(rect.horizontalNormalizedPosition, targethorizontal, t);

                if (Math.Abs(rect.horizontalNormalizedPosition - targethorizontal) <= 0.02 && IsScrollEnd == false)
                {
                    IsScrollEnd = true;
                    if (scroll_end_function != null)
                    {
                        scroll_end_function.Call();
                    }
                }


                //rect.horizontalNormalizedPosition = targethorizontal;
                //缓慢匀速滑动效果
                //rect.horizontalNormalizedPosition = Mathf.Lerp(rect.horizontalNormalizedPosition, targethorizontal, Time.deltaTime * speed);
            }
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            isDrag = true;
            //开始拖动
            startDragHorizontal = rect.horizontalNormalizedPosition;  //horizontalNormalizedPosition这个参数是scrollRect滑动期间变化的x坐标值，在（0， 1）之间
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            //Debug.Log("OnEndDrag");
            float posX = rect.horizontalNormalizedPosition;
            int index = 0;
            float offset = Mathf.Abs(posList[index] - posX);  //计算当前位置与第一页的偏移量，初始化offect
            for (int i = 1; i < posList.Count; i++)
            {    //遍历页签，选取当前x位置和每页偏移量最小的那个页面
                float temp = Mathf.Abs(posList[i] - posX);
                if (temp < offset)
                {
                    index = i;
                    offset = temp;
                }
            }

            this.pageTo(index);
        }

        public void pageTo(int index)
        {
            Debug.Log("pageTo......");
            curIndex = index;
            targethorizontal = posList[curIndex]; //设置当前坐标，更新函数进行插值  
            isDrag = false;
            startTime = 0;
            IsScrollEnd = false;
            //curPage.text = String.Format("当前页码：{0}", curIndex.ToString());

            //Debug.Log("测试输出 pageto：" + index);
            if (lua_function != null)
            {
                lua_function.Call<int>(index);
            }
        }
    }

}