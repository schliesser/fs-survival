----------------------------------------------------------------------------------------------------
-- Disable leasing in shop menu
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------

-- override lease button callback
function ShopConfigScreen:onYesNoLease(yes)
    g_gui:showInfoDialog({
        text = "Leasing is disabled!"
    })
end
