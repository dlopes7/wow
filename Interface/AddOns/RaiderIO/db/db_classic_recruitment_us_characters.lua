--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2025-01-22T06:09:41Z",numCharacters=24,db={}}
local F

F = function() provider.db["Benediction"]={0,"Abbilene","Abbilify","Abbillanica","Abbizolam","Abbriella","Daestronous","Daestrous","Focalin","Vaerynd"} end F()
F = function() provider.db["Whitemane"]={18,"Bigeasy"} end F()
F = function() provider.db["Mankrik"]={20,"Baitandtackl","Blazem","Drulino","Fleshharvest","Galacnocok","Kadron","Message","Tyder","Tydesin","Tydison","Viscerill","Weast"} end F()

F = nil
RaiderIO.AddProvider(provider)
