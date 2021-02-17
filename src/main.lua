----------------------------------------------------------------------------------------------------
-- Entry point of FS19_Survival mod
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

print('Survival: Try not to die!')

-- Do not reset this variable, we can't re-set it again
local modDirectory = g_currentModDirectory

-- Load files
source(modDirectory .. "src/noLoan.lua")
source(modDirectory .. "src/noSleep.lua")
source(modDirectory .. "src/missions.lua")
source(modDirectory .. "src/helper.lua")
