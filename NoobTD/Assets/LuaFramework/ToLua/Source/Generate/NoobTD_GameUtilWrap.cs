﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NoobTD_GameUtilWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NoobTD.GameUtil), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("OnExitGame", OnExitGame);
		L.RegFunction("EditorPause", EditorPause);
		L.RegFunction("IsTouchedUI", IsTouchedUI);
		L.RegFunction("CreateClassByName", CreateClassByName);
		L.RegFunction("ScenePoint2UI", ScenePoint2UI);
		L.RegFunction("UI2Scene", UI2Scene);
		L.RegFunction("Cross", Cross);
		L.RegFunction("SegmentsInterPoint", SegmentsInterPoint);
		L.RegFunction("BetweenLineAndCircle", BetweenLineAndCircle);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnExitGame(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			NoobTD.GameUtil.OnExitGame();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EditorPause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			NoobTD.GameUtil.EditorPause();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsTouchedUI(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			bool o = NoobTD.GameUtil.IsTouchedUI();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateClassByName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			object o = NoobTD.GameUtil.CreateClassByName(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ScenePoint2UI(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 1);
			UnityEngine.GameObject arg1 = (UnityEngine.GameObject)ToLua.CheckObject(L, 2, typeof(UnityEngine.GameObject));
			UnityEngine.Vector3 o = NoobTD.GameUtil.ScenePoint2UI(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UI2Scene(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 1);
			UnityEngine.Vector2 o = NoobTD.GameUtil.UI2Scene(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Cross(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 1);
			UnityEngine.Vector2 arg1 = ToLua.ToVector2(L, 2);
			float o = NoobTD.GameUtil.Cross(arg0, arg1);
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SegmentsInterPoint(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 1);
			UnityEngine.Vector2 arg1 = ToLua.ToVector2(L, 2);
			UnityEngine.Vector2 arg2 = ToLua.ToVector2(L, 3);
			UnityEngine.Vector2 arg3 = ToLua.ToVector2(L, 4);
			UnityEngine.Vector2 o = NoobTD.GameUtil.SegmentsInterPoint(arg0, arg1, arg2, arg3);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BetweenLineAndCircle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 1);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			UnityEngine.Vector2 arg2 = ToLua.ToVector2(L, 3);
			UnityEngine.Vector2 arg3 = ToLua.ToVector2(L, 4);
			UnityEngine.Vector2 o = NoobTD.GameUtil.BetweenLineAndCircle(arg0, arg1, arg2, arg3);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

