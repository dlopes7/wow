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
 local lookup = {'Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Unknown-Unknown','Monk-Windwalker','Paladin-Holy','Paladin-Retribution','DeathKnight-Frost','DeathKnight-Unholy','DeathKnight-Blood','Monk-Mistweaver','Hunter-BeastMastery',}; local provider = {region='US',realm='Eredar',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aamon:AwAGCAIABAoAAA==.',Ad='Adam:AwAECAoABRQEAQAEAQiUBQBHSuMABRQAAQADAQiUBQArPOMABRQAAgACAQgMAwBcOMkABRQAAwABAQhXAgBdnm4ABRQAAA==.Adragon:AwAECAEABAoAAA==.',Al='Allsmiles:AwACCAQABAoAAA==.Allura:AwABCAEABAoAAA==.Alyysha:AwAGCAsABAoAAA==.',Am='Amoon:AwADCAQABAoAAA==.',Ar='Arckady:AwABCAEABAoAAA==.',Ba='Badaboom:AwACCAIABAoAAA==.Barrenwuffet:AwACCAIABAoAAA==.',Bi='Bigfluffy:AwADCAIABAoAAA==.Bio:AwAFCA0ABAoAAA==.',Bl='Blackhearth:AwAFCAcABAoAAA==.Bladesmcgee:AwACCAIABAoAAQQAAAACCAIABAo=.',Bo='Boomstick:AwAECAYABAoAAA==.',Br='Brendoh:AwAGCA0ABAoAAA==.Brewswayne:AwACCAIABAoAAA==.',Ca='Calisa:AwADCAQABAoAAA==.',Ch='Chickynugs:AwABCAEABAoAAA==.',Co='Cosmi:AwACCAEABAoAAA==.Coulee:AwACCAMABAoAAA==.',De='Deffy:AwADCAQABAoAAA==.',Do='Docholiday:AwAICAoABAoAAA==.',Dr='Dracarius:AwABCAEABAoAAA==.Drarghon:AwACCAIABAoAAA==.Dryad:AwABCAEABAoAAA==.',Du='Durkk:AwADCAQABAoAAA==.',Es='Estara:AwADCAQABAoAAA==.',Et='Etali:AwADCAQABAoAAA==.',Fa='Fanis:AwADCAQABAoAAA==.',Fi='Fibo:AwEFCAYABAoAAA==.',Fo='Forgiven:AwADCAMABRQCBQAIAQgFAgBeJ1ADBAoABQAIAQgFAgBeJ1ADBAoAAA==.',Fr='Frakir:AwADCAQABAoAAA==.Francis:AwACCAMABAoAAQQAAAAGCAwABAo=.',Fw='Fwapp:AwACCAMABRQCBgAIAQiVAwBR4cICBAoABgAIAQiVAwBR4cICBAoAAA==.',Ge='Gemini:AwADCAMABAoAAA==.Genny:AwACCAQABAoAAA==.',Gr='Grizzle:AwABCAEABAoAAA==.',Ic='Ickyvicki:AwAHCAcABAoAAA==.',Il='Ilenor:AwABCAEABAoAAA==.',Im='Imperius:AwABCAIABRQCBwAIAQgAIgBHN3ICBAoABwAIAQgAIgBHN3ICBAoAAA==.',In='Insomiax:AwAGCAMABAoAAA==.',Ja='Jarrin:AwACCAMABAoAAA==.',Ju='Juicy:AwAECAcABAoAAA==.',Ki='Kinan:AwADCAQABAoAAA==.Kita:AwADCAIABAoAAA==.',Kr='Krishnamurti:AwABCAEABAoAAA==.',Ky='Kynra:AwADCAIABAoAAA==.Kyonko:AwADCAQABAoAAA==.Kythin:AwAGCAwABAoAAA==.',Li='Livewire:AwABCAEABAoAAA==.',Lo='Lomponic:AwAGCBAABAoAAA==.',Ma='Manakendrick:AwACCAQABRQDAgAIAQhMAgBFRXYCBAoAAgAIAQhMAgA/FnYCBAoAAQAGAQgmJgBLQ7oBBAoAAA==.Manyfists:AwACCAIABAoAAA==.Marlboroguy:AwABCAEABRQCCAAHAQgFAwBdNMMCBAoACAAHAQgFAwBdNMMCBAoAAA==.Marxman:AwAGCAIABAoAAA==.',Mc='Mcribz:AwACCAMABRQCCQAIAQjwBwBWMeECBAoACQAIAQjwBwBWMeECBAoAAA==.',Mi='Mistqt:AwAECAsABRQCCgAEAQhLAQBELVYBBRQACgAEAQhLAQBELVYBBRQAAA==.',Mo='Monnehbaggs:AwAECAIABAoAAA==.Mooinator:AwAHCBsABAoCBwAHAQh5MABF7CoCBAoABwAHAQh5MABF7CoCBAoAAA==.',Na='Nairdax:AwABCAEABAoAAA==.Nalia:AwAGCAYABAoAAQQAAAAGCAwABAo=.',Ne='Necriss:AwADCAgABAoAAA==.',Ni='Nike:AwAICA4ABAoAAA==.',Or='Ordestur:AwACCAQABAoAAA==.',Pa='Papapump:AwAHCBAABAoAAA==.Parlare:AwABCAEABAoAAQQAAAAFCAUABAo=.',Pi='Pinga:AwAFCAUABAoAAA==.',Pr='Praying:AwAECAMABAoAAA==.',Ps='Pseriph:AwAGCAwABAoAAA==.',Ra='Rakin:AwACCAMABAoAAA==.Raun:AwADCAgABAoAAA==.',Re='Relaire:AwACCAIABAoAAA==.Resonate:AwAICAoABAoAAA==.',Ri='Riku:AwADCAIABAoAAA==.',Ro='Robbin:AwADCAQABAoAAA==.Ronse:AwAECAMABAoAAA==.',Sa='Sathanus:AwABCAEABAoAAA==.',Sh='Shihøin:AwAGCAYABAoAAA==.Shortsighted:AwAFCAIABAoAAQkAVjECCAMABRQ=.Shortsword:AwAECAEABAoAAQkAVjECCAMABRQ=.Shumn:AwACCAIABAoAAA==.',Si='Silverwolf:AwAFCAsABAoAAA==.Sinon:AwAHCAYABAoAAA==.Sizzlechop:AwADCAUABAoAAA==.',So='Songs:AwAICBkABAoCCwAIAQhuDwBAv1ACBAoACwAIAQhuDwBAv1ACBAoAAA==.Sorbak:AwACCAIABAoAAQQAAAAICBMABAo=.Sosuke:AwABCAEABAoAAA==.',Sp='Sparklerocks:AwADCAcABAoAAA==.',St='Strecagosa:AwADCAQABAoAAA==.',Sv='Svenn:AwACCAQABAoAAA==.',Te='Teengirl:AwADCAQABAoAAA==.',Th='Themantyler:AwABCAEABAoAAA==.',Ti='Tirna:AwADCAQABAoAAA==.',Ts='Tsunade:AwAHCAwABAoAAA==.',Tu='Tullen:AwEDCAQABAoAAA==.Turanos:AwABCAEABAoAAA==.',Un='Unggoy:AwAECAkABRQCDAAEAQiJAQBNkIoBBRQADAAEAQiJAQBNkIoBBRQAAA==.',Ur='Urmum:AwADCAMABAoAAQQAAAAECAYABAo=.',Va='Valkaryon:AwACCAIABAoAAQQAAAAICAoABAo=.',Ve='Vedacia:AwACCAEABAoAAA==.',Vi='Virt:AwAFCAoABAoAAQEANBEBCAEABRQ=.',Wa='Wackashaman:AwAGCBAABAoAAA==.Wafuzz:AwADCAIABAoAAA==.',Wh='Whipnsniff:AwADCAMABAoAAA==.',Wr='Wraith:AwAGCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end