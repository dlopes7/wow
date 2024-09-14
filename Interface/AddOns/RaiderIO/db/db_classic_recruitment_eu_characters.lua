--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2024-09-14T06:14:52Z",numCharacters=22,db={}}
local F

F = function() provider.db["MirageRaceway"]={0,"Daloon","Dýnem","Loneta","Sanshein","Taala","Veznik"} end F()
F = function() provider.db["Flamegor"]={12,"Ган","Дыкалыч","Киринн","Мыхалыч","Павуву","Пейнфула","Пейнфулаа","Пэйнфула","Пэйнфулла"} end F()
F = function() provider.db["Lakeshire"]={30,"Rizzina"} end F()

F = nil
RaiderIO.AddProvider(provider)
