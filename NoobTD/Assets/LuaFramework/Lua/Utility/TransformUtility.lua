local TransformUtility = {}

function TransformUtility.AddTo(entity, parent, offset)
    entity.transform:SetParent(parent.transform)
    entity.transform.localPosition = Vector3.zero
end

return TransformUtility