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
 local lookup = {'Shaman-Enhancement','Priest-Shadow','Priest-Holy','Druid-Restoration','Monk-Mistweaver','Hunter-BeastMastery','Druid-Feral','Mage-Frost','Mage-Fire','Warrior-Fury','Evoker-Devastation','Paladin-Retribution','Paladin-Holy','DeathKnight-Blood','Unknown-Unknown','Warlock-Affliction','Warlock-Demonology','Warlock-Destruction','Warrior-Arms','Shaman-Elemental','DeathKnight-Unholy','Druid-Balance','Monk-Windwalker','Hunter-Survival',}; local provider = {region='US',realm='Khadgar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adalaide:AwABCAEABRQAAA==.',Ae='Aedras:AwAGCAwABAoAAA==.',Al='Aliraeda:AwAGCAwABAoAAA==.Alisara:AwAHCAcABAoAAQEAQyEBCAIABRQ=.Alysra:AwABCAEABAoAAA==.',Am='Amasu:AwABCAIABRQDAgAIAQjCCQBPiqECBAoAAgAHAQjCCQBZdKECBAoAAwABAQiTXQAyA0IABAoAAA==.',Ap='Aphis:AwABCAEABAoAAA==.',Ar='Arcangel:AwABCAIABRQCBAAIAQhVAgBcGCQDBAoABAAIAQhVAgBcGCQDBAoAAA==.Argand:AwAFCAwABAoAAA==.',At='Atheren:AwAGCBEABAoAAA==.',Ay='Ayani:AwAFCAIABAoAAA==.',Az='Azrazule:AwADCAQABAoAAA==.',Ba='Baconweaver:AwADCAMABAoAAA==.Bagelz:AwABCAIABRQCBQAIAQiHBQBUifQCBAoABQAIAQiHBQBUifQCBAoAAA==.Bayla:AwAGCAYABAoAAQYARN4DCAUABRQ=.',Be='Bec:AwAGCA0ABAoAAA==.Beefcat:AwAICBgABAoCBwAIAQjPAABha0oDBAoABwAIAQjPAABha0oDBAoAAA==.',Bi='Bigboymanguy:AwABCAEABRQAAA==.Biron:AwAFCA0ABAoAAA==.',Bl='Bluedrankk:AwABCAEABAoAAA==.Blugó:AwAICAgABAoAAA==.Blurpleberry:AwACCAIABAoAAA==.',Ca='Catastrophe:AwACCAMABAoAAA==.',Ce='Cenvoked:AwAGCAEABAoAAA==.',Ch='Charlicious:AwAECAsABAoAAA==.Chedwiwwiper:AwACCAIABAoAAA==.Chithel:AwABCAEABRQAAA==.Chocomochi:AwAECAoABAoAAA==.Chyna:AwABCAEABAoAAA==.',Ci='Circuit:AwACCAIABAoAAA==.',Cl='Clouds:AwAGCAIABAoAAA==.',Co='Coolbeans:AwADCAkABAoAAQcAYWsICBgABAo=.',Cy='Cynadora:AwAGCA4ABAoAAA==.',['C�']='Cáustic:AwAECAYABAoAAA==.',De='Deathmaster:AwAFCA8ABAoAAA==.Devilwoman:AwACCAIABAoAAQcAYWsICBgABAo=.',Di='Diggut:AwACCAMABAoAAA==.Diosa:AwAGCA4ABAoAAA==.',Dm='Dmz:AwAECAcABAoAAA==.',Do='Doeydruid:AwAFCAoABAoAAA==.',Dr='Dragondude:AwAECAEABAoAAA==.',Du='Dumbledory:AwAICAUABAoAAA==.',['D�']='Dàhlià:AwABCAEABAoAAA==.',El='Ellasian:AwACCAMABAoAAA==.Eloise:AwAFCAoABAoAAA==.Eltria:AwABCAIABRQDCAAIAQjoAABhx3YDBAoACAAIAQjoAABhx3YDBAoACQADAQjtSwBNvdkABAoAAA==.',Ep='Epirius:AwAICAgABAoAAA==.',Es='Essential:AwABCAEABRQCCgAGAQiEGgBNJQkCBAoACgAGAQiEGgBNJQkCBAoAAA==.',Et='Ethop:AwAECAIABAoAAQcAYWsICBgABAo=.',Ez='Ezz:AwABCAEABAoAAA==.',Fe='Felartamiel:AwAECAgABAoAAA==.Felhoof:AwADCAEABAoAAA==.',Fl='Flappywalsh:AwADCAQABRQCCwAIAQifAQBd1UIDBAoACwAIAQifAQBd1UIDBAoAAA==.Flubber:AwADCAUABAoAAA==.',Fo='Forestspirit:AwAGCA4ABAoAAA==.',Fr='Frodostabbns:AwAECAYABAoAAA==.',Ga='Galadryel:AwABCAEABRQCAgAIAQgWEwAwFgMCBAoAAgAIAQgWEwAwFgMCBAoAAA==.Gangrene:AwABCAEABRQAAA==.Ganguskahn:AwACCAIABAoAAA==.',Ge='Geist:AwABCAIABRQDDAAIAQgmFABT480CBAoADAAHAQgmFABeNc0CBAoADQAHAQhpEgAuAIgBBAoAAA==.Geraith:AwABCAIABRQCDgAIAQjZAQBdoU0DBAoADgAIAQjZAQBdoU0DBAoAAA==.Gerios:AwAGCBAABAoAAA==.',Gl='Glendra:AwAGCA0ABAoAAA==.Gloomfx:AwAICAgABAoAAA==.',Go='Gorbosplort:AwAGCA0ABAoAAQ8AAAACCAMABRQ=.Gothicka:AwAECAIABAoAAA==.',Gr='Gregoriusz:AwADCAYABRQCBgADAQgtCgArDOQABRQABgADAQgtCgArDOQABRQAAA==.',Gu='Guntank:AwAGCAIABAoAAA==.',Hi='Hierodoulos:AwAGCAIABAoAAA==.',Ho='Homedepot:AwAGCBAABAoAAA==.Howiedoohan:AwADCAMABAoAAA==.',Hu='Hunthard:AwACCAIABAoAAA==.',Ik='Ikthus:AwABCAIABRQEEAAIAQiDBAAwWwgCBAoAEAAIAQiDBAAwWwgCBAoAEQABAQhcRAAKRSgABAoAEgABAQg7hQAPJSQABAoAAA==.',In='Infected:AwABCAIABRQDEgAHAQimGwA+KQsCBAoAEgAHAQimGwA+KQsCBAoAEQABAQgkOQBAwlAABAoAAA==.',Ja='Jaywilde:AwABCAEABRQDCgAIAQjJJQAlHqIBBAoACgAHAQjJJQAjZqIBBAoAEwADAQgMKgAj28gABAoAAA==.',Je='Jellystalker:AwACCAIABRQCBgAIAQgdJQBCNTICBAoABgAIAQgdJQBCNTICBAoAAA==.',Ju='Judgementt:AwACCAIABAoAAQQASbQCCAMABRQ=.Justbringit:AwABCAIABAoAAQ8AAAABCAIABRQ=.',Ka='Karnamoo:AwAECAMABAoAAA==.Karotten:AwAECAkABAoAAA==.Katsumotto:AwABCAIABAoAAA==.',Ke='Keello:AwACCAIABAoAAA==.',Kh='Khzule:AwAICAgABAoAAA==.',Ko='Koko:AwAECAEABAoAAA==.',Kr='Kromaga:AwAICAIABAoAAA==.Kröm:AwAICAkABAoAAA==.',Ky='Kyrhios:AwAECAgABAoAAA==.',La='Laindra:AwAGCBEABAoAAA==.Lark:AwABCAIABAoAAA==.',Le='Lealia:AwABCAIABRQDAQAGAQhXGABDIcUBBAoAAQAGAQhXGABDIcUBBAoAFAABAQitUQAVTi4ABAoAAA==.',Li='Liams:AwABCAEABAoAAA==.Litmas:AwAGCAcABAoAAA==.',Ll='Llysandrea:AwAGCAIABAoAAA==.Llòth:AwACCAIABAoAAA==.',Lo='Lolskate:AwAECAEABAoAAA==.',Lr='Lrrp:AwADCAIABAoAAA==.',Ly='Lytol:AwACCAQABAoAAA==.',Ma='Manathas:AwACCAIABAoAAA==.Massacre:AwACCAIABRQCFQAIAQhQBgBWhv0CBAoAFQAIAQhQBgBWhv0CBAoAAA==.Maxamis:AwAGCBEABAoAAA==.Maxieflames:AwAFCAUABAoAAA==.',Mi='Milin:AwADCAMABAoAAA==.',Mo='Modwolf:AwABCAEABAoAAA==.Mohini:AwAGCA0ABAoAAA==.Monq:AwADCAMABAoAAA==.Mordinsolus:AwAECAYABAoAAA==.Moulin:AwAGCBIABAoAAA==.',Na='Napkinz:AwAICBoABAoCFgAIAQhgBQBYch8DBAoAFgAIAQhgBQBYch8DBAoAAA==.',Ne='Neameto:AwAGCA4ABAoAAA==.Ness:AwABCAEABRQAAA==.',Ni='Nikkikayama:AwABCAIABRQCBgAIAQhhHABIVHMCBAoABgAIAQhhHABIVHMCBAoAAA==.',No='Norikoff:AwABCAIABRQAAA==.',Nu='Nubios:AwACCAEABAoAAQ8AAAADCAMABAo=.',Ny='Nynox:AwAECAQABAoAAA==.',['N�']='Nügg:AwADCAUABAoAAA==.',Od='Odenpanda:AwABCAEABRQAAA==.',On='Onlyvlprfans:AwABCAIABRQAAA==.Onyxander:AwAHCBAABAoAAA==.',Pa='Paolon:AwACCAMABAoAAA==.',Ph='Philkulson:AwACCAIABAoAAQ8AAAAGCAcABAo=.',Pu='Punkvc:AwACCAEABAoAAA==.',Py='Pyrrah:AwADCAQABAoAAA==.',['P�']='Párts:AwADCAQABAoAAQ8AAAAECAkABAo=.',Qu='Quaeras:AwAGCAIABAoAAA==.',Ra='Radiantgoat:AwAGCBEABAoAAA==.',Re='Recky:AwAGCBMABAoAAA==.Remus:AwAICA4ABAoAAA==.Revanxo:AwABCAEABRQAAA==.',Ri='Riptar:AwAHCBwABAoCBgAHAQiHKQBAmRUCBAoABgAHAQiHKQBAmRUCBAoAAA==.',Ru='Rumlock:AwAECAYABAoAAA==.',Sa='Sal:AwAHCAMABAoAAA==.Salivan:AwADCAgABAoAAA==.Savvywalnuts:AwAGCAYABAoAAA==.Saxophone:AwAGCAIABAoAAA==.',Se='Secksy:AwACCAIABAoAAA==.Seiya:AwAECAsABAoAAA==.Senshisan:AwAICAgABAoAAA==.Sensi:AwADCAMABAoAAA==.Serkawne:AwADCAEABAoAAA==.',Sh='Shakkirah:AwACCAEABAoAAA==.Shampaign:AwAHCAEABAoAAA==.Shamuza:AwEBCAEABRQCAQAIAQjrFQAj0uUBBAoAAQAIAQjrFQAj0uUBBAoAAA==.Sharrah:AwAICAgABAoAAA==.Shatterskull:AwABCAEABAoAAA==.',Si='Sideffects:AwAGCA4ABAoAAA==.Silvercircle:AwAECAMABAoAAA==.Silverlord:AwACCAIABAoAAA==.Sinsong:AwAICBIABAoAAA==.Sinzar:AwABCAIABRQDCAAIAQinDQBE/msCBAoACAAIAQinDQBENGsCBAoACQADAQhaWAAqXJgABAoAAA==.Siv:AwADCAYABAoAAA==.',Sl='Sliggeryjig:AwAHCAUABAoAAA==.',St='Stabel:AwACCAIABAoAAA==.Stitches:AwAECAYABAoAAA==.Studdmuffin:AwAICBEABAoCFQAIAQi/EABAalkCBAoAFQAIAQi/EABAalkCBAoAAA==.Stõrmy:AwACCAMABRQCBAAIAQjUBwBJtIsCBAoABAAIAQjUBwBJtIsCBAoAAA==.',Su='Suzé:AwAGCBEABAoAAA==.',Sy='Sylvië:AwAICBAABAoAAA==.Syrioforel:AwAECAEABAoAAA==.',Ta='Taginor:AwABCAEABRQCFwAIAQiuCABMfLECBAoAFwAIAQiuCABMfLECBAoAAA==.Tanala:AwACCAIABAoAAA==.Tater:AwAGCAYABAoAAA==.',Te='Telzindrov:AwAGCAIABAoAAA==.',Th='Thehealness:AwACCAIABAoAAA==.Thepalelady:AwAGCAkABAoAAQ8AAAAICAgABAo=.Thundermuffn:AwADCAEABAoAAA==.Thundernuts:AwAFCA0ABAoAAA==.Théière:AwAGCAIABAoAAA==.',Tr='Tray:AwACCAQABRQCBAAIAQjCDABAGDICBAoABAAIAQjCDABAGDICBAoAAA==.',Ts='Tsukiku:AwAECAQABAoAAA==.',Tu='Tuc:AwABCAIABAoAAA==.',Ty='Typhoontravv:AwACCAQABRQCDAAIAQjuBQBfGksDBAoADAAIAQjuBQBfGksDBAoAAA==.Tyrsspear:AwAGCAIABAoAAA==.',Uf='Ufearme:AwABCAEABAoAAA==.',Ug='Ugabooga:AwABCAEABRQAAA==.',Ut='Uthur:AwAECAgABAoAAA==.Utterchaos:AwABCAIABRQEEgAIAQiUJgA3+bcBBAoAEgAHAQiUJgA457cBBAoAEAACAQjzHAAf/IQABAoAEQABAQjhNwBMVlUABAoAAA==.',Va='Valfore:AwAFCAwABAoAAA==.Vanebane:AwAGCA4ABAoAAA==.Vasila:AwAGCBAABAoAAA==.Vayle:AwAGCAIABAoAAA==.',Ve='Velinasonara:AwABCAEABAoAAQ8AAAAGCA4ABAo=.Venser:AwAGCAIABAoAAA==.Vetta:AwABCAEABRQAAA==.',Wi='Willferrell:AwABCAIABAoAAA==.',Xa='Xara:AwAGCBEABAoAAA==.',Xe='Xeroxoxo:AwABCAIABRQAAA==.',Ym='Ymedruid:AwABCAIABRQCBwAIAQj9AgBRyccCBAoABwAIAQj9AgBRyccCBAoAAA==.',Yu='Yuck:AwAGCBcABAoDGAAGAQipBwAsnCEBBAoAGAAFAQipBwAvVyEBBAoABgABAQhKqgAe+EAABAoAAA==.Yueyue:AwADCAYABAoAAA==.',Za='Zaptor:AwABCAEABAoAAA==.Zaraxxi:AwAFCAwABAoAAA==.',Ze='Zenturtle:AwADCAEABAoAAA==.',Zi='Zindi:AwADCAMABAoAAA==.',Zo='Zoobee:AwACCAEABAoAAA==.Zoog:AwABCAIABRQCDQAIAQhQBABORKsCBAoADQAIAQhQBABORKsCBAoAAA==.',['À']='Àsdread:AwAFCAsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end