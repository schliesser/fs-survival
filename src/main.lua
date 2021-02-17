----------------------------------------------------------------------------------------------------
-- Entry point of FS19_Survival mod
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

-- Do not reset this variable, we can't re-set it again
local modDirectory = g_currentModDirectory

Survival = {}
Survival.name = "Survival"

function Survival:loadMap()
    print('Survival: Try not to die!')

    -- Load files
    source(modDirectory .. "src/noLoan.lua")
    source(modDirectory .. "src/noSleep.lua")
    source(modDirectory .. "src/missions.lua")
    source(modDirectory .. "src/helper.lua")
    source(modDirectory .. "src/shop.lua")
end

addModEventListener(Survival)
