using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace NoobTD
{
    [RequireComponent(typeof(Image))]
    public class RedDot : MonoBehaviour
    {
        private Image red_dot_img   = null;
        public string[] ListenList  = null;  //红点监听的各种类型
        //例如: 当我想要监听关于升级, 以及升阶
        //则在这里注册两个消息类型即可

        private void Awake()
        {
            red_dot_img = this.GetComponent<Image>();       //获得红点逻辑
        }

        public void SetVisible(bool flag)
        {
            this.gameObject.SetActive(flag);
        }
    }
}


