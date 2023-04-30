using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NoobTD
{
    public class Defender : MonoBehaviour
    {
        // Start is called before the first frame update
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {

        }

        private void OnMouseUpAsButton()
        {
            //µã»÷UI¾Í·µ»Ø
            if (UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject() == true)
            {
                return;
            }

            EventManager.instance.SendEvent("BATTLE_DEFENDER_CLICK", null, gameObject);
        }
    }
}
