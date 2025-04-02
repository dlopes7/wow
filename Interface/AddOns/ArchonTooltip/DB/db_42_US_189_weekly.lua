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
 local lookup = {'Priest-Shadow','Warlock-Destruction','Warlock-Demonology','Unknown-Unknown','Hunter-BeastMastery','Warrior-Protection','Shaman-Elemental','Paladin-Protection',}; local provider = {region='US',realm='Shadowmoon',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeonkai:AwAECAMABAoAAA==.',Ak='Akamma:AwABCAEABAoAAA==.',Ba='Backbush:AwADCAcABAoAAA==.',Bi='Bistroboy:AwAICAgABAoAAA==.',Bo='Boneplow:AwADCAcABAoAAA==.',Bu='Bubby:AwAICAEABAoAAA==.',Ch='Chaoscody:AwAECAoABAoAAA==.Chewÿ:AwAICBAABAoAAA==.',Co='Cojarr:AwAFCAkABAoAAA==.Cowadin:AwAECAoABAoAAA==.',Cr='Cru:AwAFCBAABAoAAA==.',Da='Datman:AwAGCAQABAoAAA==.',Di='Diáo:AwAECAYABAoAAA==.',Dr='Drylogic:AwAGCAYABAoAAA==.',Ea='Eap:AwACCAIABAoAAA==.Eazye:AwAGCBQABAoCAQAGAQgAGgA22KQBBAoAAQAGAQgAGgA22KQBBAoAAA==.',El='Elphzz:AwAFCA4ABAoAAA==.',En='Enmma:AwACCAYABRQCAgACAQjECwAwApAABRQAAgACAQjECwAwApAABRQAAA==.',Fe='Felorc:AwAECAwABAoDAwAEAQjZKAA5MaYABAoAAwADAQjZKAAlu6YABAoAAgADAQgMXQA4fJoABAoAAA==.',Fl='Flustered:AwAECAQABAoAAA==.',Fo='Forzay:AwADCAMABAoAAA==.',Fr='Freebird:AwACCAIABAoAAQQAAAAECAQABAo=.Frozaral:AwAECAYABAoAAA==.',Ge='Gelektrael:AwAECAoABAoAAA==.',Ha='Haschel:AwAGCBIABAoAAA==.',Hi='Hillaryduff:AwAFCAcABAoAAA==.',Ho='Hoorycow:AwABCAEABRQAAA==.',Hy='Hycisan:AwAFCAsABAoAAA==.',Je='Jetmage:AwAHCBEABAoAAA==.',Ka='Kaylib:AwAFCAUABAoAAA==.',Ke='Kesatrix:AwAFCAMABAoAAA==.',Kh='Khie:AwAFCAcABAoAAA==.',La='Larsen:AwAECAoABAoAAA==.',Lo='Lokomachina:AwADCAYABRQCBQADAQgpCgAuiOQABRQABQADAQgpCgAuiOQABRQAAA==.',['L�']='Lôko:AwACCAEABAoAAA==.',Mi='Mightyguzz:AwAGCAYABAoAAA==.Mike:AwAGCAwABAoAAA==.',Mu='Muffnmeister:AwAECAQABAoAAA==.',Na='Natë:AwAHCBUABAoCBgAHAQgWBABMxl4CBAoABgAHAQgWBABMxl4CBAoAAA==.',Ne='Neonatomicc:AwAGCBQABAoCBwAGAQi7CwBei3cCBAoABwAGAQi7CwBei3cCBAoAAA==.',Ni='Niykee:AwAFCAcABAoAAA==.',Pe='Perpetva:AwABCAIABAoAAA==.',Po='Poblano:AwADCAQABAoAAA==.',Ra='Raiiz:AwAFCAUABAoAAA==.Rayleïgh:AwABCAEABAoAAA==.',Re='Remilia:AwADCAUABAoAAA==.',Rj='Rjolz:AwAFCAwABAoAAA==.',Sa='Sandalfon:AwAFCAUABAoAAA==.Sanleron:AwAICBgABAoCCAAIAQgECgA3UA4CBAoACAAIAQgECgA3UA4CBAoAAA==.',Se='Seg:AwAECAoABAoAAA==.',Sh='Shikarisuzu:AwAGCAQABAoAAA==.',Sn='Snappy:AwABCAIABAoAAA==.',Sp='Spellz:AwAECAcABAoAAA==.',Sy='Syphon:AwADCAQABAoAAA==.',Ta='Tandarilada:AwABCAEABAoAAA==.',Th='Thryxx:AwABCAEABAoAAA==.',To='Totemator:AwACCAMABAoAAA==.Totemlyawsum:AwADCAoABAoAAA==.',Tr='Traphouse:AwADCAMABAoAAA==.',Tw='Twoshot:AwADCAMABAoAAA==.',Ve='Vexxdr:AwAGCA0ABAoAAQQAAAAHCA0ABAo=.Vexxs:AwAHCA0ABAoAAA==.',Wa='Wargoth:AwAECAsABAoAAA==.',We='Weebeez:AwAHCBAABAoAAA==.',Xa='Xazio:AwAGCAYABAoAAA==.',Yo='Yonie:AwABCAEABRQAAA==.',Yu='Yuànji:AwABCAEABAoAAA==.',Ze='Zedrock:AwAICAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end