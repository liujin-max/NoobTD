//############### LandControl #################// 
//1.控制地表移动
//2.记录人物所属位置
//3.记录素材出现位置

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


namespace FoodWar
{
    public class LandControl : MonoBehaviour
    {
        private int count = 1;
        public GameObject[] TeamPos = null;
        public GameObject   MatPos = null;
        public GameObject   Land = null;

        public bool MoveFinished = false;

        public void Move()
        {
            MoveFinished = false;
            Land.transform.DOMoveY(count * (-14.7f + 0.98f), 1f).OnComplete(()=>
            {
                count ++;
                var panel = Land.transform.GetChild(0);
                panel.transform.position = Land.transform.GetChild(1).transform.position + new Vector3(0, (+ 14.7f - 0.98f)* (Land.transform.childCount - 1), 0);
                panel.SetAsLastSibling();
                MoveFinished = true;
            });
        }
    }
}
