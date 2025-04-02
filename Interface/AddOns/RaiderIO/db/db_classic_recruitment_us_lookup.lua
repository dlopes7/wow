--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2025-04-02T06:05:32Z",numCharacters=100,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 56
F = function() provider.lookup[1] = "\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29\4\16\10\29\10\29\10\29\10\29\10\29\10\29\10\29\10\29" end F()

F = nil
RaiderIO.AddProvider(provider)
