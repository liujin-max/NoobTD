using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace NoobTD
{
    public class Loading : MonoBehaviour
    {
        public Image Progress;

        private System.Action Callback;

        // Start is called before the first frame update
        void Start()
        {
            Progress.fillAmount = 0;
        }

        public void Enter(string sceneName, System.Action onComplete)
        {
            Callback = onComplete;
            StartCoroutine(StartLoading(sceneName));
        }

        IEnumerator StartLoading(string sceneName)
        {
            AsyncOperation op = SceneManager.LoadSceneAsync(sceneName); //Application.LoadLevelAsync(sceneName);

            //op.allowSceneActivation = false;

            while (!op.isDone)
            {
                Progress.fillAmount = op.progress;

                yield return new WaitForEndOfFrame();

            }

            //op.allowSceneActivation = true;
            if (Callback != null)
            {
                Callback();
            }
            Destroy(gameObject);
        }
    }
}