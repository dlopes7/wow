local V2_TAG_NUMBER = 3

---Parse a single set of spec data from `state`
---@param decoder BitDecoder
---@param state ParseState
---@param lookup table<number, string>
---@return ProviderProfileSpec
local function parseSpecData(decoder, state, lookup)
	local result = {}
	result.spec = decoder.decodeString(state, lookup)
	result.progress = decoder.decodeInteger(state, 1)
	result.partition = decoder.decodeInteger(state, 1)
	result.total = decoder.decodeInteger(state, 1)
	result.rank = decoder.decodeInteger(state, 3)
	result.average = decoder.decodeFixedFloat(state, 1, 1)
	result.asp = decoder.decodeInteger(state, 2)
	result.difficulty = decoder.decodeInteger(state, 1)
	result.size = decoder.decodeInteger(state, 1)

	local encounterCount = decoder.decodeInteger(state, 1)
	result.encounters = {}
	for i = 1, encounterCount do
		local id = decoder.decodeInteger(state, 4)
		local kills = decoder.decodeInteger(state, 2)
		local best = decoder.decodeInteger(state, 1)

		result.encounters[id] = { kills = kills, best = best }
	end
	return result
end

---Parse a binary-encoded data string into a ProviderProfile
---@param decoder BitDecoder
---@param content string
---@param lookup table<number, string>
---@return ProviderProfile|nil
local function parse(decoder, content, lookup) -- luacheck: ignore 211
	---@type ParseState
	local state = { content = content, position = 1 }

	local tag = decoder.decodeInteger(state, 1)
	if tag ~= V2_TAG_NUMBER then
		return nil
	end

	local result = {}

	-- user data
	result.subscriber = decoder.decodeInteger(state, 1)
	-- overall data
	result.progress = decoder.decodeInteger(state, 1)
	result.total = decoder.decodeInteger(state, 1)
	result.totalKillCount = decoder.decodeInteger(state, 2)
	result.difficulty = decoder.decodeInteger(state, 1)
	result.size = decoder.decodeInteger(state, 1)
	result.perSpec = {}

	local specCount = decoder.decodeInteger(state, 1)
	if specCount > 0 then
		result.anySpec = parseSpecData(decoder, state, lookup)

		for _i = 1, specCount - 1 do
			local spec = parseSpecData(decoder, state, lookup)
			table.insert(result.perSpec, spec)
		end
	end

	local hasMainCharacter = decoder.decodeBoolean(state)

	if hasMainCharacter then
		local main = {}
		main.spec = decoder.decodeString(state, lookup)
		main.average = decoder.decodeFixedFloat(state, 1, 1)
		main.progress = decoder.decodeInteger(state, 1)
		main.total = decoder.decodeInteger(state, 1)
		main.totalKillCount = decoder.decodeInteger(state, 2)
		main.difficulty = decoder.decodeInteger(state, 1)
		main.size = decoder.decodeInteger(state, 1)
		result.mainCharacter = main
	end

	return result
