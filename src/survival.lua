----------------------------------------------------------------------------------------------------
-- Entry point of FS19_Survival mod
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

Survival = {}
Survival.name = "Survival"

function Survival:loadMap()
    print('Survival: Try not to die!')

    -- disable AI helper
    g_currentMission.disableAIVehicle = true

    -- disable loan
    Farm.MIN_LOAN = 0
    Farm.MAX_LOAN = 0

    -- override lease button callback of shop menu
    ShopConfigScreen.onYesNoLease = Utils.overwrittenFunction(ShopConfigScreen.onYesNoLease, Survival.onYesNoLease)

    -- override sleep check
    SleepManager.getCanSleep = Utils.overwrittenFunction(SleepManager.getCanSleep, Survival.getCanSleep)
end

-- prevent leasing in shop
function Survival:onYesNoLease(superFunc, yes)
    g_gui:showInfoDialog({
        text = g_i18n:getText("leasing_disabled")
    })
end

-- prevent sleeping
function Survival:getCanSleep()
    return false
end

addModEventListener(Survival)
