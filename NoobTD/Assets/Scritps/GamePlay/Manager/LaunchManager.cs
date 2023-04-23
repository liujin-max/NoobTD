using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;

//------------------------------------------------------------------------
//Launch Manager的作用主要如下:
//在真正进入lua脚本执行阶段前:
//1. 检查版本是否同步;
//2. 如果不同步, 则首先下载资源文件比对文本，lua文件比对文本;
//3. 比对好针对新版本, 需要下载哪些资源后, 进行对应的下载更新;
//4. 更新模式: 目前先采用HttpWebRequest, 进行下载;
//------------------------------------------------------------------------

namespace NoobTD
{
    public class LaunchManager : MonoBehaviour, IManager
    {
//         internal enum FileState
//         {
//             Stay        = 0,
//             Delete      = 1,
//             Add         = 2,
//             Replace     = 3,
//         }

//         internal enum HTTPState
//         {
//             NotReceived = 0,
//             OK          = 1,
//             Error       = 2
//         }

//         internal class Content
//         {
//             public string   text;
//             public bool     success;
//         }

//         internal class FileMD5
//         {
//             public string key;
//             public string md5;
//             public FileState state = FileState.Stay;


//             public FileMD5(string key, string md5, FileState state)
//             {
//                 this.key    = key;
//                 this.md5    = md5;
//                 this.state  = state;
//             }
//         }

//         internal class BundleCRC
//         {
//             public string key;
//             public string crc;
//             public float size;
//             public string fmd5;

//             public FileState state = FileState.Stay;

//             public BundleCRC(string key, string crc, string fmd5, string size, FileState state)
//             {
//                 this.key    = key;
//                 this.crc    = crc;
//                 this.fmd5   = fmd5;

//                 this.state  = state;
//                 this.size   = float.Parse(size);
//             }
//         }

//         internal class UpdateAbstract
//         {
//             public Dictionary<string, BundleCRC> local_bundle_abs      = null;
//             public Dictionary<string, BundleCRC> remote_bundle_abs     = null;
//             public Dictionary<FileState, List<BundleCRC>> bundle_records = new Dictionary<FileState, List<BundleCRC>>();

//             public Dictionary<string, FileMD5> local_file_abs = null;
//             public Dictionary<string, FileMD5> remote_file_abs = null;
//             public Dictionary<FileState, List<FileMD5>> file_records = new Dictionary<FileState, List<FileMD5>>();

//             public UpdateAbstract()
//             {
//                 bundle_records.Add(FileState.Add,       new List<BundleCRC>());
//                 bundle_records.Add(FileState.Delete,    new List<BundleCRC>());
//                 bundle_records.Add(FileState.Replace,   new List<BundleCRC>());

//                 file_records.Add(FileState.Add,         new List<FileMD5>());
//                 file_records.Add(FileState.Delete,      new List<FileMD5>());
//                 file_records.Add(FileState.Replace,     new List<FileMD5>());
//             }
//         }

//         //两个文件下载器
//         private HotFixDownloader _BundleDownloader  = new HotFixDownloader();
//         private HotFixDownloader _LuaFileDownloader = new HotFixDownloader();

//         private UpdateAbstract _Abastract = new UpdateAbstract();

//         private LauncherWindow      _LauncherUI = null;
//         private InitPrivacyWindow   _PrivacyUI  = null;

//         private Version _ver = null;
//         public Version Version
//         {
//             get
//             {
//                 return _ver;
//             }
//         }

//         private bool NeedRetry = false;

//         private bool isSDKInited = false;

// #if UNITY_ANDROID
//         private const string URLHead = "https://z10.tanyu.mobi/lsjyxz/soulland_upgrade/android/";
// #elif UNITY_IPHONE || UNITY_IOS
//         private const string URLHead = "https://z10.tanyu.mobi/lsjyxz/soulland_upgrade/ios/";
// #elif UNITY_EDITOR
//         private const string URLHead = "https://z10.tanyu.mobi/lsjyxz/soulland_upgrade/android/";
// #endif

//         private bool IsPrivacyAgree = false;

//         public void CheckPrivacyAgree(bool result)
//         {
//             if (result == true)
//             {
//                 IsPrivacyAgree = true;
//             }
//             else
//             {

//             }
//         }

