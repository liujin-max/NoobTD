local TestItem = {}

function TestItem:Awake(items)
    self.Title = items["Title"]
end


function TestItem:OnDestroy()

end


return TestItem