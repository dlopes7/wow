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
 local lookup = {'DemonHunter-Havoc','DeathKnight-Unholy','DemonHunter-Vengeance','Druid-Balance','Shaman-Elemental','DeathKnight-Blood','Priest-Discipline','Priest-Holy','Monk-Windwalker','Monk-Brewmaster','Monk-Mistweaver','Hunter-BeastMastery','Rogue-Outlaw','Unknown-Unknown','Priest-Shadow','Rogue-Assassination','Rogue-Subtlety','Shaman-Restoration','Shaman-Enhancement','Warlock-Destruction','Warlock-Affliction','Warrior-Fury','Paladin-Protection','Evoker-Devastation','Evoker-Preservation','Paladin-Holy','Hunter-Survival','Mage-Fire','Hunter-Marksmanship','Druid-Restoration',}; local provider = {region='US',realm='Spirestone',name='US',type='weekly',zone=42,date='2025-03-28',data={Ag='Agni:AwABCAQABRQAAA==.',Ak='Akkadian:AwAFCAsABAoAAA==.',Al='Alnava:AwAFCAUABAoAAA==.',Am='Amarillys:AwAICBAABAoAAA==.',An='Angermeier:AwADCAcABAoAAA==.Annamarth:AwAICAgABAoAAA==.',Ar='Argus:AwAFCAoABAoAAA==.Arowin:AwAFCAUABAoAAA==.',Aw='Aw:AwAICBcABAoCAQAIAQhGDQBQW8kCBAoAAQAIAQhGDQBQW8kCBAoAAA==.',Ax='Ax:AwEDCAQABRQCAgAIAQglBABYzCIDBAoAAgAIAQglBABYzCIDBAoAAA==.',Az='Azala:AwAECAQABAoAAA==.Azuro:AwADCAQABRQDAQAIAQgJCABXlA4DBAoAAQAIAQgJCABXlA4DBAoAAwACAQisLgA5v3oABAoAAA==.',['A�']='Açë:AwAICAwABAoAAQQAXDsCCAQABRQ=.',Be='Beck:AwABCAEABAoAAA==.',Br='Braze:AwAGCA4ABAoAAA==.Brodobaggins:AwABCAEABRQCBQAIAQhSBQBbGeoCBAoABQAIAQhSBQBbGeoCBAoAAA==.Brotherguy:AwAHCBUABAoCBgAHAQgVCABSkX4CBAoABgAHAQgVCABSkX4CBAoAAA==.',Bu='Bumir:AwACCAIABAoAAA==.Burch:AwAECAgABAoAAA==.',Ca='Carnal:AwACCAIABAoAAA==.Carrion:AwAHCBQABAoDBwAHAQiDGQAvQoABBAoABwAHAQiDGQAszIABBAoACAAGAQhRKwAngS4BBAoAAA==.Castro:AwADCAYABAoAAA==.',Ce='Cedren:AwAFCAgABAoAAA==.Certified:AwAHCAUABAoAAA==.',Ch='Cheapheal:AwAHCBIABAoAAA==.Cheburashka:AwADCAYABRQCBQADAQhTAQBWSjIBBRQABQADAQhTAQBWSjIBBRQAAA==.Chunkymonkey:AwAHCBcABAoECQAHAQjfDABN+VgCBAoACQAHAQjfDABN+VgCBAoACgAGAQgsCwAy50IBBAoACwAEAQhxSwASrY8ABAoAAA==.',Ci='Cidren:AwABCAEABRQAAA==.',Cr='Crimsonaxe:AwAECAcABAoAAA==.',Da='Daemon:AwADCAgABAoAAA==.Dankbrewsbro:AwAICAgABAoAAA==.Darksouls:AwAFCAcABAoAAA==.Darkspartan:AwADCAgABAoAAA==.',De='Demonicchoas:AwAHCAoABAoAAA==.Deutzfr:AwAICAQABAoAAA==.',Dh='Dhdh:AwADCAMABAoAAA==.',Do='Dorgie:AwADCAMABAoAAA==.',Dr='Draiko:AwAFCAwABAoAAA==.',Du='Dubdub:AwAGCAYABAoAAA==.',Ei='Eisador:AwADCAEABAoAAA==.Eisenhorn:AwAFCAgABAoAAA==.',El='Eloquinn:AwAGCA0ABAoAAA==.',En='Endosh:AwAICAIABAoAAA==.',Fe='Felawful:AwAFCAYABAoAAA==.Felstrider:AwAGCAgABAoAAA==.Ferador:AwADCAQABRQCDAAIAQhsEgBQqb8CBAoADAAIAQhsEgBQqb8CBAoAAA==.',Fi='Fistsphoyou:AwAGCAoABAoAAA==.',Go='Goomz:AwAGCAkABAoAAA==.Goredrinker:AwADCAgABRQCBgADAQhhAQBhOkwBBRQABgADAQhhAQBhOkwBBRQAAA==.Gortlok:AwABCAEABAoAAA==.Gothmummy:AwAHCAcABAoAAA==.',Gr='Graygpl:AwAFCAgABAoAAA==.Grimreaper:AwAHCBUABAoCDQAHAQgnAgBK41sCBAoADQAHAQgnAgBK41sCBAoAAA==.Gringott:AwADCAUABAoAAQ4AAAAECAoABAo=.Grubby:AwAECAIABAoAAA==.',Ho='Holyloaner:AwAFCAUABAoAAA==.',Hu='Hungter:AwACCAIABAoAAA==.Hushwing:AwABCAEABRQDAQAIAQi7DgBNfrgCBAoAAQAIAQi7DgBNfrgCBAoAAwABAQi5QwAI5BgABAoAAA==.',Ig='Ignacious:AwABCAEABAoAAA==.Igris:AwAHCBIABAoAAA==.',Ih='Ihealhardbro:AwAECAQABAoAAA==.',Is='Ischia:AwADCAMABRQDCAAIAQh2FAAyj+sBBAoACAAIAQh2FAAyj+sBBAoADwAHAQidGAAskqkBBAoAAA==.',Jc='Jch:AwADCAgABRQCDAADAQgoCQA5R+cABRQADAADAQgoCQA5R+cABRQAAA==.',Je='Jenova:AwAECAYABAoAAA==.Jepwar:AwAFCAwABAoAAA==.',Jp='Jprottsuhh:AwAECAQABAoAAA==.',Ju='Juffowup:AwABCAEABRQAAA==.',Ka='Kaiju:AwAECAYABAoAAA==.Karoo:AwABCAEABAoAAA==.',Ki='Kikue:AwADCAQABRQDEAAIAQjjAQBfqR0DBAoAEAAIAQjjAQBfCx0DBAoAEQAIAQgtAwBPAQoDBAoAAA==.',Kl='Klunder:AwAECAEABAoAAA==.',Ko='Kostik:AwAFCAMABAoAAA==.',Kr='Kridillis:AwAGCBMABAoAAA==.',Kt='Ktang:AwAGCAoABAoAAA==.',Ku='Kungfudingus:AwAGCA0ABAoAAA==.',La='Lacroix:AwABCAEABRQAAA==.',Li='Liesx:AwAFCBEABAoDEQAFAQiGFABEXIwBBAoAEQAFAQiGFABEXIwBBAoAEAABAQjqLAAlJC4ABAoAAA==.Lilboothang:AwADCAgABAoAAA==.Lisin:AwADCAEABAoAAA==.',Lo='Loerasdh:AwABCAEABRQAAA==.Logañ:AwACCAMABRQDEgAIAQhoBABVbv8CBAoAEgAIAQhoBABVbv8CBAoAEwAGAQi+KAANzA8BBAoAAA==.Loko:AwABCAIABRQCBAAIAQiIDABQ6a8CBAoABAAIAQiIDABQ6a8CBAoAAA==.Lothlock:AwADCAcABRQDFAADAQgyBwBRFLoABRQAFAACAQgyBwBPeroABRQAFQABAQjXCABUSFoABRQAAA==.',Lu='Luckygrapes:AwABCAEABRQCCwAHAQhCDQBO5mcCBAoACwAHAQhCDQBO5mcCBAoAAA==.',Ma='Mable:AwAECAUABAoAAA==.Magelybmoney:AwAGCAcABAoAAA==.Manalèss:AwABCAIABRQCDAAIAQhTGgBAAXsCBAoADAAIAQhTGgBAAXsCBAoAAA==.Mantycore:AwACCAUABRQCCwACAQipCwAaBIkABRQACwACAQipCwAaBIkABRQAAA==.',Mi='Midk:AwAHCBAABAoAAA==.Mikayy:AwABCAEABRQCEQAHAQgGBwBU2KUCBAoAEQAHAQgGBwBU2KUCBAoAAA==.Mikepenance:AwACCAIABAoAAQQAXDsCCAQABRQ=.Mildwalnut:AwAECAYABAoAAA==.Milenko:AwAFCAsABAoAAA==.',Mo='Monstrous:AwADCAYABRQCFgADAQg3BQA6SQwBBRQAFgADAQg3BQA6SQwBBRQAAA==.Moreye:AwAGCAoABAoAAA==.',Mt='Mthafknfreez:AwAHCAQABAoAAA==.',Od='Odiedude:AwADCAEABAoAAA==.',Pa='Pallyfrìend:AwABCAEABRQCFwAHAQjYBABWf58CBAoAFwAHAQjYBABWf58CBAoAAA==.Panders:AwABCAEABRQCCwAIAQgjEQA9CC8CBAoACwAIAQgjEQA9CC8CBAoAAA==.',Pi='Pickle:AwAICAIABAoAAA==.',Pl='Ploxis:AwADCAYABRQCAwADAQilAQA9duUABRQAAwADAQilAQA9duUABRQAAA==.',Po='Potionfirst:AwAFCA8ABAoAAA==.',Pr='Prea:AwADCAMABAoAAA==.Premiumferal:AwAGCAoABAoAAA==.Primecarry:AwAGCAoABAoAAQcAV64DCAQABRQ=.Primedaddy:AwADCAQABRQCBwAIAQj6AQBXrjADBAoABwAIAQj6AQBXrjADBAoAAA==.',Qb='Qbz:AwAFCAQABAoAAA==.',Ra='Ralvia:AwADCAMABAoAAA==.Randioh:AwABCAEABAoAAA==.Rassputen:AwAHCAoABAoAAA==.Ratio:AwAGCAYABAoAAA==.',Re='Reck:AwACCAIABAoAAA==.Redonkulos:AwADCAIABAoAAQ4AAAADCAMABAo=.Regifel:AwACCAIABAoAAA==.Rex:AwAHCBUABAoCBgAHAQjtDABF6Q4CBAoABgAHAQjtDABF6Q4CBAoAAA==.',Ro='Roguen:AwAHCAIABAoAAQ4AAAAHCAQABAo=.Ronor:AwADCAYABAoAAA==.Roulduke:AwAECAEABAoAAA==.',Sa='Sandon:AwAGCAoABAoAAA==.',Se='Secrtservice:AwAHCA8ABAoAAA==.Selexi:AwAFCAUABAoAAA==.Selrahc:AwAFCAMABAoAAA==.',Sh='Shadyblades:AwAFCAoABAoAAA==.Shasa:AwAGCBEABAoAAA==.Sheroko:AwAICA4ABAoAAA==.Shøcktherapy:AwABCAEABRQAAA==.',Si='Sindorella:AwAECAEABAoAAA==.',Sk='Skysong:AwADCAQABRQDGAAIAQiPCwBGLFECBAoAGAAIAQiPCwBGLFECBAoAGQABAQhZHQAJbTIABAoAAA==.',Sn='Snowynn:AwAECAEABAoAAA==.',So='Solheim:AwAFCAYABAoAAA==.',Sp='Splÿff:AwACCAIABAoAAA==.',Sq='Squirtz:AwADCAgABAoAAA==.',Sr='Srirachajane:AwADCAMABAoAAA==.',St='Strathin:AwAHCBUABAoCDwAHAQgSEgA+8wgCBAoADwAHAQgSEgA+8wgCBAoAAA==.',Su='Suggadeath:AwABCAEABRQCGgAIAQiPCAAzdTUCBAoAGgAIAQiPCAAzdTUCBAoAAA==.Suggademon:AwAFCAUABAoAARoAM3UBCAEABRQ=.',Sy='Sylatis:AwEDCAcABRQCGwADAQgKAABjCkkBBRQAGwADAQgKAABjCkkBBRQAAA==.',Ta='Taydertot:AwAECAQABAoAAA==.Tayylor:AwAFCAMABAoAAA==.',Ti='Tiddybear:AwAICAYABAoAAA==.',To='Tokken:AwAGCBEABAoAAA==.',Tu='Tubularoso:AwAGCAkABAoAAA==.',Ve='Vengened:AwABCAEABRQCFgAHAQgGEQBHi2MCBAoAFgAHAQgGEQBHi2MCBAoAAA==.',Vi='Vilous:AwAHCA4ABAoAAA==.',Vr='Vraax:AwABCAIABRQCDAAIAQg8HwA+oFMCBAoADAAIAQg8HwA+oFMCBAoAAA==.',Xe='Xenophontes:AwADCAQABRQCHAAIAQhzFwBHD1ICBAoAHAAIAQhzFwBHD1ICBAoAAA==.',Xi='Xihuang:AwAECAkABAoAAQ4AAAAHCAQABAo=.Xiia:AwABCAEABRQDDAAIAQicHABCfmkCBAoADAAIAQicHABCfmkCBAoAHQAEAQiIMgAKy20ABAoAAA==.',Xo='Xouu:AwACCAQABRQDBAAIAQhxDwBcO4cCBAoABAAGAQhxDwBcvocCBAoAHgAIAQhjCABFEHcCBAoAAA==.',Xx='Xxuu:AwAICA8ABAoAAQQAXDsCCAQABRQ=.',Yo='Yourewelcome:AwACCAIABAoAAA==.',Za='Zaleris:AwAFCAMABAoAAA==.',Zi='Zieva:AwADCAQABAoAAA==.',Zo='Zoid:AwADCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end