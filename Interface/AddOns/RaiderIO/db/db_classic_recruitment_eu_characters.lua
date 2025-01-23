--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2025-01-22T06:09:41Z",numCharacters=24,db={}}
local F

F = function() provider.db["Flamegor"]={0,"Медифв"} end F()
F = function() provider.db["Golemagg"]={2,"Sugynopr"} end F()

F = nil
RaiderIO.AddProvider(provider)
