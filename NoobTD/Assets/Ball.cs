using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ball : MonoBehaviour
{

    private Rigidbody2D rigidbody;

    private void Awake()
    {
        rigidbody = transform.GetComponent<Rigidbody2D>();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }

    

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.transform.name == "LeftBorad")
        {
            Debug.Log("测试输出 左边打到");
        }

        if (collision.transform.name == "RightBorad")
        {
            Debug.Log("测试输出 右边打到");
        }

                    //rigidbody.velocity *= 3;
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        

    }
}