end
 local lookup = {'Evoker-Devastation','Mage-Arcane','Monk-Windwalker','Unknown-Unknown','Evoker-Preservation','DeathKnight-Frost','Warrior-Arms','Warrior-Fury','Paladin-Retribution','Paladin-Holy','Mage-Frost','Monk-Brewmaster','Monk-Mistweaver','Priest-Holy','Rogue-Assassination','Druid-Balance','Druid-Restoration','Shaman-Enhancement','Shaman-Restoration',}; local provider = {region='US',realm='Mannoroth',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abbynormal:AwADCAYABAoAAA==.Abena:AwAGCAYABAoAAA==.Abusive:AwAGCAkABAoAAA==.',Ae='Aerogosa:AwADCAUABRQCAQADAQgYBQAsaOAABRQAAQADAQgYBQAsaOAABRQAAA==.',Ag='Agerthbet:AwADCAcABAoAAA==.Agogagog:AwABCAEABRQAAA==.',Al='Alandis:AwAFCAgABAoAAA==.Alrixx:AwADCAkABAoAAA==.',An='Anic:AwAFCAkABAoAAA==.Anklestabber:AwAGCA0ABAoAAA==.',Ap='Apokalypso:AwAECAQABAoAAA==.',Ar='Areoles:AwAICAgABAoAAA==.Areolla:AwAICAgABAoAAA==.Arleos:AwAGCA0ABAoAAA==.Aryuncrimson:AwAICBgABAoCAgAIAQjwAABIUbUCBAoAAgAIAQjwAABIUbUCBAoAAA==.',At='Atrophied:AwAECAYABAoAAA==.',Az='Azreluna:AwAGCA0ABAoAAA==.Azrile:AwADCAUABAoAAA==.',Ba='Babonim:AwAFCAoABAoAAA==.Baradoon:AwACCAUABAoAAA==.Bayow:AwABCAIABRQAAA==.',Bb='Bblenjoyer:AwAECAgABAoAAA==.',Bi='Bibabo:AwADCAYABAoAAA==.Bigbluetaco:AwAGCA8ABAoAAA==.Bigchug:AwAHCBgABAoCAwAHAQj9DgBFmT8CBAoAAwAHAQj9DgBFmT8CBAoAAA==.Bigjeff:AwADCAMABAoAAA==.Bigschnibs:AwAICA8ABAoAAA==.Bigtim:AwAECAoABAoAAA==.Bizzul:AwAFCAYABAoAAA==.',Bk='Bkbombs:AwACCAEABAoAAA==.',Bl='Blakberrygoo:AwACCAQABAoAAQQAAAABCAEABRQ=.Blìnk:AwAECAEABAoAAA==.',Bo='Boogerzug:AwAECAcABAoAAA==.',Br='Bramon:AwADCAYABAoAAA==.Brizzletwo:AwAECAcABAoAAA==.Brozz:AwADCAQABAoAAA==.Brubak:AwADCAcABAoAAA==.Brättie:AwAHCAQABAoAAA==.Bróx:AwAHCBEABAoAAA==.',Bt='Btrack:AwABCAEABAoAAA==.',Bu='Bustercherry:AwABCAEABAoAAA==.',By='Bynkie:AwACCAQABAoAAA==.',Ca='Calmpressure:AwAGCAsABAoAAA==.Cas:AwAECAQABAoAAA==.Caveatemptor:AwADCAgABAoAAQUATR8BCAIABRQ=.',Ch='Chelanda:AwAECAYABAoAAA==.Chontosh:AwADCAMABAoAAA==.Chugget:AwAECAgABAoAAA==.',Ci='Cindymccain:AwAECAUABAoAAA==.',Co='Colossuss:AwACCAIABAoAAA==.',Cr='Crolly:AwADCAEABAoAAA==.Crual:AwAFCAkABAoAAA==.',Cu='Cumchulainn:AwAFCAEABAoAAQQAAAAGCAkABAo=.',Cy='Cyrenius:AwAFCAsABAoAAA==.',Da='Darrkin:AwADCAUABAoAAA==.Darvax:AwAECAcABAoAAA==.',De='Deluxemage:AwAGCA4ABAoAAA==.Deluxewar:AwADCAQABAoAAA==.',Di='Dimsumfatboy:AwAICAEABAoAAA==.Dionelli:AwACCAMABAoAAA==.Divinus:AwABCAIABRQCBgAIAQh2AgBUFOYCBAoABgAIAQh2AgBUFOYCBAoAAA==.',Dj='Djjinn:AwAECAEABAoAAA==.',Do='Dolobot:AwACCAMABRQDBwAIAQioCABKW28CBAoABwAHAQioCABPz28CBAoACAAEAQh1SgAThbMABAoAAA==.',Dr='Dregoth:AwACCAIABAoAAA==.',Ep='Epsilon:AwABCAEABAoAAA==.',Ev='Evorel:AwAGCA8ABAoAAA==.',Ez='Ezaneath:AwAECAYABAoAAA==.',Fe='Fearhazard:AwAGCA0ABAoAAA==.',Fl='Flarehammer:AwAHCBQABAoCCQAHAQh/XAAl0YEBBAoACQAHAQh/XAAl0YEBBAoAAA==.Fleurdumal:AwEECAoABAoAAA==.',Fo='Fogdeme:AwACCAgABAoAAA==.Fogdk:AwAECAgABAoAAA==.',Fr='Franko:AwAGCAEABAoAAA==.',Fu='Fugues:AwAECAUABAoAAA==.',['F�']='Förbindelse:AwAECAgABAoAAA==.',Ga='Gawkagawka:AwADCAQABAoAAA==.',Go='Goopski:AwABCAEABRQCCgAIAQieDQAmudkBBAoACgAIAQieDQAmudkBBAoAAA==.',Ha='Hanginglow:AwACCAIABAoAAA==.Hasan:AwAICAkABAoAAA==.Hazzkul:AwACCAMABAoAAA==.',He='Helldwarf:AwAICB0ABAoCBgAIAQh+AwBKhqMCBAoABgAIAQh+AwBKhqMCBAoAAA==.Helloboys:AwAGCAgABAoAAA==.',Ho='Hojodidthat:AwAGCAwABAoAAA==.Holdmybeard:AwAECAQABAoAAA==.Holytwan:AwAGCAoABAoAAA==.Howlingfjord:AwADCAMABAoAAA==.',Hs='Hsk:AwAHCBQABAoCCwAHAQjOEABI4EMCBAoACwAHAQjOEABI4EMCBAoAAA==.',Il='Illune:AwAGCAcABAoAAA==.',In='Inebriated:AwACCAIABAoAAA==.Infinitepain:AwAHCBgABAoEAwAHAQggEgBGghACBAoAAwAHAQggEgA9kBACBAoADAAEAQh2EAAw4s8ABAoADQABAQh/aQAVniQABAoAAA==.',Ja='Jaichim:AwADCAMABAoAAA==.Jalana:AwAGCAMABAoAAA==.',Ji='Jinxtd:AwADCAYABAoAAA==.',Jo='Josa:AwEGCAoABAoAAA==.',['J�']='Jêkyl:AwADCAcABAoAAA==.',Ka='Karrl:AwADCAMABAoAAA==.Kaydene:AwAICAgABAoAAA==.Kazama:AwAECAgABAoAAA==.Kazmo:AwADCAgABAoAAA==.',Ki='Kitanya:AwAICAkABAoAAA==.',Kr='Krypticsneak:AwAFCAoABAoAAA==.',['K�']='Kîng:AwAGCAsABAoAAA==.',Li='Licht:AwACCAIABAoAAA==.Lickeinstein:AwAECAYABAoAAA==.Likkatoad:AwAICAgABAoAAA==.',Lu='Lusekiller:AwACCAMABAoAAA==.',Ma='Maeivalla:AwAICBcABAoCDgAIAQggFQA3VOwBBAoADgAIAQggFQA3VOwBBAoAAA==.Mancane:AwAFCAsABAoAAA==.Martigan:AwADCAQABAoAAA==.',Me='Merrem:AwAFCAgABAoAAA==.',Mi='Mitsy:AwADCAIABAoAAA==.',Mk='Mkza:AwACCAIABAoAAA==.',Mo='Moonuckle:AwAICAgABAoAAA==.Morganah:AwAGCA0ABAoAAA==.',Mu='Mushixz:AwABCAEABAoAAA==.',My='Mythomagic:AwAGCA0ABAoAAA==.',Na='Naebadin:AwAGCAwABAoAAA==.Nakotak:AwAECAMABAoAAA==.Natendo:AwAFCA0ABAoAAA==.Nathandrias:AwABCAEABAoAAQQAAAAFCA0ABAo=.',Ne='Nelan:AwACCAIABAoAAA==.Nethril:AwAECAcABAoAAA==.',No='Normo:AwAGCA0ABAoAAA==.Notes:AwAFCAkABAoAAA==.',Ob='Obliterate:AwAFCAUABAoAAA==.',Og='Ogbsn:AwAGCAQABAoAAA==.',Oo='Oopii:AwAHCAIABAoAAA==.',Ow='Owlz:AwADCAUABAoAAA==.',Ox='Oxymoron:AwABCAEABAoAAA==.',Pa='Palomine:AwAICAgABAoAAA==.Pandamilf:AwAECAQABAoAAA==.Papablindy:AwADCAMABAoAAA==.Paperalza:AwAHCBEABAoAAA==.',Ph='Phalluic:AwAHCBcABAoCCQAHAQivPwA8z+sBBAoACQAHAQivPwA8z+sBBAoAAA==.Philpriest:AwAGCAgABAoAAA==.',Pi='Pidgeon:AwACCAIABAoAAA==.',Pl='Pliocene:AwABCAIABRQDBQAIAQgUAgBNH9oCBAoABQAIAQgUAgBNH9oCBAoAAQAEAQhmJQAyhdgABAoAAA==.',Po='Pounddcake:AwAICAoABAoAAA==.',Ra='Rainbowholy:AwACCAIABAoAAA==.Rainpain:AwABCAMABRQDCAAIAQixCQBKQ80CBAoACAAIAQixCQBKQ80CBAoABwAFAQitIwAm/QABBAoAAA==.Rarh:AwADCAQABAoAAA==.Rathlore:AwAECAoABAoAAA==.Ravixx:AwADCAgABAoAAA==.',Re='Reforsaken:AwAICBcABAoCDwAIAQjBCgAtyxACBAoADwAIAQjBCgAtyxACBAoAAA==.Remingtondb:AwAICAkABAoAAA==.Restosham:AwAFCAUABAoAAA==.Revengeance:AwAGCA0ABAoAAA==.',Ri='Ripstuffup:AwAICAgABAoAAA==.',Ro='Roxen:AwAGCA4ABAoAAA==.',Ry='Ryuunosuke:AwAGCA0ABAoAAA==.',Sa='Sabrinachi:AwAFCAcABAoAAA==.Sakkraa:AwACCAIABAoAAA==.Samwish:AwAHCBYABAoCDwAHAQi3BQBW5pgCBAoADwAHAQi3BQBW5pgCBAoAAA==.',Se='Selidori:AwAECAoABAoAAA==.Sentinel:AwABCAEABAoAAA==.',Sh='Shadowshock:AwAFCAwABAoAAA==.Shrimpy:AwACCAQABAoAAA==.',Si='Sidedogging:AwACCAEABAoAAA==.Sithpaladin:AwADCAMABAoAAA==.',Sk='Skinnylejend:AwAFCAcABAoAAA==.',Sl='Sloblin:AwAHCAcABAoAAA==.Slutpolice:AwACCAIABAoAAA==.',Sm='Smoke:AwACCAIABAoAAA==.',Sp='Speedshot:AwAGCAoABAoAAA==.Spitfirex:AwADCAUABRQCEAADAQgDBwBBxPUABRQAEAADAQgDBwBBxPUABRQAAA==.',St='Strahd:AwAECAQABAoAAA==.Stroganov:AwADCAMABAoAAA==.Stunamgid:AwAGCAkABAoAAA==.',Su='Sure:AwAICAsABAoAAA==.Susumu:AwABCAEABRQAAA==.',Ta='Tahu:AwAGCA8ABAoAAA==.Tappnlock:AwAGCAwABAoAAA==.Tastynips:AwAECAQABAoAAA==.',Te='Teake:AwABCAIABRQDEQAIAQihDwAzGwkCBAoAEQAIAQihDwAzGwkCBAoAEAAHAQg/KwAz9ogBBAoAAA==.Teddymoove:AwADCAMABAoAAA==.Tehtotemz:AwABCAEABRQAAA==.Terrorize:AwAECAoABAoAAA==.Terrous:AwAGCAsABAoAAA==.',Th='Thraanduil:AwAECAgABAoAAA==.Thriane:AwAICAgABAoAAA==.Thrine:AwADCAUABAoAAA==.',To='Tokajok:AwABCAIABRQAAA==.Tokeadin:AwAGCAkABAoAAA==.Tornadofang:AwAGCA0ABAoAAA==.',Tr='Treset:AwADCAUABAoAAA==.Treyrin:AwADCAcABAoAAA==.Trolldemon:AwACCAIABAoAAA==.Trolloutcast:AwAICAkABAoAAA==.',Tu='Turtle:AwAICBYABAoCCgAIAQiWCAA98ToCBAoACgAIAQiWCAA98ToCBAoAAA==.',Tw='Twanzworld:AwACCAMABAoAAA==.',Um='Ummigotbored:AwACCAIABAoAAA==.',Un='Unlknow:AwAFCAEABAoAAA==.',Va='Valcaris:AwADCAMABAoAAA==.Valte:AwAECAEABAoAAA==.Varonos:AwAECAgABRQDEgAEAQjWAgBEyxgBBRQAEgADAQjWAgBQpRgBBRQAEwABAQgtEAAIaEkABRQAAA==.Vathnar:AwACCAQABAoAAA==.',Vi='Views:AwADCAMABAoAAA==.Viewsonic:AwAICA8ABAoAAA==.Vipeer:AwABCAIABAoAAA==.',Vy='Vynaster:AwACCAIABAoAAA==.',Wo='Wokker:AwADCAYABAoAAA==.',Xe='Xencero:AwAFCAQABAoAAA==.',Xh='Xhyros:AwAGCBAABAoAAA==.',Xi='Xiahou:AwAGCAwABAoAAA==.',Za='Zargan:AwAGCAEABAoAAA==.Zazie:AwAGCA0ABAoAAA==.',Ze='Zeinat:AwABCAEABAoAAA==.',Zo='Zowa:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end