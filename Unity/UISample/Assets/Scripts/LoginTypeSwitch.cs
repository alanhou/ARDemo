using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LoginTypeSwitch : MonoBehaviour {
    public GameObject PasswordPage;
    public GameObject QRCodePage;
    public Button SwitchToQR;
    public Button SwitchToPwd_Image;
    public Button SwitchToPwd_Text;
    // Start is called before the first frame update
    void Start() {
        QRCodePage.SetActive(false);
        SwitchToPwd_Image.onClick.AddListener(ShowPasswordPage);
        SwitchToPwd_Text.onClick.AddListener(ShowPasswordPage);
        SwitchToQR.onClick.AddListener(ShowQRCodePage);
    }

    // Update is called once per frame
    void Update() {

    }
    private void ShowPasswordPage() {
        QRCodePage.SetActive(false);
        PasswordPage.SetActive(true);
    }
    private void ShowQRCodePage() {
        PasswordPage.SetActive(false);
        QRCodePage.SetActive(true);
    }
}
