using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NoobTD
{
    public class BGM : MonoBehaviour
    {
        private AudioSource Audio = null;

        private float _origin_value = 0;


        private void Awake()
        {
            Audio = transform.GetComponent<AudioSource>();
            _origin_value = Audio.volume;
        }

        public void Pause()
        {
            Audio.Pause();
        }

        public void Resume()
        {
            Audio.Play();
        }

        public void Play()
        {
            Audio.Play();
        }

        private void Update()
        {
            UpdateVolumn();
        }

        public void UpdateVolumn()
        {
            float ismute = 1;
            Audio.volume = _origin_value * ismute;
        }
    }
}

