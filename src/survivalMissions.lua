SurvivalMissions = {}
SurvivalMissions.name = "SurvivalMissions"
SurvivalMissions.fieldToMission = {}
SurvivalMissions.fieldToMissionUpdateTimeout = 5000
SurvivalMissions.fieldToMissionUpdateTimer = 5000

function SurvivalMissions:loadMap()
    print('Survival: Mission impossible 19')

    -- Optimize mission rewards
    AbstractFieldMission.REWARD_PER_HA = 600
    CultivateMission.REWARD_PER_HA = 700
    FertilizeMission.REWARD_PER_HA = 200
    FertilizeMission.REIMBURSEMENT_PER_HA = 200
    HarvestMission.REWARD_PER_HA_SMALL = 1000
    HarvestMission.REWARD_PER_HA_WIDE = 700
    PlowMission.REWARD_PER_HA = 1400
    SowMission.REWARD_PER_HA = 500
    SprayMission.REWARD_PER_HA = 150
    SprayMission.REIMBURSEMENT_PER_HA = 200


    -- Mission generation
    MissionManager.MAX_MISSIONS_PER_GENERATION = 20
    MissionManager.MAX_TRIES_PER_GENERATION = 10
    MissionManager.MAX_MISSIONS = 100
    MissionManager.MISSION_GENERATION_INTERVAL = 1800000
    MissionManager.MAX_TRANSPORT_MISSIONS = 0
    MissionManager.AI_PRICE_MULTIPLIER = 10

    -- Override functions
    InGameMenuContractsFrame.setButtonsForState = Utils.overwrittenFunction(InGameMenuContractsFrame.setButtonsForState, SurvivalMissions.setButtonsForState)
    MissionManager.hasFarmActiveMission = Utils.overwrittenFunction(MissionManager.hasFarmActiveMission, SurvivalMissions.hasFarmActiveMission)
end

function SurvivalMissions:update(dt)
    self.fieldToMissionUpdateTimer = self.fieldToMissionUpdateTimer + dt
    if self.fieldToMissionUpdateTimer >= self.fieldToMissionUpdateTimeout then
        self.fieldToMission = {}
        for _, mission in pairs(g_missionManager.missions) do
            if mission.field ~= nil then
                self.fieldToMission[mission.field.fieldId] = mission
            end
        end
        self.fieldToMissionUpdateTimer = 0
    end
end

-- Remove lease button on missions screen
function SurvivalMissions:setButtonsForState(superFunc, state, canLease)
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

function SurvivalMissions:hasFarmActiveMission(superFunc, farmId)
    local count = 0
    for _, mission in ipairs(self.missions) do
        if mission.farmId == farmId and (mission.status == AbstractMission.STATUS_RUNNING or mission.status == AbstractMission.STATUS_FINISHED) then
            count = count + 1
        end
    end

    if count >= 3 then
        return true
    end

	return false
end

function SurvivalMissions.colorForFarm(farmId)
    local farm = g_farmManager:getFarmById(farmId)
    if farm ~= nil then
        local color = Farm.COLORS[farm.color]
        if color ~= nil then
            return color[1], color[2], color[3], color[4]
        end
    end
    return 1, 1, 1, 1
end

function MapHotspot:render(minX, maxX, minY, maxY, scale, drawText)
    if self:getIsVisible() and self.enabled then
        scale = scale or 1

        -- draw bg
        self.overlayBg:setDimension(self.width * self.zoom * scale, self.height * self.zoom * scale)
        self.overlayBg:setPosition(self.x, self.y)

        if not self:getIsActive() then
            self.overlayBg:setColor(unpack(MapHotspot.COLOR.INACTIVE))
        else
            self.overlayBg:setColor(unpack(self.bgImageColor))
        end

        local overlay = self:getOverlay(self.height * self.zoom * g_screenHeight)
        local overlayPosY = self.overlayBg.y + self.overlayBg.height - overlay.height

        if self.verticalAlignment == Overlay.ALIGN_VERTICAL_MIDDLE then
            overlayPosY = self.overlayBg.y + (self.overlayBg.height - overlay.height) * 0.5
        elseif self.verticalAlignment == Overlay.ALIGN_VERTICAL_BOTTOM then
            overlayPosY = self.overlayBg.y
        end

        overlay:setDimension(self.overlayBg.width * self.iconScale, self.overlayBg.height * self.iconScale)
        overlay:setPosition(self.x + self.overlayBg.width * 0.5 - overlay.width * 0.5, overlayPosY)

        if self.blinking then
            self.overlayBg:setColor(nil, nil, nil, IngameMap.alpha)
            overlay:setColor(nil, nil, nil, IngameMap.alpha)
        end

        self.overlayBg:render()
        overlay:render()

        local doRenderText = self.showNameDefault and self.fullViewName ~= "" and (drawText or self.renderLast)
        doRenderText = doRenderText or self.category == MapHotspot.CATEGORY_AI or self.category == MapHotspot.CATEGORY_FIELD_DEFINITION

        if doRenderText then
            if self.category == MapHotspot.CATEGORY_FIELD_DEFINITION and SurvivalMissions.fieldToMission[tonumber(self.fullViewName)] and SurvivalMissions.fieldToMission[tonumber(self.fullViewName)].status ~= 0 then
                -- render custom field number
                local mission = SurvivalMissions.fieldToMission[tonumber(self.fullViewName)]

                setTextBold(true)
                setTextAlignment(self.textAlignment)

                local alpha = 1

                if not mission.success then
                    alpha = IngameMap.alpha
                end

                setTextColor(0, 0, 0, alpha)

                local posX = self.x + (0.5 * self.width + self.textOffsetX) * self.zoom * scale
                local posY = self.y - (self.textSize - self.textOffsetY) * self.zoom * scale

                renderText(posX, posY - 1 / g_screenHeight, self.textSize * self.zoom * scale, self.fullViewName)

                local r, g, b, _ = SurvivalMissions.colorForFarm(mission.farmId)
                setTextColor(r, g, b, alpha)

                renderText(posX + 1 / g_screenWidth, posY, self.textSize * self.zoom * scale, self.fullViewName)
                setTextAlignment(RenderText.ALIGN_LEFT)
                setTextColor(1, 1, 1, 1)
            else
                setTextBold(self.textBold)
                setTextAlignment(self.textAlignment)

                local alpha = 1

                if self.blinking then
                    alpha = IngameMap.alpha
                end

                setTextColor(0, 0, 0, 1)

                local posX = self.x + (0.5 * self.width + self.textOffsetX) * self.zoom * scale
                local posY = self.y - (self.textSize - self.textOffsetY) * self.zoom * scale
                local textWidth = getTextWidth(self.textSize * self.zoom * scale, self.fullViewName) + 1 / g_screenWidth

                if self.category ~= MapHotspot.CATEGORY_FIELD_DEFINITION then
                    posX = math.min(math.max(posX, minX + textWidth * 0.5), maxX - textWidth * 0.5)
                    posY = math.min(math.max(posY, minY), maxY - self.textSize * self.zoom * scale)
                end

                renderText(posX, posY - 1 / g_screenHeight, self.textSize * self.zoom * scale, self.fullViewName)
                setTextColor(self.textColor[1], self.textColor[2], self.textColor[3], alpha)
                renderText(posX + 1 / g_screenWidth, posY, self.textSize * self.zoom * scale, self.fullViewName)
                setTextAlignment(RenderText.ALIGN_LEFT)
                setTextColor(1, 1, 1, 1)
            end
        end
    end
end

addModEventListener(SurvivalMissions)
