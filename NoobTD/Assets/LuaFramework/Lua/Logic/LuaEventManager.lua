--[[
--全局事件监听处理类
--这个类调用的就是项目现有的EventManager，只是封装了一下，
--与EventManage不同的地方在于删除事件监听时不需要再传eventData了，
--例如:EventManager删除事件是这样的----EventManager.instance:DelHandler(SiegeEventType.READY_SHOT, self.readyShotEventData);
--而LuaEventManager是这样的  --------LuaEventManager:DelHandler(GameEventType.MAP_UI_CLOSE,WorldMapBaseView.UICloseHandler,self),
--其它的方法的调用都一样
--author mrt
]]
LuaEventManager = {}

LuaEventManager.EventTypeList = {}  --事件类型列表

--[[
--添加一个事件监听
--@eventType @see GameEventType
--@handler 回调函数
--@instance 注册事件的源对象
--@parmSelf 自定义self对象，在回调中返回，主要在lua中返回self对象便于操作
--return EventData
]]
function LuaEventManager.AddHandler(eventType,handler,instance, parmSelf, priority)
	--print("ADD HANDLER " .. eventType .. " " .. tostring(handler) .. " " ..  tostring(instance) .. " " .. debug.traceback())
	if not eventType then
		--logError("-------事件监听请传事件类型------------")
		return
	end

	if not handler then
		--logError("-------事件监请传回调函数------------" .. eventType)
		return
	end

	if not instance then
		--logError("-------事件监听请传调用对象------------" .. eventType)
		return
	end

	local eventList = LuaEventManager.EventTypeList[eventType]
	if eventList then
		for _, eventObject in ipairs(eventList) do
			if eventObject.handler == handler and eventObject.instance == instance then
				--这个对象的这个事件已经监听了
				--logError("-------事件监听重复------------" .. eventType)
				return
			end
		end
	else
		eventList = {}
		LuaEventManager.EventTypeList[eventType] = eventList
	end
	local eventObject = {}
	local eventData = nil

	eventObject.handler 	= handler
	eventObject.instance 	= instance
	eventObject.eventData 	= eventData
	eventObject.parmSelf	= parmSelf

	table.insert(eventList, eventObject)

	return eventData
end

--[[
--发送事件
--@eventType 事件类型 @see GameEventType
--@instance发送事件源对象 如果传入此值 那么事件接收的时候 只会派发给 同样注册了 这个值的回调
--@paramss 回调附带的参数
]]
function LuaEventManager.SendEvent(eventType,instance, ...)
	if not eventType then
		--logError("-------发送事件类型不能为空------------")
		return
	end

	local eventList = LuaEventManager.EventTypeList[eventType]

	if eventList ~= nil then
		local stackEventList = {}
		for _, eventObject in ipairs(eventList) do	
			table.insert(stackEventList, eventObject)
		end

		for _, eventObject in ipairs(stackEventList) do
			if instance ~= nil then
				if eventObject.instance ~= nil then 
					if eventObject.instance == instance then
						--print("SEND EVENT 2=============> " .. eventType)
						eventObject.handler(eventObject.parmSelf, eventType, ...)
					end
				end
			else
				--print("SEND EVENT 1=============> " .. eventType .. " " .. tostring(eventObject.instance) .. " " .. #eventList .. " " .. eventType)
				eventObject.handler(eventObject.parmSelf, eventType, ...)
			end
		end
		--清除临时数组
		stackEventList = nil
	end
end

--[[
--移除事件监听
--@eventType 事件类型 @see GameEventType

]]
function LuaEventManager.DelHandler(eventType,handler,instance)
	if not eventType then
		--logError("-------移除事件类型不能为空------------")
		return
	end

	if not handler then
		--logError("-------移除事件回调函数不能为空------------" .. eventType)
		return
	end

	if not instance then
		--logError("-------移除事件对象不能为空------------" .. eventType)
		return
	end

	
	local eventList = LuaEventManager.EventTypeList[eventType]
	if not eventList then
		--logError("-------事件类型不存在------------"..eventType)
		return
	end

	for i, eventObject in ipairs(eventList) do
		if eventObject.handler == handler and eventObject.instance == instance then
			table.remove(eventList,i)
			return
		end
	end
	--logError("-------事件类型移除不成功------------" .. eventType)
end

--检查是否已注册某事件
function LuaEventManager.HasHandler(eventType,handler,instance)
	local eventList = LuaEventManager.EventTypeList[eventType]
	if not eventList then
		return false
	end

	for i,eventObject in ipairs(eventList) do
		if eventObject.handler == handler and eventObject.instance == instance then
			return true
		end
	end

	return false
end

--显示出当前没有被清除的对应事件
function LuaEventManager.PrintAll()
	-- for eventType, eventList in pairs(LuaEventManager.EventTypeList) do
	-- 	print("EVENT TYPE " .. eventType .. " " .. #eventList)
	-- end
end

