using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.Net;
using System.IO;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

internal class WebReqState
{
    public byte[] Buffer;

    public FileStream fs;

    public const int BufferSize = 1024;

    public Stream OrginalStream;

    public HttpWebResponse WebResponse;

    public WebReqState(string path)
    {
        Buffer = new byte[1024];
        fs = new FileStream(path, FileMode.Create);
    }

}

public class ThreadHTTP
{
    private bool fake = false;
    public const float STOCK_TIME = 10f;
    public string destination = null;
    public string tag;
    public string url;
    public string origin_url;
    public string md5 = string.Empty;
    public float  Weight = 0.1f;
    public int trial_time = 3;
    public float StockTime = 0;
    private bool _Responsed = false;
    Stream responseStream = null;
    WebReqState responseState = null;

    public enum State
    {
        NotInit     = 0,
        Running     = 1,
        Finished    = 2,
        Error       = 3,
    }
    private State state = State.NotInit;

    private HttpWebRequest httpRequest = null;

    public ThreadHTTP(string tag, string destination_folder, string url, float weight, string md5)
    {
        this.destination    = destination_folder;
        this.tag            = tag;
        this.origin_url     = url;
        this.url            = url + "?t=" + NoobTD.FileUtility.GetCurrentTimeStamp();
        this.Weight         = weight;
        this.md5            = md5;
        
    }

    public State GetState()
    {
        return state;
    }

    public bool HasResponse()
    {
        var flag = _Responsed;
        _Responsed = false;
        return flag;
    }

    public bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
    {
        return true; // 总是接受    
    }

    public void AsyDownLoad()
    {
        trial_time = 0;
        _Responsed = false;
        StockTime = 0;
        this.state = State.Running;

        if (this.url.StartsWith("https", StringComparison.OrdinalIgnoreCase))
        {
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
            httpRequest = WebRequest.Create(url) as HttpWebRequest;
            httpRequest.ProtocolVersion = HttpVersion.Version11;
        }
        else
        {
            httpRequest = (System.Net.HttpWebRequest)System.Net.HttpWebRequest.Create(url);
        }
        httpRequest.BeginGetResponse(new AsyncCallback(ResponseCallback), httpRequest);
        _Responsed = false;
    }

    void ResponseCallback(IAsyncResult ar)
    {
        try
        {
            HttpWebRequest req = ar.AsyncState as HttpWebRequest;
            if (req == null) return;
            HttpWebResponse response = req.EndGetResponse(ar) as HttpWebResponse;
            if (response.StatusCode != HttpStatusCode.OK)
            {
                WebReqState rs = ar.AsyncState as WebReqState;
                rs.fs.Close();
                rs.OrginalStream.Close();
                rs.WebResponse.Close();
                req.Abort();
                this.state = State.Error;
                return;
            }

            Debug.Log(" ReadDataCallback BEGIN  " + this.url);


            var path = System.IO.Path.GetDirectoryName(destination + "/" + tag);
            if(Directory.Exists(path) == false)
            {
                Directory.CreateDirectory(path);
            }

            responseState = new WebReqState(destination + "/" + tag);
            responseState.WebResponse = response;
            responseStream = response.GetResponseStream();

            responseState.OrginalStream = responseStream;

            responseStream.BeginRead(responseState.Buffer, 0, WebReqState.BufferSize, new AsyncCallback(ReadDataCallback), responseState);
        }
        catch (WebException webEx)
        {
            WebExceptionStatus status = webEx.Status;
            WebResponse responseEx = webEx.Response;
            if(responseStream!= null)
            {
                responseStream.Close();
            }

            WebReqState rs = ar.AsyncState as WebReqState;
            rs.fs.Close();
            rs.OrginalStream.Close();
            rs.WebResponse.Close();

            Debug.LogError(webEx.ToString() + " " + this.url);
            this.state = State.Error;
        }
        catch (Exception ex)
        {
            if (responseStream != null)
            {
                responseStream.Close();
            }

            WebReqState rs = ar.AsyncState as WebReqState;
            rs.fs.Close();
            rs.OrginalStream.Close();
            rs.WebResponse.Close();


            Debug.LogError(ex.ToString() + " " + this.url);
            this.state = State.Error;
        }
    }

    public void Stop()
    {
        if(httpRequest != null)
        {
            if(responseState != null)
            {
                responseState.fs.Close();
                responseState.OrginalStream.Close();
                responseState.WebResponse.Close();
            }
            httpRequest.Abort();
        }
    }

    void ReadDataCallback(IAsyncResult ar)
    {
        try
        {
            WebReqState rs = ar.AsyncState as WebReqState;
            int read = rs.OrginalStream.EndRead(ar);

            if (read > 0)
            {
                rs.fs.Write(rs.Buffer, 0, read);
                rs.fs.Flush();
                rs.OrginalStream.BeginRead(rs.Buffer, 0, WebReqState.BufferSize, new AsyncCallback(ReadDataCallback), rs);
            }
            else
            {
                rs.fs.Close();
                rs.OrginalStream.Close();
                rs.WebResponse.Close();
                this.httpRequest.Abort();

                //校验MD5
                if (string.IsNullOrEmpty(this.md5))
                {
                    Debug.Log(" ReadDataCallback FINISH 1 " + this.url);
                    this.state = State.Finished;
                }
                else
                {
                    string path = destination + "/" + tag;
                    Debug.Log("ReadDataCallback PATH " + path);
                    string md5 = NoobTD.FileUtility.GetFileMD5(path);
                    if (this.md5.Equals(md5))
                    {
                        Debug.Log(" ReadDataCallback FINISH 2 " + this.url + " MD5 " + md5 + " " + this.md5 + " " + path);
                        this.state = State.Finished;
                    }
                    else
                    {
                        trial_time--;
                        if (trial_time == 0) //下载3次校验都没通过, 可能是md5出了一些问题
                        {
                            Debug.Log(" ReadDataCallback FINISHED 3 " + this.url + " MD5 " + md5 + " " + this.md5 + " " + path);
                            this.state = State.Finished;
                        }
                        else
                        {
                            Debug.Log(" ReadDataCallback ERROR 4 " + this.url + " MD5 " + md5 + " " + this.md5 + " " + path);
                            this.state = State.Error;

                        }
                    }
                }
            }
            _Responsed = true;
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.ToString() + " " + this.url);
            this.state = State.Error;
            this.httpRequest.Abort();
        }
    }
}
