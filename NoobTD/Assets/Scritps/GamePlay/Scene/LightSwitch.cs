using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightSwitch : MonoBehaviour
{
    public Light Light = null;
    public bool IsRendering = false;  
  
    void Update()  
    {  
        if(Mathf.Abs(this.transform.position.x) > 1000)
        {
            if(IsRendering == true)
            {
                IsRendering = false;
                Light.enabled = false;
            }
        }
        else
        {
            if(IsRendering == false)
            {
                IsRendering = true;
                Light.enabled = true;
            }
        }
    }  
}
