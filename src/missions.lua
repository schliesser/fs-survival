----------------------------------------------------------------------------------------------------
-- Disable leasing of machines for missions
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

-- Override lease button function
function InGameMenuContractsFrame:onButtonLease()
  -- Use false to prevent leasing
  self:startContract(false)
end

-- Remove button
function InGameMenuContractsFrame:setButtonsForState(state, canLease)
    local info = {
        self.backButtonInfo
    }
    local hasPermission = g_currentMission:getHasPlayerPermission(Farm.PERMISSION.MANAGE_CONTRACTS)

    if state == InGameMenuContractsFrame.BUTTON_STATE.FINISHED then
        table.insert(info, self.dismissButtonInfo)

        self.dismissButtonInfo.disabled = not hasPermission
    elseif state == InGameMenuContractsFrame.BUTTON_STATE.ACTIVE then
        table.insert(info, self.cancelButtonInfo)

        self.cancelButtonInfo.disabled = not hasPermission
    elseif #self.contracts == 0 then
        -- Nothing
    else
        table.insert(info, self.acceptButtonInfo)

        self.acceptButtonInfo.disabled = not hasPermission
    end

    self.menuButtonInfo = info

    self:setMenuButtonInfoDirty()
end

-- Change rewards amount
AbstractFieldMission.REWARD_PER_HA = 600
CultivateMission.REWARD_PER_HA = 700
FertilizeMission.REWARD_PER_HA = 350
HarvestMission.REWARD_PER_HA_SMALL = 800
HarvestMission.REWARD_PER_HA_WIDE = 600
PlowMission.REWARD_PER_HA = 1200
SowMission.REWARD_PER_HA = 750
SprayMission.REWARD_PER_HA = 150
