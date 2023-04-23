using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Networking;
using System.Text;
using System.Net;
using System.IO;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace NoobTD
{
    public class HTTPRequest
    {
        private LuaFunction Callback = null;
        private int ReconnectTimes = -1;
        private string IP;
        private int port;
        private string url;
        private string content;
        private bool post;
        private string get_full_url;

        public static void SendFootPrint(int ID, string info, int step)
        {
            //StringBuilder json_data = new StringBuilder("{");
            //json_data.Append("\"deviceinfo\":\"" + FileUtility.GetDviceInfo() + "\",");
            //json_data.Append("\"deviceid\":\"" + FileUtility.GetDeviceID() + "\",");
            //json_data.Append("\"version\":\"" + "-1" + "\",");
            //json_data.Append("\"sn\":" + 0 + ",");
            //json_data.Append("\"type\":" + ID + ",");
            //json_data.Append("\"userid\":-1,");
            //json_data.Append("\"context\": {");
            //json_data.Append("\"timestamp\":\"" + FileUtility.GetCurrentTimeStamp() + "\",");
            //json_data.Append("\"typeinfo\":\"" + info + "\",");
            //json_data.Append("\"step\":" + step + "");
            //json_data.Append("}");
            //json_data.Append("}");

            //// Debug.Log("JSON_DATA " + json_data);
            //HTTPRequest req = new HTTPRequest(GameFacade.Instance.NetManager.IP, NetManager.PORT, "Public/BuriedPoint", json_data.ToString() ,true, -1, null);
        }

        public HTTPRequest(string IP, int port, string url, string content, bool post, int reconnect_times, LuaFunction callback)
        {
            Callback       = callback;
            ReconnectTimes = reconnect_times;
            this.IP        = IP;
            this.port      = port;
            this.url       = url;
            this.content   = content;
            this.post      = post;


            if (post == false)
            {
                string vist_mode = GameFacade.Instance.ConstManager.PTR == true ? "https://" : "http://";
                string full_url = vist_mode + IP + "/" + url + "?" + content;
                Debug.Log("full_url " + full_url);
                get_full_url = full_url;

                GameFacade.Instance.NetManager.HTTPProgress(this.SendGetMessage(full_url, reconnect_times));
            }
            else
            {
                string full_url = "http://" + IP + "/" + url;
                Debug.Log("full_url " + full_url);
                get_full_url = full_url;

                GameFacade.Instance.NetManager.HTTPProgress(this.SendPostMessage(full_url, content, reconnect_times));
            }

        }

        public void Resend()
        {
            this.ReconnectTimes --;
            if (post == false)
            {
                string full_url = this.get_full_url;
                GameFacade.Instance.NetManager.HTTPProgress(this.SendGetMessage(full_url, this.ReconnectTimes));
            }
            else
            {
                string full_url = "http://" + IP + "/" + url;
                GameFacade.Instance.NetManager.HTTPProgress(this.SendPostMessage(full_url, content, this.ReconnectTimes));
            }
        }

        //废弃POST
        public IEnumerator SendPostMessage(string url, string data, int reconnect_times)
        {
            yield return null;
            ////Debug.Log("SendPostMessage " + url);
            //UnityWebRequest uwr = UnityWebRequest.Post(url, data);
            //uwr.useHttpContinue = false;
            ////uwr.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
            //uwr.SetRequestHeader("Cache-Control", "max-age=0, no-cache, no-store");
            //uwr.SetRequestHeader("Pragma", "no-cache");

            //uwr.chunkedTransfer = false;
            //yield return uwr.SendWebRequest();

            //if (uwr.isNetworkError)
            //{
            //    if (this.ReconnectTimes > 0)
            //    {
            //        //UnityEngine.Debug.LogError("Reconnect Avaiable: " + this.ReconnectTimes);
            //        uwr.Dispose();
            //        this.Resend();
            //        yield break;
            //    }

            //    UnityEngine.Debug.LogError("HTTP错误: " + uwr.error + " " + url + " " + uwr.responseCode);
            //    string error = "{ \"Error\": \"" + uwr.error + "\", \"Code\" :" + uwr.responseCode + "}";
            //    if(Callback != null)
            //    {
            //        Callback.Call<string>(error);
            //        Callback.Dispose();
            //    }
            //}
            //else
            //{
            //    //UnityEngine.Debug.LogError("HTTP回包： " + uwr.downloadHandler.text + " " + url + " " + data);
            //    if (Callback != null)
            //    {
            //        Callback.Call<string>(uwr.downloadHandler.text);
            //        Callback.Dispose();
            //    }
            //}
            //uwr.Dispose();
        }

        public bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
        {
            if(Application.platform == RuntimePlatform.Android)
            {
                bool isOk = true;
                // If there are errors in the certificate chain,
                // look at each error to determine the cause.
                if (errors != SslPolicyErrors.None)
                {
                    for (int i = 0; i < chain.ChainStatus.Length; i++)
                    {
                        if (chain.ChainStatus[i].Status == X509ChainStatusFlags.RevocationStatusUnknown)
                        {
                            continue;
                        }
                        chain.ChainPolicy.RevocationFlag = X509RevocationFlag.EntireChain;
                        chain.ChainPolicy.RevocationMode = X509RevocationMode.Online;
                        chain.ChainPolicy.UrlRetrievalTimeout = new TimeSpan(0, 1, 0);
                        chain.ChainPolicy.VerificationFlags = X509VerificationFlags.AllFlags;
                        bool chainIsValid = chain.Build((X509Certificate2)certificate);
                        if (!chainIsValid)
                        {
                            isOk = false;
                            break;
                        }
                    }
                }
                return isOk;
            }
            else
            {
                return true; // 总是接受    
            }
        }

        public IEnumerator SendGetMessage(string url, int reconnect_times)
        {
            HttpWebRequest uwr = null;
            HttpWebResponse wr = null;
            try
            {
                if (url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
                {
                    ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
                    uwr = WebRequest.Create(url) as HttpWebRequest;
                    uwr.ProtocolVersion = HttpVersion.Version11;
                }
                else
                {
                    uwr = (System.Net.HttpWebRequest)System.Net.HttpWebRequest.Create(url);
                }
                uwr.Method = "GET";

                using (wr = uwr.GetResponse() as HttpWebResponse)
                {
                    Stream responseStream = wr.GetResponseStream();
                    StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
                    string result_text = streamReader.ReadToEnd();
                    if (Callback != null)
                    {
                        Callback.Call<string>(result_text);
                    }
                }
            }
            catch (WebException e)
            {
                if (this.ReconnectTimes > 0)
                {
                    Debug.LogError("WebException " + url + " " + e.ToString()); 
                    this.Resend();
                    yield break;
                }

                string error = "{ \"Error\": \"" + e.ToString() + "\", \"Code\" :" + wr.StatusCode + "}";


                if (Callback != null)
                {
                    Callback.Call<string>(error);
                    Callback.Dispose();
                }
            }

            yield return null;

            //UnityWebRequest uwr = UnityWebRequest.Get(url);
            //uwr.useHttpContinue = false;
            ////uwr.SetRequestHeader("Content-Type", "application/json;charset=utf-8");
            //uwr.SetRequestHeader("Cache-Control", "max-age=0, no-cache, no-store");
            //uwr.SetRequestHeader("Pragma", "no-cache");

            //uwr.chunkedTransfer = false;
            //yield return uwr.SendWebRequest();

            //if (uwr.isNetworkError)
            //{
            //    if (this.ReconnectTimes > 0)
            //    {
            //        uwr.Dispose();
            //        this.Resend();
            //        yield break;
            //    }

            //    UnityEngine.Debug.LogError("HTTP错误: " + uwr.error + " " + url + " " + uwr.responseCode);
            //    string error = "{ \"Error\": \"" + uwr.error + "\", \"Code\" :" + uwr.responseCode + "}";
            //    if (Callback != null)
            //    {
            //        Callback.Call<string>(error);
            //        Callback.Dispose();
            //    }
            //}
            //else
            //{
            //    if (Callback != null)
            //    {
            //        Callback.Call<string>(uwr.downloadHandler.text);
            //        Callback.Dispose();
            //    }
            //}
            //uwr.Dispose();
        }
    }
}

