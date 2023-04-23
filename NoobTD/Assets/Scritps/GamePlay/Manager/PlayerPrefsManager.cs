using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NoobTD
{
    public class PlayerPrefsManager 
    {
        public static void SetIntKey(string key, int value)
        {
            PlayerPrefs.SetInt(key, value);
        }

        public static int GetIntByKey(string key, int defaultvalue = 0)
        {
            return PlayerPrefs.GetInt(key, defaultvalue);
        }


    }

}

