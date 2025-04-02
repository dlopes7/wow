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
 local lookup = {'Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Evoker-Preservation','Unknown-Unknown','Hunter-BeastMastery',}; local provider = {region='US',realm='Ysera',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Ababear:AwAGCAoABAoAAA==.',Ai='Ainseley:AwAFCAkABAoAAA==.',Al='Allionys:AwADCAUABAoAAA==.Alopex:AwADCAMABAoAAA==.',Ar='Arragni:AwABCAEABAoAAA==.',As='Ashw:AwAECAUABAoAAA==.Asukka:AwAECAcABAoAAA==.',Be='Bearlylegal:AwADCAIABAoAAA==.',Bo='Bocephous:AwACCAMABAoAAA==.',Bu='Bunnicula:AwAECAYABAoAAA==.Buttercupp:AwAFCAEABAoAAA==.',Ca='Caelphia:AwADCAoABAoAAA==.Caythus:AwACCAMABRQEAQAIAQgBCwBhHKgCBAoAAQAHAQgBCwBhqqgCBAoAAgADAQh8DABexzgBBAoAAwACAQigHgBgkNYABAoAAA==.',Cl='Cloudburst:AwAGCAsABAoAAA==.',Co='Colibrinoire:AwADCAMABAoAAA==.',De='Deathjeff:AwADCAUABAoAAA==.Deathsgates:AwABCAEABRQCAQAIAQiLEwA9/UoCBAoAAQAIAQiLEwA9/UoCBAoAAA==.Dezzyy:AwAECAEABAoAAA==.',Do='Dokkaebipld:AwAECAsABAoAAQQAQVwCCAUABRQ=.',Dr='Dragønslayer:AwADCAMABAoAAA==.Draksvoid:AwAGCAUABAoAAA==.',['D�']='Dâññy:AwAFCAkABAoAAA==.',Eb='Ebtotem:AwAECAoABAoAAA==.',Ev='Evilrayne:AwAGCAsABAoAAA==.',Fa='Fauxpas:AwADCAUABAoAAA==.',Fe='Feldragon:AwAGCAsABAoAAA==.Fenngri:AwACCAMABRQAAA==.',Fi='Fistandilius:AwADCAMABAoAAA==.',Fl='Flyleaf:AwAECAMABAoAAA==.',Ga='Gaz:AwAHCBEABAoAAA==.',Ge='George:AwADCA0ABAoAAA==.',Gh='Ghulrokk:AwAECAYABAoAAA==.',Gi='Giratìna:AwABCAEABAoAAQUAAAAGCBEABAo=.',Gl='Glenndragon:AwACCAIABAoAAQUAAAAECAcABAo=.',Gr='Graceosilver:AwACCAMABAoAAA==.',Gw='Gwyngad:AwADCAQABAoAAA==.',['G�']='Gårrus:AwAECAQABAoAAA==.',Ha='Hallie:AwADCAYABAoAAA==.Hammercc:AwABCAEABAoAAA==.',He='Helbourne:AwADCAMABAoAAA==.Hereforu:AwADCAIABAoAAA==.',Hw='Hwanwok:AwADCAUABAoAAA==.',Im='Imadragon:AwAFCBEABAoAAA==.Imdeadguy:AwAECAYABAoAAA==.',Ja='Jacquelynn:AwACCAgABAoAAA==.',Js='Jsttrons:AwADCAUABAoAAA==.',Ju='Judgementall:AwADCAIABAoAAA==.',Ka='Kalyope:AwACCAQABAoAAA==.Karpana:AwEECAwABAoAAA==.',Ke='Keloha:AwADCAMABAoAAA==.',Ki='Kintsukuroi:AwADCAQABAoAAA==.Kittykitty:AwAFCAIABAoAAA==.',Ko='Kolzane:AwACCAcABRQCBgACAQhICgBaidQABRQABgACAQhICgBaidQABRQAAA==.',Kr='Krezz:AwADCAUABAoAAA==.',Ky='Kythera:AwADCAEABAoAAQUAAAAGCA8ABAo=.',Li='Lichmade:AwAICAgABAoAAA==.',Lo='Lokaroki:AwABCAIABAoAAA==.',Ly='Lyzoldas:AwADCAMABAoAAA==.',Ma='Malchromatus:AwABCAIABAoAAA==.',Me='Merlinthos:AwADCAQABAoAAQUAAAAFCAkABAo=.Metaljack:AwAFCAkABAoAAA==.',Mo='Mooveit:AwADCAQABAoAAA==.',Na='Natalìa:AwADCAQABAoAAA==.',Ne='Nepheleah:AwAFCAEABAoAAA==.Nesmoth:AwAGCBEABAoAAA==.',Or='Ortar:AwAICAgABAoAAA==.',Pa='Pakno:AwABCAIABAoAAA==.',Pr='Preacherheal:AwADCAMABAoAAA==.',Pu='Puraevil:AwACCAMABAoAAA==.',Ra='Ramosdek:AwABCAEABAoAAA==.',Ry='Ryniel:AwAECA0ABAoAAA==.',Sa='Sadge:AwADCAMABAoAAQUAAAABCAEABRQ=.Sanasta:AwADCAYABAoAAA==.Saramoon:AwADCAYABAoAAA==.',Se='Seethinghate:AwADCAMABAoAAA==.',Sh='Shazrra:AwAGCBAABAoAAA==.Shieldforge:AwADCAMABAoAAA==.Shong:AwAGCA8ABAoAAA==.',Si='Silentio:AwAFCAkABAoAAA==.Sinofwrath:AwADCAMABAoAAA==.Sinsaurus:AwABCAEABAoAAA==.Sinsidious:AwADCAMABAoAAA==.',Sm='Smoko:AwADCAMABAoAAA==.',So='Solusrush:AwACCAEABAoAAA==.',Sp='Sploo:AwACCAIABAoAAA==.',St='Strohs:AwABCAEABAoAAA==.',Ta='Talyon:AwADCAMABAoAAA==.Tatertotem:AwAFCAIABAoAAA==.',Th='Thalstrasza:AwAFCAEABAoAAA==.The:AwACCAIABAoAAA==.',Tr='Tristanthia:AwAFCAEABAoAAA==.',Ul='Uldric:AwADCAUABAoAAA==.',Va='Vadien:AwABCAEABAoAAA==.Valazdin:AwAGCA4ABAoAAA==.',Ve='Veternosa:AwADCAMABAoAAA==.',Vi='Villain:AwAFCAIABAoAAA==.',Vl='Vll:AwADCAMABAoAAA==.',Wa='Wakenbake:AwABCAEABRQAAA==.',Xt='Xtena:AwAICAgABAoAAA==.',Za='Zaco:AwADCAMABAoAAA==.Zaether:AwAGCAYABAoAAA==.Zarko:AwADCAUABAoAAA==.',Ze='Zendàya:AwADCAMABAoAAA==.',Zi='Zinovia:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end