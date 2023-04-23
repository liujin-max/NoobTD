Class = {};

-- class 类型
Class.TYPE_CLASS = "Class";

--接口类型
Class.TYPE_INTERFACE = "Interface";
 
--保存过的类定义
Class.classList = {};

--该类名是否已经初始化过
--@parma className 类名
function Class.isExist(className)
	return Class.classList[className] ~= nil;
end

--类的注册
--@param className 字符串类名
--@param clazz 实例 object
function Class.register(className,clazz)
	if(Class.isExist(className)) then return end;
	Class.classList[className]=clazz;
end

--全局静态类 也就是程序应用域的class  是静态的
--@param className 字符串类名
function Class.getDefinedClass(className)
	return Class.classList[className];
end

--检查是否合法
--如果是合法的话 则返回nil  如果返回的不为nil 则表示class有问题
--@param class 类对象
--@param classType 类型  类 or 接口
function Class.checkValid(class,classType)
	
	--判空  如果不传参 默认为class
	classType = classType or Class.TYPE_CLASS;	
	
	--判空
	if class == nil then
		return classType.."未定义!!";
	end
	
	--判断是否为table对象
	if(type(class)~="table") then
		return "\""..tostring(class).."\" 不是一个"..classType;
	end
	
	--判断是否已经注册 因为传的是class 那么class 有个classname属性 这个className 是全局静态的
	--如果className 为空的时候 则代表这个class 已经不是一个已经实例化的class对象
	local className = class.className;
	local b = Class.isExist(className);
	
	if(not b) then
		return classType.. ":"..className .. " 未定义!!";
	end
	return nil;
end

--定义一个类. 由于无法区分是没有传入extendsCls还是传入了一个错误的extendsCls,所以提供了define2来自动继承自Object. 这个方法是强制传入Object方法
--@param className 类名.字符串.  
--@param 第二个参数为 继承的父类
--@param 第三个参数为  实现的接口
--@param eg. Role = Class.define("Role",Object,Ixxx); 
function Class.define(className, ...)
	local cls = Class._define(Class.TYPE_CLASS,className, ...)
	if (type(cls)=="string") then
		error(cls, 2);
	end
	return cls;
end


--定义类2
--@param classType 类型
--@param className 类名 
--@param 第三个参数 继承的类
--@param 第四个参数 实现的接口
function Class._define(classType,className, ...)
	if type(className) ~= "string" then
		return classType.."\""..tostring(className).."\" 无效!!";
	end
	
	if Class.isExist(className) then
		return classType.."class \""..tostring(className).."\" 重复定义!!";
	end
	
	--赋值className 生成唯一的标识
	local clazz = { className=className, __classType=Class.TYPE_CLASS};
	
	--保存本类需要实现的接口,且不能重复实现同一接口
	local extendsCls;   --父类
	local arglen = select("#", ...); --参数列表
	local err = nil;
	
	-- 说明没有显示传入继承的类
	if(arglen<1) then
		if(className=="Object") then
			--如果当前的对象为object 那么则不需要继承 
			extendsCls = nil;
		else
			--默认继承object
			extendsCls = Object;
		end
	else
		extendsCls = select(1,...);
		
		--检查类的兼容性
		err = Class.checkValid(extendsCls);
		if(err) then
			return err;
		end
	end
	
	--赋值父类属性
	clazz.parentClass = extendsCls;
	
	-- clazz.__implments = {};
	-- local _impl;
	-- --接口的实现是多个的
	-- for i=2,arglen do
	-- 	_impl = select(i, ...);
	-- 	--验证接口的有效性 也就是验证这个接口的类是否已经实现了
	-- 	err = Class.checkValid(_impl,Class.TYPE_INTERFACE);
	-- 	if (err) then
	-- 		return err;
	-- 	end
		
	-- 	--检查接口是否有重复继承
	-- 	-- for _,v in ipairs(clazz.__implments) do
	-- 	-- 	if v == _impl then
	-- 	-- 		return Class.TYPE_INTERFACE.." \"".. _impl.className.."\" 重复继承!!";
	-- 	-- 	end
	-- 	-- end
	-- 	--将要赋值实现的接口 填充进去
	-- 	-- table.insert(clazz.__implments, _impl);
	-- end
	
	--检测完毕 开始注册 这个类的信息
	if(className=="Object") then
		Class.register(className,clazz);
		return clazz;
	end
	
	Class.register(className,clazz);
	return clazz;
