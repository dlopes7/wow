--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="kr",date="2024-11-07T09:18:11Z",numCharacters=32603,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 2
F = function() provider.lookup[1] = ";\16" end F()

F = nil
RaiderIO.AddProvider(provider)
