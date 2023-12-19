using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GuestLogin : MonoBehaviour
{
    private Button guestLoginBtn;
    public GameObject GuestLoginGo;
    public Button CancelBtn;
    public Button LoginBtn;

    private void Awake() {
        guestLoginBtn = this.GetComponent<Button>();
        guestLoginBtn.onClick.AddListener(GuestLoginBtnClick);
        CancelBtn.onClick.AddListener(CancelBtnClick);
        LoginBtn.onClick.AddListener(LoginBtnClick);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void LoginBtnClick() {
        Debug.Log("游客登录成功");
    }
    private void CancelBtnClick() {
        GuestLoginGo.SetActive(false);
    }
    private void GuestLoginBtnClick() {
        GuestLoginGo.SetActive(true);
    }
}
