using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace NoobTD
{
    public class LevelManager : MonoBehaviour
    {
        public void LoadLevelSync(string sceneName, System.Action onComplete)
        {
            SceneManager.LoadScene(sceneName);
            if(onComplete != null)
            {
                onComplete();
            }
        }

        public void LoadLevelAsync(string sceneName, System.Action onComplete)
        {
            StartCoroutine(LoadLevelAsyncCoroutine(sceneName, onComplete));
        }

        IEnumerator LoadLevelAsyncCoroutine(string sceneName, System.Action onComplete)
        {
            string last_scene = null;
            if (SceneManager.GetActiveScene() != null)
            {
                last_scene = SceneManager.GetActiveScene().name;
                if(last_scene == sceneName)
                {
                    onComplete();
                    yield break;
                }
            }

            if (GameFacade.Instance.ConstManager.LoadFromBundle == true)  //如果是从Bundle加载
            {
                yield return GameFacade.Instance.BundleManager.LoadScene(sceneName);
            }

            //============================================================================
            var operation = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Single);
            yield return operation;
            if (operation.isDone)
            {
                if (GameFacade.Instance.ConstManager.LoadFromBundle == true)  //如果是从Bundle加载
                {
                    if(last_scene != null)
                    {
                        GameFacade.Instance.BundleManager.UnloadScene(last_scene);
                    }
                }
                onComplete();
            }
        }

        public void EnterLoading(string sceneName, System.Action onComplete)
        {
            GameObject obj = NoobTD.GameFacade.Instance.AssetManager.LoadSync("Prefab/UI/Window/LoadingWindow");
            obj.transform.SetParent(GameObject.Find("UI/Canvas/BOTTOM").transform);
            obj.transform.localPosition = Vector3.zero;
            obj.transform.localScale = Vector3.one;

            NoobTD.Loading loading = obj.GetComponent<NoobTD.Loading>();
            loading.Enter(sceneName, onComplete);

        }


        
    }
}
