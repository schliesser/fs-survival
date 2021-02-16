----------------------------------------------------------------------------------------------------
-- Override lease button function
-- Use false to prevent leasing
--
-- Copyright (c) Schliesser, 2021
----------------------------------------------------------------------------------------------------
function InGameMenuContractsFrame:onButtonLease()
  self:startContract(false)
end
