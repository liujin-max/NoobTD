local NoticeItem = {}

function NoticeItem:Awake(items)
    self.GO     = items["This"]
    self.Text   = items["Text"]
end

function NoticeItem:Init(_text)
    self.Text.text  = _text
end

function NoticeItem:OnDestroy()

end


return NoticeItem