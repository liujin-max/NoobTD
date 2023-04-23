--数组: 用lua做Array容器
Array  = Class.define("Array");

local function array_iter (a, i)
    i = i + 1
    local v = a:Get(i)
    if v then
       return i, v
    end
end
 
function Array:Triverse()
    return array_iter, self, 0
end

--构造函数
function Array:ctor()
    self.container = {}
end

function Array:Insert(element, i)
    if element == nil then return end
    table.insert(self.container,i, element)
end

function Array:Tail(element)
    table.insert(self.container, #self.container, element)
end

--加入元素
function Array:Add(element)
    table.insert(self.container, element)
end

function Array:RemoveAt(i)
    table.remove(self.container, i)
end

function Array:IndexOfComplex(func, fromback)
    if fromback == true then
        for k = #self.container, 1, -1 do
            local el = self.container[k]
            if func(el) == true then
                return k
            end
        end
    else
        for k, el in ipairs(self.container) do
            if func(el) == true then
                return k
            end
        end
    end
    return -1
end

--fromback: 从后往前数
function Array:IndexOf(element, fromback)
    if fromback == true then
        for k = #self.container, 1, -1 do
            local el = self.container[k]
            if el == element then
                return k
            end
        end
    else
        for k, el in ipairs(self.container) do
            if el == element then
                return k
            end
        end
    end
    return nil
end

function Array:Contains(element)
    for k, el in ipairs(self.container) do
        if el == element then
            return k
        end
    end
    return nil
end

--删除元素
function Array:Remove(element)
    for idx, el in ipairs(self.container) do
        if el == element then
            table.remove(self.container, idx)
            return true
        end
    end
    return false
end

function Array:Concat(arr)
    if arr == nil then return end
    for k, v in arr:Triverse() do
        self:Add(v)
    end
end

function Array:Sub(start, over)
    local ret = Class.new(Array)
    if over == nil then
        over = self:Count()
    end
    for i = start, over do
        ret:Add(self:Get(i))
    end
    return ret
end

function Array:Count()
    return #self.container
end

function Array:Replace(i, element)
    self.container[i] = element
end

function Array:Get(i)
    return self.container[i]
end

function Array:Clear()
    self.container = {}
end

--对于数字类的属性, 进行排序
function Array:SortBy(attribute, isdesc)
    table.sort(self.container, function(a1, a2)
        if isdesc then
            return a1[attribute] > a2[attribute]
        else
            return a1[attribute] < a2[attribute]
        end
     end)
end

function Array:Sort(sort_func)
    table.sort(self.container, sort_func)
end

function Array:Each(func)
    for idx, el in ipairs(self.container) do
        func(el, idx)
    end
end

--根据属性来获取元素
function Array:GetElementBy(attribute, value)
    for idx, el in ipairs(self.container) do
        if el[attribute] == value then
            return el
        end
    end
    return nil
end

--根据属性来获取元素
function Array:GetElementsBy(func)
    local list = Class.new(Array)
    for idx, el in ipairs(self.container) do
        if func(el) == true then
            list:Add(el)
        end
    end
    return list
end

--根据属性判断是否存在
function Array:HasElementBy(attribute, value)
    for idx, el in ipairs(self.container) do
        if el[attribute]:Equals(value) then
            return true
        end
    end
    return false
end

--是否有存在element
function Array:Has(element)
    for idx, el in ipairs(self.container) do
        if el == element then
            return true
        end
    end
    return false
end

function Array:Last()
    if #self.container == 0 then return nil end
    return self.container[#self.container]
end

function Array:First()
    if #self.container == 0 then return nil end
    return self.container[1]
end

function Array.Copy(a, func)
    local c = Class.new(Array)
    for i = 1, a:Count() do
        if func ~= nil and func(a:Get(i)) == true then
            c:Add(a:Get(i))
        end
    end
    return c
end

function Array:AddFromTable(tab,pair)
    if tab == nil then
        return 
    end
    if pair then
        for _,v in pairs(tab) do
            table.insert(self.container, v)
        end
    else
        for _,v in ipairs(tab) do
            table.insert(self.container, v)
        end
    end
end

function Array:CleanDisplay()
    for _, display in ipairs(self.container) do
        destroy(display.GO)
    end
    self.container = {}
end