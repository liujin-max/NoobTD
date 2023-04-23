using UnityEngine;
using System.Collections;


// using jjmassas;

namespace NoobTD
{
    public class IosPlatformNanager
    // public class IosPlatformNanager : ISDKApi
    {
        // public void OpenToolBar(bool flag)
        // {
        //     if (flag == true)
        //     {
        //         JJmassas.getInstance().showToolBar(ToolbarPlace.QUICK_SDK_TOOLBAR_BOT_LEFT);
        //     }
        //     else
        //     {
        //         JJmassas.getInstance().hideToolBar();
        //     }
        // }

        // //账号登录
        // public void OnAccountLogin()
        // {
        //     JJmassas.getInstance().login();
        // }


        // //账号登出
        // public void OnAccountLogout()
        // {
        //     JJmassas.getInstance().logout();
        // }

        // //退出游戏
        // public void OnGameExit()
        // {
        //     if (JJmassas.getInstance().isChannelHasExitDialog())
        //     {
        //         JJmassas.getInstance().exit();
        //     }
        //     else
        //     {
        //         EventManager.instance.SendEvent("GAME_EXIT", null);
        //     }
        // }

        // //支付
        // public void OnGamePay(string produce_id, string apple_id, string product_name, double amount, int count, string OrderID, string extra_params, double price, string product_des,
        //     string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        // {
        //     OrderInfo orderInfo = new OrderInfo();
        //     GameRoleInfo gameRoleInfo = new GameRoleInfo();


        //     orderInfo.goodsID = apple_id;
        //     orderInfo.goodsName = product_name;
        //     orderInfo.amount = amount;
        //     orderInfo.count = count;
        //     orderInfo.cpOrderID = OrderID;
        //     orderInfo.extrasParams = extra_params;
        //     orderInfo.price = price;  //
        //     orderInfo.quantifier = "个";  //
        //     orderInfo.goodsDesc = product_des;  //


        //     gameRoleInfo.gameRoleBalance = roleBalance;
        //     gameRoleInfo.gameRoleID = roleID;
        //     gameRoleInfo.gameRoleLevel = roleLevel;
        //     gameRoleInfo.gameRoleName = roleName;
        //     gameRoleInfo.partyName = "无";
        //     gameRoleInfo.serverID = serverID;
        //     gameRoleInfo.serverName = serverName;
        //     gameRoleInfo.vipLevel = "1";
        //     gameRoleInfo.roleCreateTime = createtime;


        //     JJmassas.getInstance().pay(orderInfo, gameRoleInfo);

        // }

        // public string GetDeviceUUID()
        // {
        //     return SystemInfo.deviceModel;
        // }


        // //--上传账号数据

        // //创建角色
        // public void OnCreateRole(string roleID, string roleName, string serverID, string serverName, string createtime)
        // {
        //     GameRoleInfo gameRoleInfo = new GameRoleInfo();

        //     gameRoleInfo.gameRoleBalance = "0";
        //     gameRoleInfo.gameRoleID = roleID;
        //     gameRoleInfo.gameRoleLevel = "1";
        //     gameRoleInfo.gameRoleName = roleName;
        //     gameRoleInfo.partyName = "无";
        //     gameRoleInfo.serverID = serverID;
        //     gameRoleInfo.serverName = serverName;
        //     gameRoleInfo.vipLevel = "1";
        //     gameRoleInfo.roleCreateTime = createtime;//UC与1881渠道必传，值为10位数时间戳


        //     gameRoleInfo.gameRoleGender = "男";//360渠道参数
        //     gameRoleInfo.gameRolePower = "1";//360渠道参数，设置角色战力，必须为整型字符串
        //     gameRoleInfo.partyId = "1";//360渠道参数，设置帮派id，必须为整型字符串
        //     gameRoleInfo.professionId = "1";//360渠道参数，设置角色职业id，必须为整型字符串
        //     gameRoleInfo.profession = "无";//360渠道参数，设置角色职业名称
        //     gameRoleInfo.partyRoleId = "1";//360渠道参数，设置角色在帮派中的id
        //     gameRoleInfo.partyRoleName = "无"; //360渠道参数，设置角色在帮派中的名称
        //     gameRoleInfo.friendlist = "无";//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190


        //     JJmassas.getInstance().createRole(gameRoleInfo);//创建角色
            
        // }
        // //进入游戏
        // public void OnEnterGame(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        // {
        //     //JJmassas.getInstance().callFunction(FuncType.QUICK_SDK_FUNC_TYPE_REAL_NAME_REGISTER);
        //     //注：GameRoleInfo的字段，如果游戏有的参数必须传，没有则不用传
        //     GameRoleInfo gameRoleInfo = new GameRoleInfo();

        //     gameRoleInfo.gameRoleBalance = roleBalance;
        //     gameRoleInfo.gameRoleID = roleID;
        //     gameRoleInfo.gameRoleLevel = roleLevel;
        //     gameRoleInfo.gameRoleName = roleName;
        //     gameRoleInfo.partyName = "无";
        //     gameRoleInfo.serverID = serverID;
        //     gameRoleInfo.serverName = serverName;
        //     gameRoleInfo.vipLevel = "1";
        //     gameRoleInfo.roleCreateTime = createtime;//UC与1881渠道必传，值为10位数时间戳

        //     gameRoleInfo.gameRoleGender = "男";//360渠道参数
        //     gameRoleInfo.gameRolePower = "1";//360渠道参数，设置角色战力，必须为整型字符串
        //     gameRoleInfo.partyId = "1";//360渠道参数，设置帮派id，必须为整型字符串

        //     gameRoleInfo.professionId = "1";//360渠道参数，设置角色职业id，必须为整型字符串
        //     gameRoleInfo.profession = "无";//360渠道参数，设置角色职业名称
        //     gameRoleInfo.partyRoleId = "1";//360渠道参数，设置角色在帮派中的id
        //     gameRoleInfo.partyRoleName = "无"; //360渠道参数，设置角色在帮派中的名称
        //     gameRoleInfo.friendlist = "无";//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190


        //     JJmassas.getInstance().enterGame(gameRoleInfo);//开始游戏
        // }

        // public void OnUpdateRole(string roleID, string roleName, string serverID, string serverName, string roleBalance, string roleLevel, string createtime)
        // {
        //     GameRoleInfo gameRoleInfo = new GameRoleInfo();

        //     gameRoleInfo.gameRoleBalance = roleBalance;
        //     gameRoleInfo.gameRoleID = roleID;
        //     gameRoleInfo.gameRoleLevel = roleLevel;
        //     gameRoleInfo.gameRoleName = roleName;
        //     gameRoleInfo.partyName = "无";
        //     gameRoleInfo.serverID = serverID;
        //     gameRoleInfo.serverName = serverName;
        //     gameRoleInfo.vipLevel = "1";
        //     gameRoleInfo.roleCreateTime = createtime;//UC与1881渠道必传，值为10位数时间戳

        //     gameRoleInfo.gameRoleGender = "男";//360渠道参数
        //     gameRoleInfo.gameRolePower = "1";//360渠道参数，设置角色战力，必须为整型字符串
        //     gameRoleInfo.partyId = "1";//360渠道参数，设置帮派id，必须为整型字符串

        //     gameRoleInfo.professionId = "1";//360渠道参数，设置角色职业id，必须为整型字符串
        //     gameRoleInfo.profession = "无";//360渠道参数，设置角色职业名称
        //     gameRoleInfo.partyRoleId = "1";//360渠道参数，设置角色在帮派中的id
        //     gameRoleInfo.partyRoleName = "无"; //360渠道参数，设置角色在帮派中的名称
        //     gameRoleInfo.friendlist = "无";//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190

        //     JJmassas.getInstance().updateRole(gameRoleInfo);
        // }

        // public void GetRealnameInfo()
        // {
        //     Debug.Log("测试输出 GetRealnameInfo");
        //     JJmassas.getInstance().getRealnameInfo();
        // }

        // public void EnterRealName()
        // {
        //     Debug.Log("测试输出 EnterRealName");
        //     JJmassas.getInstance().enterRealName();
        // }
    }
}
