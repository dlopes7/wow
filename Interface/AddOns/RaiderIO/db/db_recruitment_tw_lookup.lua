--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2025-03-22T20:03:59Z",numCharacters=35441,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 2
F = function() provider.lookup[1] = ";\8" end F()

F = nil
RaiderIO.AddProvider(provider)
