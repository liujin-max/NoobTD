﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NoobTD_UIEventListenerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NoobTD.UIEventListener), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Awake", Awake);
		L.RegFunction("IsRaycastLocationValid", IsRaycastLocationValid);
		L.RegFunction("SetPassThrough", SetPassThrough);
		L.RegFunction("ClearListener", ClearListener);
		L.RegFunction("Get", Get);
		L.RegFunction("PGet", PGet);
		L.RegFunction("OnLongPressed", OnLongPressed);
		L.RegFunction("OnPointerClick", OnPointerClick);
		L.RegFunction("OnPointerDown", OnPointerDown);
		L.RegFunction("OnPointerEnter", OnPointerEnter);
		L.RegFunction("OnPointerExit", OnPointerExit);
		L.RegFunction("OnPointerUp", OnPointerUp);
		L.RegFunction("OnSelect", OnSelect);
		L.RegFunction("OnUpdateSelected", OnUpdateSelected);
		L.RegFunction("OnDrag", OnDrag);
		L.RegFunction("OnBeginDrag", OnBeginDrag);
		L.RegFunction("OnEndDrag", OnEndDrag);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("PassThrough", get_PassThrough, set_PassThrough);
		L.RegVar("EnableInteration", get_EnableInteration, set_EnableInteration);
		L.RegVar("onClick_P", get_onClick_P, set_onClick_P);
		L.RegVar("onClick", get_onClick, set_onClick);
		L.RegVar("onDown", get_onDown, set_onDown);
		L.RegVar("onDown_P", get_onDown_P, set_onDown_P);
		L.RegVar("onEnter", get_onEnter, set_onEnter);
		L.RegVar("onEnter_P", get_onEnter_P, set_onEnter_P);
		L.RegVar("onExit", get_onExit, set_onExit);
		L.RegVar("onExit_P", get_onExit_P, set_onExit_P);
		L.RegVar("onUp", get_onUp, set_onUp);
		L.RegVar("onUp_P", get_onUp_P, set_onUp_P);
		L.RegVar("onSelect", get_onSelect, set_onSelect);
		L.RegVar("onUpdateSelect", get_onUpdateSelect, set_onUpdateSelect);
		L.RegVar("onLongPress_P", get_onLongPress_P, set_onLongPress_P);
		L.RegVar("onLongPress", get_onLongPress, set_onLongPress);
		L.RegVar("onDrag", get_onDrag, set_onDrag);
		L.RegVar("onDrag_P", get_onDrag_P, set_onDrag_P);
		L.RegVar("onDragBegin", get_onDragBegin, set_onDragBegin);
		L.RegVar("onDragBegin_P", get_onDragBegin_P, set_onDragBegin_P);
		L.RegVar("onDragEnd", get_onDragEnd, set_onDragEnd);
		L.RegVar("onDragEnd_P", get_onDragEnd_P, set_onDragEnd_P);
		L.RegVar("parameter", get_parameter, set_parameter);
		L.RegVar("delegateObject", get_delegateObject, set_delegateObject);
		L.RegFunction("ParamedPointerDelegate", NoobTD_UIEventListener_ParamedPointerDelegate);
		L.RegFunction("PointerDelegate", NoobTD_UIEventListener_PointerDelegate);
		L.RegFunction("VoidDelegate", NoobTD_UIEventListener_VoidDelegate);
		L.RegFunction("ParamedDelegate", NoobTD_UIEventListener_ParamedDelegate);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Awake(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			obj.Awake();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsRaycastLocationValid(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 2);
			UnityEngine.Camera arg1 = (UnityEngine.Camera)ToLua.CheckObject(L, 3, typeof(UnityEngine.Camera));
			bool o = obj.IsRaycastLocationValid(arg0, arg1);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPassThrough(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			bool arg1 = LuaDLL.luaL_checkboolean(L, 2);
			NoobTD.UIEventListener.SetPassThrough(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			NoobTD.UIEventListener.ClearListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Get(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			NoobTD.UIEventListener o = NoobTD.UIEventListener.Get(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PGet(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			object arg1 = ToLua.ToVarObject(L, 2);
			NoobTD.UIEventListener o = NoobTD.UIEventListener.PGet(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnLongPressed(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			obj.OnLongPressed();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerClick(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerClick(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerDown(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerDown(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerEnter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerEnter(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerExit(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerExit(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPointerUp(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnPointerUp(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnSelect(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.BaseEventData arg0 = (UnityEngine.EventSystems.BaseEventData)ToLua.CheckObject<UnityEngine.EventSystems.BaseEventData>(L, 2);
			obj.OnSelect(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnUpdateSelected(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.BaseEventData arg0 = (UnityEngine.EventSystems.BaseEventData)ToLua.CheckObject<UnityEngine.EventSystems.BaseEventData>(L, 2);
			obj.OnUpdateSelected(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnDrag(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnDrag(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnBeginDrag(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnBeginDrag(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnEndDrag(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)ToLua.CheckObject<NoobTD.UIEventListener>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnEndDrag(arg0);
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
	static int get_PassThrough(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			bool ret = obj.PassThrough;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index PassThrough on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_EnableInteration(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, NoobTD.UIEventListener.EnableInteration);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onClick_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate ret = obj.onClick_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onClick_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onClick(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onClick;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onClick on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDown(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onDown;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDown on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDown_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate ret = obj.onDown_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDown_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onEnter(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onEnter;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onEnter on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onEnter_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate ret = obj.onEnter_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onEnter_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onExit(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onExit;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onExit on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onExit_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate ret = obj.onExit_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onExit_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onUp(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onUp;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUp on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onUp_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate ret = obj.onUp_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUp_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onSelect(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onSelect;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onSelect on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onUpdateSelect(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onUpdateSelect;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUpdateSelect on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onLongPress_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate ret = obj.onLongPress_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onLongPress_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onLongPress(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate ret = obj.onLongPress;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onLongPress on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDrag(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate ret = obj.onDrag;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDrag on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDrag_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate ret = obj.onDrag_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDrag_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragBegin(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate ret = obj.onDragBegin;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragBegin on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragBegin_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate ret = obj.onDragBegin_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragBegin_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragEnd(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate ret = obj.onDragEnd;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragEnd on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragEnd_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate ret = obj.onDragEnd_P;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragEnd_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_parameter(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			object ret = obj.parameter;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index parameter on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_delegateObject(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			object ret = obj.delegateObject;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index delegateObject on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_PassThrough(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.PassThrough = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index PassThrough on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_EnableInteration(IntPtr L)
	{
		try
		{
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			NoobTD.UIEventListener.EnableInteration = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onClick_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate arg0 = (NoobTD.UIEventListener.ParamedDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedDelegate>(L, 2);
			obj.onClick_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onClick_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onClick(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onClick = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onClick on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDown(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onDown = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDown on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDown_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate arg0 = (NoobTD.UIEventListener.ParamedPointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedPointerDelegate>(L, 2);
			obj.onDown_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDown_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onEnter(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onEnter = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onEnter on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onEnter_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate arg0 = (NoobTD.UIEventListener.ParamedDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedDelegate>(L, 2);
			obj.onEnter_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onEnter_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onExit(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onExit = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onExit on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onExit_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate arg0 = (NoobTD.UIEventListener.ParamedDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedDelegate>(L, 2);
			obj.onExit_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onExit_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onUp(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onUp = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUp on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onUp_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate arg0 = (NoobTD.UIEventListener.ParamedPointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedPointerDelegate>(L, 2);
			obj.onUp_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUp_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onSelect(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onSelect = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onSelect on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onUpdateSelect(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onUpdateSelect = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onUpdateSelect on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onLongPress_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedDelegate arg0 = (NoobTD.UIEventListener.ParamedDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedDelegate>(L, 2);
			obj.onLongPress_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onLongPress_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onLongPress(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.VoidDelegate arg0 = (NoobTD.UIEventListener.VoidDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.VoidDelegate>(L, 2);
			obj.onLongPress = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onLongPress on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDrag(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate arg0 = (NoobTD.UIEventListener.PointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.PointerDelegate>(L, 2);
			obj.onDrag = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDrag on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDrag_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate arg0 = (NoobTD.UIEventListener.ParamedPointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedPointerDelegate>(L, 2);
			obj.onDrag_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDrag_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragBegin(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate arg0 = (NoobTD.UIEventListener.PointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.PointerDelegate>(L, 2);
			obj.onDragBegin = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragBegin on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragBegin_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate arg0 = (NoobTD.UIEventListener.ParamedPointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedPointerDelegate>(L, 2);
			obj.onDragBegin_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragBegin_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragEnd(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.PointerDelegate arg0 = (NoobTD.UIEventListener.PointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.PointerDelegate>(L, 2);
			obj.onDragEnd = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragEnd on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragEnd_P(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			NoobTD.UIEventListener.ParamedPointerDelegate arg0 = (NoobTD.UIEventListener.ParamedPointerDelegate)ToLua.CheckDelegate<NoobTD.UIEventListener.ParamedPointerDelegate>(L, 2);
			obj.onDragEnd_P = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onDragEnd_P on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_parameter(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			object arg0 = ToLua.ToVarObject(L, 2);
			obj.parameter = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index parameter on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_delegateObject(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			NoobTD.UIEventListener obj = (NoobTD.UIEventListener)o;
			object arg0 = ToLua.ToVarObject(L, 2);
			obj.delegateObject = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index delegateObject on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NoobTD_UIEventListener_ParamedPointerDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.ParamedPointerDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.ParamedPointerDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NoobTD_UIEventListener_PointerDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.PointerDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.PointerDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NoobTD_UIEventListener_VoidDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.VoidDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.VoidDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NoobTD_UIEventListener_ParamedDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.ParamedDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<NoobTD.UIEventListener.ParamedDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

