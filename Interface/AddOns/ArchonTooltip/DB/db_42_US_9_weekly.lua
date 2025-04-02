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
 local lookup = {'Druid-Feral','Paladin-Holy','Shaman-Enhancement','Shaman-Restoration','Unknown-Unknown','DemonHunter-Havoc','Warlock-Demonology','Warlock-Destruction','Evoker-Devastation','Monk-Windwalker','Monk-Mistweaver','Monk-Brewmaster',}; local provider = {region='US',realm='AlteracMountains',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alcha:AwAGCAEABAoAAA==.Alliwolf:AwAECAEABAoAAA==.',An='Animeniac:AwAECAEABAoAAA==.',Au='Aurix:AwAICBAABAoAAA==.',Av='Avdol:AwACCAUABRQCAQACAQhWAQBJrrwABRQAAQACAQhWAQBJrrwABRQAAA==.',Ba='Baelsar:AwADCAQABAoAAA==.',Be='Bedivere:AwACCAQABAoAAA==.Bel:AwADCAMABAoAAA==.',Bi='Bigsheet:AwACCAMABAoAAA==.',Br='Brewmister:AwADCAMABAoAAA==.',Bu='Busterposer:AwAECAUABAoAAA==.Buusey:AwABCAEABAoAAA==.',Ca='Cainn:AwAECAMABAoAAA==.',Ch='Chorrol:AwAHCA0ABAoAAA==.',Co='Cogglutch:AwAFCAwABAoAAA==.',Cr='Creamkin:AwAECAkABAoAAA==.',Da='Dacrus:AwAECAYABAoAAA==.Dalsen:AwAECA0ABAoAAA==.Darksider:AwACCAIABAoAAA==.',Di='Dilph:AwABCAEABAoAAA==.',Dm='Dmachine:AwACCAQABAoAAQEASa4CCAUABRQ=.',Do='Dopéy:AwAECAsABAoAAA==.',El='Elsharion:AwAICBkABAoCAgAIAQhmAgBS6e8CBAoAAgAIAQhmAgBS6e8CBAoAAA==.Elshie:AwADCAMABAoAAQIAUukICBkABAo=.',Fa='Fastasheet:AwABCAEABRQAAA==.',Fi='Fill:AwAECAcABRQCAwAEAQg6AQBBkWgBBRQAAwAEAQg6AQBBkWgBBRQAAA==.',Fl='Flehiest:AwAECAQABAoAAA==.Flehtwo:AwACCAYABRQCBAACAQg7CQAyZJMABRQABAACAQg7CQAyZJMABRQAAA==.',Fy='Fyrefest:AwABCAEABAoAAQUAAAAFCAcABAo=.',Ga='Ganska:AwAFCAcABAoAAA==.',Ge='Genjyosanzo:AwAECAEABAoAAA==.',Gi='Gidgyt:AwAECAgABAoAAA==.',Gr='Grito:AwADCAQABAoAAA==.Groppum:AwAECAUABAoAAA==.',Ha='Halsina:AwAFCAcABAoAAA==.',He='Hetairoii:AwADCAQABAoAAA==.',Hi='Hilazy:AwAECAEABAoAAA==.',Ho='Hort:AwAECAEABAoAAA==.',Il='Illidantwo:AwADCAYABRQCBgADAQjyCAAjccsABRQABgADAQjyCAAjccsABRQAAA==.',Im='Imatool:AwACCAIABAoAAA==.',In='Inderoni:AwAECAUABAoAAA==.Inside:AwAECAUABAoAAQUAAAAGCAIABAo=.Interruptpls:AwABCAEABAoAAA==.Interuptus:AwAECAYABAoAAA==.',Ip='Iplaybänjo:AwADCAUABAoAAA==.',Je='Jenstonedart:AwAECAUABAoAAA==.Jery:AwAECAkABAoAAA==.',Ka='Kain:AwAGCAwABAoAAA==.',Ki='Kiwí:AwAFCAYABAoAAA==.',La='Laeda:AwAGCAwABAoAAA==.',['L�']='Løbø:AwAICAgABAoAAA==.',Ma='Malëk:AwAGCAkABAoAAA==.Masturlingus:AwAGCAQABAoAAA==.',Me='Mellowlizard:AwABCAIABRQCBwAFAQjICQBSvssBBAoABwAFAQjICQBSvssBBAoAAQEASa4CCAUABRQ=.',Mi='Misslespam:AwAECAEABAoAAA==.Mito:AwABCAEABAoAAA==.',Mo='Moonangel:AwAECAEABAoAAA==.Moonfang:AwADCAQABAoAAA==.',Mu='Mudget:AwADCAUABRQDCAADAQiABABR1voABRQACAADAQiABABNtvoABRQABwABAQgVAgBjIHQABRQAAA==.Mugginz:AwADCAEABAoAAA==.Multanni:AwAECAYABAoAAA==.',My='Myonecrosis:AwAECAEABAoAAA==.',Na='Nagusame:AwAHCAEABAoAAA==.Navaani:AwAECAEABAoAAA==.',Ni='Nightelyn:AwADCAYABAoAAA==.Nimbus:AwABCAEABRQCCQAIAQgoCABOfqECBAoACQAIAQgoCABOfqECBAoAAA==.',Og='Ogmount:AwAGCAEABAoAAA==.',Pe='Pearbear:AwACCAIABAoAAQUAAAAFCAwABAo=.',Ph='Phrash:AwABCAEABRQDCgAIAQiLAABh5YMDBAoACgAIAQiLAABh5YMDBAoACwACAQiuVgARjGgABAoAAQMAQZEECAcABRQ=.',Po='Poolparty:AwAFCAcABAoAAA==.',Ra='Racker:AwAECAEABAoAAA==.',Re='Renne:AwAECAcABAoAAA==.',Sa='Sass:AwADCAUABAoAAA==.',Sh='Shack:AwABCAEABRQAAA==.Shirokhan:AwAICBAABAoAAA==.Shvmwow:AwAFCAYABAoAAA==.',Sn='Sneezý:AwAECAEABAoAAA==.',Su='Sunchipzz:AwADCAQABAoAAA==.Suzume:AwAECA4ABAoAAQEASa4CCAUABRQ=.',['S�']='Sèrënibolt:AwAGCAwABAoAAA==.',To='Totallyatrox:AwAFCAYABAoAAA==.',Tw='Twix:AwABCAEABAoAAA==.',Ve='Velmalthea:AwADCAEABAoAAA==.Venk:AwAGCBEABAoAAA==.',Vo='Vonker:AwAHCAMABAoAAA==.',Vy='Vyndistaul:AwAECAQABAoAAA==.',Wy='Wyland:AwAECAkABAoAAA==.Wylandruid:AwABCAEABAoAAQUAAAAECAkABAo=.',Za='Zarika:AwACCAYABAoAAQoAOmoDCAcABRQ=.Zarì:AwADCAcABRQDCgADAQgVBQA6ar0ABRQACgACAQgVBQBOfr0ABRQADAABAQhABQASQDIABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end