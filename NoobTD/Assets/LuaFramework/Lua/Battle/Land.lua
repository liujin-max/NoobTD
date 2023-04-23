--战场场景 数据类
-- 1920 * 1080
-- 19 * 10

local Land = Class.define("Battle.Land")


local LandCfg   = 
{
    Lines   = 
    {
        {
            Route = 
            {
                {1,5},{2,5},{3,5},{4,5},{5,5},{6,5},{7,5},{8,5},{9,5},{10,5},
                {11,5},{12,5},{13,5},{14,5},{15,5},{16,5},{17,5},{18,5},{19,5},{20,5},
                {20,6},{20,7},{20,8},{21,8},{22,8},{23,8},{24,8},{25,8},{26,8},{27,8},
                {27,9},{27,10},{27,11},{27,12},{28,12},{29,12},{30,12},
            },

            Spawn   = {1,5},
            Exit    = {30,12}
        }
    },

    
}


function Land:ctor(field)
    self.Field      = field


    --路线
    self.Lines      = Class.new(Array)
    for i, cfg in ipairs(LandCfg.Lines) do
        local line  = Class.new(Battle.RouteLine, self, cfg)
        self.Lines:Add(line)
    end
end

function Land:Display()
    self.Avatar = Class.new(Display.Land, self)
    self.Avatar:Display()

    self.Lines:Each(function(line)
        line:Display()        
    end)
end

function Land:GetLine()
    return self.Lines:First()
end

function Land:Update(deltatime)
    
end



return Land