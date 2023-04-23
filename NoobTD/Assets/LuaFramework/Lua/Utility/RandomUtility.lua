local RandomUtility = {}

function RandomUtility.Shuffle(t, fix_seed)
    if not t then return end
    local cnt = t:Count()
    for i = 1, cnt do
        local j = RandomUtility.Range(i , cnt, fix_seed)
        local temp = t:Get(i)
        t:Replace(i, t:Get(j))
        t:Replace(j, temp)
    end
    return t
end

function RandomUtility.TableWeightedPick(key, table, fix_seed)
    local weights = {}
    local temp    = {}
    local i = 1
    for v, el in pairs(table) do
        weights[i] = el[key]
        temp[i] = el
        i = i + 1
    end

    local index = RandomUtility.WeightedPick(weights , fix_seed)
    return temp[index]
end

function RandomUtility.ArrayWeightedPick(key, array, fix_seed)
    local weights = {}
    for i, el in array:Triverse() do
        weights[i] = el[key]
    end
    local index = RandomUtility.WeightedPick(weights , fix_seed)
    return array:Get(index)
end

--适用于如下情况: N选1, 但每个元素有权重, 返回选中的序号
function RandomUtility.WeightedPick(weights, fix_seed)
    local total = 0
    for i = 1, #weights do
        total = total + weights[i]
    end
    local fac = RandomUtility.Range(1, total, fix_seed)

    -- print("PICK QUALITY-> FAC " .. fac .. " TOTAL " .. total)
    total = 0
    for i = 1, #weights do
        if fac <= total + weights[i] and fac > total then
            return i
        end
        total = total + weights[i]
    end
end

function RandomUtility.IsHit(percent, fix_seed)
    local p = RandomUtility.Range(1, 100, fix_seed)
    return p <= percent
end

function RandomUtility.Range(min, max, fix_seed)
    if fix_seed == true then
        return RandomUtility.CRange(min, max)
    end
    return math.random(min, max)
end

function RandomUtility.CRange(min, max)
    return CRandUtility.Range(min, max + 1)
end

function RandomUtility.PickOne(array, fix_seed)
    if array.Count ~= nil then
        if array:Count() == 0 then return nil end
        local count = array:Count()
        local c = RandomUtility.Range(1, count, fix_seed)
        return array:Get(c)
    else
        if #array == 0 then return nil end
        return array[RandomUtility.Range(1, #array, fix_seed)]
    end
end

function RandomUtility.Get(array, condition)
    local picked = Class.new(Array)
    for i = 1, #array do
        if condition == nil then
            picked:Add(array[i])
        elseif condition(array[i]) == true then
            picked:Add(array[i])
        end
    end
    return picked
end

--从中随机出number个array
function RandomUtility.Pick(number, array, condition , fix_seed)
    local picked = Class.new(Array)
    local indexes = Class.new(Array)

    if array.Count ~= nil then
        for i = 1, array:Count() do
            if condition == nil then
                indexes:Add(i)
            elseif condition(array:Get(i)) == true then
                indexes:Add(i)
            end
        end
        for i = 1, number do 
            if indexes:Count() ~= 0 then    
                local index = RandomUtility.Range(1, indexes:Count(), fix_seed)
                local pick = array:Get(indexes:Get(index))
                indexes:RemoveAt(index)
                picked:Add(pick)
            end
        end
    else
        for i = 1, #array do
            if condition == nil then
                indexes:Add(i)
            elseif condition(array[i]) == true then
                indexes:Add(i)
            end
        end
                
        for i = 1, number do 
            if indexes:Count() ~= 0 then
                local index = RandomUtility.Range(1, indexes:Count(), fix_seed)
                local pick = array[indexes:Get(index)]
                indexes:RemoveAt(index)
                picked:Add(pick)
            end
        end
    end

    return picked
end

return RandomUtility