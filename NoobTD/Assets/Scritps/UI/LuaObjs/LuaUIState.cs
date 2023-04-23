using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    [RequireComponent(typeof(Animator))]
    public class LuaUIState : MonoBehaviour
    {
        private Animator _animator = null;
        void Awake()
        {
            _animator = this.GetComponent<Animator>();
        }

        public bool IsNormal()
        {
            AnimatorStateInfo stateinfo = _animator.GetCurrentAnimatorStateInfo(0);
            return stateinfo.IsName("UINormal");
        }
    }
}

