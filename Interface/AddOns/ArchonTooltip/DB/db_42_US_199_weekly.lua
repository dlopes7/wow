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
 local lookup = {'Mage-Fire','Hunter-BeastMastery','Evoker-Devastation','Evoker-Augmentation','Unknown-Unknown','DemonHunter-Vengeance','Monk-Mistweaver','Druid-Guardian','Warrior-Protection','Monk-Windwalker','Warlock-Destruction','Warrior-Fury','Druid-Feral','Warrior-Arms','Monk-Brewmaster','Shaman-Restoration','Paladin-Retribution','Priest-Holy','Mage-Arcane','Mage-Frost','Warlock-Demonology','Warlock-Affliction',}; local provider = {region='US',realm='Skywall',name='US',type='weekly',zone=42,date='2025-03-28',data={Ae='Aeluu:AwAHCA8ABAoAAA==.',Ai='Ailis:AwADCAQABAoAAQEAN+ECCAIABRQ=.',Al='Aloy:AwACCAQABRQCAgAIAQhTDQBRCe8CBAoAAgAIAQhTDQBRCe8CBAoAAA==.Alyndria:AwAFCA0ABAoAAA==.Alyss:AwACCAIABAoAAA==.',Ar='Ares:AwABCAEABAoAAA==.Armorgorden:AwAECAcABAoAAA==.',As='Ashtareth:AwAFCAoABAoAAA==.',Au='Aurti:AwAFCA0ABAoAAA==.',Av='Avanel:AwAFCA0ABAoAAA==.',Az='Azbogah:AwAGCBIABAoAAA==.',Ba='Barnette:AwAHCBIABAoAAA==.',Bo='Bollux:AwAHCBIABAoAAA==.',Br='Brassmonky:AwAICAMABAoAAA==.Bristatia:AwADCAQABAoAAA==.',Bu='Bubblement:AwACCAQABRQDAwAIAQjNCQBKonYCBAoAAwAIAQjNCQBHOnYCBAoABAACAQjMAgBioeIABAoAAA==.',Ch='Chö:AwAECAUABAoAAQUAAAAHCBMABAo=.',Cl='Claes:AwAHCBUABAoCBgAHAQi7EAAwpJYBBAoABgAHAQi7EAAwpJYBBAoAAA==.',Cr='Crazyndn:AwAFCBAABAoAAA==.',Cu='Curissan:AwACCAIABAoAAA==.',['C�']='Cères:AwAECAcABAoAAQUAAAAHCBMABAo=.',Da='Dahl:AwAFCAEABAoAAA==.Dalruend:AwABCAEABAoAAQcATdcCCAQABRQ=.Dalspin:AwACCAQABRQCBwAIAQh/CABN17cCBAoABwAIAQh/CABN17cCBAoAAA==.',De='Deanuu:AwABCAEABAoAAA==.Debauch:AwAFCAgABAoAAA==.Dendahn:AwAHCBEABAoAAA==.Deskillaa:AwAFCBEABAoAAA==.',Di='Diladrin:AwAHCBUABAoCCAAHAQg1BQA1taABBAoACAAHAQg1BQA1taABBAoAAA==.',Du='Dufdh:AwACCAQABRQCBgAIAQiXAQBarzIDBAoABgAIAQiXAQBarzIDBAoAAA==.',['D�']='Dìzzy:AwAFCAoABAoAAA==.Dûn:AwABCAIABAoAAA==.',El='Elidria:AwADCAUABAoAAA==.Elketha:AwAHCBUABAoDAwAHAQhiCwBNkVUCBAoAAwAHAQhiCwBNkVUCBAoABAADAQjpAwAptogABAoAAA==.Elm:AwAICAgABAoAAA==.Elrric:AwAFCA4ABAoAAA==.',Fa='Faustus:AwAECAYABAoAAA==.Faye:AwACCAIABAoAAA==.',Fi='Finit:AwACCAIABAoAAQUAAAAECAYABAo=.',Ga='Galial:AwAGCAEABAoAAA==.',Gh='Ghibli:AwADCAYABAoAAA==.',Go='Goopie:AwAGCAkABAoAAA==.',Gr='Griffo:AwAFCAsABAoAAA==.',Ha='Haruña:AwACCAIABAoAAA==.',He='Heydh:AwABCAEABAoAAQUAAAAGCBEABAo=.',Ho='Holyßloodelf:AwAFCA0ABAoAAA==.Honeysbadger:AwAICAgABAoAAA==.',Hu='Humungous:AwADCAYABAoAAA==.',Im='Imeanwhynot:AwAFCAUABAoAAA==.',Ir='Irkenfox:AwACCAQABRQCCQAIAQi+AABbgUMDBAoACQAIAQi+AABbgUMDBAoAAA==.',Iz='Izwarrior:AwABCAEABAoAAA==.',Ja='Jalam:AwAICBkABAoCCgAIAQisBgBRtdQCBAoACgAIAQisBgBRtdQCBAoAAA==.Janaa:AwAECAYABAoAAA==.Jarre:AwAGCAYABAoAAA==.',Je='Jesterjoe:AwAECAQABAoAAA==.',Ji='Jimboberjim:AwACCAQABRQCCwAIAQjXAABfPGwDBAoACwAIAQjXAABfPGwDBAoAAA==.',Jo='Jobux:AwAGCAwABAoAAA==.Jolio:AwAGCAoABAoAAA==.Joshie:AwAGCA4ABAoAAA==.',['J�']='Jøsh:AwADCAMABAoAAA==.',Ka='Kalzod:AwAICBEABAoAAA==.Kattara:AwAFCAUABAoAAA==.',Ke='Kekleshmeck:AwAICAgABAoAAA==.',Ko='Korevash:AwAHCAIABAoAAA==.',Kr='Krudd:AwADCAUABAoAAA==.',['K�']='Kürömë:AwAECAQABAoAAA==.',La='Latvias:AwADCAMABAoAAA==.Law:AwAGCBMABAoAAA==.',Lu='Lumia:AwABCAEABRQAAA==.',Ly='Lycemmas:AwAFCAoABAoAAA==.',['L�']='Lïo:AwAICAIABAoAAA==.',Ma='Mad:AwADCAcABRQCDAADAQjdBQAltfkABRQADAADAQjdBQAltfkABRQAAA==.Magicshowers:AwADCAcABAoAAA==.Martei:AwACCAQABRQCDQAIAQgoAQBV7ioDBAoADQAIAQgoAQBV7ioDBAoAAA==.',Me='Metamage:AwAFCAkABAoAAA==.',Mi='Midnyte:AwAFCA0ABAoAAA==.',Mo='Morgawr:AwAECAEABAoAAA==.',['M�']='Mäddie:AwABCAEABAoAAA==.',Ni='Nimravidae:AwAFCAwABAoAAA==.',Oi='Oili:AwADCAQABAoAAA==.',On='Onithetiger:AwABCAEABRQAAA==.Onlyfel:AwAICBUABAoCBgAHAQi1EAA0h5YBBAoABgAHAQi1EAA0h5YBBAoAAA==.',Pe='Pedwyn:AwACCAIABAoAAA==.',Pi='Piett:AwACCAIABAoAAA==.Piingu:AwAFCAgABAoAAA==.',Po='Poppalock:AwADCAQABAoAAA==.',Qu='Quan:AwAICAgABAoAAA==.Quantar:AwAICAgABAoAAQUAAAAICAgABAo=.',Ra='Rasniir:AwAFCAMABAoAAA==.',Re='Really:AwAECAMABAoAAA==.Regna:AwACCAQABRQDDAAIAQhOAgBes1EDBAoADAAIAQhOAgBdvVEDBAoADgADAQgtHgBXKysBBAoAAA==.Remaked:AwADCAcABRQCDwADAQjJAABN/AwBBRQADwADAQjJAABN/AwBBRQAAA==.',Ri='Rickjamesb:AwABCAIABRQCEAAIAQivHAAsr9cBBAoAEAAIAQivHAAsr9cBBAoAAA==.Rickyybobbie:AwAECAEABAoAAA==.',Rn='Rnjezus:AwAFCA4ABAoAAA==.',Sa='Sanosagara:AwAFCAkABAoAAA==.',Sc='Schaden:AwAHCBMABAoAAA==.Scrubzero:AwADCAQABAoAAA==.',Se='Selexi:AwADCAQABAoAAA==.',Sh='Shawasha:AwADCAUABAoAAA==.Shuddarun:AwACCAQABRQCAgAIAQhpDgBL2OUCBAoAAgAIAQhpDgBL2OUCBAoAAA==.',Sl='Slayvylora:AwABCAMABRQCEQAIAQiIHABKGYkCBAoAEQAIAQiIHABKGYkCBAoAAA==.',Sm='Smallholy:AwABCAIABAoAAA==.Smart:AwADCAQABAoAAA==.',So='Soulsmite:AwAECAQABAoAAA==.',Sp='Spicymaker:AwAGCAIABAoAAA==.',St='Starlok:AwAGCAsABAoAAA==.Strifewood:AwADCAQABAoAAA==.',Ti='Tiktokdots:AwAICAgABAoAAA==.',To='Totorö:AwAGCBEABAoAAA==.',Tr='Trepania:AwACCAQABRQCEgAIAQhnGgAlgLEBBAoAEgAIAQhnGgAlgLEBBAoAAA==.',Tu='Tumbler:AwADCAQABAoAAA==.',Ul='Ulnuk:AwABCAEABRQCEAAHAQhsCgBTk5QCBAoAEAAHAQhsCgBTk5QCBAoAAA==.',Un='Unhuman:AwABCAEABAoAAA==.',Up='Uphellyaa:AwACCAIABRQEAQAIAQjTGAA34UQCBAoAAQAIAQjTGAA3j0QCBAoAEwAHAQjXBAAhdj8BBAoAFAAFAQjXTgAOK5oABAoAAA==.',Ve='Vexomous:AwADCAQABAoAAA==.',Vi='Vikss:AwAFCAEABAoAAA==.',Wa='Warcarnivore:AwAICBEABAoAAA==.',Wh='Whatami:AwABCAEABRQECwAIAQgUMgAuJl4BBAoACwAFAQgUMgA4YF4BBAoAFQADAQimJQAdGasABAoAFgAEAQhGGAAZyqUABAoAAA==.Why:AwAICBAABAoAAA==.',Wi='Widowmaker:AwADCAMABAoAAA==.',Wr='Wryxe:AwADCAMABAoAAA==.',Xy='Xyal:AwABCAEABAoAAA==.',Ya='Yazzbek:AwAECAQABAoAAA==.',Ze='Zendrov:AwAGCAYABAoAAQMAWHICCAQABRQ=.Zenith:AwAGCAwABAoAAA==.',Zi='Zilvræ:AwAFCAEABAoAAA==.',Zy='Zyrvog:AwAFCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end