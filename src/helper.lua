----------------------------------------------------------------------------------------------------
-- Disable helper
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

SurvivalHelpers = {}
SurvivalHelpers.name = "SurvivalHelpers"

function SurvivalHelpers:loadMap ()
    g_currentMission.disableAIVehicle = true
end

addModEventListener(SurvivalHelpers)