end

--检测当前类以及父类是否实现了相关接口的方法
--@param cls 当前的class
--@param interface 当前类 和父类的所有接口
-- function Class._checkImplements(cls,interfaces)
-- 	if (#interfaces < 1) then return end;
	
-- 	--遍历 当前类 是否已经实现了 每一个接口类
-- 	for k,v in ipairs(interfaces) do
-- 		Class.__checkImplements(cls,v);

-- 		--因为接口是可以继承接口的 那么需要判断接口的是否存在继承 存在继承需要遍历判断是否已经实现
-- 		--查找当前接口的父级接口的所有方法是否被实现
-- 		pInterface=v.parentClass;
-- 		while(pInterface) do
-- 			Class.__checkImplements(cls, pInterface);
-- 			pInterface = pInterface.parentClass;
-- 		end
-- 	end
-- end

-- --检测当前类和父类是否实现了一个接口的所有方法
-- function Class.__checkImplements(cls, interface)
-- 	local b = true;
-- 	local pcls;
-- 	--遍历接口类里面所有的属性 只拿fun类型的
-- 	for name, func in pairs(interface) do
-- 		if(type(func)=="function") then
-- 			if(cls[name] and type(cls[name]=="function")) then return end

-- 			--当本类中不存在这个,则在父类中查找
-- 			pcls=cls.parentClass;
-- 			while(pcls) do
-- 				if(pcls[name] and type(pcls[name]=="function")) then return end
-- 				pcls=pcls.parentClass;
-- 			end

-- 			--子类和父类中都没找到,说明没有实现
-- 			error("\""..cls.className.."\" 未覆盖 \""..interface.className.."\" 中的抽象方法 "..name.."()");
-- 		end
-- 	end
-- end

--从一个类 获取一个object对象
function Class.createObjectFromClass(class)
	local o={};
	o.class = class;
	setmetatable(o,class);
	--设置访问时的操作
	--属性和方法从本类开始往父类逐级找	先从本级的操作寻找 如果找不到 递归到父类一直寻找 直到寻找到为止
	--否则 返回 nil 也就是没这个属性
	class.__index=function(t,k)
		local v = nil;
		local pcls = t.class;
		while(pcls) do
			v = rawget(t.class, k);
			if(v) then return v end;
			pcls = pcls.parentClass;
		end
		return nil; 
	end
	return o;
end

--验证构造参数合法性
--@param class 类
function Class.checkCtor(class, ...)
	if(class==Object or class.parentClass==nil) then
		return;
	end

	--产生一个无参构造.
	if(class.defaultRun == nil and class.ctor == nil) then
		--获取下划线的构造函数 则表示为class内部创建的 无参的构造
		class.defaultRun = function() end;
	end
	
	--检查父类的构造函数 是否正确
	Class.checkCtor(class.parentClass);
end

--new一个对象的实例
--@parma class 类对象 
--@param ...构造函数的参数
function Class.new(class, ...)
	--检查合法性
	Class.checkValid(class);

	--检查接口
	-- Class._checkImplements(class, class.__implments);
	
	--如果都没显示指定无参构造函数,则在checkCtor()中生成一个无参的构造函数
	Class.checkCtor(class, ...);
	
	-- 获取参数的真实长度, 用来区分传入的参数在为nil时,到底是调用者填写的nil还是系统默认的nil
	local arglen = select("#", ...);
	--如果当前类没有有参构造,则参数必须为空
	--自定义的构造函数 参数必须符合正确
	if(class.ctor == nil and arglen ~= 0 ) then
		error("构造函数错误,不存在有参构造函数. Class "..class.className);
	end
	
	-- 将父类的所有定义的属性拿出来放到一个映射表中
	local attributes = {}; -- Map<类名, Map<属名,value> >
	
	-- 将类链表中定义的方法做个列表存放起来. 每个类自己定义的方法都做单独保存,主要为super提供
	-- local functionsMap = {}; -- Map<类名, Map<方法名,func> >
	
	--保存最后实现的那些方法. 实现多态.
	-- functionsMap.lastFuncs = {};
	
	--查找类链
	local _clsListTemp = {};
	local pcls = class;
	while(pcls~=nil) do
		table.insert(_clsListTemp, pcls)
		pcls = pcls.parentClass;
	end
	
	--这里写法很奇怪, 理论上func找不到的时候, 直接通过index一层一层往上找就好了

	--先从上往下依次调用类链中的所有方法.
	-- local _cls = nil;
	-- for i = #_clsListTemp, 1, -1 do
	-- 	_cls = _clsListTemp[i];

	-- 	functionsMap[_cls] = {};

	-- 	--找出方法,保存到方法列表中
	-- 	for k,v in pairs(_cls) do
	-- 		--默认的无参构造函数不存起来,因为会自动都调用一次.
	-- 		--找出所有的方法  不包括构造函数 因为构造函数只能在new执行 不能再调用
	-- 		if(type(v)=="function" and k~="defaultRun" and k~="__index" and k~="__newindex") then
	-- 			--保存对应的方法列表. 默认指向最后的实现者,但也保存每个类中自己的那个方法,以便通过super调用的时候找到对应的方法.
	-- 			functionsMap[_cls][k] = v;
	-- 			--由于是从上往下调用,所以子类覆盖的方法会被正确指向. 有参构造不能覆盖保存. 
	-- 			--lastFuncs 就是 最后被覆盖掉 整个类作用链下来的最后的方法 
	-- 			if(k~="ctor") then
	-- 				functionsMap.lastFuncs[k] = v;
	-- 			end
	-- 		end
	-- 	end
	-- end
	
	local meta = {class = class, __attributes = attributes} -- __functionsMap = functionsMap};

	--设置键为弱引用.
	meta.__mode="k";
	--类型不是Class
	meta.__type="Instance"

	setmetatable(meta,{__index = Class._index, __newindex = Class.__newindex});
	--以下注意
	--由于上面已经找出了所有方法, 所以在构造函数中就可以访问那些方法了. 也就是在构造函数中执行一些逻辑.
	-- for i = #_clsListTemp, 1, -1 do
	-- 	_cls = _clsListTemp[i];

	-- 	--产生_cls的临时对象
	-- 	local __o = Class.createObjectFromClass(_cls);
		
	-- 	--这里用点号访问,并传入了代理的obj对象,这样在_ctor定义的属性就会保存到obj元表对象meta的 attributes中(通过上面的__newindex操作).
	-- 	--如果在_ctor中初始调用逻辑方法,也能在obj元表meta的functionsMap 中正确访问到.
	-- 	--如果出现重复定义属性, 这里没有使用像java一样的方式保存在不同类中定义的相同属性的副本.
	-- 	--有点像actionscript中一样不能重复定义(as中父类的属性可见性要比子类小,否则就报重复定义的编译级错误).
	-- 	--但这里没有实现 private 这样的可见性, 所以全部视为 public. 那自然不允许重复定义属性.
	-- 	--理论上应该做一次检查,如果重复定义要报错.但lua没有像其它预编译语言的定义属性的概念,
	-- 	--并且我无法知道子类在构造方法内部写self.xx=value 时到底是定义这个属性还是更改它的值(如果它已经在父类中定义了)
	-- 	--所以这里统一处理,不存在就定义,存在就覆盖.
	-- 	--并且由于ctor 不能被覆盖,在上面存储方法时已经屏蔽了ctor方法,但_ctor方法中可能会调用ctor方法,且此时只能访问自己这个类中的ctor方法,
	-- 	--那就要将这个存在的ctor从__o中取出来放到obj的元表中临时保存起来,再调用_ctor时,如果内部又要调用ctor才不会出错,且能正确调用到类链中对应位置的ctor.

	-- 	--a自底向上 一直调用构造函数
	-- 	if(__o.ctor~=nil) then
	-- 		(meta).__functionsMap.lastFuncs.ctor=__o.ctor;
	-- 	end
		
	-- 	--自动调用了一次每个类的无参构造函数.
	-- 	--这里和java不一样, java是当new时不传参数时,才会调用无参构造,且如果这个无参构造里没有显示写super,又会自动调用父类的无参构造.
	-- 	--但在这里我无法知道到底有没有在代码内部显示写super, 就不知道是否该自动调用父类的无参构造.
	-- 	--如果不自动统一调用,那每个子类都要显示写上无参构造函数并在内部写self:super(class,"_ctor").
	-- 	--为了业务统一方便,这里自动调用, 所以在无参构造函数里尽量不要包含对其它函数的调用,免得逻辑重复.
	-- 	if(__o.defaultRun~=nil) then
	-- 		__o.defaultRun(meta);
	-- 	end
		
	-- 	--如果子类没有定义他自己的ctor,但子类的_ctor中又写self:ctor()这样的语句,就可能会调用到父类的ctor方法.这是错误的.
	-- 	--所以不管_ctor内部是否调用过了ctor,之后都要将临时保存的ctor清除。
	-- 	if(__o.ctor~=nil) then
	-- 		(meta).__functionsMap.lastFuncs.ctor=nil;
	-- 	end
	-- end
	
	--如果存在参数就调用本类的有参的构造ctor(). 父类的有参构造不会被自动调用,只有子类显示写self:super(class, k, ...);
	--新修改 ctor 只要存在 即会被调用 不管参数是否存在 子类需要调用父类的构造 需要手动处理self:super(class, k, ...);
	local arglen = select("#", ...);
	local ctorFunc = arglen >=0 and class.ctor;
	if(ctorFunc) then
		ctorFunc(meta,...);
	end
	
	return meta;
