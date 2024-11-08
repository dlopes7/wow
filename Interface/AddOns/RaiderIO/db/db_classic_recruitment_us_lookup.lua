--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2024-11-07T06:14:55Z",numCharacters=110,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 32
F = function() provider.lookup[1] = "\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\4\4" end F()

F = nil
RaiderIO.AddProvider(provider)
