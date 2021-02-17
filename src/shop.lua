----------------------------------------------------------------------------------------------------
-- Disable leasing in shop menu
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------
print('load shop.lua')
function ShopController:buyVehicle(vehicleStoreItem, price, outsideBuy)
    print('tinte ShopController:buyVehicle')
    self.buyItemFilename = vehicleStoreItem.xmlFilename
    self.buyItemPrice = price
    self.buyItemIsOutsideBuy = outsideBuy or false
    self.buyItemConfigurations = nil
    self.buyItemIsLeasing = false

    if StoreItemUtil.getIsLeasable(vehicleStoreItem) then
        self.switchToConfigurationCallback(vehicleStoreItem)
    elseif self:canBeBought(vehicleStoreItem, price) then
        self:finalizeBuy()
    end
end

ShopConfigScreen.CONTROLS.LEASE_BUTTON = {}

function ShopConfigScreen:onOpen(element)
    print('tinte ShopConfigScreen:onOpen')
	ShopConfigScreen:superClass().onOpen(self)
	g_depthOfFieldManager:reset()
	setSceneBrightness(getBrightness())
	self:updateBalanceText()
	g_gameStateManager:setGameState(GameState.MENU_SHOP_CONFIG)
	self.currentMission.environment:setCustomLighting(self.shopLighting)
	setVisibility(self.workshopRootNode, true)

	self.previousCamera = getCamera()

	setCamera(self.cameraNode)
	link(self.workshopRootNode, self.workshopNode)
	self:updateInputGlyphs()
	self:toggleCustomInputContext(true, ShopConfigScreen.INPUT_CONTEXT_NAME)
	self:registerInputActions()
	self:selectFirstConfig()
end

function ShopConfigScreen:onYesNoLease(yes)
    print('tinte ShopConfigScreen:onYesNoLease')
	if yes then
		self:onCallback(false, self.storeItem, self.configurations)
	end
end

function ShopConfigScreen:onClickActivate()
    print('tinte ShopConfigScreen:onClickActivate')
	if self.vehicle ~= nil then
		return
	end

	if not self.storeItem.allowLeasing then
		return
	end

	local enoughMoney = self.initialLeasingCosts <= self.currentMission:getMoney()
	local enoughSlots = self.currentMission:hasEnoughSlots(self.storeItem)

	self.inputManager:setShowMouseCursor(true)

	if not enoughMoney then
		self:playSample(GuiSoundPlayer.SOUND_SAMPLES.ERROR)
		g_gui:showInfoDialog({
			text = self.l10n:getText(ShopConfigScreen.L10N_SYMBOL.NOT_ENOUGH_MONEY_LEASE)
		})
	elseif not enoughSlots then
		self:playSample(GuiSoundPlayer.SOUND_SAMPLES.ERROR)
		g_gui:showInfoDialog({
			text = self.l10n:getText(ShopConfigScreen.L10N_SYMBOL.TOO_FEW_SLOTS)
		})
	else
		self:playSample(GuiSoundPlayer.SOUND_SAMPLES.CLICK)

		local text = string.format(self.l10n:getText(ShopConfigScreen.L10N_SYMBOL.CONFIRM_LEASE), self.l10n:formatMoney(self.initialLeasingCosts, 0, true, false))

		g_gui:showYesNoDialog({
			text = text,
			callback = self.onYesNoLease,
			target = self
		})
	end
end