end

--赋值新属性
function Class.__newindex( t,k,v )
	--value 不为空的情况
	if v ~= nil then
		t.__attributes[k] = v;
	else
		--将属性和方法都设置为空
		t.__attributes[k] = nil;
		-- t.__functionsMap.lastFuncs[k] = nil;
	end
end

--获取属性
function Class._index( t,k)
	-- body
	--获取当前的class则 获取已经设置好的class
	if(k=="class") then return t.class end
	
	--属性
	local attr = t.__attributes[k];
	if(attr~=nil) then return attr end
	--方法
	-- local func = t.__functionsMap.lastFuncs[k];
	-- if(func ~= nil) then return func end
	-- return nil;

	local cls = t.class

	-- print("Class._index " .. tostring(k) .. " " .. tostring(cls) .. " " .. tostring(cls[k]) .. " " .. debug.traceback())
	while cls ~= nil do
		if cls[k] ~= nil then 
			return cls[k]
		else
			cls = cls.parentClass
		end
	end

	return nil
end


--根据className生成对应的class
function Class.newByString(className,...)
	local nowClass = Class.getDefinedClass(className);
	return Class.new(nowClass,...);
end

--假如这个super是一个简单实现,没有第一个class作为参数,出现的情况是:
--设有类 A <- B <- C <- D 其中在A类中定义了func1, 在C类中覆盖了func1,并在方法代码内部简单写super(self,"walk").
--现在Class.new(D),并通过D的实例调用func1. 正确的逻辑应该是访问到C 的func1,然后又访问到A 的func1.
--但方法都是冒号访问, 所以用C 类中的func1里的super(self,"walk")这个self的引用实际上是D 的实例. 如果不进行判断,就会陷入死循环.
--这里传入cls就是明确告诉我当前覆盖walk方法的类是哪个, 再从cls的父类继续找到A.
--如果不传入cls, 那我无法知道当前super代码位于哪个类里面, 就可能导致陷入循环(B和C的walk方法里都写生super时就会陷入死循环)
--所以第一个参数class只能通过外部显示传入.
function super(cls, t, k, ...)
	--检查有效性
	Class.checkValid(cls);
	
	--检查 对应的类 是否有效
	Class.checkValid(t.class);
		if(type(k)~="string") then
		error("参数类型错误. 使用 super 访问时,只能传入属性或方法的字符串名称!!");
	end
	
	--拿出元表
	local m = t;
	local pcls = cls.parentClass;
	local func = nil;
	--访问父类 如果没父类 直接抛错
	if(pcls==nil) then
		error("访问 Class \""..cls.className.."\" 的父类不存在!!");
	end
	
	--构造函数 直接获取访问
	if(k=="ctor") then
		func = pcls[k]
		if(func~=nil) then
			return func(t, ...);
		else
			error("访问 Class \""..t.class.className.."\" super的方法 \""..k.."\" 不存在!!");
		end
	end
	
	--属性.属性只有一级 不存在多级的情况
	local attr = m.__attributes[k];
	if(attr~=nil) then
		return attr;
	end
	
	--检查t的class中是否有k方法
	while(pcls~=nil)do
		func = pcls[k];
		if(func~=nil) then
			return func(t, ...);
		end
		pcls = pcls.parentClass;
	end
	
	error("访问 Class \""..t.class.className.."\" super的方法 \""..k.."\" 不存在!!");
