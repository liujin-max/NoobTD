using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UnityEngine;

namespace NoobTD
{
    public class FileUtility
    {
        public static void CreateDirectory(string dir_path)
        {
            Directory.CreateDirectory(dir_path);
        }

        public static bool IsDirectoryExist(string dir_path)
        {
            return Directory.Exists(dir_path);
        }

        public static void DeleteFile(string dir_path)
        {
            //Directory.Delete(dir_path,true);
            File.Delete(dir_path);
        }

        public static bool IsFileExist(string path)
        {
            return File.Exists(path);
        }

        public static void CopyWord(string str)
        {
            GUIUtility.systemCopyBuffer = str;
        }

        public static string GetJsonFiles(string dir_path)
        {
            string[] files = Directory.GetFiles(dir_path,"*.json");
            string file = String.Join(" ", files);

            return file;
        }

        public static string StreamingPath()
        {
            string path = string.Empty;
            switch (Application.platform)
            {
                case RuntimePlatform.Android:
                    path = "jar:file://" + Application.dataPath + "!/assets/";
                    break;
                case RuntimePlatform.IPhonePlayer:
                    path = Application.dataPath + "/Raw/";
                    break;
                default:
                    path = Application.dataPath + "/StreamingAssets/";
                    break;
            }
            return path;
        }

        public static void SetFileContent(string file_path, string content)
        {
            StreamWriter sw = new StreamWriter(file_path, false);
            sw.Write(content);
            sw.Close();
        }

        public static string GetFileContent(string file_path)
        {
            StreamReader sr = new StreamReader(file_path);
            string ret = sr.ReadToEnd();
            sr.Close();
            return ret;
        }

        public static string GetDeviceID()
        {
            return SystemInfo.deviceUniqueIdentifier;
        }

        public static string GetDviceInfo()
        {
            return SystemInfo.deviceModel;
        }

        public static long GetCurrentTimeStamp()
        {
            TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return Convert.ToInt64(ts.TotalMilliseconds);
        }

        public static void SetPlayerPrefsValue(string key, int value)
        {
            PlayerPrefs.SetInt(key, value);
        }

        public static int GetPlayerPrefsValue(string key)
        {
            return PlayerPrefs.GetInt(key);
        }

        public static string BuildFileMd5(string filePath)
        {
            string fileMd5 = string.Empty;
            try
            {
                using (FileStream fs = File.OpenRead(filePath))
                {
                    MD5 md5 = MD5.Create();
                    Byte[] fileMd5Bytes = md5.ComputeHash(fs); // Calculate the hash value of the FileStream object
                    fileMd5 = System.BitConverter.ToString(fileMd5Bytes).Replace("-", "").ToLower();
                    fs.Close();
                }
            }
            catch (System.Exception ex)
            {
                Debug.LogError(ex);
            }
            return fileMd5;
        }


        public static string GetFileMD5(string file_path)
        {
            try
            {
                FileStream fs = new FileStream(file_path, FileMode.Open);
                System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(fs);
                fs.Close();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < retVal.Length; i++)
                {
                    sb.Append(retVal[i].ToString("x2"));
                }
                return sb.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("md5file() fail, error:" + ex.Message);
            }
        }
    }
}

