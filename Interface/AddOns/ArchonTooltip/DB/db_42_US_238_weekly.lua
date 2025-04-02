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
 local lookup = {'Unknown-Unknown','Druid-Balance','Druid-Restoration','Priest-Discipline','Priest-Holy','Priest-Shadow','Shaman-Enhancement','Hunter-BeastMastery','DeathKnight-Blood','Mage-Fire','DemonHunter-Havoc','DemonHunter-Vengeance',}; local provider = {region='US',realm='Wildhammer',name='US',type='weekly',zone=42,date='2025-03-28',data={Aq='Aquabat:AwAGCA8ABAoAAA==.',['A�']='Aí:AwAFCAwABAoAAA==.',Ba='Bartab:AwAECAIABAoAAA==.Battlegrouns:AwAGCAwABAoAAA==.',Be='Beau:AwAFCAsABAoAAA==.Bestadi:AwABCAEABAoAAQEAAAACCAIABAo=.',Bl='Blastyu:AwAECAgABAoAAA==.',Bo='Boston:AwADCAMABAoAAA==.',Br='Brandoo:AwABCAIABAoAAA==.',Bu='Burnah:AwAECAoABAoAAA==.Burphette:AwAFCAQABAoAAA==.Buttonsmash:AwABCAEABRQDAgAIAQhvGQBORBcCBAoAAgAGAQhvGQBTdhcCBAoAAwAIAQhvEQA5i+oBBAoAAA==.',Bw='Bwonsamdí:AwADCAEABAoAAA==.',['B�']='Bên:AwABCAEABAoAAA==.',Co='Cobi:AwAFCAIABAoAAA==.Colamitus:AwAICAwABAoAAA==.Combo:AwACCAIABRQAAA==.',Cr='Cralgar:AwAGCAwABAoAAA==.Crates:AwAFCAYABAoAAA==.Croakam:AwABCAEABAoAAQEAAAAFCBEABAo=.',Da='Daigle:AwADCAcABAoAAA==.Damues:AwAFCAsABAoAAA==.Darkling:AwABCAIABRQAAA==.',De='Demet:AwAHCAgABAoAAA==.Dethsoul:AwABCAEABRQEBAAGAQh1EABKFvIBBAoABAAGAQh1EABKFvIBBAoABQADAQivPAA+VckABAoABgABAQijTwAHkBkABAoAAA==.',Di='Dixonmybut:AwACCAMABRQCBwAIAQjfCQBG5qUCBAoABwAIAQjfCQBG5qUCBAoAAA==.',Dr='Dreamblast:AwAFCBAABAoAAA==.',El='Elkshamen:AwAFCAsABAoAAA==.',Fa='Faerless:AwAECAQABAoAAA==.Faoton:AwAGCAsABAoAAA==.Farmtoon:AwADCAQABAoAAA==.Faustt:AwAGCAkABAoAAA==.',Ga='Garrosh:AwAFCAgABAoAAA==.',Ge='Geörge:AwACCAMABRQCBgAIAQgrBQBWivkCBAoABgAIAQgrBQBWivkCBAoAAA==.',Gl='Globglo:AwAGCAoABAoAAA==.',Gr='Grismond:AwAFCAwABAoAAA==.',Ha='Haedrath:AwACCAIABAoAAA==.',Im='Imtoasty:AwABCAEABAoAAA==.',Ja='Jalax:AwAGCAsABAoAAA==.',Ka='Kano:AwAICBoABAoCCAAIAQhwIwA8fjMCBAoACAAIAQhwIwA8fjMCBAoAAA==.',Kh='Khory:AwABCAEABRQCCQAGAQiIDQBOEgICBAoACQAGAQiIDQBOEgICBAoAAA==.',Li='Liriel:AwAICAgABAoAAA==.',Lt='Ltgubbinz:AwACCAIABAoAAA==.',Lu='Luneztoprime:AwADCAMABAoAAA==.',Ma='Mag:AwAHCA0ABAoAAA==.Mantussy:AwAFCA4ABAoAAA==.Matt:AwABCAEABAoAAA==.Maylbrook:AwAFCAMABAoAAA==.',Mo='Moonshine:AwAFCAUABAoAAQoAOfEGCBgABAo=.',Na='Nanju:AwACCAEABAoAAA==.Napzz:AwABCAEABAoAAA==.Nathanael:AwAFCAkABAoAAA==.',Ni='Nikodemos:AwACCAMABRQDCwAIAQhzBQBbzzQDBAoACwAIAQhzBQBbzzQDBAoADAADAQhTKQA1050ABAoAAA==.',Pa='Papamidnight:AwACCAIABAoAAA==.',Pe='Penguinadin:AwAFCAUABAoAAA==.',Ra='Ragingwater:AwAFCAsABAoAAA==.Rajamana:AwABCAEABRQAAA==.Raylei:AwAFCAMABAoAAA==.',Re='Redvelvet:AwADCAEABAoAAA==.',Sa='Sahomi:AwAFCAsABAoAAA==.',Sh='Shandrisa:AwAHCBEABAoAAA==.',So='Somazugzug:AwAHCAoABAoAAA==.',Sp='Spincycle:AwADCAMABAoAAA==.',St='Stanleyy:AwACCAIABAoAAA==.',Ta='Tarnished:AwACCAEABAoAAA==.',Th='Thedegz:AwAGCAoABAoAAA==.',Ti='Tissue:AwAECAcABAoAAA==.',Tw='Tworaccoons:AwAFCAQABAoAAA==.',Ul='Ulghar:AwAGCAkABAoAAA==.',Va='Vangpao:AwABCAEABAoAAA==.',Ve='Vengefül:AwACCAIABAoAAA==.Vexie:AwAECAsABAoAAA==.',Wa='Washedup:AwAECAQABAoAAA==.',Wo='Wolfadin:AwAGCAMABAoAAA==.',Wu='Wuhshake:AwACCAIABAoAAA==.',Xe='Xenophics:AwABCAIABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end