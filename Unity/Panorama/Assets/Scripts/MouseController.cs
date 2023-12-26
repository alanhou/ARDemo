using UnityEngine;

public class MouseController : MonoBehaviour {
    public float xSpeed = 2;
    public float ySpeed = 2;
    public float yMinLimit = -50;
    public float yMaxLimit = 50;
    public float zoomSpeed = 5;
    public float MinFOV = 40;
    public float MaxFOV = 75;
    private float zoomFOV;
    private float x = 0.0f;
    private float y = 0.0f;
    private Camera camera;
    // Start is called before the first frame update
    void Start() {
        x = transform.eulerAngles.y;
        y = transform.eulerAngles.x;
        camera = this.GetComponent<Camera>();
        zoomFOV = camera.fieldOfView;
    }

    private void LateUpdate() {
        if (Input.GetMouseButtonDown(0)) {
            x = transform.eulerAngles.y;
            y = transform.eulerAngles.x;
        }
        if (Input.GetMouseButton(0)) {
            x += Input.GetAxis("Mouse X") * xSpeed;
            y -= Input.GetAxis("Mouse Y") * ySpeed;
            y = ClampAngle(y, yMinLimit, yMaxLimit);
            transform.eulerAngles = new Vector3(y, x, 0);
        }
        zoomFOV -= Input.GetAxis("Mouse ScrollWheel") * zoomSpeed;
        zoomFOV = Mathf.Clamp(zoomFOV, MinFOV, MaxFOV);
        camera.fieldOfView = zoomFOV;
    }

    float ClampAngle(float angle, float min, float max) {
        if (angle > 180.0f)
            angle -= 360.0f;
        return Mathf.Clamp(angle, min, max);
    }
}
