--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=1,region="kr",date="2024-09-14T06:35:57Z",currentSeasonId=0,numCharacters=9641,keystoneMilestoneLevels={2,4,7,9,12,15},db={}}
local F

F = function() provider.db["아즈샤라"]={0,"Aias","Aimo","Allegrissimo","Barkmann","Ctrl","Fastforward","Glasscom","Glassrom","Glasswall","Glasswar","Gracias","Lungdo","Marcocuore","Megaaxe","Potbelly","Schnauzer","Thebackroom","Triangler","드래콩","마법소녀두두킨","메나고","방탄소년소","실퍼렌","실프렌","얼큰한소갈비탕","염재만","전세사는전사","집섬유지","천콩스님","콩뽕","콩왕","핑크콩"} end F()
F = function() provider.db["줄진"]={960,"스피렌"} end F()
F = function() provider.db["헬스크림"]={990,"프라누스","피사소울"} end F()
F = function() provider.db["하이잘"]={1050,"Ashenhallow","Cmitmit","Demnoklannik","나비드림어","남성추적자","회드시면초밥공짜"} end F()

F = nil
RaiderIO.AddProvider(provider)
