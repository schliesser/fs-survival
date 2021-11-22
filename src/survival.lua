----------------------------------------------------------------------------------------------------
-- Entry point of FS22_Survival mod
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------
Survival = {}
Survival.name = "Survival"

function Survival:loadMap()
    print('Survival: Try not to die!')

    -- disable AI
    g_currentMission.disableAIVehicle = true
    InGameMenuAIFrame.getCanCreateJob = Utils.overwrittenFunction(InGameMenuAIFrame.getCanCreateJob, Survival.disableFunction)
    InGameMenuAIFrame.getCanStartJob = Utils.overwrittenFunction(InGameMenuAIFrame.getCanStartJob, Survival.disableFunction)

    -- disable loan
    Farm.MIN_LOAN = 0
    Farm.MAX_LOAN = 0

    -- override lease button callback of shop menu
    ShopConfigScreen.updateButtons = Utils.prependedFunction(ShopConfigScreen.updateButtons, Survival.updateButtons)

    -- override sleep check
    SleepManager.getCanSleep = Utils.overwrittenFunction(SleepManager.getCanSleep, Survival.disableFunction)
end

-- prevent leasing in shop
function Survival:updateButtons(storeItem, vehicle, saleItem)
	storeItem.allowLeasing = false
end

-- return false to disable overwritten function
function Survival:disableFunction()
    return false
end

addModEventListener(Survival)
