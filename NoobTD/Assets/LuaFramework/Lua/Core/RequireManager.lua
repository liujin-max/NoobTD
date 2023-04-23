RequireManager = {};

RequireManager.item = {};
RequireManager.requestMap = {};
RequireManager.isInitRegister = true;

--require对象
function RequireManager:Register(path, className)
	if RequireManager.item[path] == nil 
	then
		RequireManager.requestMap[path] = className;
		if className ~= "" and className ~= nil then
		else
			RequireManager.item[path] = true;
		end
		RequireManager:LateRequest(path, className)
	end
end

function RequireManager:LateRequest(path, className)
	assert(require(path), "error:"..path);
	if className ~= "" and className ~= nil then
		RequireManager.item[path] = _G[className];
	end
end

-- 代码根类
require("Core/Class")
require("Core/Array")
require("Core/Stack")
require("Core/Queue")
require("Core/GameLogicInclude")

