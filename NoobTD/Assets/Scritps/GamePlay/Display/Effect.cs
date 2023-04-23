//Effect: 控制特效的脚本,主要控制特效的:
//1.生存周期;
//2.*大小;
//3.*方向;
//4.*暂停/播放;

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FoodWar
{
    public class Effect : MonoBehaviour
    {
        public bool IsLoop = false;
        public float LifeTime = 1f;

        private void Update()
        {
            if (IsLoop == false)
            {
                LifeTime -= Time.deltaTime;
                if (LifeTime < 0)
                {
                    GameObject.Destroy(this.gameObject);
                }
            }
        }
    }
}

