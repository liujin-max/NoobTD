﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class JumpingNumberTextComponentWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(JumpingNumberTextComponent), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Init", Init);
		L.RegFunction("AddNumber", AddNumber);
		L.RegFunction("AddAcNumber", AddAcNumber);
		L.RegFunction("ClearNumbers", ClearNumbers);
		L.RegFunction("Change", Change);
		L.RegFunction("SetNumber", SetNumber);
		L.RegFunction("DoTween", DoTween);
		L.RegFunction("TestChange", TestChange);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("OnComplete", get_OnComplete, set_OnComplete);
		L.RegVar("duration", get_duration, set_duration);
		L.RegVar("different", get_different, null);
		L.RegVar("number", get_number, set_number);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Init(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			obj.Init();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddNumber(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			UnityEngine.UI.Text arg0 = (UnityEngine.UI.Text)ToLua.CheckObject<UnityEngine.UI.Text>(L, 2);
			obj.AddNumber(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddAcNumber(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			UnityEngine.UI.Text arg0 = (UnityEngine.UI.Text)ToLua.CheckObject<UnityEngine.UI.Text>(L, 2);
			obj.AddAcNumber(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearNumbers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			obj.ClearNumbers();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Change(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			obj.Change(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetNumber(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
			obj.SetNumber(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoTween(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			UnityEngine.UI.Text arg0 = (UnityEngine.UI.Text)ToLua.CheckObject<UnityEngine.UI.Text>(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 4);
			obj.DoTween(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TestChange(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)ToLua.CheckObject<JumpingNumberTextComponent>(L, 1);
			obj.TestChange();
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
	static int get_OnComplete(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			System.Action ret = obj.OnComplete;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnComplete on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_duration(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			float ret = obj.duration;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index duration on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_different(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			float ret = obj.different;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index different on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_number(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			int ret = obj.number;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index number on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnComplete(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			System.Action arg0 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
			obj.OnComplete = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnComplete on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_duration(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.duration = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index duration on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_number(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			JumpingNumberTextComponent obj = (JumpingNumberTextComponent)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.number = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index number on a nil value");
		}
	}
}

