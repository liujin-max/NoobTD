using System.Collections;
using UnityEngine;
using UnityEngine.UI;
public class ScreenUtil : MonoBehaviour
{
    Texture2D screenShot;//保存截取的纹理
    public Image image;  //显示截屏的Image


    public void Start()
    {
        //StartCoroutine(ScrrenCapture(new Rect(0, 0, Screen.width, Screen.height)));
        ScreenShotWithCamera(GameObject.Find("SceneCam").GetComponent<Camera>());
    }


    public void ScreenShotWithCamera(Camera _camera)
    {
        RenderTexture rt = new RenderTexture(Screen.width, Screen.height, 16);
        _camera.targetTexture = rt;
        _camera.Render();
        RenderTexture.active = rt;

        Texture2D t = new Texture2D(Screen.width, Screen.height);
        t.ReadPixels(new Rect(0, 0, t.width, t.height), 0, 0);
        t.Apply();

        Sprite sp = Sprite.Create(t, new Rect(0, 0, t.width, t.height), new Vector2(0.5f, 0.5f), 100.0f);
        image.sprite = sp;

        _camera.targetTexture = null;
        RenderTexture.active = null;
        Destroy(rt);
    }

    IEnumerator ScrrenCapture(Rect rect)
    {
        screenShot = new Texture2D((int)rect.width, (int)rect.height, TextureFormat.RGB24, false);
        yield return new WaitForEndOfFrame();
        screenShot.ReadPixels(rect, 0, 0);
        screenShot.Apply();

        Sprite sp = Sprite.Create(screenShot, new Rect(0, 0, screenShot.width, screenShot.height), new Vector2(0.5f, 0.5f), 100.0f);
        image.sprite = sp;

    }
}