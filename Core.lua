local AddOnName, Engine, _ = ...
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Pet Happiness", {type = "data source", label = "Happiness"})
local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceEvent-3.0")

Engine[1] = AddOn
Engine[2] = LDB
Broker_PetHappiness = Engine

local function UpdateDataObject(object)
    LDB.icon = object.icon or "Interface\\Icons\\INV_Box_PetCarrier_01"
    LDB.text = object.text or ""
    LDB.iconCoords = object.iconCoords or {0, 1, 0, 1}
    LDB.texcoord = LDB.iconCoords
    LDB.OnTooltipShow = function(tooltip)
        object.OnTooltipShow(tooltip)
        LDB.tooltipShown = true
    end
end

local function Update()
    if AddOn.FeedEffectObject.icon then
        AddOn.FeedEffectObject.text = AddOn.HappinessObject.text
        UpdateDataObject(AddOn.FeedEffectObject)
    else
        UpdateDataObject(AddOn.HappinessObject)
    end
end

function AddOn:OnEnable()
    self:RegisterEvent("UNIT_HAPPINESS", Update)
    self:RegisterEvent("UNIT_AURA", Update)
    self:RegisterEvent("UNIT_PET", Update)
    self:RegisterEvent("PET_UI_UPDATE", Update)
end

function AddOn:OnInitialize()
    AddOn.FeedEffectObject:OnInitialize()
    AddOn.HappinessObject:OnInitialize()
    Update()
end

function LDB.OnEnter(self)
    if not LDB.tooltipShown then
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
        GameTooltip:ClearLines()
        LDB.OnTooltipShow(GameTooltip)
        GameTooltip:Show()
    end
end

function LDB.OnLeave()
    GameTooltip:Hide()
    LDB.tooltipShown = nil
end
