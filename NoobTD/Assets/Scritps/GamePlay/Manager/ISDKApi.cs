using System;


namespace NoobTD
{
    public interface ISDKApi
    {
        //账号登录
        void OnAccountLogin();
        //账号登出
        void OnAccountLogout();

        //支付
        void OnGamePay(string produce_id, string apple_id, string product_name, double amount, int count, string OrderID, string extra_params, double price, string product_des,
            string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime);

        //退出游戏
        void OnGameExit();

        //上传账号数据
        void OnCreateRole(string roleID, string roleName, string serverID, string serverName , string createtime);
        void OnEnterGame(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime);
        void OnUpdateRole(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime);

        //获取设备id
        string GetDeviceUUID();

        //开关悬浮窗
        void OpenToolBar(bool flag);

        //获取实名制信息
        void GetRealnameInfo();
        //进入实名制
        void EnterRealName();
    }
}

