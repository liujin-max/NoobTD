﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NoobTD_TimerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NoobTD.Timer), typeof(System.Object));
		L.RegFunction("Register", _Register);
		L.RegFunction("Cancel", Cancel);
		L.RegFunction("Pause", Pause);
		L.RegFunction("Resume", Resume);
		L.RegFunction("CancelAllRegisteredTimers", CancelAllRegisteredTimers);
		L.RegFunction("PauseAllRegisteredTimers", PauseAllRegisteredTimers);
		L.RegFunction("ResumeAllRegisteredTimers", ResumeAllRegisteredTimers);
		L.RegFunction("GetTimeElapsed", GetTimeElapsed);
		L.RegFunction("GetTimeRemaining", GetTimeRemaining);
		L.RegFunction("GetRatioComplete", GetRatioComplete);
		L.RegFunction("GetRatioRemaining", GetRatioRemaining);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("duration", get_duration, null);
		L.RegVar("isLooped", get_isLooped, set_isLooped);
		L.RegVar("isCompleted", get_isCompleted, null);
		L.RegVar("usesRealTime", get_usesRealTime, null);
		L.RegVar("isPaused", get_isPaused, null);
		L.RegVar("isCancelled", get_isCancelled, null);
		L.RegVar("isDone", get_isDone, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _Register(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				NoobTD.Timer o = NoobTD.Timer.Register(arg0, arg1);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 3)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				System.Action<float> arg2 = (System.Action<float>)ToLua.CheckDelegate<System.Action<float>>(L, 3);
				NoobTD.Timer o = NoobTD.Timer.Register(arg0, arg1, arg2);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 4)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				System.Action<float> arg2 = (System.Action<float>)ToLua.CheckDelegate<System.Action<float>>(L, 3);
				bool arg3 = LuaDLL.luaL_checkboolean(L, 4);
				NoobTD.Timer o = NoobTD.Timer.Register(arg0, arg1, arg2, arg3);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 5)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				System.Action<float> arg2 = (System.Action<float>)ToLua.CheckDelegate<System.Action<float>>(L, 3);
				bool arg3 = LuaDLL.luaL_checkboolean(L, 4);
				bool arg4 = LuaDLL.luaL_checkboolean(L, 5);
				NoobTD.Timer o = NoobTD.Timer.Register(arg0, arg1, arg2, arg3, arg4);
				ToLua.PushObject(L, o);
				return 1;
			}
			else if (count == 6)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				System.Action<float> arg2 = (System.Action<float>)ToLua.CheckDelegate<System.Action<float>>(L, 3);
				bool arg3 = LuaDLL.luaL_checkboolean(L, 4);
				bool arg4 = LuaDLL.luaL_checkboolean(L, 5);
				UnityEngine.MonoBehaviour arg5 = (UnityEngine.MonoBehaviour)ToLua.CheckObject<UnityEngine.MonoBehaviour>(L, 6);
				NoobTD.Timer o = NoobTD.Timer.Register(arg0, arg1, arg2, arg3, arg4, arg5);
				ToLua.PushObject(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NoobTD.Timer.Register");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Cancel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			obj.Cancel();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pause(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
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
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			obj.Resume();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CancelAllRegisteredTimers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			NoobTD.Timer.CancelAllRegisteredTimers();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PauseAllRegisteredTimers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			NoobTD.Timer.PauseAllRegisteredTimers();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ResumeAllRegisteredTimers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			NoobTD.Timer.ResumeAllRegisteredTimers();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTimeElapsed(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			float o = obj.GetTimeElapsed();
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTimeRemaining(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			float o = obj.GetTimeRemaining();
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRatioComplete(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			float o = obj.GetRatioComplete();
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRatioRemaining(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)ToLua.CheckObject<NoobTD.Timer>(L, 1);
			float o = obj.GetRatioRemaining();
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_duration(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
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
	static int get_isLooped(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.isLooped;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isLooped on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isCompleted(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.isCompleted;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isCompleted on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_usesRealTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.usesRealTime;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index usesRealTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isPaused(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.isPaused;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isPaused on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isCancelled(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.isCancelled;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isCancelled on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isDone(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool ret = obj.isDone;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isDone on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isLooped(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.Timer obj = (NoobTD.Timer)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.isLooped = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isLooped on a nil value");
		}
	}
}

