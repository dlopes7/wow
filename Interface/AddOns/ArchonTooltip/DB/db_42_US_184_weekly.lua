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
 local lookup = {'Shaman-Restoration','Priest-Shadow','Mage-Frost','Unknown-Unknown','DeathKnight-Unholy','Paladin-Holy','Warrior-Protection','Monk-Windwalker','DeathKnight-Frost',}; local provider = {region='US',realm='ScarletCrusade',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aamine:AwAFCAgABAoAAA==.',Ac='Acornilly:AwABCAEABRQCAQAIAQgpEwA/BjECBAoAAQAIAQgpEwA/BjECBAoAAA==.Acornkei:AwACCAUABAoAAQEAPwYBCAEABRQ=.',Ai='Ailanthus:AwABCAIABAoAAA==.',Al='Aldrathar:AwABCAEABRQAAA==.',Ar='Archiee:AwADCAQABAoAAA==.Arén:AwADCAYABAoAAA==.',As='Ashamarhaast:AwADCAQABAoAAA==.',Av='Averagesur:AwACCAIABRQCAgAIAQilCgBH/JECBAoAAgAIAQilCgBH/JECBAoAAA==.',Bi='Bigbuns:AwABCAEABRQCAwAIAQh9EgA21DECBAoAAwAIAQh9EgA21DECBAoAAA==.',Br='Brahbrah:AwACCAQABAoAAQQAAAABCAIABRQ=.Brewtality:AwABCAEABAoAAA==.',Bu='Burstangel:AwACCAEABAoAAA==.',Cd='Cdmickey:AwAFCAcABAoAAA==.',Ch='Chibeard:AwADCAgABAoAAA==.',De='Delbert:AwABCAEABAoAAA==.',Dr='Druidney:AwAICAYABAoAAA==.',Du='Dunbarke:AwAFCAwABAoAAA==.',El='Elwynria:AwAECAcABAoAAA==.',Er='Eralan:AwACCAMABAoAAA==.',Fi='Fightswiftjr:AwAFCAgABAoAAA==.',Fo='Fooly:AwAHCAcABAoAAA==.Foorplay:AwADCAgABAoAAA==.',Go='Goopd:AwAICAYABAoAAA==.',Gr='Grimhorn:AwACCAQABAoAAA==.',He='Hessian:AwADCAQABAoAAA==.',Hi='Hillbroken:AwAECAgABAoAAA==.',Hv='Hvit:AwAGCAEABAoAAA==.',In='Inèvitable:AwAECAoABAoAAA==.',Jo='Jolty:AwABCAEABRQCBQAIAQiVAwBaUjQDBAoABQAIAQiVAwBaUjQDBAoAAA==.',Ka='Kaulder:AwABCAEABAoAAA==.',Ke='Ketameanie:AwACCAYABAoAAA==.',Ky='Kynzo:AwAECAoABAoAAA==.',Ma='Maplem:AwACCAQABAoAAA==.Masume:AwABCAEABAoAAA==.',Mi='Mizmonk:AwAFCAwABAoAAA==.',Na='Nametaken:AwAFCAcABAoAAA==.',Pa='Parzivàl:AwABCAEABRQCBgAIAQjxDQArANMBBAoABgAIAQjxDQArANMBBAoAAA==.Paxaa:AwAFCAoABAoAAA==.Paéon:AwACCAQABAoAAA==.',Po='Podnov:AwABCAIABRQAAA==.',Ra='Raink:AwACCAQABAoAAQcAQo0BCAEABRQ=.Raithiss:AwABCAEABRQCBwAIAQh/BABCjU0CBAoABwAIAQh/BABCjU0CBAoAAA==.Ramsesb:AwABCAEABRQAAA==.',Sa='Samsonknight:AwACCAMABAoAAA==.',Si='Silversaiyan:AwAFCA0ABAoAAA==.',Sl='Slade:AwAECAcABAoAAA==.',Sw='Swagidan:AwAGCAgABAoAAA==.Sweatermagic:AwADCAMABAoAAA==.',['S�']='Sçrpunchin:AwAHCBUABAoCCAAHAQhdEQA82RwCBAoACAAHAQhdEQA82RwCBAoAAA==.Sçruffy:AwAECAUABAoAAA==.',Tr='Tricarnetry:AwACCAEABAoAAA==.',Tw='Twentyëyes:AwADCAYABAoAAA==.',Vo='Vortheus:AwADCAYABAoAAA==.',Wi='Windtalon:AwADCAUABAoAAA==.',Ye='Yemozun:AwACCAQABAoAAA==.',Yo='Yoku:AwAHCBQABAoCCQAHAQgaAwBZm74CBAoACQAHAQgaAwBZm74CBAoAAA==.',Za='Zamønk:AwADCAUABAoAAA==.',Zh='Zhrali:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end