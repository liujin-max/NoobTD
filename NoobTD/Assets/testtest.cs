using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testtest : MonoBehaviour
{
    public Transform P1;
    public Transform Pivot;
    public int Count = 0;
    public float Distance = 0;
    // Start is called before the first frame update
    void Start()
    {


    }

    // Update is called once per frame
    void Update()
    {
        float distance = 180 * Time.deltaTime;
        Distance += distance;
        P1.RotateAround(Pivot.position, Pivot.transform.forward, distance);

        if (Distance >= 360)
        {
            Distance = 0;
            Count += 1;
        }
    }
}
