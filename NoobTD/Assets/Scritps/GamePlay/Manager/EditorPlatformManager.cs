using UnityEngine;
using System.Collections;

namespace NoobTD
{
    public class EditorPlatformManager : ISDKApi
    {
        public EditorPlatformManager()
        {

        }

        public void OpenToolBar(bool flag)
        {

        }

        public void OnAccountLogin()
        {
            EventManager.instance.SendEvent("SHOW_DEFAULT_LOGIN", null);
        }

        public void OnAccountLogout()
        {
            EventManager.instance.SendEvent("ACCOUNT_SDKLOGOUT", null);
        }

        public void OnGameExit()
        {
            EventManager.instance.SendEvent("GAME_EXIT", null);
        }

        public void OnGamePay(string produce_id, string apple_id, string product_name, double amount, int count, string OrderID, string extra_params, double price, string product_des,
            string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        {
            EventManager.instance.SendEvent("ACCOUNT_SDKRECHARGEEND", null);
            EventManager.instance.SendEvent("U2M_PAYMENT_RECHARGE", null, produce_id);
        }

        public string GetDeviceUUID()
        {
            return SystemInfo.deviceModel;
        }

        //上传账号数据
        public void OnCreateRole(string roleID, string roleName, string serverID, string serverName, string createtime)
        {

        }

        public void OnEnterGame(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        {

        }

        public void OnUpdateRole(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        { }

        public void GetRealnameInfo()
        {

        }

        public void EnterRealName()
        {

        }

    }

}