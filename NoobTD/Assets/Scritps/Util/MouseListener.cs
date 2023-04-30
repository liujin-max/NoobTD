using UnityEngine;
using System.Collections;
using System;
using LuaInterface;

public class MouseListener : MonoBehaviour
{
    private LuaFunction MounseDownCallback;

    public void SetMounseDownCallback(LuaFunction callbck)
    {
        MounseDownCallback = callbck;
    }

    private void OnMouseDown()
    {
        if (MounseDownCallback != null)
        {
            MounseDownCallback.Invoke<bool>();
        }
    }
}
