using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEngine.Advertisements;

namespace NoobTD
{
    public class AdsManager : MonoBehaviour
    {

        void Update()
        {
            //Input.get
        }

        string gameId = "4803249";
        public bool testMode = true;

        private void Start()
        {
            //Advertisement.Initialize(gameId, testMode);
        }

        public void ShowNormal()
        {
            //Debug.Log("������� ShowNormal");
            //Advertisement.Show("ios_init");
        }

        public void ShowRewarded()
        {
            //Debug.Log("������� ShowRewarded");
            //if (Advertisement.IsReady("ios_reward"))
            //{
            //    Debug.Log("������� ShowRewarded confirm");

            //    var options = new ShowOptions { resultCallback = HandleShowResult };
            //    Advertisement.Show("ios_reward", options);
            //}
        }

        public void ShowRewarded2()
        {
            //Debug.Log("������� ShowRewarded2");

            //var options = new ShowOptions { resultCallback = HandleShowResult };
            //Advertisement.Show("ios_reward", options);
        }

        //private void HandleShowResult(ShowResult result)
        //{
            //switch (result)
            //{
            //    case ShowResult.Finished:
            //        Debug.Log("The ad was successfully shown.");
            //        //
            //        // YOUR CODE TO REWARD THE GAMER
            //        // Give coins etc.
            //        break;
            //    case ShowResult.Skipped:
            //        Debug.Log("The ad was skipped before reaching the end.");
            //        break;
            //    case ShowResult.Failed:
            //        Debug.LogError("The ad failed to be shown.");
            //        break;
            //}
        //}
    }
}
