----------------------------------------------------------------------------------------------------
-- Entry point of FS22_Survival mod
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------
Survival = {}
Survival.name = "Survival"

function Survival:loadMap()
    print('Survival: Difficulty raised!')

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

    -- override animal trigger
    -- AnimalLoadingTrigger.showAnimalScreen = Utils.overwrittenFunction(AnimalLoadingTrigger.showAnimalScreen, Survival.showAnimalScreen)
end

-- prevent leasing in shop
function Survival:updateButtons(storeItem, vehicle, saleItem)
	storeItem.allowLeasing = false
end

-- return false to disable overwritten function
function Survival:disableFunction()
    return false
end

function Survival:showAnimalScreen(husbandary)
    if husbandry == nil and self.loadingVehicle == nil then
		g_gui:showInfoDialog({
			text = g_i18n:getText("shop_messageNoHusbandries")
		})

		return
	end

	local controller = nil

	if husbandry ~= nil and self.loadingVehicle == nil then
        print('Survival: change this method?!')
		controller = AnimalScreenDealerFarm.new(husbandry)
	elseif husbandry == nil and self.loadingVehicle ~= nil then
		controller = AnimalScreenDealerTrailer.new(self.loadingVehicle)
	else
		controller = AnimalScreenTrailerFarm.new(husbandry, self.loadingVehicle)
	end

	if controller ~= nil then
		controller:init()
		g_animalScreen:setController(controller)
		g_gui:showGui("AnimalScreen")
	end
end

addModEventListener(Survival)
