--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2024-08-26T06:14:28Z",numCharacters=19,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 22
F = function() provider.lookup[1] = "\10\25\10\25\10\25\10\25\10\25\10\25\10\25\10\25\10\25\4\16\4\4" end F()

F = nil
RaiderIO.AddProvider(provider)
