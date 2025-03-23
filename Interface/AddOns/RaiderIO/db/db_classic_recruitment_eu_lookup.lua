--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2025-03-22T06:05:52Z",numCharacters=80,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 82
F = function() provider.lookup[1] = "\10\5\10\5\10\5\10\5\10\5\10\5\10\29\10\29\10\29\10\29\10\5\10\5\11\29\11\29\10\5\10\5\4\4\4\4\4\8\10\5\10\5\10\5\10\5\4\4\11\29\11\29\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\5\10\13\10\13\10\13\10\13" end F()

F = nil
RaiderIO.AddProvider(provider)
