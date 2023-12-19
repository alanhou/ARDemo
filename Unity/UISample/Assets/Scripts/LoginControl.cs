using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;


public class LoginControl : MonoBehaviour {
    public string UsernameStr;
    public string PasswordStr;
    public Button LoginButton;
    public TMP_InputField UsernameInput;
    public TMP_InputField PasswordInput;
    public Button RegisterBtn;
    public Button ForgetPwdBtn;

    private void Awake() {
        LoginButton.onClick.AddListener(LoginBtnClick);
        RegisterBtn.onClick.AddListener(RegisterClick);
        ForgetPwdBtn.onClick.AddListener(ForgetPwdClick);
    }
    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        if (!string.IsNullOrEmpty(UsernameInput.text) && !string.IsNullOrEmpty(PasswordInput.text)) {
            LoginButton.interactable = true;
        }
        else {
            LoginButton.interactable = false;
        }
    }

    private void RegisterClick() {
        Debug.Log("免费注册");
    }
    private void ForgetPwdClick() {
        Debug.Log("忘记密码");
    }
    private void LoginBtnClick() {
        if (UsernameInput.text == UsernameStr && PasswordInput.text == PasswordStr) {
            Debug.Log("登录成功");
        }
        else {
            Debug.LogError("你输入的密码和用户名不匹配");
        }
    }
}
