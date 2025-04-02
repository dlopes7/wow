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
 local lookup = {'Mage-Frost','Unknown-Unknown','Hunter-BeastMastery','Shaman-Restoration','Rogue-Assassination','Rogue-Subtlety','Mage-Arcane','Mage-Fire','Warrior-Arms','Monk-Mistweaver','Paladin-Retribution','Priest-Discipline','Druid-Feral','Hunter-Marksmanship','DemonHunter-Vengeance','Warlock-Destruction','Priest-Holy','Shaman-Enhancement','Warlock-Affliction',}; local provider = {region='US',realm='Exodar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Ablivien:AwABCAMABRQCAQAHAQjaDgBOfVwCBAoAAQAHAQjaDgBOfVwCBAoAAA==.',Aq='Aquamyst:AwAECAoABAoAAA==.',Ar='Arctica:AwAECAQABAoAAQIAAAAICAgABAo=.Arctre:AwAECAQABAoAAA==.',Au='Aukatsang:AwABCAMABRQAAA==.',Ba='Banaritaz:AwAFCAoABAoAAA==.Bayla:AwADCAUABRQCAwADAQjvBgBE3hkBBRQAAwADAQjvBgBE3hkBBRQAAA==.',Be='Bearomir:AwAFCBAABAoAAA==.Benjam:AwAECAcABAoAAA==.',Bi='Bigghugz:AwAFCAIABAoAAQQANWUCCAUABRQ=.',Bl='Blanket:AwABCAEABRQDBQAIAQilFgAhdCQBBAoABgAGAQgDGwARxSwBBAoABQAEAQilFgAtUCQBBAoAAA==.',Br='Brewslock:AwADCAMABAoAAA==.',Ce='Cereas:AwACCAQABAoAAA==.',Ch='Chicknnugget:AwAFCAkABAoAAA==.',Cl='Clukdogg:AwABCAIABRQCAwAHAQgwJQBEMjECBAoAAwAHAQgwJQBEMjECBAoAAA==.',Da='Datia:AwAFCAoABAoAAQIAAAAGCA0ABAo=.',Do='Dora:AwAICBAABAoAAA==.',Dp='Dpsvendor:AwAECAQABAoAAA==.',Dr='Dreamq:AwAICBsABAoDBwAIAQgDAgBPBiUCBAoABwAGAQgDAgBY3yUCBAoACAAIAQjkIwA4F+cBBAoAAQgAVbQFCA4ABRQ=.Drylie:AwABCAMABRQCAwAHAQhJFgBb26YCBAoAAwAHAQhJFgBb26YCBAoAAA==.',Dt='Dtinnel:AwAECAgABAoAAQIAAAAFCA0ABAo=.',El='Elandra:AwAGCAkABAoAAA==.',Em='Emmone:AwAECAEABAoAAA==.',En='Energydrink:AwAECAoABAoAAA==.',Es='Escopae:AwADCAEABAoAAA==.',Fa='Faunna:AwAFCAsABAoAAA==.',Fe='Febb:AwAHCAIABAoAAA==.',Fr='Frathi:AwABCAIABRQAAA==.Frrank:AwABCAEABRQCCQAHAQiaAgBhNQ8DBAoACQAHAQiaAgBhNQ8DBAoAAA==.',Fu='Funnelcake:AwAECAYABAoAAA==.',Ga='Gabagooldan:AwAFCA0ABAoAAA==.Galcain:AwAGCBIABAoAAA==.',Gu='Gudetama:AwAECAcABAoAAA==.',He='Helixra:AwAECAQABAoAAA==.',Hu='Huteley:AwAFCA8ABAoAAA==.Huxter:AwADCAMABAoAAA==.',Ip='Ipx:AwABCAEABRQCCgAIAQgaHwAnNKkBBAoACgAIAQgaHwAnNKkBBAoAAA==.',Ja='Jacksson:AwAHCBUABAoCCwAHAQhAVQAoyJsBBAoACwAHAQhAVQAoyJsBBAoAAA==.Jasonandrory:AwADCAEABAoAAA==.Jayja:AwAHCBQABAoCAwAHAQjQcwAHkdIABAoAAwAHAQjQcwAHkdIABAoAAA==.',Je='Jeyd:AwAGCAkABAoAAA==.',Jo='Johnfkent:AwAECAQABAoAAA==.Jonahheal:AwAGCA0ABAoAAQQANWUCCAUABRQ=.',Ka='Kaael:AwAFCAUABAoAAA==.Kainiy:AwAGCAQABAoAAA==.Kalzil:AwABCAEABAoAAA==.Kawaiiwaffl:AwAFCAIABAoAAA==.Kazule:AwADCAUABAoAAA==.',Ke='Keeller:AwAECAcABAoAAA==.',Kr='Krinprisun:AwABCAIABRQCDAAIAQg3BgBKPbQCBAoADAAIAQg3BgBKPbQCBAoAAA==.',Ky='Kynthria:AwACCAIABAoAAQIAAAAFCAoABAo=.',La='Lampion:AwAHCA8ABAoAAA==.Lasstchance:AwACCAEABAoAAA==.',Le='Lenorah:AwAFCAoABAoAAA==.Leroth:AwACCAEABAoAAA==.',Li='Linds:AwAFCAoABAoAAA==.',Lo='Lockbruh:AwADCAUABAoAAA==.',Lu='Luxu:AwAFCA4ABAoAAA==.',Mo='Moonunit:AwABCAEABRQCDQAHAQgzAgBeM/MCBAoADQAHAQgzAgBeM/MCBAoAAA==.Mooseboy:AwAECAQABAoAAA==.Moshworm:AwADCAIABAoAAA==.',Ne='Nelaphim:AwAFCAoABAoAAA==.Nesu:AwABCAEABAoAAQIAAAAFCA8ABAo=.',Ni='Nico:AwACCAIABAoAAA==.',No='Noxxidari:AwAFCAoABAoAAA==.Noxxus:AwACCAIABAoAAA==.',['N�']='Nãh:AwABCAEABAoAAA==.',Or='Orcchops:AwACCAIABAoAAA==.',Pe='Peontotem:AwAICAoABAoAAA==.',Ph='Phishncheese:AwABCAEABRQAAA==.',Pi='Pinkrosé:AwAICBAABAoAAA==.',Po='Pocket:AwACCAgABAoAAQIAAAABCAEABRQ=.',Qi='Qillratha:AwADCAQABAoAAA==.',Ra='Rathidk:AwABCAEABRQAAA==.',Re='Renia:AwACCAMABAoAAA==.',Ri='Rinnax:AwABCAEABAoAAQIAAAAFCAoABAo=.Rith:AwABCAEABAoAAA==.',Ru='Ruká:AwABCAIABAoAAA==.Ruukia:AwAFCA0ABAoAAA==.',Sa='Samoltera:AwADCAYABAoAAA==.',Sc='Scaly:AwACCAEABAoAAQIAAAABCAEABRQ=.',Se='Selena:AwABCAEABAoAAA==.Selindea:AwAFCAUABAoAAA==.',Sh='Shaeen:AwAFCAEABAoAAA==.',Sk='Skybles:AwAFCAoABAoAAA==.',So='Soilwork:AwAICAgABAoAAA==.',Sw='Swan:AwAGCAYABAoAAA==.',['S�']='Séxyhunter:AwAICBYABAoDAwAIAQiIIAA/F1MCBAoAAwAIAQiIIAA/F1MCBAoADgAEAQgdMQAO9YEABAoAAA==.Séxymage:AwADCAgABAoAAA==.',Ta='Taloriesh:AwABCAEABAoAAA==.',Te='Teito:AwAGCAEABAoAAA==.',Th='Thundrtheigs:AwAFCAwABAoAAA==.',Ti='Tides:AwABCAEABRQAAA==.Tilamano:AwAFCAoABAoAAA==.Timaeus:AwABCAIABRQCDwAHAQgrBABazscCBAoADwAHAQgrBABazscCBAoAAA==.',To='Tohrnado:AwAFCAoABAoAAA==.Toobie:AwACCAIABAoAAA==.',['T�']='Téchymoon:AwABCAIABRQCEAAHAQiBGgA+/BQCBAoAEAAHAQiBGgA+/BQCBAoAAA==.',Ug='Ugo:AwAHCA4ABAoAAA==.',Va='Valcristo:AwAFCAoABAoAAA==.',Ve='Vegean:AwACCAUABAoAAA==.Venous:AwAFCAoABAoAAA==.Vexmir:AwACCAMABAoAAA==.',Vi='Vicariana:AwABCAIABRQDEQAHAQhEBwBhzKoCBAoAEQAHAQhEBwBZVqoCBAoADAAGAQhrBwBiKZkCBAoAAA==.',Vo='Vodmor:AwABCAEABAoAAA==.Voidpocketz:AwABCAEABRQAAA==.',Wa='Warrenstorm:AwABCAMABRQCEgAHAQiiBQBe/fYCBAoAEgAHAQiiBQBe/fYCBAoAAA==.',Wi='Widerichard:AwAFCAgABAoAAA==.',Wo='Wowbelly:AwABCAIABRQCCgAIAQiDAQBeDlMDBAoACgAIAQiDAQBeDlMDBAoAAA==.',Xo='Xonk:AwABCAMABRQCEwAHAQgIBgA3gdIBBAoAEwAHAQgIBgA3gdIBBAoAAA==.',Zk='Zkull:AwAICAIABAoAAA==.',['Ð']='Ðaywalker:AwAFCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end