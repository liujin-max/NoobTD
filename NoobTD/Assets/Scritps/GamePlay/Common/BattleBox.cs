using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NoobTD
{
    public class BattleBox : MonoBehaviour
    {
        // Start is called before the first frame update
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {

        }

        private void OnMouseDown()
        {
            //���UI�ͷ���
            if (UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject() == true)
            {
                return;
            }

            EventManager.instance.SendEvent("BATTLE_DOWN", null);
        }
    }
}
