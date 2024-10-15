--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2024-10-14T07:57:38Z",numCharacters=30064,db={}}
local F

F = function() provider.db["眾星之子"]={0,"魘塵"} end F()
F = function() provider.db["語風"]={2,"Solozdruid","Solozmage"} end F()

F = nil
RaiderIO.AddProvider(provider)
