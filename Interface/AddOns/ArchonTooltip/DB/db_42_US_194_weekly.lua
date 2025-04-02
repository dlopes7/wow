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
 local lookup = {'Unknown-Unknown','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction',}; local provider = {region='US',realm="Shu'halo",name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adelyana:AwACCAEABAoAAA==.',Af='Aftershocks:AwAHCAgABAoAAA==.',Ag='Agarmon:AwAFCAkABAoAAA==.',Al='Allaris:AwAECAEABAoAAA==.',Ar='Aryabhatta:AwAECAEABAoAAA==.',Ba='Badpallytwo:AwABCAEABAoAAA==.',Be='Beefsupriem:AwAECAEABAoAAA==.Beelzerrbub:AwAICAgABAoAAQEAAAAICBAABAo=.',Bi='Biohazard:AwAHCBIABAoEAgAHAQjDCABH1tIBBAoAAgAGAQjDCABNqNIBBAoAAwADAQjfTAA6jdIABAoABAABAQheJQAsM0YABAoAAA==.',Bo='Bonekrusha:AwABCAEABAoAAA==.',Da='Darkblades:AwADCAMABAoAAQEAAAAHCAgABAo=.',De='Deader:AwADCAUABAoAAA==.',Dr='Druecc:AwAECAEABAoAAA==.',Du='Duckyfur:AwAGCBAABAoAAA==.',Em='Emeraldlight:AwABCAEABRQAAA==.',Fe='Felixious:AwAFCAsABAoAAA==.',Fo='Foutre:AwAECAEABAoAAA==.',Fr='Frostdee:AwAECAEABAoAAA==.',Ge='Getlnmyvan:AwABCAMABRQAAA==.',Go='Gorvax:AwAECAEABAoAAA==.',Gw='Gwenledyr:AwAGCBAABAoAAA==.',Ho='Holychoochoo:AwADCAYABAoAAA==.',Il='Ilovetaylor:AwACCAIABAoAAA==.',Ka='Karai:AwACCAIABAoAAQIAR9YHCBIABAo=.',Kh='Khalli:AwAECAEABAoAAA==.',Kl='Klaylee:AwABCAEABAoAAA==.',Li='Lilazymonk:AwABCAIABAoAAA==.',Ly='Lynites:AwADCAMABAoAAA==.',Ma='Malganon:AwADCAQABAoAAA==.Mathelmana:AwAECAkABAoAAA==.',Mi='Mistspring:AwAECAEABAoAAA==.',Mo='Mokaccino:AwAFCAYABAoAAA==.Morghella:AwAGCBAABAoAAA==.Morphvenzerr:AwAICBAABAoAAA==.Mouthbreathr:AwADCAEABAoAAA==.',Ne='Nesmae:AwABCAEABAoAAQEAAAAFCAEABAo=.',No='Nohkash:AwADCAQABAoAAA==.Noirra:AwAFCAEABAoAAA==.',Or='Orgasmos:AwADCAMABAoAAA==.',Ov='Overfrosty:AwAECAEABAoAAA==.',Po='Popedope:AwAECAgABAoAAQIAR9YHCBIABAo=.',['PÃ']='PÃ¤l:AwAGCA0ABAoAAA==.',Ra='Ransus:AwAECAUABAoAAA==.',Sa='Sardenn:AwABCAEABRQAAA==.',Sc='Scottcooney:AwAECAEABAoAAA==.',Sh='Shallowheart:AwACCAEABAoAAA==.Shamane:AwABCAEABAoAAA==.',Sl='Sliceschmax:AwADCAIABAoAAA==.',So='Sokorag:AwAGCA0ABAoAAA==.',Sp='Spooktober:AwACCAMABAoAAQEAAAAICAEABAo=.',Sq='Squatchie:AwACCAIABAoAAA==.',St='Starrbuck:AwAECAEABAoAAA==.',Ta='Taksun:AwADCAcABAoAAA==.',Tr='Tritium:AwADCAQABAoAAA==.Trojaan:AwAICAgABAoAAA==.Trollbridge:AwAHCA0ABAoAAA==.',Ug='Uggo:AwAGCAYABAoAAA==.',Un='Uncleremus:AwABCAEABAoAAA==.',Va='Valenbaby:AwACCAIABAoAAA==.',Wa='Warriorname:AwAECAYABAoAAA==.',Wo='Wong:AwACCAEABAoAAA==.',Xa='Xanvarani:AwACCAIABAoAAA==.',Xe='Xergos:AwACCAIABAoAAA==.',Ya='Yakushimaru:AwACCAMABAoAAA==.',Za='Zarella:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end