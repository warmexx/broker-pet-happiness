local AddOn, LDB = unpack(Broker_PetHappiness)
local DataObject = {}
local AE = LibStub("AceEvent-3.0"):Embed(DataObject)

AddOn.FeedEffectObject = DataObject

local SPELL_FEED_PET = 1539

local function Update(unit)
    DataObject.index = nil
    DataObject.icon = nil
    DataObject.text = nil

    local name, icon, spellId, _
    local index = 1
    repeat
        name, icon, _, _, _, _, _, _, _, spellId = UnitBuff("pet", index, "HELPFUL")
        if spellId == SPELL_FEED_PET then
            DataObject.index = index
            DataObject.icon = icon
            DataObject.text = name
        end
        index = index + 1
    until not name or spellId == SPELL_FEED_PET
end

function DataObject.OnInitialize(self)
    self:RegisterEvent("UNIT_AURA", Update)
end

function DataObject.OnTooltipShow(tooltip)
    if DataObject.index then
        tooltip:SetUnitBuff("pet", DataObject.index)
    end
end
