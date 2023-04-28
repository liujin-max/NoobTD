--战场场景 数据类
-- 1920 * 1080
-- 19 * 10

local Land = Class.define("Battle.Land")


--cfg => battle_field_1001...
function Land:ctor(field, cfg)
    self.Field      = field

    --路线
    self.Lines      = Class.new(Array)
    for i, cfg in ipairs(cfg.Lines) do
        local line  = Class.new(Battle.RouteLine, self, cfg)
        self.Lines:Add(line)
    end

    --防守位
    self.Defenders  = Class.new(Array)
    for i, cfg in ipairs(cfg.Defender) do
        local line  = Class.new(Battle.Defender, self, cfg)
        self.Defenders:Add(line)
    end
end

function Land:Decorate()
    self.Avatar = Class.new(Display.Land, self)
    self.Avatar:Decorate()

    self.Defenders:Each(function(g)
        g:Decorate()        
    end)
end

function Land:Dispose()
    self.Avatar:Dispose()
end

function Land:GetLines()
    return self.Lines
end

function Land:Update(deltatime)
    
end



return Land