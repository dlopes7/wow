--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2024-10-13T06:15:45Z",numCharacters=53,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 8
F = function() provider.lookup[1] = "\10\13\10\13\10\13\4\4" end F()

F = nil
RaiderIO.AddProvider(provider)
