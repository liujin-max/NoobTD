using UnityEngine;
using System.Collections;
using DG.Tweening;

namespace FoodWar
{
    public class CameraUtil : MonoBehaviour
    {

        private float FOV_FITTER = 60f;

        private Camera CAMARE;
        private Canvas UICANVAS;

        //适配相机
        private float CameraFov(float aspect, float fov)
        {
            double frustumHeight = 2f * 1000 * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
            float CurrentFov = 2 * Mathf.Atan((float)frustumHeight * (1920f / 1080f) / aspect * 0.5f / 1000) * Mathf.Rad2Deg;
            if (CurrentFov > fov)
            {
                return CurrentFov;
            }

            return fov;
        }

        private void Awake()
        {
            CAMARE = transform.GetComponent<Camera>();
            UICANVAS = GameObject.Find("UI/Canvas").GetComponent<Canvas>();


            //float aspect = UnityEngine.Screen.width / (float)UnityEngine.Screen.height;
            float aspect = UICANVAS.transform.GetComponent<RectTransform>().rect.width / (float)UICANVAS.transform.GetComponent<RectTransform>().rect.height;

            FOV_FITTER = CameraFov(aspect, CAMARE.fieldOfView);
  
            CAMARE.fieldOfView = FOV_FITTER;
        }

        // Use this for initialization
        void Start()
        {

        }
    }
}
