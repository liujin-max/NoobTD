using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Networking;
using System.Text;

namespace NoobTD
{
    public class WWWRequest
    {
        public enum State:int
        {
            NOTINIT,
            ACTING,
            ERROR,
            OK
        }


        public string URL = null;
        public State WWWState = WWWRequest.State.NOTINIT;
        public int TrailTime = 10;   //10次机会
        private WWW www = null;

        private string _Content = "";
        public string Content
        {
            get { return _Content;  }
        }

        public WWWRequest(string url)
        {
            URL = url;
            www = new WWW(url);
        }

        public void Dispose()
        {
            if(www != null)
            {
                www.Dispose();
            }
        }


        public IEnumerator Fetch()
        {
            yield return www;
            if (www.error != null)
            {
                if (TrailTime == 0)
                {
                    WWWState = State.ERROR;
                    _Content = www.error;
                }
                else
                {
                    www.Dispose();
                    www = new WWW(this.URL);
                    TrailTime--;
                }
            }

            if (www.isDone == true)
            {
                _Content = www.text;
                WWWState = State.OK;
            }
        }
    }
}