        public void Launch()
        {
            //if(GameFacade.Instance.ConstManager.LoadFromBundle == true)
            //{
            //发送一条埋点日志, 视为启动
            // StartCoroutine(LaunchProcess());
            //}
            //else
            //{
            //GameFacade.Instance.LuaManager.InitStart();
            //GameFacade.Instance.LaunchManager.Launch();
            GameFacade.Instance.GameLogicManager.Run();
            //}


            // 开启SDK的日志打印，发布版本请务必关闭
            BuglyAgent.ConfigDebugMode(false);
            // 注册日志回调，替换使用 'Application.RegisterLogCallback(Application.LogCallback)'注册日志回调的方式
            // BuglyAgent.RegisterLogCallback (CallbackDelegate.Instance.OnApplicationLogCallbackHandler);

#if UNITY_IPHONE || UNITY_IOS
            BuglyAgent.InitWithAppId("89683f4af6");
#elif UNITY_ANDROID
        BuglyAgent.InitWithAppId ("89683f4af6");
#endif

            // 如果你确认已在对应的iOS工程或Android工程中初始化SDK，那么在脚本中只需启动C#异常捕获上报功能即可
            BuglyAgent.EnableExceptionHandler();
        }

//         private string GetLuaPath(string relative_path)
//         {
//             //1. 获取下当前路径
//             var persistent  = LuaFramework.Util.DataPath;
//             var s_path = LuaFramework.Util.AppContentPath() + relative_path;
//             var p_path      = persistent + "lua/" + relative_path;
//             if(System.IO.File.Exists(p_path) == true)
//             {
// #if UNITY_IOS || UNITY_IPHONE 
//                 return "file://" + p_path;
// #elif UNITY_ANDROID
//                 return "file://" + p_path;
// #else
//                 return "file:///" + p_path;
// #endif
//             }
            
// #if UNITY_IOS || UNITY_IPHONE 
//             return "file://" + s_path;
// #elif UNITY_ANDROID
//             return s_path; 
// #else
//             return "file:///" + s_path;
// #endif
//         }

//         //1. 如果在persistent里有, 那么优先取;
//         //2. 否则在streaming里找;
//         private IEnumerator GetLocalFileContent(string file_path, Content content)
//         {
//             WWWRequest www = new WWWRequest(file_path);

//             while (www.WWWState == WWWRequest.State.ACTING || www.WWWState == WWWRequest.State.NOTINIT)
//             {
//                 yield return www.Fetch();
//             }

//             if (www.WWWState == WWWRequest.State.ERROR)
//             {
//                 Debug.LogError("Reading " + www.URL + " Error " + www.Content);
//                 _LauncherUI.ShowPanel("远程文件拉取失败: " + www.URL + " " + www.Content);
//                 yield break;
//             }
//             else
//             {
//                 if (www.Content.Contains("<html>"))
//                 {
//                     Debug.LogError("Reading " + www.URL + " Error " + www.Content);
//                     _LauncherUI.ShowPanel("远程文件拉取失败: " + www.URL + " " + www.Content);
//                     yield break;
//                 }
//                 else if(string.IsNullOrEmpty(www.Content))
//                 {
//                     Debug.LogError("Reading " + www.URL);
//                     _LauncherUI.ShowPanel("远程文件拉取失败: " + www.URL);
//                     yield break;
//                 }
//                 content.text = www.Content;
//             }

//             www.Dispose();
//         }


//         private IEnumerator GetRemoteFile(string url_path, Content content)
//         {

//             HTTPState get_version_flag = HTTPState.NotReceived;
//             HTTPLocalRequest get_version_request = new HTTPLocalRequest(url_path, null, false, 10, (is_error, response_text) =>
//             {
//                 if (is_error)
//                 {
//                     _LauncherUI.ShowPanel("获取文件" + url_path + ":" + response_text);
//                 }
//                 else
//                 {
//                     content.text = response_text;
//                 }

//                 if (is_error == true)
//                 {
//                     get_version_flag = HTTPState.Error;
//                 }
//                 else
//                 {
//                     get_version_flag = HTTPState.OK;
//                 }
//             });

//             while (get_version_flag == HTTPState.NotReceived)
//             {
//                 yield return null;
//             }

//             if (get_version_flag == HTTPState.Error)
//             {
//                 content.success = false;
//                 yield break;
//             }
//             else
//             {
//                 content.success = true;
//                 yield break;
//             }
//         }

//         public void SDKInited()
//         {
//             isSDKInited = true;
//         }

//         private void PrepareFolders()
//         {
//             //---------------------- BUNDLE FOLDER ------------------
//             var bundle_path = Application.persistentDataPath + "/AssetBundles/";
//             if (System.IO.Directory.Exists(bundle_path) == false)
//             {
//                 System.IO.Directory.CreateDirectory(bundle_path);
//             }

//             //---------------------- LUA FOLDER ------------------
//             var lua_path = Application.persistentDataPath + "/lua/";
//             if (System.IO.Directory.Exists(lua_path) == false)
//             {
//                 System.IO.Directory.CreateDirectory(lua_path);
//             }
//         }

//         private void DeleteLegacyFiles()
//         {
//             var bundle_path = Application.persistentDataPath + "/AssetBundles/";
//             if (System.IO.Directory.Exists(bundle_path) == true)
//             {
//                 System.IO.Directory.Delete(bundle_path, true);
//             }

//             //---------------------- LUA FOLDER ------------------
//             var lua_path = Application.persistentDataPath + "/lua/";

//             if (System.IO.Directory.Exists(lua_path) == true)
//             {
//                 System.IO.Directory.Delete(lua_path, true);
//             }

//             var ver_path = Application.persistentDataPath + "/version.txt";
//             if (System.IO.File.Exists(ver_path) == true)
//             {
//                 System.IO.File.Delete(ver_path);
//             }

//             var crc_path = Application.persistentDataPath + "/BundleCRC.txt";
//             if (System.IO.File.Exists(crc_path) == true)
//             {
//                 System.IO.File.Delete(crc_path);
//             }

//             var path_match_path = Application.persistentDataPath + "/PathMatcher.txt";
//             if (System.IO.File.Exists(path_match_path) == true)
//             {
//                 System.IO.File.Delete(path_match_path);
//             }
//         }

//         private bool PersistentEmpty()
//         {
// #if UNITY_EDITOR    //Unity里就不处理了
//             return false;
// #else
//             string persistentPath = LuaFramework.Util.DataPath + "lua/";                      //数据目录
//             string indexFilePath = persistentPath + "files.txt";
//             return File.Exists(indexFilePath) == false;
// #endif
//         }

//         public void HardUpdate()
//         {
//             int channel = SoulLand.AppUtility.GetGameChannelType();
//             string url  = ChannelInfo.Instance.MarketURL(channel);
//             if(url != null)
//             {
//                 SoulLand.ExternalLinkUtility.OpenUrl(url);
//             }
//             Debug.Log("== HARD UPDATE ==");
//         }

//         private void DeletePersistentLegacy()
//         {
//             //判断下, stream包体里的版本号, 是不是大于persistent下的版本号, 如果是, 则将那些文件都删除
//             //具体要删除的文件有:
//             //1. AssetBundles   文件夹
//             //2. version.txt
//             //3. PathMacher.txt
//             //4. BundleCRC.txt
//             //5. lua            文件夹

//             //删除AssetBundles
//             if(Directory.Exists(BundleManager.GetPersistentPath() + "/AssetBundles"))
//             {
//                 Directory.Delete(BundleManager.GetPersistentPath() + "/AssetBundles", true);
//             }

//             //删除lua
//             if (Directory.Exists(LuaFramework.Util.DataPath + "/lua"))
//             {
//                 Directory.Delete(LuaFramework.Util.DataPath + "/lua", true);
//             }

//             if (File.Exists(BundleManager.GetPersistentPath() + "/version.txt"))
//             {
//                 File.Delete(BundleManager.GetPersistentPath() + "/version.txt");
//             }

//             if (File.Exists(BundleManager.GetPersistentPath() + "/BundleCRC.txt"))
//             {
//                 File.Delete(BundleManager.GetPersistentPath() + "/BundleCRC.txt");
//             }

//             if (File.Exists(BundleManager.GetPersistentPath() + "/PathMatcher.txt"))
//             {
//                 File.Delete(BundleManager.GetPersistentPath() + "/PathMatcher.txt");
//             }
//         }

//         public static string tmp_version = null;

//         public void Retry()
//         {
//             StartCoroutine(LaunchProcess());
//         }

//         private void InitBugly()
//         {
//             //设置Bugly版本
//             BuglyAgent.ConfigDefault("TANYU", _ver.Current(), "Normal", 0);
//             //开启SDK的日志打印，发布版本请务必关闭
//             BuglyAgent.ConfigDebugMode(false);
// #if UNITY_IPHONE || UNITY_IOS
//             BuglyAgent.InitWithAppId("faa631152a");
// #elif UNITY_ANDROID
//             BuglyAgent.InitWithAppId("9a09a653fd");
// #endif
//             //如果你确认已在对应的IOS工程或Android工程中初始化SDK，那么在脚本中只需启动C#异常捕获上报功能即可
//             BuglyAgent.EnableExceptionHandler();
//         }

//         //检查隐私权限
//         private IEnumerator CheckPrivacy()
//         {
//             if(Application.platform == RuntimePlatform.Android)
//             {
//                 if (SoulLand.EventHandle.CheckPermissions() == false)
//                 {
//                     var ui_prefab = Resources.Load("Static/InitPrivacyPolicyWindow") as GameObject;
//                     if (_PrivacyUI == null)
//                     {
//                         _PrivacyUI = UnityEngine.Object.Instantiate<GameObject>(ui_prefab).GetComponent<InitPrivacyWindow>();
//                     }
//                     var bottom = GameObject.Find("BOTTOM").transform;
//                     _PrivacyUI.transform.SetParent(bottom, false);

//                     while (IsPrivacyAgree == false)
//                     {
//                         yield return null;
//                     }

//                     GameObject.Destroy(_PrivacyUI.gameObject);
//                     GameFacade.Instance.PlayerManager.SetIntKey("PRIVACY_AGREED", 1);
//                 }
//                 else
//                 {
//                     SoulLand.EventHandle.GrandPermissions();
//                 }
//             }

// #if UNITY_EDITOR
//             isSDKInited = true;
// #endif            
//             while(isSDKInited == false)
//             {
//                 yield return null;
//             }

//             yield return null;
//         }


//         //检查乐变更新
//         private void LBqueryUpdate()
//         {
// #if UNITY_IOS && !UNITY_EDITOR

// #elif UNITY_ANDROID && !UNITY_EDITOR
//             try
//             {
//                 AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
//                 AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
//                 AndroidJavaClass lebianSdk = new AndroidJavaClass("com.excelliance.lbsdk.LebianSdk");
//                 if (lebianSdk != null)
//                 {
//                     lebianSdk.CallStatic("queryUpdate", activity, null, null);
//                 }
//             }
//             catch (System.Exception e)
//             {
//                 Debug.Log(e.ToString());
//             }
// #endif

//         }

//         //是否需要大更
//         private IEnumerator NeedHardUpdate()    
//         {
//             HTTPState get_version_flag = HTTPState.NotReceived;
//             //@FAKE hard_version
//             HTTPLocalRequest get_version_request = new HTTPLocalRequest(URLHead + "hard_version.txt?t=" + FileUtility.GetCurrentTimeStamp(), null, false, 10, (is_error, response_text) =>
//             {
//                 if (is_error)
//                 {
//                     UnityEngine.Debug.LogError(" 获取最低版本号错误: " + response_text);
//                     _LauncherUI.ShowPanel("获取最低版本号错误 " + response_text);
//                 }
//                 else
//                 {
//                     var version_text = response_text;
//                     this._ver.SetHardVersion(version_text);
//                 }

//                 if (is_error == true)
//                 {
//                     get_version_flag = HTTPState.Error;
//                 }
//                 else
//                 {
//                     get_version_flag = HTTPState.OK;
//                 }
//             });
//             yield return null;

//             while(get_version_flag == HTTPState.NotReceived)
//             {
//                 yield return null;
//             }

//             if(get_version_flag == HTTPState.Error)
//             {
//                 yield break;
//             }

//             Debug.Log("NEED HARD UPDATE" + this._ver.GetHardVersion());
//         }

//         private IEnumerator LaunchProcess()
//         {
//             GameFacade.Instance.TrackManager.SendActivationProgress(101, "进入启动项步骤");
//             //进入Check场景
//             var operation = SceneManager.LoadSceneAsync("Check", LoadSceneMode.Single);
//             yield return operation;
//             //Check 场景完成
//             if (operation.isDone == false)
//             {
//                 yield return null;
//             }

//             Debug.LogError("INTO CHECK PRIVACY BEGINs");

//             yield return CheckPrivacy();    //检查隐私权限
//             GameFacade.Instance.TrackManager.SendActivationProgress(102, "隐私协议检查完毕");
//             Debug.LogError("INTO CHECK PRIVACY FINISH");
//             //乐变检查更新
//             LBqueryUpdate();
//             Debug.LogError("LB QUERY UPDATE FINISH");

//             //在安卓的移动平台上
//             if (Application.platform == RuntimePlatform.Android)
//             {
//                 yield return LEBIAN_HOT_FIX();
//             }
//             yield return NORMAL_HOT_FIX();
//         }

//         //###################################### ANDROID HOT FIX ###################################
        
//         private IEnumerator LEBIAN_HOT_FIX()
//         {
//             Debug.LogError("INTO ANDROID_HOT_FIX");
//             try
//             {
//                 Debug.Log("INTO ANDROID_HOT_FIX1");
//                 AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
//                 Debug.Log("INTO ANDROID_HOT_FIX2");
//                 AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
//                 Debug.Log("INTO ANDROID_HOT_FIX3");
//                 AndroidJavaObject java_application = jo.Call<AndroidJavaObject>("getApplication");
//                 Debug.Log("INTO ANDROID_HOT_FIX4 " + java_application.ToString());
//                 AndroidJavaObject java_context = jo.Call<AndroidJavaObject>("getApplicationContext");
//                 Debug.Log("INTO ANDROID_HOT_FIX5" + java_context.ToString());
//                 AndroidJavaClass lebian = new AndroidJavaClass("com.excelliance.lbsdk.LebianSdk");
//                 Debug.Log("INTO ANDROID_HOT_FIX6");
//                 if (lebian != null)
//                 {
//                     lebian.CallStatic<bool>("setPrivacyChecked", java_application, java_context);
//                 }
//                 else
//                 {
//                     Debug.LogError("INTO ANDROID_HOT_FIX lebian not exist " );
//                 }
//             }
//             catch (System.Exception e)
//             {
//                 Debug.LogError("Lebian Exception " + e.ToString());
//             }

//             yield return null;
//         }

//         //###################################### IPHONE HOT FIX ####################################

//         private IEnumerator NORMAL_HOT_FIX()
//         {

//             var ui_prefab = Resources.Load("Static/LauncherWindow") as GameObject;
//             //0.1. 加载窗口
//             if (_LauncherUI == null)
//             {
//                 _LauncherUI = UnityEngine.Object.Instantiate<GameObject>(ui_prefab).GetComponent<LauncherWindow>();
//             }

//             _LauncherUI.ShowRetry(false);

//             var bottom = GameObject.Find("BOTTOM").transform;
//             _LauncherUI.transform.SetParent(bottom, false);

//             if (GameFacade.Instance.ConstManager.Console == true)
//             {
//                 while (tmp_version == null)
//                 {
//                     yield return null;
//                 }
//             }


//             PrepareFolders();
//             GameFacade.Instance.TrackManager.SendActivationProgress(103, "准备开始同步版本");

//             _ver = new Version();
//             yield return _ver.Fetch();
//             GameFacade.Instance.TrackManager.SendActivationProgress(104, "读取本地版本号成功");

//             yield return NeedHardUpdate();  //是否需要大更
//             GameFacade.Instance.TrackManager.SendActivationProgress(105, "检测是否需要大更");


//             InitBugly();    //初始化BUGLY
//             GameFacade.Instance.TrackManager.SendActivationProgress(106, "初始化Bugly");

//             if (this._ver.NeedHardUpdate() == true)
//             {
//                 int channel = SoulLand.AppUtility.GetGameChannelType();
//                 GameFacade.Instance.TrackManager.SendActivationProgress(107, "显示大更流程");

//                 if (SoulLand.ChannelInfo.Instance.GetMarketPack(channel) != null)
//                 {
//                     _LauncherUI.ShowHardUpdatePanel("需要去" + SoulLand.ChannelInfo.Instance.GetChannelShowName(channel) + "更新版本才能进入游戏", true);
//                 }
//                 else
//                 {
//                     _LauncherUI.ShowHardUpdatePanel("需要去" + SoulLand.ChannelInfo.Instance.GetChannelShowName(channel) + "更新版本才能进入游戏", false);
//                 }
//                 //弹出界面: 需要大更新, 
//                 //1. 点击确定:
//                 //2. 如果能够更新则跳转;
//                 //3. 否则直接关闭;
//                 yield break;
//             }

//             bool is_local_version_lower = false;

//             //0.2. 查看是否初始化过脚本, 没有的话, Copy所有的lua脚本去persistentPath
//             //判断标准, 查看下persistentPath是否有lua/file.txt这个文件

//             _LauncherUI.SetVersion(this.Version.Current());
//             //_LauncherUI.SetInfo("初始化脚本...");
//             //_LauncherUI.SetProgress(GameFacade.Instance.GameLogicManager.InitialExtractProgress);
//             //yield return GameFacade.Instance.GameLogicManager.OnInitialExtractLuaFile();
//             //_LauncherUI.SetProgress(GameFacade.Instance.GameLogicManager.InitialExtractProgress);

//             var dir_paths = System.IO.Directory.GetDirectories(Application.persistentDataPath);

//             var file_paths = System.IO.Directory.GetFiles(Application.persistentDataPath);

//             //------------------------------------      核对版本     -------------------------------//
//             _LauncherUI.SetInfo("核对版本号...");
//             _LauncherUI.SetProgress(0);
//             //1. 首先: 先查看当前版本号

//             HTTPState get_version_flag = HTTPState.NotReceived;
//             HTTPLocalRequest get_version_request = new HTTPLocalRequest(URLHead + "version.txt?t=" + FileUtility.GetCurrentTimeStamp(), null, false, 10, (is_error, response_text) =>
//             {
//                 if (is_error)
//                 {
//                     UnityEngine.Debug.LogError(" 获取版本号错误: " + response_text);
//                     _LauncherUI.ShowPanel("获取版本号错误 " + response_text);
//                 }
//                 else
//                 {
//                     Debug.Log("输出 tmp_version：" + tmp_version);
//                     var version_text = response_text;
//                     Debug.Log("输出 version_text：" + version_text);
//                     if (GameFacade.Instance.ConstManager.Console == true)
//                     {
//                         is_local_version_lower = this._ver.Compare(tmp_version);
//                     }
//                     else
//                     {
//                         is_local_version_lower = this._ver.Compare(version_text);
//                     }
//                 }

//                 if (is_error == true)
//                 {
//                     get_version_flag = HTTPState.Error;
//                 }
//                 else
//                 {
//                     get_version_flag = HTTPState.OK;
//                 }
//             });

//             while (get_version_flag == HTTPState.NotReceived)
//             {
//                 yield return null;
//             }

//             if (get_version_flag == HTTPState.Error)
//             {
//                 GameFacade.Instance.TrackManager.SendActivationProgress(109, "获取远程版本号失败", true);
//                 yield break;
//             }

//             _LauncherUI.SetProgress(1);
//             GameFacade.Instance.TrackManager.SendActivationProgress(110, "获取远程版本号成功");



//             //--------------------- 关于如何处理文件恢复的问题 -------------------------//
//             //
//             //  开启游戏时:
//             //  1. 核对版本，如果Persistent里的版本号低于Streaming:
//             //  处理: 删除Persistent里的数据, 重新拷贝一份过去;
//             //  
//             //  2. 如果需要热更，  则热更，一切都没有问题
//             //  3. 如果不需要热更, 则进入游戏， 但是要把Persisteng里的版本进行热更
//             //---------------------------------------------------------------------------
//             if (Version.IsPersistentLegacy() == true || PersistentEmpty() == true)
//             {
//                 //删除Persistent下的各种文件
//                 Debug.LogError("删除低版本的文件");
//                 this.DeletePersistentLegacy();
//                 DeleteLegacyFiles();
//                 PrepareFolders();
//                 yield return GameFacade.Instance.GameLogicManager.OnRecoverLuaFile();
//             }
//             GameFacade.Instance.TrackManager.SendActivationProgress(111, "检查冗余资源");

//             //------------------------------------------------------------------------------------//
//             if (is_local_version_lower == false)
//             {
//                 Debug.Log("当前已经是最高版本!");

//                 this.Version.UpdateVersion();
//                 _LauncherUI.SetVersion(this.Version.Current());

//                 yield return GameFacade.Instance.BundleManager.LoadSearcher();
//                 GameFacade.Instance.TrackManager.SendActivationProgress(115, "初始化Searcher");


//                 BuglyAgent.ConfigDefault("TANYU", this.Version.Current(), "Normal", 0);

//                 //初始化资源
//                 GameFacade.Instance.BundleManager.Init();
//                 GameFacade.Instance.TrackManager.SendActivationProgress(116, "初始化Bundle");


//                 //初始化Lua框架
//                 GameFacade.Instance.LuaManager.InitStart();
//                 GameFacade.Instance.TrackManager.SendActivationProgress(117, "初始化Lua");

//                 Dispose();
//             }
//             else
//             {
//                 //2. 如果版本号比当前版本号高, 则拉取两个文件
//                 _LauncherUI.SetInfo("查询新版本数据...");
//                 _LauncherUI.SetProgress(0);

//                 Content local_bundle_abstract = new Content();
//                 string local_bundle_abs_path = GetAlternativePath("BundleCRC.txt");

//                 yield return GetLocalFileContent(local_bundle_abs_path, local_bundle_abstract);
//                 _LauncherUI.SetProgress(0.2f);


//                 Content remote_bundle_abstract = new Content();
//                 string remote_bundle_abs_path = URLHead + _ver.URLCompare() + "/BundleCRC.txt" + "?t=" + FileUtility.GetCurrentTimeStamp();
//                 yield return GetRemoteFile(remote_bundle_abs_path, remote_bundle_abstract);
//                 _LauncherUI.SetProgress(0.4f);

//                 //如果是另一个版本号更高, 就下拉对应版本号
//                 Content local_lua_abstract = new Content();

//                 string local_lua_abs_path = GetLuaPath("files.txt");
//                 yield return GetLocalFileContent(local_lua_abs_path, local_lua_abstract);
//                 _LauncherUI.SetProgress(0.6f);

//                 Content remote_lua_abstract = new Content();
//                 string remote_lua_abs_path = URLHead + _ver.URLCompare() + "/lua/files.txt" + "?t=" + FileUtility.GetCurrentTimeStamp();
//                 yield return GetRemoteFile(remote_lua_abs_path, remote_lua_abstract);
//                 _LauncherUI.SetProgress(0.8f);

//                 //对比需要下载的Bundle文件
//                 BundleCompare(local_bundle_abstract.text, remote_bundle_abstract.text);
//                 //对比需要下载的lua文件
//                 LuaFileCompare(local_lua_abstract.text, remote_lua_abstract.text);

//                 _LauncherUI.SetProgress(1.0f);
//                 yield return null;

//                 //3. -> 需要去更新哪些资源, 已经获得
//                 //接下去做更新:
//                 //3.1 -> 删除需要删除的文件, 如果是streaming里的, 不做删除;
//                 //3.2 -> 覆盖更新文件, 如果是streaming里的, 不做删除;
//                 //3.3 -> 添加新文件;
//                 //3.4 -> 更新File.txt, 以及BundleCRC.txt这两个文件

//                 //----------------------------- 更新Bundle ------------------------------

//                 //更新对应的
//                 if (_Abastract.bundle_records[FileState.Replace].Count != 0 || _Abastract.bundle_records[FileState.Add].Count != 0)
//                 {
//                     foreach (var bundle_abs in _Abastract.bundle_records[FileState.Replace])
//                     {
//                         var bundle_name = bundle_abs.key;   //Bundle的名称
//                         var bundle_url = URLHead + _ver.URLCompare() + "/AssetBundles/" + bundle_name;
//                         ThreadHTTP task = new ThreadHTTP(bundle_name, Application.persistentDataPath + "/AssetBundles", bundle_url, bundle_abs.size, bundle_abs.fmd5);
//                         _BundleDownloader.AddTask(task);
//                     }

//                     foreach (var bundle_abs in _Abastract.bundle_records[FileState.Add])
//                     {
//                         var bundle_name = bundle_abs.key;   //Bundle的名称
//                         var bundle_url = URLHead + _ver.URLCompare() + "/AssetBundles/" + bundle_name;
//                         ThreadHTTP task = new ThreadHTTP(bundle_name, Application.persistentDataPath + "/AssetBundles", bundle_url, bundle_abs.size, bundle_abs.fmd5);
//                         _BundleDownloader.AddTask(task);
//                     }
//                 }

//                 //删除已经无用的bundle_path
//                 foreach (var bundle_abs in _Abastract.bundle_records[FileState.Delete])
//                 {
//                     var bundle_name = bundle_abs.key;   //Bundle的名称
//                     var bundle_path = Application.persistentDataPath + "/AssetBundles/" + bundle_name;
//                     if (File.Exists(bundle_path) == true)
//                     {
//                         System.IO.File.Delete(bundle_path);
//                     }
//                 }

//                 if (_BundleDownloader.IsEmpty() == false)
//                 {
//                     //加入下载AssetBundles对应的Menifest
//                     var manifest_name = "AssetBundles";
//                     var manifest_url = URLHead + _ver.URLCompare() + "/AssetBundles/" + manifest_name;
//                     ThreadHTTP manifest_task = new ThreadHTTP(manifest_name, Application.persistentDataPath + "/AssetBundles", manifest_url, 0.1f, string.Empty);
//                     _BundleDownloader.AddTask(manifest_task);

//                     var manifest_name_t = "AssetBundles.manifest";
//                     var manifest_url_t = URLHead + _ver.URLCompare() + "/AssetBundles/" + manifest_name_t;
//                     ThreadHTTP manifest_task_t = new ThreadHTTP(manifest_name_t, Application.persistentDataPath + "/AssetBundles", manifest_url_t, 0.1f, string.Empty);
//                     _BundleDownloader.AddTask(manifest_task_t);

//                     _BundleDownloader.Execute();

//                     //当下载还未执行完
//                     while (_BundleDownloader.Check() == false)
//                     {
//                         //Debug.Log("下载1 " + _BundleDownloader.Progress + " " + _BundleDownloader.Total);
//                         _LauncherUI.SetSizeInfo(_BundleDownloader.Progress, _BundleDownloader.Total);
//                         _LauncherUI.SetProgress(_BundleDownloader.Progress / _BundleDownloader.Total);
//                         yield return null;
//                     }

//                     var mb3 = string.Format("{0:N2}", _BundleDownloader.CountProgress() * 100);
//                     var mb4 = string.Format("{0:N2}", _BundleDownloader.CountProgress() * 100);
//                     _LauncherUI.SetSizeInfo(_BundleDownloader.Progress, _BundleDownloader.Total);
//                     //Debug.Log("下载2 " + _BundleDownloader.Progress + " " + _BundleDownloader.Total);
//                     _LauncherUI.SetProgress(_BundleDownloader.CountProgress());
//                 }

//                 //---> 更新BundleCRC <----//
//                 FileStream bundle_stream = File.Open(Application.persistentDataPath + "/BundleCRC.txt", FileMode.Create, FileAccess.Write);
//                 byte[] bundle_content = Encoding.UTF8.GetBytes(remote_bundle_abstract.text);
//                 bundle_stream.Write(bundle_content, 0, bundle_content.Length);
//                 bundle_stream.Flush();
//                 bundle_stream.Close();

//                 HTTPRequest.SendFootPrint(8003, "热更AB资源完成", 3);

//                 //------------------------------ 更新Bundle END ------------------------------

//                 //----------------------------------- 更新Lua --------------------------------
//                 if (_Abastract.file_records[FileState.Replace].Count != 0 || _Abastract.file_records[FileState.Add].Count != 0)
//                 {
//                     foreach (var file_abs in _Abastract.file_records[FileState.Replace])
//                     {
//                         var file_name = file_abs.key;
//                         var file_url = URLHead + _ver.URLCompare() + "/lua" + file_name;
//                         ThreadHTTP task = new ThreadHTTP(file_name, LuaFramework.Util.DataPath, file_url, 1, file_abs.md5);
//                         _LuaFileDownloader.AddTask(task);
//                     }

//                     foreach (var file_abs in _Abastract.file_records[FileState.Add])
//                     {
//                         var file_name = file_abs.key;   //Bundle的名称
//                         var file_url = URLHead + _ver.URLCompare() + "/lua" + file_name;
//                         ThreadHTTP task = new ThreadHTTP(file_name, LuaFramework.Util.DataPath, file_url, 1, file_abs.md5);
//                         _LuaFileDownloader.AddTask(task);
//                     }

//                     _LuaFileDownloader.Execute();

//                     while (_LuaFileDownloader.Check() == false)
//                     {
//                         _LauncherUI.SetInfo(string.Format("下载脚本中 .. " + _LuaFileDownloader.Progress + "/" + _LuaFileDownloader.Total));
//                         _LauncherUI.SetProgress(_LuaFileDownloader.Progress / _LuaFileDownloader.Total);
//                         yield return null;
//                     }

//                     var mb3 = string.Format("{0:N2}", Convert.ToDecimal(_BundleDownloader.Progress / 1000).ToString());
//                     var mb4 = string.Format("{0:N2}", Convert.ToDecimal(_BundleDownloader.Total / 1000).ToString());
//                     _LauncherUI.SetInfo(string.Format("下载脚本中 .. " + _LuaFileDownloader.Progress + "/" + _LuaFileDownloader.Total));
//                     _LauncherUI.SetProgress(_LuaFileDownloader.Progress / _LuaFileDownloader.Total);
//                 }

//                 _LuaFileDownloader._Progress = 0;
//                 _LuaFileDownloader._Total = 0;

//                 _BundleDownloader._Progress = 0;
//                 _BundleDownloader._Total = 0;

//                 _Abastract.file_records[FileState.Add].Clear();
//                 _Abastract.file_records[FileState.Delete].Clear();
//                 _Abastract.file_records[FileState.Replace].Clear();

//                 //设置Bugly版本

//                 _Abastract.bundle_records[FileState.Add].Clear();
//                 _Abastract.bundle_records[FileState.Delete].Clear();
//                 _Abastract.bundle_records[FileState.Replace].Clear();

//                 //_LauncherUI.ShowRetry(true);
//                 //NeedRetry = true;

//                 //---> 更新Files.txt <----//
//                 //yield return GameFacade.Instance.BundleManager.LoadSearcher();

//                 FileStream file_stream = File.Open(LuaFramework.Util.DataPath + "lua/files.txt", FileMode.Create, FileAccess.Write);
//                 byte[] file_content = Encoding.UTF8.GetBytes(remote_lua_abstract.text);
//                 file_stream.Write(file_content, 0, file_content.Length);
//                 file_stream.Flush();
//                 file_stream.Close();

//                 //更新下Remote_Matcher_Abstract
//                 Content remote_matcher_abstract = new Content();
//                 string remote_matcher_abs_path = URLHead + _ver.URLCompare() + "/PathMatcher.txt?t=" + FileUtility.GetCurrentTimeStamp();
//                 yield return GetRemoteFile(remote_matcher_abs_path, remote_matcher_abstract);
//                 FileStream matcher_stream = File.Open(Application.persistentDataPath + "/PathMatcher.txt", FileMode.Create, FileAccess.Write);
//                 byte[] matcher_content = Encoding.UTF8.GetBytes(remote_matcher_abstract.text);
//                 matcher_stream.Write(matcher_content, 0, matcher_content.Length);
//                 matcher_stream.Flush();
//                 matcher_stream.Close();

//                 // ------------------------------ 更新Files END ------------------------------

//                 yield return null;
//                 this.Version.UpdateVersion();
//                 _LauncherUI.SetVersion(this.Version.Current());

//                 yield return GameFacade.Instance.BundleManager.LoadSearcher();

//                 //初始化资源
//                 GameFacade.Instance.BundleManager.Init();

//                 //初始化Lua框架
//                 GameFacade.Instance.LuaManager.InitStart();
//                 Dispose();

//                 HTTPRequest.SendFootPrint(8004, "热更脚本完成, 进入游戏", 4);
//             }
//         }
       
//         //######################################################################################

//         private void Update()
//         {
//             if(NeedRetry == true)
//             {
//                 GameFacade.Instance.LaunchManager.Retry();
//                 NeedRetry = false;
//             }
//         }

//         private void OnApplicationQuit()
//         {
//             _LuaFileDownloader.Clear();
//             _BundleDownloader.Clear();
//         }

//         private string GetAlternativePath(string file_name)
//         {
//             var p_path = BundleManager.GetPersistentPath() + "/" + file_name;
//             Debug.Log("p_path " + p_path);
//             if (System.IO.File.Exists(p_path) == true)
//             {
// #if UNITY_IOS || UNITY_IPHONE
//                 return "file://" + p_path;
// #elif UNITY_ANDROID
//                 return "file://" + p_path;
// #else
//                 return "file:///" + p_path;
// #endif
//             }

// #if UNITY_IOS || UNITY_IPHONE
//             return "file://" + BundleManager.GetStreamingPath() + file_name;
// #elif UNITY_EDITOR
//             return "file:///" +  BundleManager.GetStreamingPath() + file_name;
// #else
//             return BundleManager.GetStreamingPath() + file_name;  
// #endif
//         }

//         private Dictionary<string, FileMD5> _OrganizeMD5(string raw)
//         {
//             Dictionary<string, FileMD5> origin = new Dictionary<string, FileMD5>();
//             raw = raw.Replace("\r", "");
//             string[] sections = raw.Split('\n');
//             for (int i = 0; i < sections.Length; i++)
//             {
//                 var line = sections[i];
//                 if (string.IsNullOrEmpty(line) == false)
//                 {
//                     var crc_pair = line.Split('|');
//                     if(crc_pair.Length == 2)
//                     {
//                         origin.Add(crc_pair[0], new FileMD5(crc_pair[0], crc_pair[1], FileState.Stay));
//                     }
//                 }

//             }
//             return origin;
//         }

//         private Dictionary<string, BundleCRC> _OrganizeCRC(string raw)
//         {
//             Dictionary<string, BundleCRC> origin = new Dictionary<string, BundleCRC>();
//             raw = raw.Replace("\r", "");
//             string[] sections = raw.Split('\n');
//             for (int i = 0; i < sections.Length; i++)
//             {
//                 var line = sections[i];
//                 if (string.IsNullOrEmpty(line) == false)
//                 {
//                     var crc_pair = line.Split('|');
//                     //Debug.Log("CRC_PAIR " + line);
//                     origin.Add(crc_pair[0], new BundleCRC(crc_pair[0], crc_pair[1], crc_pair[3], crc_pair[2], FileState.Stay));
//                 }
//             }
//             return origin;
//         }

//         private void BundleCompare(string local, string remote)
//         {
//             Debug.LogError("BundleCompare " + local.Length + " " + remote.Length);
//             _Abastract.local_bundle_abs     = _OrganizeCRC(local);
//             _Abastract.remote_bundle_abs    = _OrganizeCRC(remote);

//             var remote_list = _Abastract.remote_bundle_abs;
//             var local_list  = _Abastract.local_bundle_abs;

//             //--------------------------- 查询 -----------------------//
//             foreach (var pair in remote_list)
//             {
//                 string key = pair.Key;
//                 if (local_list.ContainsKey(key) == true)
//                 {
//                     if(local_list[key].crc != remote_list[key].crc) //两者CRC不等, 则标记替换
//                     {
//                         local_list[key].state = FileState.Replace;
//                         local_list[key].fmd5 = remote_list[key].fmd5;
//                         _Abastract.bundle_records[FileState.Replace].Add(local_list[key]);
//                         Debug.Log("ADD ==> " + local_list[key]);
//                     }
//                 }
//                 else
//                 {
//                     remote_list[key].state = FileState.Add; //如果没有, 标记添加
//                     _Abastract.bundle_records[FileState.Add].Add(remote_list[key]);
//                     Debug.Log("ADD ==> " + remote_list[key]);

//                 }
//             }

//             foreach (var pair in local_list)
//             {
//                 string key = pair.Key;
//                 if (remote_list.ContainsKey(key) == false)
//                 {
//                     local_list[key].state = FileState.Delete;       //如果这个Bundle已经没有了, 标记删除
//                     _Abastract.bundle_records[FileState.Delete].Add(local_list[key]);
//                 }
//             }
//         }

//         private void LuaFileCompare(string local, string remote)
//         {
//             Debug.LogError("LuaCompare " + local.Length + " " + remote.Length);
//             _Abastract.local_file_abs       = _OrganizeMD5(local);
//             _Abastract.remote_file_abs      = _OrganizeMD5(remote);

//             var remote_list = _Abastract.remote_file_abs;
//             var local_list = _Abastract.local_file_abs;

//             //--------------------------- 查询 -----------------------//
//             foreach (var pair in remote_list)
//             {
//                 string key = pair.Key;
//                 if (local_list.ContainsKey(key) == true)
//                 {
//                     if (local_list[key].md5 != remote_list[key].md5) //两者CRC不等, 则标记替换
//                     {
//                         local_list[key].state = FileState.Replace;
//                         local_list[key].md5 = remote_list[key].md5;
// ;                        _Abastract.file_records[FileState.Replace].Add(local_list[key]);
//                     }
//                 }
//                 else
//                 {
//                     remote_list[key].state = FileState.Add; //如果没有, 标记添加
//                     _Abastract.file_records[FileState.Add].Add(remote_list[key]);
//                 }
//             }

//             foreach (var pair in local_list)
//             {
//                 string key = pair.Key;
//                 if (remote_list.ContainsKey(key) == false)
//                 {
//                     local_list[key].state = FileState.Delete;       //如果这个Bundle已经没有了, 标记删除
//                     _Abastract.file_records[FileState.Delete].Add(local_list[key]);
//                 }
//             }
//         }

//         private void Dispose()
//         {
//             GameObject.Destroy(_LauncherUI.gameObject);
//         }
    }
}

