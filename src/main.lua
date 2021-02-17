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

function Survival:init()
    print('Survival: init')
    Survival.addModTranslations(g_i18n)
end

function Survival:delete()
    print('Survival: delete')
    Survival.removeModTranslations(g_i18n)
end

---Copy our translations to global space.
function Survival.addModTranslations(i18n)
    print('Survival: addModTranslations')
    -- We can copy all our translations to the global table because we prefix everything with survival_
    -- The mod-based l10n lookup only really works for vehicles, not UI and script mods.
    local global = getfenv(0).g_i18n.texts

    for key, text in pairs(i18n.texts) do
        global[key] = text
    end
end

---Remove mod translations to prevent duplicated next time it gets loaded
function Survival.removeModTranslations(i18n)
    print('Survival: removeModTranslations')
    local global = getfenv(0).g_i18n.texts
    for key, text in pairs(i18n.texts) do
        global[key] = nil
    end
end

addModEventListener(Survival)
