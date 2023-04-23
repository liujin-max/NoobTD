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
    /// ����ҳ��Ч��
    /// </summary>
    public class PageView : MonoBehaviour, IBeginDragHandler, IEndDragHandler
    {
        private ScrollRect rect;
        private float targethorizontal = 0;
        private List<float> posList = new List<float>();//������ͼƬ��λ��(0, 0.333, 0.666, 1) 
        private bool isDrag = true;
        private float startTime = 0;
        private float startDragHorizontal;
        private int curIndex = 0;

        public float speed = 4;      //�����ٶ�  
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
            //Debug.Log("������� �� " + rect.content.transform.childCount);
            for (int i = 0; i < rect.content.transform.childCount; i++)
            {
                posList.Add((_rectWidth + Spacing) * i / horizontalLength);   //������ͼƬ��λ��(0, 0.333, 0.666, 1) 
            }

            this.pageTo(order);
            //curPage.text = String.Format("��ǰҳ�룺0");

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
                //���ٻ���Ч��
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
                //�������ٻ���Ч��
                //rect.horizontalNormalizedPosition = Mathf.Lerp(rect.horizontalNormalizedPosition, targethorizontal, Time.deltaTime * speed);
            }
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            isDrag = true;
            //��ʼ�϶�
            startDragHorizontal = rect.horizontalNormalizedPosition;  //horizontalNormalizedPosition���������scrollRect�����ڼ�仯��x����ֵ���ڣ�0�� 1��֮��
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            //Debug.Log("OnEndDrag");
            float posX = rect.horizontalNormalizedPosition;
            int index = 0;
            float offset = Mathf.Abs(posList[index] - posX);  //���㵱ǰλ�����һҳ��ƫ��������ʼ��offect
            for (int i = 1; i < posList.Count; i++)
            {    //����ҳǩ��ѡȡ��ǰxλ�ú�ÿҳƫ������С���Ǹ�ҳ��
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
            targethorizontal = posList[curIndex]; //���õ�ǰ���꣬���º������в�ֵ  
            isDrag = false;
            startTime = 0;
            IsScrollEnd = false;
            //curPage.text = String.Format("��ǰҳ�룺{0}", curIndex.ToString());

            //Debug.Log("������� pageto��" + index);
            if (lua_function != null)
            {
                lua_function.Call<int>(index);
            }
        }
    }

}