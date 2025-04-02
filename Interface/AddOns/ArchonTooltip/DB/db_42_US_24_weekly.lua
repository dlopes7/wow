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
 local lookup = {'Hunter-Marksmanship','DeathKnight-Frost','DeathKnight-Blood','Warlock-Destruction','Warlock-Affliction','Warrior-Fury','Paladin-Protection','Monk-Mistweaver','Mage-Frost','Hunter-BeastMastery','Paladin-Holy','Paladin-Retribution','DemonHunter-Vengeance','Shaman-Enhancement','Shaman-Restoration','Monk-Windwalker','Rogue-Assassination','Druid-Feral','Warrior-Arms','Priest-Shadow','Druid-Balance','DemonHunter-Havoc','Mage-Fire','Rogue-Outlaw','Druid-Restoration','Evoker-Devastation','Warrior-Protection','Unknown-Unknown','Priest-Holy',}; local provider = {region='US',realm='AzjolNerub',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Addy:AwAFCAoABAoAAA==.',Ai='Aispere:AwAFCAkABAoAAA==.',Al='Alledria:AwABCAMABRQAAA==.',Am='Amphi:AwAHCAMABAoAAA==.',Ar='Arcadian:AwABCAEABRQAAA==.Arnixp:AwABCAEABRQAAA==.',As='Ashnikko:AwADCAQABAoAAA==.',Au='Auberon:AwAFCAUABAoAAA==.',Az='Azi:AwADCAYABRQCAQADAQg1AgAqcNcABRQAAQADAQg1AgAqcNcABRQAAA==.',Ba='Badankhadonk:AwABCAIABRQAAA==.Badazzmom:AwABCAEABAoAAA==.Badpope:AwAFCAUABAoAAA==.',Be='Beefmuffinz:AwADCAYABRQDAgADAQilAQBJYq8ABRQAAgACAQilAQBOc68ABRQAAwABAQijCwA/Pk8ABRQAAA==.Bendeekay:AwABCAIABRQCAwAHAQhTBQBdI9gCBAoAAwAHAQhTBQBdI9gCBAoAAA==.',Br='Brionthicc:AwAFCAUABAoAAQQAMekDCAcABRQ=.Brownington:AwAFCAUABAoAAA==.Brìonik:AwADCAcABRQDBAADAQhLBgAx6dQABRQABAADAQhLBgAou9QABRQABQACAQgZBQAz56QABRQAAA==.',Ca='Canyon:AwAFCAUABAoAAA==.Cariagne:AwAGCA4ABAoAAA==.',Ci='Cindylune:AwADCAMABAoAAA==.',Cl='Clazzicola:AwABCAEABRQAAA==.',Cp='Cptncrush:AwAECAUABAoAAA==.',Cr='Crowshadow:AwABCAIABAoAAA==.',Cy='Cyther:AwADCAcABRQCBgADAQjGBQAuKAsBBRQABgADAQjGBQAuKAsBBRQAAA==.',De='Decix:AwADCAcABRQCBwADAQhlAgA/3OoABRQABwADAQhlAgA/3OoABRQAAA==.Deletedelves:AwAFCAUABAoAAA==.Demonickill:AwACCAIABAoAAA==.Desolation:AwAGCA8ABAoAAA==.',Di='Dicot:AwACCAcABAoAAA==.',Dj='Djpallyd:AwAHCBIABAoAAA==.',Do='Doinks:AwAHCAcABAoAAA==.',Dr='Dragoncurry:AwABCAEABRQAAA==.Draktyr:AwABCAEABRQCBgAIAQhzBQBauxMDBAoABgAIAQhzBQBauxMDBAoAAA==.',El='Ellismom:AwACCAIABAoAAA==.',Er='Ereithelda:AwADCAcABRQCCAADAQjuBgAgDtwABRQACAADAQjuBgAgDtwABRQAAA==.',Fa='Fann:AwAECAgABAoAAA==.Faytl:AwAFCAkABAoAAA==.',Fe='Fewz:AwABCAIABRQCCQAHAQhhEgBJvzICBAoACQAHAQhhEgBJvzICBAoAAA==.',Fo='Folus:AwAFCAUABAoAAA==.Fornost:AwAFCAUABAoAAA==.',Fr='Fridgie:AwACCAMABRQCCgAIAQh/LgA5/PUBBAoACgAIAQh/LgA5/PUBBAoAAA==.',Ga='Garcutt:AwACCAEABRQCCQAIAQj7CgBF640CBAoACQAIAQj7CgBF640CBAoAAA==.',Ge='Genericck:AwADCAIABAoAAA==.',Gr='Greenngoblin:AwAECAIABAoAAA==.Griggemix:AwADCAMABAoAAA==.',He='Healsforjuul:AwAECAQABAoAAA==.',Ho='Holy:AwABCAEABRQDCwAHAQiOFwAX5D4BBAoACwAHAQiOFwAX5D4BBAoADAAFAQifmAAYLd8ABAoAAA==.Holyshock:AwADCAcABRQCDAADAQgFBgBNRR4BBRQADAADAQgFBgBNRR4BBRQAAA==.',Hu='Huukend:AwAGCA0ABAoAAA==.',Il='Illydãn:AwABCAIABRQCDQAHAQjsEAA0daABBAoADQAHAQjsEAA0daABBAoAAA==.',In='Inkystreamz:AwACCAIABAoAAA==.',Ir='Ironuc:AwACCAMABAoAAA==.',Ja='Jade:AwABCAEABAoAAA==.',Je='Jeanne:AwAGCAEABAoAAA==.Jemma:AwAFCAwABAoAAA==.Jettadin:AwAHCA4ABAoAAA==.Jettatotes:AwADCAYABRQCDgADAQjqBAAewt0ABRQADgADAQjqBAAewt0ABRQAAA==.',Ji='Jimmystrazsa:AwAGCAUABAoAAA==.',['J�']='Jéks:AwAFCAUABAoAAQ8ARIgDCAcABRQ=.Jëks:AwADCAcABRQDDwADAQivBwBEiKQABRQADwACAQivBwBQR6QABRQADgABAQhvDgAA/DkABRQAAA==.',Ke='Keiyona:AwACCAIABAoAAA==.Kev:AwAGCAcABAoAAA==.',Kh='Khenna:AwAFCAUABAoAAA==.',Ko='Koogacca:AwAECAQABAoAAA==.',Ku='Kukulcán:AwAGCBAABAoAAA==.Kurrox:AwABCAIABRQCEAAHAQh7DABPHmgCBAoAEAAHAQh7DABPHmgCBAoAAA==.',La='Lahyanhou:AwACCAMABAoAAA==.Lalin:AwAGCAMABAoAAA==.Laylah:AwAECAcABAoAAA==.',Lo='Locsul:AwADCAEABAoAAA==.',Lu='Lucinà:AwAFCAIABAoAAA==.Lumalor:AwAECAMABAoAAA==.',Ma='Maidrim:AwACCAMABRQCEQAIAQiJAQBd+jEDBAoAEQAIAQiJAQBd+jEDBAoAAA==.Maricelle:AwABCAIABAoAAA==.',Me='Metavanq:AwAHCBAABAoAAA==.',Mi='Mierín:AwABCAMABRQCEgAHAQg+AwBapbsCBAoAEgAHAQg+AwBapbsCBAoAAA==.Miskaabin:AwACCAIABAoAAA==.Miststress:AwAHCAcABAoAAA==.',Mo='Monkybizness:AwAHCAcABAoAAA==.',Mu='Muraye:AwACCAMABRQAAA==.',My='Mybizël:AwAHCBsABAoCCgAHAQhZKAA/lBwCBAoACgAHAQhZKAA/lBwCBAoAAA==.',Na='Naelih:AwABCAEABAoAAA==.',Ni='Nikkolos:AwABCAEABAoAAA==.',No='Nogusta:AwADCAQABRQDBgAIAQhmBQBXbhQDBAoABgAIAQhmBQBXbhQDBAoAEwABAQh2PgATiEMABAoAAA==.Nohmojo:AwADCAYABAoAAA==.Norberta:AwAFCAkABAoAAA==.',Ny='Nyan:AwAECAcABAoAAA==.',On='Onlyshams:AwAFCAUABAoAAA==.Onu:AwAFCAUABAoAAQcAWfACCAQABRQ=.Onulight:AwACCAQABRQCBwAIAQjnAQBZ8CYDBAoABwAIAQjnAQBZ8CYDBAoAAA==.Onuwar:AwAFCAUABAoAAQcAWfACCAQABRQ=.Onux:AwAECAcABAoAAQcAWfACCAQABRQ=.',Or='Orondo:AwAECAcABAoAAA==.',Ou='Oukei:AwAFCAUABAoAARQAUcMCCAYABRQ=.Oumura:AwACCAYABRQCBgACAQiCCwAuUp4ABRQABgACAQiCCwAuUp4ABRQAAA==.',Pa='Pallyoop:AwAGCAYABAoAAA==.',Ph='Phantöm:AwACCAEABAoAAA==.',Po='Podan:AwAGCAEABAoAAA==.',Pr='Preechr:AwAICBAABAoAAA==.Prowner:AwABCAIABRQCFQAHAQiMCgBfl9ACBAoAFQAHAQiMCgBfl9ACBAoAAA==.',Pv='Pvlolz:AwAFCAUABAoAAA==.',Qp='Qplus:AwAECAgABAoAAA==.',Ra='Ragewarg:AwABCAEABAoAAA==.Ralvarr:AwADCAMABAoAAA==.Ravenslock:AwAGCAkABAoAAA==.',Re='Redchord:AwADCAMABAoAAA==.Redg:AwABCAIABRQAAA==.Resith:AwAFCAsABAoAAA==.',Ro='Rondon:AwACCAYABAoAAA==.Rookdh:AwADCAcABRQCFgADAQhCCAAi5uUABRQAFgADAQhCCAAi5uUABRQAAA==.',Ru='Rugsalon:AwABCAEABRQAAA==.Rustedbarrel:AwAHCAcABAoAAA==.',Sa='Sakazuki:AwADCAQABAoAAA==.Santaclaaws:AwABCAIABRQCFgAHAQiIFgBN1GoCBAoAFgAHAQiIFgBN1GoCBAoAAA==.Saphotic:AwAGCAUABAoAAQcAP9wDCAcABRQ=.Sayvil:AwAFCAEABAoAAA==.',Se='Seawolph:AwAFCAwABAoAAA==.Sensational:AwAGCAgABAoAAA==.',Sh='Shadownage:AwAICAgABAoAAA==.Shalash:AwACCAIABAoAAA==.Shampooh:AwADCAYABAoAAA==.Shaokhan:AwAHCBIABAoAAA==.Shockeei:AwACCAYABRQCFwACAQiYDABZF8kABRQAFwACAQiYDABZF8kABRQAAA==.Shocknoris:AwACCAIABAoAAA==.Shocky:AwAFCAUABAoAAA==.',Si='Siakora:AwACCAQABRQCGAAIAQjAAgA69yoCBAoAGAAIAQjAAgA69yoCBAoAAA==.Silverwar:AwAECAsABAoAAA==.Simmi:AwEDCAcABRQCGQADAQgxAgBKkBUBBRQAGQADAQgxAgBKkBUBBRQAAA==.',Sk='Skepti:AwAFCAwABAoAAA==.',Sn='Sneakers:AwAGCAYABAoAAQcAWfACCAQABRQ=.',So='Socorrista:AwAGCA0ABAoAAA==.Sooma:AwAECAcABAoAAA==.',St='Strangerdk:AwAECAcABAoAAA==.',Su='Sugaruntamed:AwAECAIABAoAAA==.',Sw='Swishersweet:AwABCAEABRQAAA==.Swordfish:AwAICCEABAoCGgAIAQhKBABYg/cCBAoAGgAIAQhKBABYg/cCBAoAAA==.',Ta='Tabrius:AwAGCBAABAoAAA==.Tanknstein:AwADCAkABAoAAA==.',Te='Tengen:AwAECAYABAoAAA==.Termana:AwADCAcABRQCGwADAQiNAABU8yoBBRQAGwADAQiNAABU8yoBBRQAAA==.',Ti='Tiferet:AwAFCAwABAoAAA==.',To='Tocksic:AwAECAQABAoAAA==.Toesuckr:AwACCAEABAoAAA==.Tolenkar:AwAECAUABAoAAA==.Tomato:AwADCAMABRQCBAAIAQjfDwBDznYCBAoABAAIAQjfDwBDznYCBAoAAA==.',Tu='Turmock:AwADCAYABAoAAA==.',Ty='Tyrela:AwAFCAoABAoAAA==.Tyreon:AwAECAYABAoAAA==.',Va='Vanquished:AwAHCA0ABAoAARwAAAAHCBAABAo=.Vapes:AwAICAgABAoAAA==.',Ve='Velgoth:AwABCAEABAoAAA==.',Vi='Vizjerei:AwADCAIABAoAAA==.',Vy='Vysis:AwABCAEABRQAAA==.',Wi='Wickèr:AwAGCAsABAoAAA==.',Wy='Wyldfire:AwABCAIABRQCFQAHAQhAFABMrlgCBAoAFQAHAQhAFABMrlgCBAoAAA==.',Xa='Xanith:AwAHCAsABAoAAA==.Xanyth:AwAFCAkABAoAAA==.',Xi='Xinjin:AwACCAIABAoAAA==.',Ys='Ysa:AwACCAMABAoAAA==.',Yu='Yugiri:AwAFCAwABAoAAA==.',Za='Zalya:AwABCAEABAoAAA==.',Zi='Ziea:AwACCAMABAoAAA==.',Zz='Zzmastermìnd:AwADCAYABRQCHQADAQhyAgBEbgABBRQAHQADAQhyAgBEbgABBRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end