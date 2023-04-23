using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sound : MonoBehaviour
{
    private AudioSource source;
    private float _origin_value;
    // Start is called before the first frame update
    void Start()
    {
        source = transform.GetComponent<AudioSource>();

        _origin_value = source.volume;
    }

    // Update is called once per frame
    private void Update()
    {
        float ismute = 1;
        source.volume = _origin_value * ismute;

        if (source.isPlaying == false)
        {
            Destroy(this.gameObject);
        }
    }
}
