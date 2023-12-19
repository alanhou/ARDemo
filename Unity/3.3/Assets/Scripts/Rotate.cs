using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public GameObject SunGo;
    public float SelfSpeed;
    public float WorldSpeed;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(SunGo.transform.position, Vector3.up, WorldSpeed * Time.deltaTime);
    }
}
