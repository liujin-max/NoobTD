
--输出日志--
function log(str)
    Util.Log(str);
end

--错误日志--
function logError(str) 
	Util.LogError(str);
end

--警告日志--
function logWarn(str) 
	Util.LogWarning(str);
end

function isNull(obj)
    return Util.IsNull(obj)
end

function round(x)
    return math.floor(x + .5)
end

function FLOOR(x)
    return math.floor(x + 0.001)
end

function exchange(x)
    local a1 = x * 10000
    local a2 = math.floor(a1)
    local a3 = a2 / 10000
    return a3
end


--查找对象--
function find(str)
	return GameObject.Find(str);
end

function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function destroy(obj)
    -- if obj ~= nil then
    --     print("DESTROY OBJECT " .. obj.name .. debug.traceback())
    -- end

    if obj == nil then
        -- error("DESTROY NIL " .. debug.traceback())
        return
    end
    -- else
    --     print("========POOL DELETE " .. obj.name .. " " .. tostring(obj:GetHashCode()) .. " " .. debug.traceback())
    -- end

    GameObject.Destroy(obj);
    obj = nil
end

function destroy_immediate(obj)
    GameObject.DestroyImmediate(obj);
    obj = nil
end

function widthSingle(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
   local lenInByte = #inputstr
   local width = 0
   local i = 1
   while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1                                           --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                           --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                           --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                           --4字节字符
        end
        local char = string.sub(inputstr, i, i+byteCount-1)                                                     
        i = i + byteCount                                 -- 重置下一字节的索引
        width = width + 1                                 -- 字符的个数（长度）
    end
    return width
end

local function charsize(ch)
    if not ch then 
        return 0 
    elseif ch >=252 then 
        return 6 
    elseif ch >= 248 and ch < 252 then 
        return 5
    elseif ch >= 240 and ch < 248 then 
        return 4
    elseif ch >= 224 and ch < 240 then 
        return 3
    elseif ch >= 192 and ch < 224 then 
        return 2
    elseif ch < 192 then 
        return 1 
    end
end

-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如utf8len("1你好") => 3
function utf8len(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = charsize(char)
        currentIndex = currentIndex + cs
        len = len +1
        if cs == 1 then 
            aNum = aNum + 1
        elseif cs >= 2 then 
            hNum = hNum + 1
        end
    end
    return len, aNum, hNum
end

-- 截取utf8 字符串
-- str:            要截取的字符串
-- startChar:    开始字符下标,从1开始
-- numChars:    要截取的字符长度
function utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + charsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + charsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end


function substring(content, start, last)
    return string.sub(content, start, last)
end

function replace(content, words, val)
    return string.gsub(words, "#", val) 
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

function math.clamp(v, minValue, maxValue)  
    if v < minValue then
        return minValue
    end
    if( v > maxValue) then
        return maxValue
    end
    return v 
end

function print_class_name(instance, extra)
    assert(instance.class ~= nil, " Not a valid class :" .. tostring(instance))
    print(instance.class.className .. tostring(extra))
end

function print_type( data ,iter )
    iter = iter or 6;
    local function print_t (data ,iterMax,formatCount,str)
        if iterMax ~= nil then
            if iterMax < 0 then
                return;
            end
            iterMax = iterMax - 1;
        end
        formatCount = formatCount + 1;
        if type(data) ~= "table" then
            if type(data) == "string" then
                str = str .. "\"" .. data .. "\"";
            else
                str = str .. tostring(data);
            end
        else
            str = str .. "\n";
            for i = 1,formatCount - 1 do str = str .. "        " end
            str = str .. "{\n";
            for k,v in pairs(data) do
                local isPrint = false
                if iterMax ~= nil  then
                    if iterMax >= 0 then
                        isPrint = true
                    end
                else
                    isPrint = true
                end

                if isPrint then
                    local string = "";
                    if type(k) == "string" then
                        string =  "\"" .. tostring(k) .. "\"" .. " = "; 
                    elseif type(k) == "number" then
                        string =  "[" .. tostring(k) .. "]" .. " = "; 
                    else string =  tostring(k) .. " = "; 
                    end

                    for i = 1,formatCount do str = str .. "        " end
                    str = str .. string;
                    local ss = print_t(v,iterMax,formatCount,str);
                    str = ss .. ",\n"; 
                end
            end
            for i = 1,formatCount - 1 do str = str .. "        " end
            str = str .. "}";
        end
        return str ;
    end

    local str = "print_type输出:"
    local sss = print_t(data,iter,0,str)
    print(sss);
end

function Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    
    while true do
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
       if not nFindLastIndex then
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
        break
       end
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)
       nSplitIndex = nSplitIndex + 1
    end

    return nSplitArray
end

--阶乘函数
function fact(n)            
    if n == 0 then
        return 1
     else
       return n * fact(n-1)
     end                   
 end   

 --保留number小数点后n位
 function GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end

 --数字单位换算 过万转换
function SetShowNumber(number, force_million)
    local show_num  = number or 0
    local flag      = show_num > 0 and 1 or -1
    local abs_num   = math.abs(show_num)

    if abs_num >= 1000000 and force_million == true then
        return string.format("%.2f", GetPreciseDecimal(show_num / 1000000, 2)) .. "百万"

    elseif abs_num >= 10000 then
            
        return string.format("%.1f", GetPreciseDecimal(show_num / 10000, 1)) .. "万"
    end

    return show_num
end

--时间戳转换成累计时长
function getCumulativeTime(stamp)
    local hour      = math.floor(stamp / (60 * 60))
    local minute    = hour > 0 and math.floor( stamp / 60 - (hour * 60) ) or math.floor( stamp / 60 )
    local second    = stamp - (minute > 0 and minute * 60 or 0) - (hour > 0 and hour * 60 * 60 or 0)

    local time      = ""
    if hour > 0 then
        time = time .. hour .. "小时"
    end

    if minute > 0 or hour > 0 then
        time = time .. minute .. "分"
    end


    time = time .. second .. "秒"

    local h_t   = hour == 0 and "00" or hour
    local m_t   = minute == 0 and "00" or string.format("%02d", minute)
    local s_t   = second == 0 and "00" or string.format("%02d", second)

    return time, h_t, m_t, s_t
end

function getCumulativeDay(stamp)
    local hour      = math.floor(stamp / (60 * 60))
    local minute    = hour > 0 and math.floor( stamp / 60 - (hour * 60) ) or math.floor( stamp / 60 )
    local second    = stamp - (minute > 0 and minute * 60 or 0) - (hour > 0 and hour * 60 * 60 or 0)

    local day       = math.floor(hour / 24)
    hour            = hour - day * 24

    local time      = ""

    if day > 0 then
        time = time .. day .. "天"
    end
    
    if hour > 0 then
        time = time .. string.format("%02d", hour) .. "小时"
    end

    if minute > 0 or hour > 0 then
        time = time .. string.format("%02d", minute) .. "分"
    end


    time = time .. string.format("%02d", second) .. "秒"

    local d_t   = day == 0 and "0" or day
    local h_t   = hour == 0 and "00" or hour
    local m_t   = minute == 0 and "00" or string.format("%02d", minute)
    local s_t   = second == 0 and "00" or string.format("%02d", second)

    return time, d_t, h_t, m_t, s_t, day, hour, minute, second
end

function byte2bin(n)
    local t = {}
    for i = 7, 0, -1 do
        t[#t+1] = math.floor(n / 2^i)
        n = n % 2^i
    end
    return table.concat(t), t
end

--点pf到线段(p1,p2)的距离
function GetPointDistanceLine(pf, p1, p2)
    if p1 == nil or p2 == nil then
        return false
    end

    --点在线段首尾两端之外则return false
    local cross = (p2.x - p1.x) * (pf.x - p1.x) + (p2.y - p1.y) * (pf.y - p1.y)
    if cross <= 0 then return false end
    local d2 = (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)
    if cross >= d2 then return false end


    local r = cross / d2
    local px = p1.x + (p2.x - p1.x) * r
    local py = p1.y + (p2.y - p1.y) * r

    --判断距离是否小于误差
    return true, math.sqrt((pf.x - px) * (pf.x - px) + (py - pf.y) * (py - pf.y)), Vector3.New(px, py, 0)
end

function IsPointInvalid(point)
    return point.x == -1000 and point.y == -1000
end

function CheckCollide(p_pos, last_pos, p_start, p_end)
    local point = GameUtil.SegmentsInterPoint(p_pos, last_pos, p_start, p_end)
    if IsPointInvalid(point) == false then
        return true, point
    end

    return false
end