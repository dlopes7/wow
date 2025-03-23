--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2025-03-22T06:05:52Z",numCharacters=80,db={}}
local F

F = function() provider.db["PyrewoodVillage"]={0,"Amoebozoa","Auam","Elfren","Palrenn","Robdot","Roberino"} end F()
F = function() provider.db["Flamegor"]={12,"Дормацайн","Кунанбаев","Миллифисент","Пуассон"} end F()
F = function() provider.db["Gehennas"]={20,"Armya","Bakaresh","Dwaaz","Dwazzie","Elzaren","Gojosatoru","Gravelhunter","Gravelmage","Gravelsham","Hugebenis","Karamonn","Neprostodkk","Sofeast","Sproof","Trocks","Trockzie","Varggan","Venrora","Zachemm","Zugzuglady"} end F()
F = function() provider.db["Auberdine"]={60,"Comburstion","Drips","Judgeret","Opey","Pakololz","Proclacondtm","Ærròr"} end F()
F = function() provider.db["Golemagg"]={74,"Avengingstab","Bearjeez","Deftnight","Louisvuítton"} end F()

F = nil
RaiderIO.AddProvider(provider)
