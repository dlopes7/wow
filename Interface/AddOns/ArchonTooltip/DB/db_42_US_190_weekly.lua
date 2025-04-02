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
 local lookup = {'Hunter-BeastMastery','Unknown-Unknown','DemonHunter-Vengeance','Priest-Holy','Shaman-Restoration','Warlock-Destruction','Warlock-Demonology','Shaman-Elemental','DeathKnight-Frost','Mage-Arcane','Mage-Fire','Monk-Mistweaver','Evoker-Preservation','Warrior-Fury','Warrior-Arms','Rogue-Assassination','Rogue-Subtlety','Hunter-Marksmanship','Warlock-Affliction','Monk-Windwalker',}; local provider = {region='US',realm='Shadowsong',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adoran:AwACCAMABAoAAA==.',Ak='Aküma:AwACCAMABAoAAA==.',Am='Amäri:AwAGCBAABAoAAA==.',An='Angrydeath:AwABCAEABAoAAA==.Antebellum:AwAGCAEABAoAAA==.',Ap='Aphrodíte:AwADCAUABAoAAA==.',Ar='Arakadia:AwABCAEABAoAAA==.Arashì:AwAFCAkABAoAAA==.',Av='Avataroffury:AwAGCAUABAoAAA==.',Ay='Ayala:AwAGCBIABAoAAA==.',Az='Azulpunkt:AwABCAEABAoAAA==.',Ba='Barbedwire:AwAGCBgABAoCAQAGAQhWUAAjQz0BBAoAAQAGAQhWUAAjQz0BBAoAAA==.',Bl='Blackclover:AwAFCAsABAoAAA==.Blandicus:AwACCAIABAoAAA==.Bleachery:AwACCAIABAoAAA==.Blitzburg:AwAGCAEABAoAAA==.',Br='Bruute:AwAFCAEABAoAAA==.',['B�']='Bâit:AwADCAMABAoAAQIAAAAICAgABAo=.',Ce='Cell:AwABCAEABAoAAA==.',Ch='Chillzmatic:AwABCAIABRQCAwAGAQjaCwBNEu4BBAoAAwAGAQjaCwBNEu4BBAoAAA==.',Cz='Czmage:AwAHCAcABAoAAA==.',Da='Darkbelt:AwADCAYABAoAAA==.Darkstryder:AwAECAEABAoAAA==.Daxgrol:AwAGCA4ABAoAAA==.',De='Derole:AwABCAEABRQAAA==.',Di='Digdalock:AwAGCBAABAoAAA==.Divinesyn:AwAHCBQABAoCBAAHAQi3LwAJAxEBBAoABAAHAQi3LwAJAxEBBAoAAA==.',Dr='Draegan:AwABCAEABAoAAQIAAAAGCAEABAo=.',El='Elowen:AwACCAIABAoAAQIAAAAGCAEABAo=.',En='Enragedbeef:AwAHCAwABAoAAQUAJ1QHCBUABAo=.Entheogen:AwAGCBAABAoAAA==.',Ev='Evanessance:AwAICAgABAoAAA==.',Fa='Favi:AwAECAkABAoAAA==.',Fl='Floatpass:AwAECAIABAoAAA==.',Ga='Gallynna:AwAFCAMABAoAAA==.',Gi='Gilgaroth:AwAECAwABAoAAA==.',Gr='Graysonn:AwAICAgABAoAAA==.',He='Hekyo:AwABCAEABAoAAA==.',Hi='Hirys:AwAGCAkABAoAAA==.',Hj='Hjoldor:AwAGCBIABAoAAA==.',Im='Imae:AwABCAEABAoAAA==.',In='Intheice:AwAECAIABAoAAA==.',Je='Jebediah:AwADCAIABAoAAA==.Jezebel:AwABCAIABRQDBgAFAQjJPwA8BhABBAoABgAEAQjJPwA8GRABBAoABwACAQikLwA7hnMABAoAAA==.',Jo='Jomage:AwAGCBAABAoAAQgALg4CCAUABRQ=.Jomaleaf:AwABCAEABRQAAQgALg4CCAUABRQ=.Jomas:AwACCAUABRQCCAACAQjgBQAuDooABRQACAACAQjgBQAuDooABRQAAA==.Jomau:AwABCAEABAoAAQgALg4CCAUABRQ=.Josephine:AwACCAIABAoAAA==.',Ju='Jubbjubb:AwAFCAsABAoAAA==.Judera:AwAFCAIABAoAAA==.',Ka='Kainlithia:AwABCAIABRQCCQAIAQgzAQBb5zUDBAoACQAIAQgzAQBb5zUDBAoAAA==.Kalindica:AwAECAkABAoAAA==.Kandee:AwAGCBIABAoAAA==.Karkonas:AwAFCAgABAoAAA==.Kasdaan:AwAGCBEABAoAAA==.Katostrafic:AwAFCAsABAoAAA==.Kazekiame:AwAGCAkABAoAAA==.',Kd='Kdubs:AwAGCBEABAoAAA==.',Ki='Kiridus:AwAECAcABAoAAA==.',Ku='Kutabare:AwAGCBEABAoAAA==.',Lu='Luxæterna:AwACCAMABAoAAA==.',Ly='Lystrasza:AwADCAQABAoAAA==.',Me='Meteora:AwAHCBAABAoAAA==.',Mi='Missedweaver:AwAGCA0ABAoAAA==.',Mo='Monstamash:AwABCAEABAoAAA==.Moxii:AwACCAIABAoAAA==.',Na='Nairnmage:AwADCAcABRQDCgADAQg1AABMtMoABRQACwADAQhKCABHqf8ABRQACgACAQg1AABWXsoABRQAAA==.Namida:AwAFCAMABAoAAA==.',Ne='Nezukø:AwAGCAEABAoAAA==.',Or='Orý:AwACCAQABAoAAA==.',Pa='Paladan:AwAFCA0ABAoAAA==.Panophobia:AwACCAIABAoAAA==.',Pe='Peachh:AwABCAIABAoAAA==.',Pl='Plumm:AwADCAYABAoAAA==.',Ra='Raskela:AwAHCBUABAoCDAAHAQhYDABUxnQCBAoADAAHAQhYDABUxnQCBAoAAA==.',Re='Reportyrself:AwAICAgABAoAAA==.Reprieve:AwACCAIABAoAAA==.Rexi:AwAGCAcABAoAAA==.',Ri='Ricshard:AwAGCBEABAoAAA==.',Ro='Rosencrantz:AwACCAEABAoAAA==.Roughluver:AwAHCBUABAoDBQAHAQj9OwAnVBUBBAoABQAGAQj9OwAewRUBBAoACAAEAQhDLwAcyuAABAoAAA==.Rozèl:AwACCAIABAoAAA==.',Sa='Sabellice:AwAGCBEABAoAAA==.Sakonna:AwAFCBAABAoAAA==.',Sc='Scall:AwADCAMABAoAAA==.Scornrouge:AwAECAcABAoAAA==.',Se='Selkamonk:AwAFCAMABAoAAA==.Sentrina:AwAHCBYABAoCDQAHAQioCwAkCW4BBAoADQAHAQioCwAkCW4BBAoAAA==.Seshymutedme:AwAHCAcABAoAAQUAJ1QHCBUABAo=.',Sh='Shamwû:AwAFCAsABAoAAA==.',Si='Sitx:AwAECAQABAoAAA==.',Sn='Snorlax:AwAGCAoABAoAAA==.',So='Solabord:AwAICAgABAoAAA==.Solignis:AwADCAcABRQDDgADAQheAwBOGjABBRQADgADAQheAwBOGjABBRQADwABAQi1BwAudVYABRQAAA==.Soohots:AwACCAEABAoAAA==.',Sp='Sparklehappy:AwAECAIABAoAAA==.',Sq='Sqù:AwAFCAkABAoAAA==.',St='Storri:AwABCAEABAoAAA==.Stärbücks:AwADCAMABAoAAA==.',Su='Sugarpantz:AwACCAIABAoAAA==.Suoiler:AwAICAgABAoAAA==.',Sw='Swiftly:AwADCAcABRQDEAADAQjzAQBSGMsABRQAEAACAQjzAQBYx8sABRQAEQACAQjDBgBGhaEABRQAAA==.',Ta='Talyndis:AwADCAQABRQDAQAIAQh5CABfkB8DBAoAAQAIAQh5CABfZB8DBAoAEgAEAQhLIwBCq+UABAoAAA==.Tayter:AwADCAMABAoAAA==.',Te='Terrika:AwABCAIABAoAAA==.',Th='Thillarick:AwADCAcABAoAAA==.',Ti='Tiranmyashol:AwAGCAsABAoAAA==.',Ud='Udari:AwABCAIABAoAAA==.',Um='Umàdbrah:AwAGCBEABAoAAA==.',Va='Vaggy:AwAHCBUABAoEBwAHAQgrGQAdaAIBBAoABwAFAQgrGQAcEQIBBAoABgAEAQhTUQAhNb4ABAoAEwADAQg1GwAWiosABAoAAA==.',Wa='Watchmegate:AwAGCBEABAoAAA==.',Ww='Wwalle:AwAGCBEABAoAAA==.',Yo='Yogiebear:AwABCAIABRQCFAAIAQgNBABXyxEDBAoAFAAIAQgNBABXyxEDBAoAAA==.',Za='Zaraa:AwAFCAgABAoAAA==.',Zz='Zzella:AwAGCBIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end