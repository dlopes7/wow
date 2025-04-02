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
 local lookup = {'Unknown-Unknown','Priest-Shadow','DemonHunter-Havoc','Paladin-Retribution','DemonHunter-Vengeance',}; local provider = {region='US',realm='Uther',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Addiction:AwABCAEABAoAAA==.',Ah='Ahmet:AwAGCAsABAoAAA==.',Al='Alobar:AwABCAEABAoAAQEAAAAFCAcABAo=.',An='Anroayde:AwACCAIABAoAAA==.',Ap='Apollyøn:AwEGCA4ABAoAAA==.',At='Athennah:AwACCAIABAoAAA==.',Au='Aurene:AwAGCAoABAoAAA==.',Av='Avatard:AwAFCBAABAoAAA==.',Ax='Axem:AwAGCAYABAoAAA==.',Ba='Bandaidkit:AwABCAEABRQCAgAIAQjQEAA3VB4CBAoAAgAIAQjQEAA3VB4CBAoAAA==.',Bi='Bigcheems:AwAICAkABAoAAA==.',Bo='Borthyr:AwAGCAoABAoAAA==.Bowowner:AwAICAgABAoAAA==.',Br='Brokenkrayon:AwAECAMABAoAAA==.',['B�']='Büg:AwAFCBIABAoAAA==.',Ca='Cathaoir:AwAFCAcABAoAAA==.',Ch='Cheer:AwABCAEABAoAAA==.Chookicookie:AwAECAgABAoAAA==.Chrome:AwADCAcABAoAAA==.',Co='Coresh:AwAGCAoABAoAAA==.Cornpuff:AwABCAEABAoAAA==.',['C�']='Cârgorr:AwAECAUABAoAAA==.',Da='Darthtree:AwAGCAwABAoAAA==.',De='Deqlyn:AwAGCAoABAoAAA==.Deschutes:AwAFCAkABAoAAA==.',Do='Domsham:AwABCAEABRQAAA==.Domwarlock:AwAECAQABAoAAA==.',Dr='Drakaina:AwAGCAsABAoAAA==.Druishana:AwACCAQABAoAAA==.Druni:AwABCAEABAoAAA==.',Em='Emokillaz:AwAHCBUABAoCAwAHAQgDKQAtvcsBBAoAAwAHAQgDKQAtvcsBBAoAAA==.',Ep='Epictaxes:AwAGCAoABAoAAA==.Epsilón:AwAFCAYABAoAAA==.',Ev='Evilboo:AwABCAIABAoAAA==.',Fi='Fireboürne:AwAECAcABAoAAA==.',Ga='Gargldees:AwAFCAUABAoAAA==.',Gi='Gipsydanger:AwAGCAMABAoAAA==.',Gl='Glootenfree:AwAGCAoABAoAAA==.',Gr='Greensun:AwAGCA0ABAoAAA==.',Ho='Holychaos:AwACCAQABAoAAA==.',In='Indub:AwABCAIABAoAAA==.Invicible:AwADCAMABAoAAA==.',Is='Ishura:AwACCAQABAoAAA==.',Je='Jebb:AwAGCA0ABAoAAA==.Jebbey:AwABCAEABAoAAQEAAAAGCA0ABAo=.Jericho:AwABCAEABRQAAA==.Jeskà:AwADCAUABAoAAA==.',Ju='Judge:AwAFCAEABAoAAA==.',Ka='Karkea:AwAGCA4ABAoAAA==.',Ke='Kelfhammer:AwAFCAwABAoAAA==.Kenner:AwAICAUABAoCBAAFAQgf+QABPi4ABAoABAAFAQgf+QABPi4ABAoAAA==.',Ko='Kos:AwAGCA0ABAoAAA==.',Kr='Krule:AwACCAIABAoAAA==.',Ku='Kujiera:AwAGCAoABAoAAA==.Kuroro:AwAGCAoABAoAAA==.',La='Laadydi:AwABCAEABAoAAA==.Lad:AwADCAMABAoAAA==.Lavos:AwAGCAoABAoAAA==.',Le='Leopan:AwAFCBAABAoAAA==.',Li='Lisster:AwAICAgABAoAAA==.Liyra:AwAHCBIABAoAAA==.',Lo='Loafe:AwAFCBAABAoAAA==.',Ma='Magicmanh:AwAFCAgABAoAAA==.Malevian:AwAFCA4ABAoAAA==.Mazy:AwAFCAcABAoAAA==.',Mo='Mograem:AwADCAgABAoAAA==.Moobinator:AwACCAIABAoAAQEAAAAGCAsABAo=.Mopsus:AwAFCAkABAoAAA==.',Ni='Ninti:AwACCAQABAoAAA==.Nishgrail:AwAGCAoABAoAAA==.',Ok='Oktharun:AwABCAEABRQAAA==.',Pa='Palexia:AwAGCAoABAoAAA==.Paliboi:AwAECAkABAoAAA==.',Ph='Philidox:AwAGCAkABAoAAA==.',Po='Porkque:AwAGCAYABAoAAA==.Postal:AwAGCAUABAoAAA==.Potatobear:AwAGCA0ABAoAAA==.',Pr='Preparedx:AwAICBUABAoCAwAIAQiPHAAxDS8CBAoAAwAIAQiPHAAxDS8CBAoAAA==.Prifduwies:AwAFCAkABAoAAA==.',Ps='Psylent:AwADCAkABAoAAA==.',Pu='Pump:AwACCAMABAoAAA==.',Qu='Quicktime:AwAFCAkABAoAAA==.',Ra='Ragedh:AwABCAIABRQDAwAIAQiUBABbqUEDBAoAAwAIAQiUBABbqUEDBAoABQACAQhlKwBFyY8ABAoAAA==.Ranillan:AwAGCAoABAoAAA==.',Ro='Roglof:AwAICAkABAoAAA==.',Rt='Rtwofyou:AwAFCBAABAoAAA==.',Sa='Sakkura:AwABCAEABAoAAQEAAAACCAIABAo=.Salionna:AwABCAEABAoAAA==.Samiihell:AwAICBAABAoAAA==.Saoiche:AwACCAQABAoAAA==.',Se='Selenar:AwAECAYABAoAAA==.Selesé:AwAFCAoABAoAAA==.',Sk='Skimtides:AwAGCBAABAoAAA==.',Sm='Smaugdor:AwABCAEABAoAAA==.',So='Solsti:AwAGCAoABAoAAA==.',Sq='Squats:AwACCAIABAoAAA==.Sqweebs:AwABCAIABAoAAA==.',St='Stabbins:AwABCAIABAoAAA==.',Sw='Swifty:AwAICAgABAoAAA==.',Ta='Taggert:AwADCAMABAoAAA==.Talin:AwABCAEABAoAAA==.Taryen:AwAFCAkABAoAAA==.',Te='Telaari:AwAECAgABAoAAA==.',Th='Thalenia:AwAFCA8ABAoAAA==.',Ti='Tikeidari:AwAECAgABAoAAA==.',Ve='Verdilac:AwACCAIABAoAAQEAAAAFCAsABAo=.',Vy='Vyranoth:AwAFCBAABAoAAA==.',We='Weigand:AwADCAYABAoAAA==.',Wi='Windborne:AwAGCA0ABAoAAA==.',Xa='Xaya:AwAFCBAABAoAAA==.',Yo='Yoruechi:AwAFCA4ABAoAAA==.',Ys='Ysoserial:AwAICAgABAoAAA==.',Za='Zahel:AwAGCAoABAoAAA==.',Ze='Zeneri:AwAGCAoABAoAAA==.Zephirum:AwAGCAoABAoAAA==.',Zi='Zimster:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end