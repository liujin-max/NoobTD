Stack = Class.define("Stack")

local function stack_iter (a, i)
    i = i + 1
    local v = a:Get(i)
    if v then
       return i, v
    end
end

function Stack:GetElementBy(attribute, value)
    for idx, el in ipairs(self._container) do
        if el[attribute] == value then
            return el
        end
    end
    return nil
end
 
function Stack:Triverse ()
    return stack_iter, self, 0
end

function Stack:ctor()
    self._container = {}
end

function Stack:Get(i)
    return self._container[i]
end

function Stack:Push(element)
    table.insert(self._container, element)
end

function Stack:Top()
    if #self._container > 0 then
        return self._container[#self._container]
    end
    return nil
end

function Stack:Remove(element)
    for i = 1, #self._container do 
        if self._container[i] == element then
            table.remove(self._container, i)
        end
    end
end

function Stack:Clear()
    self._container = {}
end

function Stack:Pop()
    --移除最后一个
    local element = self._container[#self._container]
    table.remove(self._container, #self._container)
    return element
end

function Stack:Count()
    return #self._container
end