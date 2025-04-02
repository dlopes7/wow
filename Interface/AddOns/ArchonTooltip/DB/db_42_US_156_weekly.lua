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
 local lookup = {'Unknown-Unknown','Priest-Discipline','DemonHunter-Havoc','DemonHunter-Vengeance','Hunter-BeastMastery','Monk-Mistweaver','Paladin-Retribution',}; local provider = {region='US',realm='Misha',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Airwaves:AwAICAkABAoAAA==.',Al='Alendria:AwADCAYABAoAAA==.Altair:AwAGCAkABAoAAA==.',Ar='Aridella:AwAECAgABAoAAA==.',As='Asailyn:AwABCAEABAoAAA==.',Ba='Baddragøn:AwADCAYABAoAAA==.',Bi='Billywitchdr:AwAECAwABAoAAA==.',Bl='Bluedomino:AwAECAkABAoAAA==.Bluetoykawi:AwAFCAoABAoAAA==.',Bo='Bolbi:AwABCAEABAoAAA==.',Br='Brokencow:AwAGCAwABAoAAA==.',Ch='Charbaby:AwAHCA4ABAoAAA==.Charitard:AwACCAIABAoAAQEAAAAHCA4ABAo=.Chatan:AwADCAMABAoAAA==.',Da='Darkjager:AwAGCA8ABAoAAA==.',Di='Dilea:AwAECAgABAoAAA==.',Do='Donangus:AwAFCB4ABAoCAgAFAQjjJwAn0gwBBAoAAgAFAQjjJwAn0gwBBAoAAA==.',Dr='Drineyp:AwAICAUABAoAAA==.',['D�']='Díscø:AwAECAUABAoAAA==.',Fa='Farrell:AwAECAUABAoAAA==.',Fe='Festeringstd:AwADCAUABAoAAA==.',Fi='Finhead:AwAFCAUABAoAAA==.',Ga='Galarína:AwAECAgABAoAAA==.',Ge='Genmon:AwAFCA4ABAoAAA==.',Gl='Glym:AwAECAUABAoAAA==.',Gr='Griiv:AwAICAIABAoAAA==.',In='Infernum:AwAECAgABAoAAA==.',Is='Isaikkdk:AwAHCAcABAoAAA==.',Ja='Janeway:AwADCAMABAoAAA==.',Ke='Keeghor:AwADCAIABAoAAQEAAAAICAIABAo=.',Ki='Kilan:AwACCAIABAoAAA==.',Kn='Knaughty:AwAGCBkABAoDAwAGAQgoNQAuA4EBBAoAAwAGAQgoNQArWoEBBAoABAACAQimOAAeFk8ABAoAAA==.',Ku='Kungfubean:AwACCAMABAoAAA==.',Ky='Kyleata:AwAFCA0ABAoAAA==.',Li='Lilylocks:AwADCAIABAoAAA==.',Ly='Lyanah:AwAGCAEABAoAAA==.',Ma='Maggrus:AwACCAUABAoAAA==.Malor:AwADCAMABAoAAA==.Mandalorian:AwAICBcABAoCBQAIAQiQJQBLES8CBAoABQAIAQiQJQBLES8CBAoAAQUAVzYGCBAABRQ=.Mattlock:AwADCAUABAoAAA==.',Mi='Mikaeljayfox:AwAFCAoABAoAAA==.Miyawaki:AwAFCAUABAoAAA==.',Mo='Moobpunch:AwAICAgABAoAAA==.',Mu='Murdalok:AwAECAkABAoAAA==.',Na='Nasene:AwAFCAIABAoAAA==.Natstryker:AwAFCA4ABAoAAA==.',Ni='Nir:AwAECAcABAoAAA==.',Oa='Oaf:AwAECAgABAoAAA==.',Pa='Pandaputin:AwAICA8ABAoAAA==.',Ph='Phroze:AwAGCAoABAoAAA==.',Pl='Plowmcballs:AwAECAQABAoAAA==.',Pr='Pronkeito:AwAECAQABAoAAA==.',Pu='Purin:AwABCAEABRQAAA==.',Ra='Raethu:AwABCAEABAoAAA==.',Ru='Rustybray:AwADCAYABAoAAA==.',Se='Sekha:AwABCAEABAoAAA==.',Sh='Shinsha:AwACCAMABAoAAA==.',Si='Silverlord:AwAECAUABAoAAA==.Simpforsale:AwACCAUABRQCBgACAQh/BwBbRMsABRQABgACAQh/BwBbRMsABRQAAA==.',Sn='Sneevie:AwAGCAsABAoAAA==.Snorehees:AwADCAMABAoAAA==.',So='Songstar:AwAECAgABAoAAA==.',St='Staavon:AwAFCBAABAoAAA==.Starblaze:AwACCAIABAoAAA==.Stopdropnbop:AwAHCBYABAoCBwAHAQhFGgBasKICBAoABwAHAQhFGgBasKICBAoAAA==.',Tr='Trenbologna:AwACCAIABAoAAA==.',Va='Valarion:AwAFCA0ABAoAAA==.',Vo='Volbain:AwADCAYABAoAAA==.',Ya='Yarria:AwABCAEABAoAAA==.',Yi='Yinh:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end