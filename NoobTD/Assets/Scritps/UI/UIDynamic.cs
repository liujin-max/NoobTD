using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public class UIDynamic : MonoBehaviour
    {
        public string Tag = "";
        public Texture2D[] Atlas = null;     //Atlas
        public Sprite[] Sprites = null;     //所有的Sprites
        private Dictionary<string, Sprite> _LookUp = new Dictionary<string, Sprite>();

        public void Generate()
        {
            _LookUp.Clear();
            if (Sprites != null)
            {
                foreach (Sprite sp in Sprites)
                {
                    if(sp != null)
                    {
                        _LookUp.Add(sp.name, sp);
                    }
                }
            }
        }

        public Sprite Get(string key)
        {
            if(_LookUp.ContainsKey(key) == false)
            {
                Debug.Log("<color=red>Not Found Dynamic Sprite: " + key + " " + Tag + " _LookUp " + _LookUp.Count + "</color>");
                return null;
            }
            else
            {
                return _LookUp[key];
            }
        }
    }
}

