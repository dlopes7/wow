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
 local lookup = {'Unknown-Unknown','Mage-Fire','Paladin-Holy','Warlock-Destruction','Warrior-Arms','Warrior-Fury','Evoker-Augmentation','Evoker-Devastation','Evoker-Preservation','Monk-Mistweaver','Rogue-Subtlety','Rogue-Assassination','Shaman-Restoration','Monk-Brewmaster','Priest-Shadow','Paladin-Retribution','DemonHunter-Havoc','DemonHunter-Vengeance','Hunter-BeastMastery','Hunter-Marksmanship','Warlock-Affliction','Warlock-Demonology',}; local provider = {region='US',realm='EarthenRing',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adorèè:AwAFCAQABAoAAA==.',Al='Aluraye:AwAICAcABAoAAA==.Alvara:AwAECAoABAoAAA==.',Am='Amorda:AwAFCAIABAoAAA==.',An='Andaayy:AwAECAMABAoAAA==.Antiquity:AwAECAQABAoAAA==.',Ar='Arcadien:AwAHCAwABAoAAA==.Arsolon:AwAECA0ABAoAAA==.',At='Athelstan:AwACCAIABAoAAA==.',Au='Audaria:AwABCAEABAoAAA==.',Az='Azrat:AwABCAIABAoAAA==.',Ba='Babrak:AwAECAQABAoAAA==.Baiter:AwAGCAwABAoAAA==.Baylel:AwADCAYABAoAAA==.',Be='Bezvoker:AwAFCAIABAoAAA==.',Bl='Blueberrypie:AwAHCBAABAoAAA==.',Bo='Bobbydigital:AwAECAIABAoAAQEAAAAGCA0ABAo=.Bonfire:AwAHCBEABAoAAA==.Borlorin:AwAGCAsABAoAAA==.Bovineblast:AwAHCAYABAoAAA==.',Bu='Buckwyster:AwAHCBAABAoCAgAHAQh7MgAhWHUBBAoAAgAHAQh7MgAhWHUBBAoAAA==.',Ca='Caraseymour:AwAFCA0ABAoAAA==.',Ch='Chewbie:AwAGCAwABAoAAA==.Chronobee:AwADCAMABAoAAA==.',Ck='Cklyde:AwAHCBUABAoCAwAHAQjsCABH5TMCBAoAAwAHAQjsCABH5TMCBAoAAA==.',Cl='Claiyre:AwAECAkABAoAAA==.Cloaca:AwAECAEABAoAAA==.Clouded:AwAHCBAABAoCBAAHAQjCGwBALwoCBAoABAAHAQjCGwBALwoCBAoAAA==.Clubs:AwAFCAQABAoAAA==.',Co='Concentrate:AwAGCAEABAoAAA==.Connan:AwAFCA8ABAoDBQAFAQjbDQBbBg8CBAoABQAFAQjbDQBbBg8CBAoABgABAQi5YwA0YD0ABAoAAA==.Constant:AwACCAEABAoAAA==.Coregahn:AwAECAMABAoAAA==.Corn:AwAFCAMABAoAAA==.',Da='Darkalex:AwAFCAQABAoAAA==.Darkhammer:AwABCAEABAoAAA==.',De='Deadlinia:AwAGCBMABAoAAA==.Delinais:AwAGCBMABAoAAA==.Dethyler:AwAFCAsABAoAAA==.',Di='Distillate:AwAFCAkABAoAAA==.',Do='Domoroboto:AwAFCA0ABAoAAA==.',Dr='Dragginballz:AwAHCBUABAoDBwAHAQhcAABUXZ4CBAoABwAHAQhcAABUXZ4CBAoACAABAQgJNwAU0jIABAoAAA==.Dragonwi:AwAGCBQABAoCCQAGAQhHDwAZVhgBBAoACQAGAQhHDwAZVhgBBAoAAA==.Drrush:AwAECAcABAoAAA==.',Du='Durrd:AwADCAQABAoAAA==.',El='Eldorin:AwADCAQABAoAAA==.Electroo:AwAHCBUABAoCCgAHAQgiGgA7WtQBBAoACgAHAQgiGgA7WtQBBAoAAA==.Eleisie:AwABCAEABAoAAA==.Elijáh:AwAHCBUABAoDCwAHAQijEwAdhaMBBAoACwAHAQijEwAdhaMBBAoADAADAQg6JwANRmEABAoAAA==.Elyn:AwAHCBUABAoDBgAHAQj6EQBJ5V8CBAoABgAHAQj6EQBIBV8CBAoABQACAQhIMwA5GoUABAoAAA==.',En='Endest:AwAECAgABAoAAA==.',Ep='Ephimonk:AwAICA4ABAoAAA==.',Eq='Equinoxh:AwAICAcABAoAAA==.',Es='Esmey:AwACCAIABAoAAA==.',Fe='Feldeyv:AwAFCAwABAoAAA==.',Ga='Garbothicc:AwADCAQABAoAAA==.Garf:AwADCAQABAoAAA==.Garyh:AwAFCAwABAoAAA==.',Gi='Giacomo:AwACCAEABAoAAA==.Gil:AwAFCAwABAoAAA==.Gildina:AwACCAEABAoAAA==.Ginggy:AwADCAQABAoAAQoAJZIHCBUABAo=.',Go='Gobbs:AwAECAcABAoAAA==.Gori:AwAFCA0ABAoAAA==.Gortac:AwADCAcABAoAAA==.',Gr='Graath:AwACCAMABAoAAA==.Grayfox:AwAFCAYABAoAAA==.Greyji:AwAFCAcABAoAAA==.Greymonkey:AwADCAYABAoAAA==.',Gu='Guarzoo:AwAGCAUABAoAAA==.',Gw='Gwendh:AwAGCA4ABAoAAA==.',Ha='Haardrada:AwAFCAsABAoAAQEAAAAFCAwABAo=.Hadrien:AwAECAMABAoAAA==.',He='Heilegeziege:AwADCAMABAoAAA==.Hellbore:AwAHCBAABAoAAA==.Hemmy:AwAHCBIABAoAAA==.Hermer:AwABCAEABAoAAA==.Heypookie:AwAFCAQABAoAAA==.Hezzakan:AwACCAEABAoAAA==.',Ho='Holycannoli:AwAFCAwABAoAAA==.',Hu='Huevonyque:AwAHCBUABAoDBQAHAQgEDQBOBB0CBAoABQAGAQgEDQBNHB0CBAoABgABAQiHXABTc1sABAoAAA==.Hugzhug:AwAICAgABAoAAA==.Hunnidoo:AwADCAgABAoAAA==.Huntsthewind:AwADCAUABAoAAA==.',In='Infoxy:AwAFCAMABAoAAA==.',Is='Ishamael:AwADCAUABAoAAA==.',Ja='Jabaho:AwACCAMABAoAAA==.',Je='Jessaril:AwAHCBAABAoAAA==.',Jo='Johnmahony:AwADCAIABAoAAA==.',Ju='Judonine:AwADCAQABAoAAA==.',['J�']='Jåzzy:AwAFCAMABAoAAA==.',Ka='Kaandew:AwACCAEABAoAAA==.Karái:AwACCAEABAoAAA==.Katiey:AwACCAMABRQCDQAIAQh7AQBgOUkDBAoADQAIAQh7AQBgOUkDBAoAAQ0AX5AFCBAABRQ=.',Ke='Keffka:AwAHCBUABAoCDQAHAQjNCQBYcqQCBAoADQAHAQjNCQBYcqQCBAoAAA==.Kegwalker:AwAHCBUABAoCDgAHAQgqAwBR9XwCBAoADgAHAQgqAwBR9XwCBAoAAA==.',Kh='Khalistra:AwAFCAwABAoAAA==.',Ki='Kilava:AwADCAMABAoAAA==.Killos:AwAGCBIABAoAAA==.Kir:AwABCAEABAoAAA==.',Kl='Klanker:AwAECAIABAoAAA==.',La='Lamisa:AwAHCBAABAoAAA==.Laundryslayr:AwAHCBUABAoDBgAHAQhMHQA3k/ABBAoABgAGAQhMHQA/XfABBAoABQABAQh8QgAI2DMABAoAAA==.',Le='Lennethal:AwADCAUABAoAAA==.Leonineone:AwAHCBUABAoCDwAHAQjGEwA6dvkBBAoADwAHAQjGEwA6dvkBBAoAAA==.',Li='Lightlady:AwACCAEABAoAAA==.Liml:AwAFCAwABAoAAA==.Lithou:AwADCAYABAoAAA==.',Lu='Lucress:AwAFCA0ABAoAAA==.',Ma='Malciceaer:AwAECAcABAoAAA==.Manajamba:AwAFCAwABAoAAA==.Mancubus:AwAFCAgABAoAAA==.Maxxim:AwAFCAwABAoAAA==.',Me='Meilichia:AwAHCBAABAoAAA==.Meushi:AwADCAcABRQCEAADAQhtCAAwvu4ABRQAEAADAQhtCAAwvu4ABRQAAA==.',Mi='Mindmuncher:AwABCAEABAoAAA==.Mishrani:AwACCAMABAoAAA==.Miste:AwADCAYABAoAAA==.',Mo='Moonstôrm:AwAFCAQABAoAAA==.Mordraug:AwADCAMABAoAAA==.',Mu='Murdermohawk:AwADCAYABAoAAA==.',Ne='Nelithas:AwAHCBYABAoDEQAHAQj7EwBQ3IUCBAoAEQAHAQj7EwBQ3IUCBAoAEgABAQgXQgAh1CQABAoAAA==.Nezukò:AwACCAIABAoAAA==.',Ni='Nightime:AwACCAIABAoAAA==.Nishaya:AwADCAcABAoAAA==.',No='Noamsky:AwAHCBUABAoCCgAHAQjuJgAlkmwBBAoACgAHAQjuJgAlkmwBBAoAAA==.Nolmac:AwACCAEABAoAAA==.',Ob='Obifizzle:AwADCAUABAoAAA==.',Og='Ogna:AwADCAMABAoAAA==.',Oi='Oisin:AwACCAEABAoAAA==.',On='Onruk:AwAFCAwABAoAAA==.',Op='Ophina:AwACCAIABAoAAA==.',Ox='Oxidising:AwAFCAsABAoAAA==.',Pa='Paladullahan:AwAFCA0ABAoAAA==.Palagrum:AwAHCBUABAoCEAAHAQjUMABBrCgCBAoAEAAHAQjUMABBrCgCBAoAAA==.Pallythepal:AwADCAQABAoAAA==.Paperbags:AwADCAEABAoAAA==.',Pe='Peak:AwAICBEABAoAAA==.',Ph='Phantsu:AwABCAEABAoAAA==.Phrenominon:AwAGCAwABAoAAA==.',Pi='Picyut:AwADCAQABAoAAA==.',Pl='Plagueniss:AwAHCBMABAoAAA==.',Pu='Purrl:AwADCAUABAoAAA==.',Ra='Raidgriefer:AwAGCAcABAoAAA==.Ravielly:AwADCAQABAoAAA==.',Re='Reyvinite:AwAHCBQABAoCEAAHAQioUgApJaQBBAoAEAAHAQioUgApJaQBBAoAAA==.',Rh='Rhyme:AwAHCBUABAoCCwAHAQhEBgBYSLsCBAoACwAHAQhEBgBYSLsCBAoAAA==.',Ri='Risuu:AwADCAMABAoAAA==.',Ro='Roasted:AwAGCAYABAoAAA==.Rotmuncher:AwADCAIABAoAAA==.',Ru='Ruff:AwAHCBUABAoCEwAHAQiIKQA9gBUCBAoAEwAHAQiIKQA9gBUCBAoAAA==.Rukia:AwAHCBUABAoCDwAHAQgNEABFoTICBAoADwAHAQgNEABFoTICBAoAAA==.',Ry='Ryoushen:AwAHCBUABAoDFAAHAQgDDABE7CACBAoAFAAHAQgDDABE7CACBAoAEwADAQiYiwAol48ABAoAAA==.',Sa='Sarb:AwADCAYABAoAAA==.',Sc='Sckritch:AwAFCAQABAoAAA==.',Se='Serrendipity:AwAHCBAABAoAAA==.',Sh='Shadowtarget:AwABCAEABRQAAA==.Shaylina:AwADCAYABAoAAA==.Shirkan:AwAGCBQABAoCBgAGAQhDHgBKpucBBAoABgAGAQhDHgBKpucBBAoAAA==.',Si='Sigillaria:AwAFCAkABAoAAA==.',Sk='Skadooshh:AwADCAQABAoAAQUAWwYFCA8ABAo=.Skíf:AwEECAgABAoAAA==.',So='Sonlen:AwAFCAcABAoAAA==.Sonofgodric:AwAECAgABAoAAA==.',Sp='Spyroh:AwAFCA0ABAoAAA==.',Sv='Svendorph:AwAICAgABAoAAA==.',Sw='Sweets:AwAFCAQABAoAAA==.',Sy='Sykko:AwAHCBcABAoCAgAHAQg4FgBKYGgCBAoAAgAHAQg4FgBKYGgCBAoAAA==.Sylvanyass:AwAICAgABAoAAA==.',Ta='Talandroz:AwABCAEABAoAAA==.',Te='Temoryn:AwAECAQABAoAAA==.Terrador:AwAFCAoABAoAAA==.Terraviridis:AwAHCBMABAoAAA==.Terrence:AwAECAgABAoAAA==.',Th='Thalamus:AwAHCA8ABAoAAA==.Thaldin:AwABCAEABAoAAA==.Thelonius:AwAHCBIABAoAAA==.Thin:AwAGCA8ABAoAAQEAAAAICBEABAo=.',Ti='Tiradis:AwABCAEABAoAAA==.Tiryl:AwADCAgABAoAAA==.',To='Tooph:AwADCAQABAoAAA==.',Tr='Trickcast:AwACCAIABRQCDwAIAQgqBABXbBUDBAoADwAIAQgqBABXbBUDBAoAAA==.',Ts='Tsone:AwADCAMABAoAAA==.',Uh='Uhoh:AwAFCAIABAoAAA==.',Ui='Uitaar:AwAHCBAABAoCBgAHAQi9HwAtTdkBBAoABgAHAQi9HwAtTdkBBAoAAA==.',Un='Undeadshaman:AwACCAIABAoAAA==.',Va='Vancasper:AwADCAUABAoAAA==.Varl:AwAGCBMABAoAAA==.Vasileia:AwAHCA0ABAoAAA==.',Vi='Vil:AwABCAEABAoAAA==.Viper:AwAHCA8ABAoAAA==.Viralmaster:AwAFCAcABAoAAA==.',Vy='Vynddradoria:AwAHCBUABAoEFQAHAQiGCQAvs3gBBAoAFQAGAQiGCQA0n3gBBAoABAADAQjrYgANP4UABAoAFgABAQgSRQAMjiUABAoAAA==.Vynlock:AwAHCBYABAoEFgAHAQh5CwBY+qgBBAoABAAGAQgqFwBYkzACBAoAFgAEAQh5CwBcIKgBBAoAFQAEAQjSCwBRrksBBAoAAA==.',Wa='Wachikoko:AwACCAEABAoAAA==.Warsildhh:AwAICA4ABAoAAA==.',We='Wetgrills:AwAHCBEABAoAAA==.',Wi='Willpete:AwADCAcABAoAAA==.',Wo='Worski:AwACCAEABAoAAA==.',Wr='Wraithzero:AwAGCAYABAoAAA==.',Wy='Wynilla:AwACCAEABAoAAA==.',Xa='Xanathar:AwACCAIABAoAAA==.',Xi='Xilorith:AwAICBAABAoAAA==.',Ya='Yassi:AwAECAgABAoAAA==.Yavi:AwADCAQABAoAAA==.',Za='Zarik:AwABCAEABAoAAA==.',Zh='Zhend:AwAFCAMABAoAAA==.',Zp='Zpaatos:AwAFCAwABAoAAA==.',Zu='Zunch:AwADCAUABAoAAA==.',['À']='Àzazel:AwAHCBAABAoAAA==.',['Ø']='Ørphêus:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end