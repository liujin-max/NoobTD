Queue = Class.define("Queue")

local function queue_iter (a, i)
    i = i + 1
    local v = a:Get(i)
    if v then
       return i, v
    end
end
 
function Queue:Triverse ()
    return queue_iter, self, 0
end

function Queue:ctor()
    self._container = {}
end

function Queue:EnQueue(element)
    table.insert(self._container, element)
end

function Queue:Head()
    if #self._container == 0 then return nil end
    return self._container[1]
end

function Queue:Tail()
    if #self._container == 0 then return nil end
    return self._container[#self._container]
end

function Queue:Insert(element)
    table.insert(self._container, 1, element)
end

function Queue:Contains(element)
    for k, el in ipairs(self._container) do
        if el == element then
            return k
        end
    end
    return nil
end

function Queue:Clear()
    self._container = {}
end

function Queue:DeQueue()
    --移除最后一个
    local element = self._container[1]
    table.remove(self._container, 1)
    return element
end

function Queue:Count()
    return #self._container
end