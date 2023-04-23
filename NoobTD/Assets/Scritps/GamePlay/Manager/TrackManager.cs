using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
// using ThinkingAnalytics;

namespace NoobTD
{
    public class TrackManager : MonoBehaviour
    {
//         //设置公共属性
//         //private Dictionary<string, object> _superProperties = new Dictionary<string, object>();
//         //用户集
//         private Dictionary<string, object> _userSet         = new Dictionary<string, object>();

//         //标记一个用户, 根据账号ID
//         public void AccountLogIn(string account_id)
//         {
//             ThinkingAnalyticsAPI.Login(account_id);
//         }

//         //用户登出, 切换账号时发生
//         public void AccountLogOut()
//         {
//             ThinkingAnalyticsAPI.Logout();
//         }

//         public void SetUserSet(string key, object value)
//         {
//             var _user_set = new Dictionary<string, object>();
//             _user_set.Add(key, value);
//             ThinkingAnalyticsAPI.UserSet(_user_set);
//         }

//         public void SetUserSetOnce(string key, object value)
//         {
//             var _user_set = new Dictionary<string, object>();
//             _user_set.Add(key, value);
//             ThinkingAnalyticsAPI.UserSetOnce(_user_set);
//         }

//         public void SetSuperProperties(string key, object value)
//         {
//             var _superProperties = new Dictionary<string, object>();
//             _superProperties.Add(key, value);
//             ThinkingAnalyticsAPI.SetSuperProperties(_superProperties);
//         }

//         public void SendTrackEvent(string track_event, Dictionary<string, object> properties)
//         {
//             ThinkingAnalyticsAPI.Track(track_event, properties);
//         }

//         public string GetDeviceID()
//         {
//             return ThinkingAnalyticsAPI.GetDeviceId();
//         }

//         private void OnApplicationFocus(bool focus)
//         {
//             if(focus == true)   //回到游戏
//             {
//                 EventManager.instance.SendEvent("TRACKER_FOCUS");
//             }
//         }

        public void SendActivationProgress(int progress, string detail, bool isfail_progress = false)
        {
            // if(PlayerPrefs.HasKey("activation_finished") == false)
            // {
            //     var properties = new Dictionary<string, object>();
            //     properties.Add("progress", progress);
            //     properties.Add("detail", detail);
            //     if(isfail_progress == true)
            //     {
            //         properties.Add("isfail_progress", isfail_progress);
            //     }
            //     ThinkingAnalyticsAPI.Track("check_activation", properties);
            // }
        }

// //############################ 两种容器 ##############################//
//         public Dictionary<string, object> GetContainer()
//         {
//             return new Dictionary<string, object>();
//         }

//         public List<string> GetList()
//         {
//             return new List<string>();
//         }
//####################################################################//
    }
}