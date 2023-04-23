﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NoobTD_BGMWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NoobTD.BGM), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Pause", Pause);
		L.RegFunction("Resume", Resume);
		L.RegFunction("Play", Play);
		L.RegFunction("UpdateVolumn", UpdateVolumn);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.BGM obj = (NoobTD.BGM)ToLua.CheckObject<NoobTD.BGM>(L, 1);
			obj.Pause();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Resume(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.BGM obj = (NoobTD.BGM)ToLua.CheckObject<NoobTD.BGM>(L, 1);
			obj.Resume();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.BGM obj = (NoobTD.BGM)ToLua.CheckObject<NoobTD.BGM>(L, 1);
			obj.Play();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateVolumn(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.BGM obj = (NoobTD.BGM)ToLua.CheckObject<NoobTD.BGM>(L, 1);
			obj.UpdateVolumn();
			return 0;
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

