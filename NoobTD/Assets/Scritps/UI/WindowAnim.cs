using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;


//UI∂Øª≠¿‡
public class WindowAnim : MonoBehaviour
{
    public bool AwakePlay = false;
    private string Flag = null;
    private float Progress = 0f;


    public bool FadeInScale = false;
    public bool FadeOutScale = false;
    private bool ScaleFlag = false;
    public float ScaleValue = 1.2f;
    private float OScale;


    public float ContinueTime = 0.2f;
    private CanvasGroup Group = null;
    private LuaFunction FadeOut_Callback;



    // Start is called before the first frame update
    private void Awake()
    {
        if (gameObject.GetComponent<CanvasGroup>() == null)
        {
            gameObject.AddComponent<CanvasGroup>();
        }

        Group = gameObject.GetComponent<CanvasGroup>();
    }

    void Start()
    {
        if (AwakePlay == true)
        {
            FadeIn();
        }

        if (FadeInScale == true)
        {
            ScaleFlag = true;
            OScale = ScaleValue;
        }
    }


    // Update is called once per frame
    void Update()
    {
        float unscale_deltatime = Time.fixedDeltaTime; //Time.fixedUnscaledDeltaTime;

        float speed = unscale_deltatime * (1 / ContinueTime);

        if (Flag == "FadeIn")
        {
            Progress = Progress + speed;

            if (Progress >= 1)
            {
                Progress = 1;
                Flag = null;
            }

            Group.alpha = Progress;

            if (FadeInScale == true)
            {
                float scale_speed = unscale_deltatime * ((OScale - 1) / ContinueTime);

                ScaleValue = ScaleValue - scale_speed;

                if (ScaleValue <= 1)
                {
                    ScaleValue = 1f;
                    ScaleFlag = false;
                }

                transform.localScale = new Vector3(ScaleValue, ScaleValue, ScaleValue);
            }
        }
        else if (Flag == "FadeOut")
        {
            Progress = Progress - speed;

            if (Progress <= 0)
            {
                Progress = 0;
                Flag = null;

                if (FadeOut_Callback != null)
                {
                    FadeOut_Callback.Call();
                    FadeOut_Callback = null;
                }
            }

            Group.alpha = Progress;

            if (FadeOutScale == true)
            {
                float scale_speed = unscale_deltatime * ((OScale - 1) / ContinueTime);

                ScaleValue = ScaleValue + scale_speed;

                if (ScaleValue >= OScale)
                {
                    ScaleValue = OScale;
                    ScaleFlag = false;
                }

                transform.localScale = new Vector3(ScaleValue, ScaleValue, ScaleValue);
            }
        }


    }

    public void FadeIn()
    {
        Flag = "FadeIn";
        Progress = 0;

        Group.alpha = Progress;
    }

    public void FadeOut(LuaFunction callback = null)
    {
        Flag = "FadeOut";
        Progress = 1;

        Group.alpha = Progress;

        FadeOut_Callback = callback;
    }

    public float GetAlpha()
    {
        return Group.alpha;
    }

    public void SetAlpha(float value)
    {
        Group.alpha = value;
    }
}
