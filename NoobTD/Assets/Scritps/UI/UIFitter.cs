using UnityEngine;
using System.Collections;

public class UIFitter : MonoBehaviour
{
    public RectTransform FullBG;


    void Start()
    {
        FillterUI();
    }

    public Vector2 GetNotchSize()
    {
        return new Vector2(Screen.safeArea.x, Mathf.Max(0, Screen.safeArea.y - 15));
        //return new Vector2(Screen.safeArea.x, Mathf.Max(0, 80));
    }

    private void FillterUI()
    {
        //适配刘海屏
        Vector2 notch_size = GetNotchSize();
        float notch_y = notch_size.y;
        float scale = notch_y / Screen.height;

        RectTransform rct = this.transform.GetComponent<RectTransform>();
        rct.anchorMax = new Vector2(rct.anchorMax.x, 1 - scale);
        //

        //适配全屏背景
        if (FullBG != null)
        {
            RectTransform bg_rect = FullBG.GetComponent<RectTransform>();
            RectTransform UICANVAS = GameObject.Find("UI/Canvas").GetComponent<Canvas>().transform.GetComponent<RectTransform>();

            float canvas_scale = Mathf.Max(1 , (UICANVAS.rect.size.y + notch_y) / bg_rect.rect.size.y );

            FullBG.transform.localScale = new Vector3(canvas_scale, canvas_scale, canvas_scale);
        }

    }
}
