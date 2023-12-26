using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PictureSceneController : MonoBehaviour
{
    public Material CubemapMat;
    public List<GameObject> Tips;
    private Cubemap cubemap;
    private RaycastHit hit;
    private Ray ray;
    private int CurrentTex = 1;
    private bool lookat = false;

    // Start is called before the first frame update
    void Start()
    {
        cubemap = Resources.Load<Cubemap>("1");
        CubemapMat.SetTexture("_Tex", cubemap);
    }
    private void Update() {
        if(lookat) {
            LookAtTarget();
        }
    }

    private void OnGUI() {
        Event mouse = Event.current;
        if(mouse.isMouse && mouse.type == EventType.MouseDown) {
            if(mouse.clickCount == 2) {
                ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                if(Physics.Raycast(ray, out hit)) {
                    if(hit.transform.tag == "Switch") {
                        CurrentTex++;
                        if(CurrentTex > 4) {
                            CurrentTex = 1;
                        }
                        cubemap = (Cubemap)Resources.Load((CurrentTex + ""));
                        CubemapMat.SetTexture("_Tex", cubemap);
                        this.transform.localRotation = new Quaternion(0, 0, 0, 0);
                        foreach (var o in Tips) {
                            o.SetActive(o.name == CurrentTex + "");
                            o.transform.GetChild(0).gameObject.SetActive(false);
                        }
                    }
                }
            }
        }
        if (mouse.isMouse && mouse.type == EventType.MouseUp) {
            lookat = false;
            ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit)) {
                if (hit.transform.tag == "Tip") {
                    lookat = true;
                    hit.transform.GetChild(0).gameObject.SetActive(!hit.transform.GetChild(0).gameObject.activeInHierarchy);
                }
            }
        }
    }

    void LookAtTarget() {
        var tmp = Quaternion.LookRotation(hit.point - this.transform.position);
        this.transform.rotation = Quaternion.Slerp(this.transform.rotation, tmp, Time.deltaTime * 7);
    }
}
