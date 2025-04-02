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
 local lookup = {'Paladin-Retribution','Unknown-Unknown','Shaman-Restoration',}; local provider = {region='US',realm='Spinebreaker',name='US',type='weekly',zone=42,date='2025-03-28',data={Al='Alaysia:AwAHCAwABAoAAA==.',Ar='Artshell:AwAECAQABAoAAA==.',Az='Azurialadi:AwACCAUABAoAAA==.',Ba='Barbatosrex:AwABCAEABAoAAA==.',Be='Benimaru:AwABCAIABAoAAA==.',Bo='Bobsalami:AwAHCAgABAoAAA==.',Br='Brightblade:AwAHCBMABAoAAA==.',Cr='Crappytank:AwACCAEABAoAAA==.',['C�']='Cöunter:AwADCAUABRQCAQADAQjMBgBBtP0ABRQAAQADAQjMBgBBtP0ABRQAAA==.',Da='Damyn:AwAFCAQABAoAAA==.Daniella:AwAICBAABAoAAA==.',De='Demark:AwACCAMABAoAAA==.',Ep='Epicfailedin:AwACCAMABAoAAA==.',Fl='Flanuora:AwABCAEABAoAAA==.',Fr='Freshpickle:AwAGCAwABAoAAA==.',Fw='Fwank:AwAGCA8ABAoAAA==.',Ha='Happyflappy:AwECCAQABAoAAQIAAAAGCAwABAo=.Happylights:AwEGCAwABAoAAA==.',He='Heffer:AwACCAIABAoAAA==.',Hi='Hirradee:AwAFCAwABAoAAA==.',Ic='Ichigo:AwACCAIABAoAAA==.',Je='Jesko:AwACCAEABAoAAA==.',Ka='Kaijin:AwAFCAkABAoAAA==.',Ke='Keewii:AwAECAEABAoAAA==.Keleborn:AwACCAMABAoAAA==.',Li='Littlefaith:AwAECAEABAoAAA==.',Lu='Luck:AwAFCAIABAoAAA==.Lugnuts:AwACCAEABAoAAA==.',Ma='Magebuff:AwAECAcABAoAAA==.',Mi='Mistres:AwADCAQABAoAAA==.',Na='Narcyon:AwAGCAgABAoAAA==.',No='Nogard:AwEECAYABAoAAQIAAAAHCA0ABAo=.Noobîtîs:AwABCAEABRQAAA==.',Od='Oddlywindw:AwADCAIABAoAAA==.',Op='Optomee:AwAHCBIABAoAAA==.',Pa='Padi:AwAECAgABAoAAA==.',Pu='Pulmypigtail:AwAFCAgABAoAAA==.',Ri='Riptard:AwABCAEABAoAAA==.Riptide:AwABCAEABAoAAQIAAAABCAEABAo=.',Sc='Scalibros:AwAFCAoABAoAAA==.',Sh='Shauxx:AwAICAgABAoAAA==.',Sl='Sleet:AwABCAEABRQCAwAIAQgACABSB7oCBAoAAwAIAQgACABSB7oCBAoAAA==.',Sm='Smacksthat:AwAGCAkABAoAAA==.',Su='Success:AwEHCA0ABAoAAA==.',Sw='Swagerdactyl:AwAICAgABAoAAA==.',Th='Thane:AwAFCAUABAoAAA==.',Ti='Tikua:AwAECAIABAoAAA==.',Um='Umbry:AwADCAEABAoAAA==.',Un='Unknowndemon:AwAFCAkABAoAAA==.Unknwndemon:AwAECAYABAoAAA==.',Wi='Witheredlick:AwACCAIABAoAAA==.',Zo='Zoêy:AwAECAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end