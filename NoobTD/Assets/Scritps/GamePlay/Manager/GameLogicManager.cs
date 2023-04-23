using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace NoobTD
{
    public class GameLogicManager : MonoBehaviour, IManager
    {
        private float _initialExtractProgress = 0.0f;
        public float InitialExtractProgress
        {
            get { return _initialExtractProgress; }
        }

        private void Awake()
        {
            Application.targetFrameRate = 30;
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Debug.Log("GameLogicManager Start");
        }

        public void Run()
        {
            //CheckExtractResource();
            StartCoroutine(OnInitialExtractLuaFile());
            Debug.Log("GameLogicManager Start");
        }

        public void CheckExtractResource()
        {
            bool isExists = Directory.Exists(Util.DataPath) &&
            Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
//#if UNITY_EDITOR
            if (isExists || AppConst.DebugMode)
            {
                GameFacade.Instance.LuaManager.InitStart();
                //StartCoroutine(OnUpdateResource());
                return;   //文件已经解压过了，自己可添加检查文件列表逻辑
            }
//#endif
            //OnExtractResource();    //启动释放协成 
        }

        public IEnumerator OnRecoverLuaFile()
        {
            string persistentPath = Util.DataPath + "lua/";                      //数据目录
            string indexFilePath = persistentPath + "files.txt";

            string resPath = Util.AppContentPath();     //游戏包资源目录

            if (Directory.Exists(persistentPath)) Directory.Delete(persistentPath, true);
            Directory.CreateDirectory(persistentPath);

            string compress_infile = resPath + "lua_pack.zip";
            string release_outpath = persistentPath;

            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(compress_infile);
                yield return www;

                if (www.isDone)
                {
                    compress_infile = release_outpath + "lua_pack.zip";
                    string dir = Path.GetDirectoryName(compress_infile);
                    if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                    File.WriteAllBytes(compress_infile, www.bytes);
                    //Debug.LogError("COMPRESS_INFILE " + compress_infile);
                    //Debug.LogError("RELEASE_OUTPATH " + release_outpath);
                    NoobTD.ZipUtility.UnZipFile(compress_infile, release_outpath, release_outpath);
                }

                //--将files.txt也搞过来
                WWW abstract_www = new WWW(resPath + "files.txt");
                yield return abstract_www;

                if (abstract_www.isDone)
                {
                    var output_path = release_outpath + "files.txt";
                    File.WriteAllBytes(output_path, abstract_www.bytes);
                }
                yield return 0;
            }
            else
            {
                var origin = compress_infile;
                compress_infile = release_outpath + "lua_pack.zip";
                string dir = Path.GetDirectoryName(compress_infile);
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
                File.Copy(origin, compress_infile, true);
                NoobTD.ZipUtility.UnZipFile(compress_infile, release_outpath, release_outpath);

                var abstract_file_path = resPath + "files.txt";
                var output_path = release_outpath + "files.txt";
                File.Copy(abstract_file_path, output_path, true);
            }

            yield return new WaitForSeconds(0.1f);
        }

        public IEnumerator OnInitialExtractLuaFile()
        {
#if !UNITY_EDITOR
            string persistentPath = Util.DataPath + "lua/";                      //数据目录
            string indexFilePath  = persistentPath + "files.txt";

            //查看是否已经初始化过lua文件, 即为是否已经从StreamingAssets里, 将这些文件Copy过去了
            bool isExists = Directory.Exists(persistentPath) && File.Exists(indexFilePath);
     
            // if(isExists == true)
            // {
            //     yield break;
            // }

            this._initialExtractProgress = 0.5f;
            yield return OnRecoverLuaFile();
            this._initialExtractProgress = 1f;
            //message = string.Empty;
            //释放完成，开始启动更新资源
            //StartCoroutine(OnUpdateResource());
#endif

            yield return null;
            // yield return new WaitForSeconds(2.0f);
            //Debug.LogError("INTO GameFacade.Instance.LuaManager.InitStart()");
            GameFacade.Instance.LuaManager.InitStart();
        }
    }
}

