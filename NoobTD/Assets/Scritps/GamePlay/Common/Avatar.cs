using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NoobTD
{
    public class Avatar : MonoBehaviour
    {
        private SpriteRenderer sprite_render;


        private void Awake()
        {
            sprite_render = this.GetComponent<SpriteRenderer>();
        }

        // Start is called before the first frame update
        void Start()
        {
            
        }

        public void SetOrder(int value)
        {
            sprite_render.sortingOrder = value;
        }


        // Update is called once per frame
        void Update()
        {

        }
    }
}
