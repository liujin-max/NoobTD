Crypt = {}

local M = {}
M[0]    = 15
M[1]    = 7
M[2]    = 1
M[3]    = 2
M[4]    = 88
M[5]    = -6
M[6]    = -14
M[7]    = 44
M[8]    = -8
M[9]    = 4

function Crypt.TE(v)
    -- return 624 - v
    local r1 = math.random(1, 100)
    local r2 = math.random(1, 100)
    return {r1 ,r2, v - r1 - r2}
end

function Crypt.TD(m)
    -- return 624 - m
    if type(m) == "table" then
        local v = 0
        for index, value in ipairs(m) do
            v = v + value
        end
        return v
    end
    return m
end

function Crypt.E(v)
    -- return (4351 - v) / 10
    local r1 = math.random(1, 100)
    local r2 = math.random(1, 100)
    return {r1 ,r2, v - r1 - r2}
end

function Crypt.D(m)
    -- return 4351 - m * 10
    if type(m) == "table" then
        local v = 0
        for index, value in ipairs(m) do
            v = v + value
        end
        return v
    end
    return m
end

function Crypt.DV(config)
    for i = 1, #config do
        config[i].value = Crypt.TD(config[i].value)
    end

    return config
end

function Crypt.Complex(N)
    local s = tostring(N)

    local CRC = 0
    for i = 1, #s do
        local t = string.sub(s, i, i)
        local num = tonumber(t)
        if num ~= nil and M[num] ~= nil then
            CRC = CRC + M[num]
        end
    end

    return CRC
end




function Crypt.ME(message)
    local seed = MATCHLIST.Rand()

    local new_msg       = ""
    local currentIndex  = 1

    while currentIndex <= #message do
        local char      = string.byte(message, currentIndex)
        local cs        = charsize(char)

        local c         = string.sub(message, currentIndex, currentIndex + cs - 1)
        local new_c     = MATCHLIST.Match(c, seed)
        new_msg         = new_msg .. new_c

        currentIndex    = currentIndex + cs
    end

    new_msg         = seed .. new_msg
    return new_msg
end

function Crypt.MD(message)
    local seed      = tonumber(string.sub(message, 1, 2))
    message         = string.sub(message, 3)

    local count     = MATCHLIST.ListCount()
    local offx      = seed % count

    -- print("测试输出 解密：" .. message .. "," .. seed .. "," .. offx)

    local new_msg   = ""

    local currentIndex = 1
    while currentIndex <= #message do
        local char      = string.byte(message, currentIndex)
        local cs        = charsize(char)

        local c         = string.sub(message, currentIndex, currentIndex + cs - 1)
        local new_c     = MATCHLIST.RevertMatch(c, offx)
        new_msg         = new_msg .. new_c

        currentIndex    = currentIndex + cs
    end

    -- print("测试输出 解密后：" .. new_msg)
    return new_msg
end