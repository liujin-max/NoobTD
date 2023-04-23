using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrbLineUtil : MonoBehaviour
{
    public GameObject Focus;
    private LineRenderer Line;

    // Start is called before the first frame update
    void Start()
    {
        Line = transform.GetComponent<LineRenderer>();
        Focus.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (Line.positionCount >= 2)
        {
            Vector3 pos = Line.GetPosition(1);
            Vector3 o_pos = transform.localPosition;
            Vector3 to_pos = pos - o_pos;
            Focus.transform.localPosition = to_pos;
            Focus.SetActive(true);
        }
    }
}
