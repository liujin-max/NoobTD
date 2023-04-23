﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class FoodWar_LandControlWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(FoodWar.LandControl), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Move", Move);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("TeamPos", get_TeamPos, set_TeamPos);
		L.RegVar("MatPos", get_MatPos, set_MatPos);
		L.RegVar("Land", get_Land, set_Land);
		L.RegVar("MoveFinished", get_MoveFinished, set_MoveFinished);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Move(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)ToLua.CheckObject<FoodWar.LandControl>(L, 1);
			obj.Move();
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_TeamPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject[] ret = obj.TeamPos;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index TeamPos on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MatPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject ret = obj.MatPos;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MatPos on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Land(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject ret = obj.Land;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Land on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MoveFinished(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			bool ret = obj.MoveFinished;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MoveFinished on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_TeamPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject[] arg0 = ToLua.CheckObjectArray<UnityEngine.GameObject>(L, 2);
			obj.TeamPos = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index TeamPos on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MatPos(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 2, typeof(UnityEngine.GameObject));
			obj.MatPos = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MatPos on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Land(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 2, typeof(UnityEngine.GameObject));
			obj.Land = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Land on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MoveFinished(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FoodWar.LandControl obj = (FoodWar.LandControl)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.MoveFinished = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MoveFinished on a nil value");
		}
	}
}
