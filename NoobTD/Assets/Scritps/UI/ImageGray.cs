using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;



namespace NoobTD
{
    public class ImageGray : MonoBehaviour
    {
        private Image Img;

        private void Awake()
        {
            Img = GetComponent<Image>();
            Img.material = new Material(Shader.Find("Custom/ImageGray"));
        }

            // Start is called before the first frame update
            public void TurnGray(bool flag, int level)
        {
            Material mat = Img.GetModifiedMaterial(Img.material);

            if (flag == true)
            {
                mat.SetFloat("_GrayFlag", level);
            }
            else
            {
                mat.SetFloat("_GrayFlag", 0);
            }
        }
    }
}