end

-- local _instanceof;
-- -- 一个对象是否是一个类或接口的实例
-- --@parma 对象类
-- --@param class静态类
-- function instanceof(obj,class)
-- 	if(obj==nil or type(obj)~="table" or obj.class==nil) then
-- 		return false;
-- 	end
	
-- 	Class.checkValid(class);
	
-- 	if(rawget(class,"__classType")==nil) then
-- 		error("__classType错误,不是一个类!!");
-- 	end
	
-- 	--所有继承自object 的 都是
-- 	if(class==Object) then return true end
	
-- 	--判断自己是不是object
-- 	local ocls=obj.class;
-- 	if(ocls==class) then return true end
	
-- 	local pcls,b=nil,false;
-- 	--如果是个类,则查找父类
	
-- 	if(class.__classType == Class.TYPE_CLASS) then
-- 		pcls=ocls.parentClass;
-- 		while(pcls~=nil) do
-- 			if(pcls==class) then return true end
-- 			pcls=pcls.parentClass;
-- 		end
-- 	--如果是个接口,则在本类和父类的所有接口中查找
-- 	elseif(class.__classType == Class.TYPE_INTERFACE) then
-- 		b=_instanceof(ocls,class);
-- 		if(b) then return true end
-- 		pcls=ocls.parentClass;

-- 		while(pcls~=nil) do
-- 			b=_instanceof(pcls,class);
-- 			if(b) then return true end
-- 			pcls=pcls.parentClass;
-- 		end
-- 	end
-- 	return false;
-- end

-- --查找是否有实现相同方法的情况  如果接口类 的方法全部都有实现 则是这个接口的子类
-- _instanceof=function(cls,class)
-- 	local interfaces,pInterface,b=cls.__implements,nil,false;
-- 	if(#interfaces<1) then return false end

-- 	--可能会重复查找相关接口
-- 	for k,v in ipairs(interfaces) do
-- 		if(class==v) then return true end

-- 		--查找当前接口的父级接口的所有方法是否被实现
-- 		pInterface=v.parentClass;
-- 		while(pInterface~=nil) do
-- 			if(class==pInterface) then return true end
-- 			pInterface=pInterface.parentClass;
-- 		end
-- 	end
-- 	return false;
-- end