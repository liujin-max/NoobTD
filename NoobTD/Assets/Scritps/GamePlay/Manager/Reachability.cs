using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Reachability : MonoBehaviour
{
    private bool _physical_disconnected = false;
    public bool CheckNetworkDisconnected()
    {
        return _physical_disconnected;
    }

    private void Update()
    {
        if(Time.frameCount % 30 == 0)
        {
            _physical_disconnected = Application.internetReachability == NetworkReachability.NotReachable;
        }
    }

    void OnGUI()
    {
        if(CheckNetworkDisconnected() == true)
        {
            GUIStyle fontStyle = new GUIStyle();
            fontStyle.normal.background = null;    //设置背景填充
            fontStyle.normal.textColor = new Color(1, 0, 0);   //设置字体颜色
            fontStyle.fontSize = 40;       //字体大小
            GUILayout.Label("物理网络断开", fontStyle);
        }
    }
}
