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
 local lookup = {'Unknown-Unknown','Monk-Mistweaver','Mage-Arcane','DeathKnight-Blood','Shaman-Restoration','Monk-Windwalker','Shaman-Enhancement','Shaman-Elemental',}; local provider = {region='US',realm='Antonidas',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abraxa:AwADCAEABAoAAA==.',Ag='Aggrenox:AwABCAIABAoAAA==.',Al='Alyssea:AwAECAgABAoAAA==.',As='Asti:AwAGCAoABAoAAA==.',Be='Beörn:AwADCAsABAoAAA==.',Bi='Birger:AwADCAQABAoAAA==.',Bo='Bondchi:AwACCAIABAoAAA==.',Bw='Bwca:AwAICAQABAoAAQEAAAAICA8ABAo=.',Ce='Cellina:AwAICAgABAoAAA==.',Ch='Chellester:AwACCAEABAoAAA==.',Da='Dadda:AwAICAUABAoAAA==.Darthwang:AwADCAUABAoAAA==.',De='Deathsbff:AwAFCAgABAoAAA==.Deathstár:AwAFCAEABAoAAA==.Deepfister:AwABCAEABAoAAQEAAAACCAIABAo=.',Di='Dizz:AwAGCA4ABAoAAA==.',Do='Docquinn:AwADCAEABAoAAA==.Dontcare:AwADCAQABAoAAA==.',Ee='Eegroll:AwADCAgABAoAAA==.',Eg='Egraw:AwADCAUABAoAAA==.',Ep='Epia:AwAICAkABAoAAA==.',Ex='Excision:AwACCAIABAoAAA==.',Fa='Fahbio:AwABCAIABAoAAA==.',Fe='Felore:AwABCAIABAoAAA==.',Fu='Fudd:AwABCAIABAoAAA==.Funkelt:AwACCAIABAoAAA==.',Ga='Garou:AwAFCBAABAoAAA==.',Gi='Gigazug:AwAGCBEABAoAAA==.',Gl='Gladorf:AwABCAIABAoAAA==.',Gn='Gnomad:AwACCAEABAoAAA==.',Go='Gouge:AwAHCBIABAoAAA==.',Gr='Gráve:AwABCAEABAoAAA==.',Gy='Gyrashun:AwAFCAcABAoAAA==.',Hi='Hiken:AwACCAUABRQCAgACAQj1CQA8BaAABRQAAgACAQj1CQA8BaAABRQAAA==.Hippopotamus:AwAFCAUABAoAAA==.',Ic='Icelancelot:AwACCAIABAoAAA==.',Ka='Kathia:AwACCAIABAoAAA==.',Ke='Kellayna:AwABCAIABAoAAA==.',Ki='Kianthus:AwAICBgABAoCAwAIAQiZAQBFQlUCBAoAAwAIAQiZAQBFQlUCBAoAAA==.',Ko='Koragg:AwABCAEABRQCBAAIAQghBgBTFroCBAoABAAIAQghBgBTFroCBAoAAA==.',Kr='Krissia:AwADCAMABAoAAA==.',['K�']='Kîn:AwABCAIABAoAAA==.',La='Laisera:AwAHCBMABAoAAA==.Lalipop:AwABCAIABAoAAA==.Lauma:AwAHCAcABAoAAQEAAAAICA8ABAo=.',Li='Littletimmy:AwAECAQABAoAAA==.',Lu='Luciferal:AwACCAMABAoAAA==.',Ma='Mashka:AwAICA8ABAoAAA==.',Mi='Missbehaving:AwAFCAYABAoAAA==.',Mo='Moonbear:AwABCAEABAoAAA==.Moxeymoron:AwACCAIABAoAAA==.',Mu='Mumra:AwACCAIABAoAAA==.',Na='Naelvis:AwACCAQABAoAAA==.Nalassa:AwAGCA0ABAoAAA==.Nannette:AwABCAIABAoAAA==.',Ne='Newport:AwACCAIABAoAAA==.',Ni='Niara:AwABCAIABAoAAA==.',No='Nofreaknway:AwABCAEABAoAAQEAAAAHCBIABAo=.Nowon:AwAICAEABAoAAA==.',Ny='Nybors:AwADCAgABAoAAA==.',Op='Opalohko:AwABCAIABAoAAA==.',Ow='Owthpela:AwAECAcABAoAAA==.',Pa='Palladiium:AwACCAIABAoAAA==.',Pl='Platious:AwAFCAYABAoAAA==.',Po='Pookaboo:AwADCAUABAoAAA==.',Qu='Quetzálcoatl:AwABCAIABAoAAA==.',Se='Semmi:AwAGCAIABAoAAA==.',Sh='Shamjacksonn:AwAHCCgABAoCBQAHAQhnBgBeLtwCBAoABQAHAQhnBgBeLtwCBAoAAA==.Shlonk:AwABCAMABRQDAgAHAQgmEABMOkUCBAoAAgAHAQgmEABMOkUCBAoABgABAQhyUgAOMSQABAoAAA==.Shlumpa:AwAICAgABAoAAA==.',Sn='Snusnurae:AwABCAEABAoAAA==.',Sp='Spartskky:AwAHCAMABAoAAA==.Spicychopz:AwAICA0ABAoAAA==.',Ss='Sscarlet:AwADCAEABAoAAA==.',Sz='Szef:AwAICAsABAoAAA==.',Ta='Talynne:AwABCAIABAoAAA==.Tangerene:AwAHCA4ABAoAAA==.Tap:AwAICAgABAoAAA==.Taterdot:AwAECAcABAoAAA==.',Th='Thayne:AwABCAEABAoAAA==.Thiccidàn:AwACCAIABAoAAA==.',To='Tonarvolt:AwACCAIABAoAAA==.',Uj='Ujio:AwABCAIABAoAAQEAAAADCAUABAo=.',Va='Valenstrasz:AwAGCAwABAoAAA==.Vanvis:AwABCAEABAoAAA==.',Ve='Velaeiraline:AwABCAEABAoAAA==.Velkris:AwAECAQABAoAAA==.Velyth:AwABCAEABRQDBwAHAQgvGgAvuK4BBAoABwAGAQgvGgA1C64BBAoACAABAQjuUAAPwjAABAoAAA==.Vexxius:AwAFCAkABAoAAA==.',['V�']='Vàlkyrie:AwAGCBAABAoAAA==.',Wa='Warienta:AwAICAgABAoAAA==.',Wt='Wtfrpets:AwAFCAcABAoAAA==.',Yo='Yourpali:AwABCAEABAoAAA==.',Za='Zahne:AwABCAEABAoAAQEAAAAFCA4ABAo=.',Zi='Ziaya:AwABCAIABAoAAA==.',['É']='Éhomi:AwACCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end