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
 local lookup = {'Unknown-Unknown','Hunter-Marksmanship','Rogue-Outlaw','Rogue-Subtlety','Monk-Mistweaver','Priest-Shadow','Warrior-Fury','Mage-Frost',}; local provider = {region='US',realm='Blackhand',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeninas:AwADCAYABAoAAA==.Aethwyn:AwADCAIABAoAAA==.',Ag='Agandaur:AwABCAEABAoAAA==.',Al='Aleinjochas:AwAGCA0ABAoAAA==.',Am='Amethystra:AwAGCAkABAoAAA==.Amlu:AwAECAcABAoAAQEAAAAFCAgABAo=.',Ba='Bachren:AwABCAEABAoAAA==.',Be='Beertrain:AwAECAQABAoAAA==.Bellezza:AwAGCAYABAoAAA==.',Bo='Bobitt:AwADCAQABAoAAA==.Bootysweatz:AwAICAgABAoAAA==.Bowdaciöus:AwABCAEABAoAAA==.',Br='Bravedh:AwADCAMABAoAAA==.Braver:AwACCAUABRQCAgACAQiRBAAsGYYABRQAAgACAQiRBAAsGYYABRQAAA==.',Ca='Caranina:AwADCAQABAoAAA==.Cassei:AwAGCAYABAoAAA==.',Ce='Celorious:AwAGCAYABAoAAA==.',Cr='Cratoz:AwAGCA4ABAoAAA==.',Cy='Cyndrine:AwAGCBAABAoAAA==.',Da='Daltina:AwAICAgABAoAAA==.Danderas:AwAICAgABAoAAA==.Dareael:AwAFCAsABAoAAA==.',De='Deathrowe:AwADCAIABAoAAA==.Denouncer:AwADCAoABAoAAA==.Dents:AwADCAEABAoAAA==.',Do='Donlazul:AwAHCBMABAoAAA==.',Dr='Draconoth:AwADCAEABAoAAA==.',Du='Dungard:AwAGCAYABAoAAA==.',Ee='Eemerald:AwACCAIABAoAAA==.',Eg='Egna:AwAFCAYABAoAAA==.',Es='Essexqt:AwAGCA4ABAoAAA==.',Ev='Evilclared:AwACCAIABAoAAA==.',Fa='Faelyianna:AwADCAMABAoAAA==.',Fo='Forsakenly:AwAFCAMABAoAAA==.',Fr='Freshstart:AwABCAEABAoAAA==.Frostmage:AwAGCA0ABAoAAA==.',Fu='Furgus:AwAECAkABAoAAA==.Futonadin:AwAGCAcABAoAAA==.',Ga='Gailyn:AwADCAQABAoAAA==.',Gr='Greed:AwAHCBQABAoDAwAHAQiCBAAtTZsBBAoAAwAHAQiCBAAtTZsBBAoABAADAQjXJwARzX8ABAoAAA==.Grismistea:AwAECAEABAoAAA==.',Gu='Gusmo:AwABCAEABAoAAA==.',Ha='Hashhbrown:AwABCAEABAoAAA==.',Hu='Humphrees:AwAGCA4ABAoAAA==.',['H�']='Hàtos:AwAHCA4ABAoAAA==.Hàtoz:AwAGCAYABAoAAA==.',In='Inteuss:AwAECAYABAoAAA==.',Iz='Izzac:AwAECAYABAoAAA==.',Ke='Kelzier:AwACCAIABAoAAQEAAAAFCAgABAo=.',Ko='Korry:AwACCAIABAoAAA==.Kortinas:AwABCAIABAoAAA==.',Kr='Krilliz:AwAHCAcABAoAAA==.',['K�']='Kàstielle:AwAHCAcABAoAAA==.',La='Landissa:AwAECAwABAoAAA==.',Li='Ligmadots:AwADCAYABAoAAA==.Lizze:AwAFCAgABAoAAA==.',Ll='Llihon:AwAFCAEABAoAAA==.',Lo='Loverocket:AwAGCAsABAoAAA==.',Ly='Lyshion:AwAGCA4ABAoAAA==.',Ma='Mageyôulook:AwAGCAwABAoAAA==.Mangerhotie:AwAFCAUABAoAAA==.Mattdemon:AwAGCA4ABAoAAA==.',Me='Meowlevolent:AwAFCAQABAoAAA==.',Mo='Moosakka:AwAGCAwABAoAAA==.Moß:AwAECAkABAoAAA==.',Ni='Niqkle:AwAGCAYABAoAAA==.Nizbiz:AwACCAIABAoAAA==.',Ny='Nyralim:AwABCAIABAoAAA==.',Ol='Olehanna:AwAGCA4ABAoAAA==.',Pa='Paladrand:AwAECAgABAoAAA==.',Pe='Peachslime:AwAECAkABRQCBQAEAQidAQBH920BBRQABQAEAQidAQBH920BBRQAAA==.',Ph='Phokue:AwABCAEABAoAAA==.',Pu='Pulshadow:AwAGCA0ABAoAAA==.',Pw='Pwnan:AwADCAUABAoAAA==.',['P�']='Píckleríck:AwADCAQABAoAAA==.',Ra='Ragnar:AwAICAsABAoAAA==.Rammalen:AwACCAMABAoAAA==.Ranes:AwAGCA4ABAoAAA==.',Re='Reacharound:AwABCAEABAoAAA==.Renasen:AwAFCAsABAoAAA==.',Rh='Rhyssen:AwABCAIABAoAAA==.',Ro='Roxxye:AwADCAMABAoAAA==.',Ru='Rumulos:AwADCAUABAoAAA==.',Ry='Rynoh:AwAGCAsABAoAAA==.Ryse:AwACCAIABAoAAA==.',Sc='Scaleorva:AwADCAYABAoAAA==.Schnappz:AwAECAIABAoAAA==.',Se='Sepheras:AwAECAYABAoAAA==.',Sh='Sharpest:AwAFCAsABAoAAA==.',Si='Sinergee:AwADCAcABAoAAA==.',Sl='Slingerz:AwAGCAYABAoAAA==.',So='Solkar:AwAECAEABAoAAA==.',Sp='Sparkaurabot:AwACCAUABRQCBgACAQj8BwBA46EABRQABgACAQj8BwBA46EABRQAAA==.',St='Starliner:AwAGCAYABAoAAA==.Styxíe:AwABCAEABAoAAA==.',Ta='Taliss:AwADCAQABAoAAA==.Taras:AwACCAQABRQCBwACAQi7BwBWjcYABRQABwACAQi7BwBWjcYABRQAAA==.Tarcanisdk:AwAECAsABAoAAA==.Tazergun:AwAECAgABAoAAA==.',Tc='Tchala:AwAFCAgABAoAAA==.',Th='Thaine:AwAGCAYABAoAAA==.Thich:AwAGCAwABAoAAA==.',Tr='Trujolt:AwADCAQABAoAAA==.',Tu='Turdinated:AwADCAYABRQCAgADAQgcAgAvqeMABRQAAgADAQgcAgAvqeMABRQAAA==.',Va='Vannida:AwACCAIABAoAAA==.',Wh='Whale:AwADCAQABAoAAA==.',Wi='Willôw:AwADCAMABAoAAA==.',Wo='Wonpiece:AwAGCBMABAoAAA==.',Yo='Yozz:AwABCAEABAoAAA==.',Ze='Zelph:AwABCAIABRQCCAAIAQiGCQBHcaECBAoACAAIAQiGCQBHcaECBAoAAA==.',Zi='Zieganfuss:AwAGCAwABAoAAA==.',Zo='Zoho:AwADCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end