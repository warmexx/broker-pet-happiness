local AddOn, LDB = unpack(Broker_PetHappiness)
local DataObject = {}
local AE = LibStub("AceEvent-3.0"):Embed(DataObject)

AddOn.HappinessObject = DataObject

local function Update()
    local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
    local hasPetUI, isHunterPet = HasPetUI()
    if not happiness or not isHunterPet then
        DataObject.icon = nil
        DataObject.text = nil
        DataObject.iconCoords = nil
        return
    end

    DataObject.icon = "Interface\\PetPaperDollFrame\\UI-PetHappiness"
    DataObject.text = format(PERCENTAGE_STRING, damagePercentage)

    if happiness == 1 then
        DataObject.iconCoords = {0.375, 0.5625, 0, 0.359375}
    elseif happiness == 2 then
        DataObject.iconCoords = {0.1875, 0.375, 0, 0.359375}
    elseif happiness == 3 then
        DataObject.iconCoords = {0, 0.1875, 0, 0.359375}
    end

    DataObject.tooltip = _G["PET_HAPPINESS" .. happiness]
    DataObject.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage)
    DataObject.tooltipDiet = format(PET_DIET_TEMPLATE, BuildListString(GetPetFoodTypes()))
    if loyaltyRate < 0 then
        DataObject.tooltipLoyalty = _G["LOSING_LOYALTY"]
        DataObject.text = DataObject.text .. " " .. loyaltyRate
    elseif loyaltyRate > 0 then
        DataObject.tooltipLoyalty = _G["GAINING_LOYALTY"]
        DataObject.text = DataObject.text .. " +" .. loyaltyRate
    else
        DataObject.tooltipLoyalty = nil
    end
end

function DataObject.OnInitialize(self)
    self:RegisterEvent("UNIT_HAPPINESS", Update)
    self:RegisterEvent("UNIT_PET", Update)
    self:RegisterEvent("PET_UI_UPDATE", Update)
    Update()
end

function DataObject.OnTooltipShow(tooltip)
    if not DataObject.text then
        tooltip:SetText(HAPPINESS, 1, 1, 1)
        tooltip:AddLine(ERR_NO_PET)
        return
    end

    tooltip:SetText(DataObject.tooltip, 1, 1, 1)
    tooltip:AddLine(DataObject.tooltipDamage)
    if DataObject.tooltipLoyalty then
        tooltip:AddLine(DataObject.tooltipLoyalty)
    end
    tooltip:AddLine(" ")
    tooltip:AddLine(DataObject.tooltipDiet)
	
    local currXP, nextXP = GetPetExperience()
    if ( nextXP == 0 ) then
        return
    end
    GameTooltip_ShowProgressBar(tooltip, min(0, currXP), nextXP, currXP, PERCENTAGE_STRING:format(math.floor((currXP/nextXP) * 100)))
end
