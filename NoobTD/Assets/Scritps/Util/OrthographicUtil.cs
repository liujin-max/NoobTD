using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrthographicUtil : MonoBehaviour
{

    private static float devWidth = 19.2f;
    private static float devHeight = 10.8f;
    private static float devAspect = devWidth / devHeight;

    void Awake()
    {

        Camera _camera = this.gameObject.GetComponent<Camera>();

        // 1.µ÷Õû camera ÊôÐÔ
        if (_camera.aspect < devAspect)
        {
            _camera.orthographicSize = devWidth * 0.5f / _camera.aspect;
        }
    }


    //public void Awake()
    //{
    //    Camera _camera = this.gameObject.GetComponent<Camera>();

    //    float aspect = _camera.aspect;
    //    float designOrthographicSize = _camera.orthographicSize;

    //    float designAspect = 1920f / 1080f;
    //    float heightOrthographicSize = designOrthographicSize * designAspect;


    //    if (aspect > designAspect)
    //    {
    //        _camera.orthographicSize = heightOrthographicSize / aspect;
    //    }
    //}
}
