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
 local lookup = {'Hunter-BeastMastery','Unknown-Unknown','Warrior-Fury','Priest-Holy','Paladin-Holy','Druid-Guardian',}; local provider = {region='US',realm='Alexstrasza',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acalin:AwABCAEABAoAAA==.Aceon:AwAFCAYABAoAAA==.',Ad='Adamanthia:AwAICAwABAoAAA==.',Al='Alerîn:AwABCAEABRQAAA==.Allarol:AwAICBgABAoCAQAIAQgeIQA7aU8CBAoAAQAIAQgeIQA7aU8CBAoAAA==.Alyzisa:AwADCAEABAoAAA==.',Ar='Arelliana:AwAGCBAABAoAAA==.Arthes:AwAICBAABAoAAA==.',Be='Beenah:AwADCAMABAoAAA==.Beni:AwAECAQABAoAAA==.',Bi='Biggerbeast:AwAICAEABAoAAA==.',Bl='Blasphemiae:AwADCAUABAoAAA==.Blodeuedd:AwAGCAoABAoAAA==.Blueaurora:AwAGCAMABAoAAA==.',Bo='Boltzaper:AwADCAMABAoAAA==.',Br='Brotund:AwAGCBAABAoAAA==.',Bu='Bubblzmgee:AwAECAgABAoAAA==.',Ca='Carahz:AwABCAEABAoAAA==.',Ch='Chen:AwAGCAYABAoAAA==.',Cl='Cloudedmonk:AwADCAMABAoAAA==.',Co='Corrode:AwAFCAkABAoAAA==.',Cr='Cricky:AwAFCAYABAoAAA==.Crimsymonk:AwADCAUABAoAAA==.',Do='Dormuwu:AwACCAEABAoAAA==.',El='Elystaria:AwADCAMABAoAAA==.',Em='Emokins:AwAECAgABAoAAA==.',En='Endesh:AwAECAgABAoAAA==.',Er='Eryss:AwADCAMABAoAAA==.',Ev='Evoked:AwADCAcABAoAAA==.',Fa='Faithfulone:AwACCAIABAoAAQIAAAADCAMABAo=.',Fl='Flameoutt:AwAECAcABAoAAA==.',Gh='Ghoulmania:AwAICBEABAoAAA==.',Go='Gormoly:AwADCAMABAoAAA==.',Gr='Grouchy:AwADCAMABAoAAA==.',Ho='Holymana:AwADCAIABAoAAA==.',Hu='Hutzil:AwABCAEABAoAAA==.',Ia='Iakopa:AwAGCBIABAoAAA==.',Im='Imfiredup:AwAICAIABAoAAA==.',Ja='Jaefury:AwAFCAgABAoAAA==.',Ju='Juanjo:AwAGCA8ABAoAAA==.',Ka='Kadywompus:AwABCAEABAoAAA==.Kait:AwACCAMABAoAAA==.Kaladnys:AwADCAIABAoAAA==.Kannoli:AwAICBYABAoCAwAIAQgtDABMfKYCBAoAAwAIAQgtDABMfKYCBAoAAA==.',Ko='Koralie:AwADCAYABAoAAA==.Koyomí:AwAFCAcABAoAAA==.',Li='Lillitthh:AwAICA8ABAoAAA==.',Ma='Main:AwAGCA8ABAoAAA==.Manek:AwAFCAUABAoAAA==.',Me='Mel:AwABCAEABAoAAA==.Mentor:AwADCAcABAoAAA==.',Mo='Monsoon:AwAGCAkABAoAAQQAUJgDCAQABRQ=.Moonkist:AwACCAMABAoAAA==.Moonpool:AwAECAYABAoAAA==.Moose:AwAGCAkABAoAAA==.Morpheos:AwAECAwABAoAAA==.',Ni='Nivox:AwACCAIABAoAAA==.',Op='Opheliastar:AwAFCAgABAoAAA==.',Pa='Pad:AwADCAMABAoAAA==.Pallyown:AwAFCAsABAoAAA==.Pandemic:AwABCAMABRQAAQQAUJgDCAQABRQ=.',Pl='Plagueborn:AwABCAEABAoAAA==.',['P�']='Pètter:AwAICAIABAoAAA==.',Ri='Rikimarou:AwAFCAgABAoAAA==.',Ru='Ruki:AwAFCAMABAoAAA==.',Sa='Sajjar:AwABCAEABAoAAA==.',Se='Sevris:AwAECAgABAoAAA==.',Si='Siley:AwACCAQABAoAAA==.',Sk='Skarletfaith:AwADCAMABAoAAA==.Skrowtumb:AwAICBAABAoAAA==.Skyshy:AwAECAgABAoAAA==.',Sp='Spëcter:AwACCAQABAoAAQIAAAADCAUABAo=.',Su='Superpallyz:AwABCAEABRQCBQAGAQjuBwBaBUsCBAoABQAGAQjuBwBaBUsCBAoAAA==.Superpriestz:AwACCAIABAoAAQUAWgUBCAEABRQ=.Supersoaker:AwAHCBUABAoCBgAHAQhKAgBPE2ACBAoABgAHAQhKAgBPE2ACBAoAAA==.',Ta='Tarogen:AwACCAMABAoAAA==.',Te='Teleion:AwADCAUABAoAAA==.',Th='Thanamoros:AwADCAMABAoAAA==.Themönk:AwAFCAgABAoAAA==.',Ti='Tinkerballa:AwAECAIABAoAAA==.',To='Toeren:AwAGCBMABAoAAA==.',Tr='Truefarty:AwAECAIABAoAAA==.',Ub='Ubvoided:AwAFCAcABAoAAA==.',Ug='Uglyelf:AwAFCAkABAoAAA==.',Va='Vantrix:AwAFCAYABAoAAA==.',Ve='Velthala:AwADCAUABAoAAA==.',Wo='Worship:AwADCAQABRQCBAAIAQg8BgBQmMACBAoABAAIAQg8BgBQmMACBAoAAA==.',Xe='Xenodozer:AwAECAoABAoAAA==.',Xl='Xlock:AwABCAEABAoAAQIAAAAGCAkABAo=.',Xp='Xpiree:AwAGCAkABAoAAA==.',Yo='Yorakk:AwADCAQABAoAAA==.Youngdip:AwAECAQABRQAAA==.',Ze='Zeke:AwAFCAkABAoAAA==.Zephymoo:AwAGCBMABAoAAA==.',Zo='Zoose:AwAECAgABAoAAA==.Zoser:AwAFCAgABAoAAA==.',['É']='Érubus:AwAFCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end