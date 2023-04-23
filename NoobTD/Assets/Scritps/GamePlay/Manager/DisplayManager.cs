using System.Collections;
using System.Collections.Generic;
using System.IO;
// using DG.Tweening;
using UnityEngine;


namespace NoobTD
{

    public class DisplayManager : MonoBehaviour, IManager
    {
        // public delegate void OnDisplayFinish();

        // public void MegaCamShake()
        // {
        //     //找到镜头
        //     GameObject cam = GameObject.Find("Camera");
        //     var shake_stand = cam.transform.parent;
        //     var shaker = shake_stand.GetComponent<CamShake>();
        //     if(shaker != null)
        //     {
        //         shaker.MegaShake();
        //     }
        // }

        // public void LittleCamShake()
        // {
        //     GameObject cam = GameObject.Find("Camera");
        //     var shake_stand = cam.transform.parent;
        //     var shaker = shake_stand.GetComponent<CamShake>();
        //     if (shaker != null)
        //     {
        //         shaker.LittleShake();
        //     }
        // }

        // private const float origin = 3.74f;
        // IEnumerator CamScaleProcess(Camera cam, float scale, float duration)
        // {
        //     float current = 0;
        //     float origin_size = cam.orthographicSize / origin;
        //     while(current < duration )
        //     {
        //         cam.orthographicSize = origin * (origin_size + (scale - origin_size) * current / duration);
        //         current += Time.deltaTime;
        //     }
        //     cam.orthographicSize = scale * origin;
        //     yield return null;
        // }

        // //让镜头移动到什么位置
        // public void CamMoveTo(float duration, Vector2 pos, float ScaleTo, OnDisplayFinish callback)
        // {
        //     GameObject cam = GameObject.Find("Camera");
        //     cam.transform.DOMove(new Vector3(pos.x, pos.y, cam.transform.position.z), duration+0.1f).OnComplete(()=>
        //     {
        //         if(callback != null)
        //         {
        //             callback();
        //         }
        //     });
        //     StartCoroutine(CamScaleProcess(cam.GetComponent<Camera>(), ScaleTo, duration));
        // }
    }
}
