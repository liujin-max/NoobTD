using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Networking;
using System.Text;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.IO;

namespace NoobTD
{
    public class HTTPLocalRequest
    {
        public delegate void ResponseDelegate(bool is_error, string text);
        private ResponseDelegate Callback = null;
        private int ReconnectTimes = -1;
        private string IP;
        private int port;
        private string url;
        private string content;
        private bool post;

        private bool finished = false;

        public HTTPLocalRequest(string url, string content, bool post, int reconnect_times, ResponseDelegate callback)
        {
            Callback       = callback;
            ReconnectTimes = reconnect_times;
            this.url       = url;
            this.content   = content;
            this.post      = post;


            if (post == false)
            {
                string full_url = url;

                GameFacade.Instance.NetManager.HTTPProgress(this.SendGetMessage(full_url, reconnect_times));
            }
            else
            {
                string full_url = url;

                GameFacade.Instance.NetManager.HTTPProgress(this.SendPostMessage(full_url, content, reconnect_times));
            }

        }

        public void Resend()
        {
            this.ReconnectTimes --;
            if (post == false)
            {
                string full_url = url;
                GameFacade.Instance.NetManager.HTTPProgress(this.SendGetMessage(full_url, this.ReconnectTimes));
            }
            else
            {
                string full_url = url;
                GameFacade.Instance.NetManager.HTTPProgress(this.SendPostMessage(full_url, content, this.ReconnectTimes));
            }
        }

        public bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
        {
            if (Application.platform == RuntimePlatform.Android)
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

        //POST类方法先废弃
        public IEnumerator SendPostMessage(string url, string data, int reconnect_times)
        {
            yield return null;
            //Debug.Log("SendPostMessage " + url);
            //UnityWebRequest uwr = UnityWebRequest.Post(url, data);
            //uwr.useHttpContinue = false;            
            //uwr.SetRequestHeader("Cache-Control", "max-age=0, no-cache, no-store");
            //uwr.SetRequestHeader("Pragma", "no-cache");

            //uwr.chunkedTransfer = false;
            //yield return uwr.SendWebRequest();

            //if (uwr.isNetworkError)
            //{
            //    UnityEngine.Debug.LogError(uwr.error + " " + url + " " + uwr.responseCode);
            //    if (this.ReconnectTimes > 0)
            //    {
            //        //UnityEngine.Debug.LogError("Reconnect Avaiable: " + this.ReconnectTimes);
            //        uwr.Dispose();
            //        this.Resend();
            //        yield break;
            //    }

            //    string error = "{ \"Error\": \"" + uwr.error + "\", \"Code\" :" + uwr.responseCode + "}";
            //    if(Callback != null)
            //    {
            //        Callback(false, error);
            //    }
            //}
            //else
            //{
            //    if (Callback != null)
            //    {
            //        Callback(true, uwr.downloadHandler.text);
            //    }
            //}
            //uwr.Dispose();
        }

        public IEnumerator SendGetMessage(string url, int reconnect_times)
        {
            HttpWebRequest uwr = null;
            try
            {
                if (this.url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
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

                using (WebResponse wr = uwr.GetResponse())
                {
                    Stream responseStream = wr.GetResponseStream();
                    StreamReader streamReader = new StreamReader(responseStream, Encoding.UTF8);
                    string result_text = streamReader.ReadToEnd();
                    if(Callback != null)
                    {
                        Callback(false, result_text);
                    }
                }
            }
            catch (WebException e)
            {
                if (this.ReconnectTimes > 0)
                {
                    this.Resend();
                    yield break;
                }

                if (Callback != null)
                {
                    Callback(true, e.ToString());
                }
            }

            yield return null;

                //uwr.useHttpContinue = false;
                //uwr.SetRequestHeader("Cache-Control", "max-age=0, no-cache, no-store");
                //uwr.SetRequestHeader("Pragma", "no-cache");
                //uwr.chunkedTransfer = false;
                //yield return uwr.SendWebRequest();

                //string result_text = uwr.downloadHandler.text;

                //if (uwr.isNetworkError)
                //{
                //    //UnityEngine.Debug.LogError(uwr.error + " " + url + " " + uwr.responseCode);
                //    if (this.ReconnectTimes > 0)
                //    {
                //        uwr.Dispose();
                //        this.Resend();
                //        yield break;
                //    }
                //    string error = "{ \"Error\": \"" + uwr.error + "\", \"Code\" :" + uwr.responseCode + "}";
                //    if (Callback != null)
                //    {
                //        Callback(true, error);
                //    }
                //}
                //else if(result_text.Contains("<Error>"))
                //{
                //    if (this.ReconnectTimes > 0)
                //    {
                //        uwr.Dispose();
                //        this.Resend();
                //        yield break;
                //    }
                //    if (Callback != null)
                //    {
                //        Callback(true, result_text);
                //    }
                //}
                //else if(string.IsNullOrEmpty(result_text))
                //{
                //    if (this.ReconnectTimes > 0)
                //    {
                //        uwr.Dispose();
                //        this.Resend();
                //        yield break;
                //    }
                //    if (Callback != null)
                //    {
                //        Callback(true, result_text);
                //    }
                //}
                //else
                //{
                //    Debug.LogError("LOCAL REQ " + url + " " + this.ReconnectTimes);

                //    if (Callback != null)
                //    {
                //        Callback(false, result_text);
                //    }
                //}
                //uwr.Dispose();
            }
    }
}

