using UnityEngine;
using System.Collections;
using DG.Tweening;

namespace FoodWar
{
    public class CameraUtil : MonoBehaviour
    {

        private Vector3 CameraOriginPosition;
        private Vector3 CameraOriginRotation;
        private Vector3 CameraOriginScale;

        private float FOV_FITTER = 60f;
        private float FOV_MAP = 60f;

        private Camera CAMARE;
        private Canvas UICANVAS;

        //适配相机
        private float CameraFov(float aspect, float fov)
        {
            double frustumHeight = 2f * 1000 * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
            float CurrentFov = 2 * Mathf.Atan((float)frustumHeight * (1080f / 1920f) / aspect * 0.5f / 1000) * Mathf.Rad2Deg;
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

            CameraOriginPosition = transform.localPosition;
            CameraOriginRotation = transform.localEulerAngles;
            CameraOriginScale = transform.localScale;

            //float aspect = UnityEngine.Screen.width / (float)UnityEngine.Screen.height;
            float aspect = UICANVAS.transform.GetComponent<RectTransform>().rect.width / (float)UICANVAS.transform.GetComponent<RectTransform>().rect.height;

            FOV_FITTER = CameraFov(aspect, CAMARE.fieldOfView);
            FOV_MAP = FOV_FITTER + 16;
            CAMARE.fieldOfView = FOV_FITTER;
        }

        // Use this for initialization
        void Start()
        {

        }

        public void EnterMap()
        {
            transform.localPosition = new Vector3(0, 0, CameraOriginPosition.z);
            transform.localEulerAngles = Vector3.zero;
            transform.localScale = Vector3.one;

            CAMARE.fieldOfView = FOV_MAP;
        }

        public void LeaveMap()
        {
            transform.localPosition = CameraOriginPosition;
            transform.localEulerAngles = CameraOriginRotation;
            transform.localScale = CameraOriginScale;

            CAMARE.fieldOfView = FOV_FITTER;
        }



        //布阵开始
        public void EnterFormation()
        {
            CAMARE.fieldOfView = FOV_FITTER + 12f;

            transform.localPosition = new Vector3(transform.localPosition.x + 1, transform.localPosition.y, transform.localPosition.z);
        }

        //战斗开始
        public void EnterBattle()
        {
            CAMARE.fieldOfView = FOV_FITTER;
            transform.localPosition = CameraOriginPosition;
        }
    }
}
