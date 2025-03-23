--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="kr",date="2025-02-20T07:39:19Z",numCharacters=30118,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 30
F = function() provider.lookup[1] = "s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5s\5" end F()

F = nil
RaiderIO.AddProvider(provider)
