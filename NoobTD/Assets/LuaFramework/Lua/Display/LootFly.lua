local LootFly = {}

function LootFly.Normal(loot, scene_tag)
    --根据loot 获取到对应的物品
    local product = loot.Product
    local exp     = loot.Exp
    local coin    = loot.Coin
    local search  = loot.SearchPoint

    for i = 1, 3 do
        local entity    = AssetManager:LoadSync("Prefab/fly_item_900002")
        Controller.Scene.Attach(scene_tag, entity)
        local lootfly   =  entity:GetComponent("LootFly")
        lootfly:GO(Vector3.New(0,5.92,0), Vector3.New(-3.24,0.98,0))
    end

    for i = 1, 2 do
        local entity    = AssetManager:LoadSync("Prefab/fly_item_900000")
        Controller.Scene.Attach(scene_tag, entity)
        local lootfly   =  entity:GetComponent("LootFly")
        lootfly:GO(Vector3.New(0,5.92,0), Vector3.New(-3.24,0.98,0))
    end

    for i = 1, 4 do
        local entity    = AssetManager:LoadSync("Prefab/fly_item_900005")
        Controller.Scene.Attach(scene_tag, entity)
        local lootfly   =  entity:GetComponent("LootFly")
        lootfly:GO(Vector3.New(0,5.92,0), Vector3.New(0,-2.3,0))
    end
end



return LootFly