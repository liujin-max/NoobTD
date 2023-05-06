using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NoobTD
{
    public class Avatar : MonoBehaviour
    {
        private SpriteRenderer sprite_render;

        public Transform Head;
        public Transform Body;
        public Transform Attack;
        public Transform Foot;

        private Vector3 OriginScale;

        private void Awake()
        {
            sprite_render = this.GetComponent<SpriteRenderer>();

            OriginScale = transform.localScale;
        }

        // Start is called before the first frame update
        void Start()
        {
            
        }


        public void SetOrder(int value)
        {
            sprite_render.sortingOrder = value;
        }

        public void Face(bool flag)
        {
            float scale_x = OriginScale.x * (flag == true ? 1 : -1);
            transform.localScale = new Vector3(scale_x, OriginScale.y, OriginScale.z);
        }


        // Update is called once per frame
        void Update()
        {

        }
    }
}
