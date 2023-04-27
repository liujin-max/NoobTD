using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrthographicUtil : MonoBehaviour
{

    public void Awake()
    {
        Camera _camera = this.gameObject.GetComponent<Camera>();

        float aspect = _camera.aspect;
        float designOrthographicSize = _camera.orthographicSize;

        float designAspect = 1920f / 1080f;
        float heightOrthographicSize = designOrthographicSize * designAspect;


        if (aspect > designAspect)
        {
            _camera.orthographicSize = heightOrthographicSize / aspect;
        }
    }
}
