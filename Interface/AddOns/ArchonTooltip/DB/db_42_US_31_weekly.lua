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
 local lookup = {'Shaman-Elemental','Druid-Restoration','Paladin-Retribution','Warlock-Affliction','Priest-Holy','Evoker-Augmentation','Monk-Mistweaver','Unknown-Unknown','Monk-Windwalker','Hunter-Survival','Hunter-BeastMastery','Druid-Balance','Priest-Shadow','Priest-Discipline','Mage-Fire','Warrior-Arms','DemonHunter-Vengeance','Druid-Feral','Shaman-Restoration','Warlock-Destruction',}; local provider = {region='US',realm='BlackDragonflight',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adrenaline:AwAECAEABAoAAA==.',Ae='Aeironok:AwAFCA4ABAoAAA==.',Ag='Agdall:AwABCAEABAoAAA==.Aggronok:AwABCAMABRQCAQAIAQjvBABSZ/kCBAoAAQAIAQjvBABSZ/kCBAoAAA==.',Ai='Airi:AwAICAgABAoAAA==.',Ak='Akunda:AwAFCAoABAoAAA==.',An='Androse:AwAFCAgABAoAAA==.Angus:AwAECAQABAoAAA==.',Av='Avolokden:AwABCAMABRQCAgAIAQhBBwBKfpgCBAoAAgAIAQhBBwBKfpgCBAoAAA==.Avort:AwAGCAEABAoAAA==.',Az='Azmyth:AwACCAUABRQCAwACAQi2CABjXecABRQAAwACAQi2CABjXecABRQAAA==.',Ba='Bartahk:AwADCAYABAoAAA==.',Be='Beetle:AwAHCBUABAoCBAAHAQjIBABC6/0BBAoABAAHAQjIBABC6/0BBAoAAA==.',Bi='Bigkahunas:AwAFCA4ABAoAAA==.Bigzacky:AwAHCBUABAoCBQAHAQjrAwBgfPECBAoABQAHAQjrAwBgfPECBAoAAA==.',Bl='Bladlast:AwAFCAoABAoAAA==.Blankee:AwAFCAUABAoAAQYAYx8CCAMABRQ=.Blastr:AwADCAMABAoAAA==.Bleena:AwAICBAABAoAAA==.Bloomthetank:AwABCAEABAoAAA==.',Bo='Booze:AwACCAIABRQCBwAHAQiCEQBIpTMCBAoABwAHAQiCEQBIpTMCBAoAAA==.Boozkin:AwAGCA4ABAoAAA==.',Br='Brainlagg:AwAFCA4ABAoAAA==.Broekskit:AwADCAIABAoAAA==.Brunda:AwAECAcABAoAAA==.Brusque:AwADCAIABAoAAA==.',Bu='Bugbug:AwAECAcABAoAAA==.Bulwark:AwABCAEABAoAAQgAAAAECAQABAo=.',Ca='Carthdemon:AwAGCBEABAoAAA==.Catalystic:AwAICBkABAoCCQAHAQiSEgA9FwkCBAoACQAHAQiSEgA9FwkCBAoAAA==.Catchdahands:AwAECAQABAoAAQgAAAAGCAsABAo=.',Ch='Chanticlare:AwAECAcABAoAAA==.Charízard:AwAICAgABAoAAA==.Chodoge:AwAHCA4ABAoAAA==.',Ci='Ciimagi:AwAFCAwABAoAAA==.Civility:AwADCAIABAoAAA==.',Co='Codyhunter:AwABCAEABAoAAA==.Copenfel:AwAECAkABAoAAA==.Cowtion:AwAHCBIABAoAAA==.',Da='Daddeigh:AwADCAIABAoAAA==.Davinia:AwAECAkABAoAAA==.',De='Degradation:AwAECAQABAoAAA==.Demons:AwAGCBIABAoAAA==.Devotion:AwACCAIABAoAAQgAAAAECAQABAo=.Deúz:AwAHCBEABAoAAA==.',Di='Diela:AwAECAQABAoAAA==.Diesel:AwAICAkABAoAAA==.Divekick:AwACCAMABAoAAA==.',Dk='Dkdurbin:AwABCAEABAoAAA==.',Do='Doggiedog:AwAFCA4ABAoAAA==.Dominàtrix:AwAHCBUABAoDCgAHAQhqBgA7uU4BBAoACwAGAQg3PwBAWJkBBAoACgAFAQhqBgA5N04BBAoAAA==.Dotmarty:AwAFCAoABAoAAA==.Dotsrus:AwAFCAUABAoAAA==.',Dr='Draconblaze:AwAFCAIABAoAAA==.Dragonee:AwACCAMABRQCBgAIAQgJAABjH4UDBAoABgAIAQgJAABjH4UDBAoAAA==.Dragön:AwADCAMABAoAAA==.Drakthor:AwADCAMABAoAAA==.Draxus:AwAECAQABAoAAA==.Dregar:AwAECAYABAoAAA==.',Du='Dumbfatbald:AwAICAwABAoAAA==.Durbinsham:AwAHCA4ABAoAAA==.Duska:AwAICAIABAoAAA==.',['D�']='Déúsvult:AwAICAgABAoAAA==.',Ea='Eatshot:AwADCAMABAoAAA==.',Ee='Eevah:AwAGCA0ABAoAAA==.',Eg='Eggsonrice:AwAECAUABAoAAA==.',El='Elementsmash:AwAFCA0ABAoAAA==.Eleventeen:AwAHCBEABAoAAA==.Elihavoc:AwABCAEABAoAAQgAAAAICAgABAo=.Elithiri:AwAICAgABAoAAA==.Elosai:AwAECAQABAoAAA==.',En='Enanodeboca:AwAFCA8ABAoAAA==.',Ep='Epicninja:AwAICAgABAoAAA==.Epiphany:AwACCAIABAoAAA==.',Er='Erissari:AwADCAQABAoAAA==.',Et='Eternius:AwAFCAoABAoAAA==.',Fa='Fangaxe:AwABCAMABRQAAA==.Fayhn:AwAECAQABAoAAA==.',Ff='Ffn:AwAICAcABAoAAA==.',Fi='Fiatko:AwAICAkABAoAAA==.Firenova:AwAFCAUABAoAAA==.',Fl='Floshotmoo:AwAECAQABAoAAA==.',Fo='Foxington:AwABCAIABRQCBwAIAQgJIwAeoYkBBAoABwAIAQgJIwAeoYkBBAoAAA==.',Fr='Franzen:AwAFCAUABAoAAA==.Frozendk:AwACCAYABAoAAA==.',Ga='Gathdazar:AwABCAEABRQAAA==.Gaypoc:AwACCAIABRQDDAAHAQhjGwBFZg4CBAoADAAHAQhjGwBFZg4CBAoAAgABAQi4SwBXbl4ABAoAAA==.',Ge='Gehenna:AwAGCAYABAoAAA==.',Gh='Ghðst:AwAECAgABAoAAA==.',Gl='Glarghal:AwAGCA4ABAoAAA==.',Gr='Grapebevrage:AwAFCAgABAoAAA==.',Ha='Hathaw:AwADCAIABAoAAA==.Hayhay:AwAFCAoABAoAAA==.',Ho='Hobgoblinn:AwAHCBMABAoAAA==.Holybel:AwABCAEABAoAAA==.Holydiver:AwAHCBYABAoDDQAHAQj/EwA7HPYBBAoADQAHAQj/EwA7HPYBBAoADgABAQjoWAAQsycABAoAAA==.Honeydutchtv:AwACCAIABRQCAwAIAQgRCwBbDBkDBAoAAwAIAQgRCwBbDBkDBAoAAA==.Hopezherbz:AwABCAEABRQDDAAIAQgBCABZK/YCBAoADAAIAQgBCABZK/YCBAoAAgABAQhHTQBRxVcABAoAAA==.',Hu='Hugedonut:AwAECAYABAoAAA==.',Im='Iminthegame:AwACCAIABAoAAA==.Impxlse:AwADCAEABAoAAA==.',Ir='Ironninja:AwAFCAIABAoAAA==.',Ja='Janitorjudas:AwAECAcABAoAAA==.Jasteer:AwACCAMABAoAAA==.',Jb='Jbsham:AwAECAMABAoAAA==.',Je='Jessfae:AwAFCAoABAoAAA==.',Ji='Jimmypage:AwABCAIABRQAAA==.',Jo='Joe:AwAICAwABAoAAA==.Joebon:AwADCAYABAoAAA==.',Jt='Jtrain:AwAECAIABAoAAA==.',Ka='Kaskkah:AwAFCAgABAoAAA==.Kavikk:AwAICBAABAoAAA==.',Ke='Kenpowers:AwAICBAABAoAAA==.',Kn='Knoctürnal:AwABCAEABRQAAA==.',Ko='Kodaa:AwACCAIABAoAAQgAAAABCAEABRQ=.Kodah:AwABCAEABRQAAA==.',Kr='Kraveaux:AwACCAUABRQCDwACAQhNEgAiRY8ABRQADwACAQhNEgAiRY8ABRQAAA==.Kritnasty:AwABCAEABRQCEAAHAQjWBgBUWJYCBAoAEAAHAQjWBgBUWJYCBAoAAQgAAAABCAEABRQ=.Krystal:AwAFCA0ABAoAAA==.',La='Lasagna:AwAFCAoABAoAAA==.Lastina:AwADCAQABAoAAA==.',Le='Leassar:AwAFCAcABAoAAA==.Lexxe:AwAICAMABAoAAA==.',Li='Lifehack:AwAICAUABAoAAA==.Liluana:AwAHCBEABAoAAA==.Linzalina:AwAFCAYABAoAAQgAAAAGCAkABAo=.',Lo='Loading:AwADCAQABAoAAA==.Lolrush:AwACCAUABRQCEQACAQgcBQAfoHYABRQAEQACAQgcBQAfoHYABRQAAA==.',Lu='Ludaa:AwACCAIABAoAAA==.',Ly='Lyrnn:AwAFCAoABAoAAA==.',['L�']='Lével:AwABCAEABAoAAQgAAAAGCBIABAo=.',Ma='Mainmoon:AwAHCBEABAoAAA==.',Mi='Mightduy:AwABCAEABRQAAA==.',Mo='Moisturize:AwAECAgABAoAAQoAO7kHCBUABAo=.Monkheals:AwACCAEABAoAAA==.Montoia:AwADCAcABAoAAA==.',Mu='Muraina:AwAECAYABAoAAA==.',['M�']='Mønk:AwAECAcABAoAAA==.',Na='Naclypants:AwAECAcABAoAAA==.Namimori:AwACCAIABAoAAA==.Namiren:AwAFCAsABAoAAA==.',Ne='Nexkaa:AwAHCBEABAoAAA==.',Ni='Niissia:AwADCAkABAoAAA==.',Nu='Nutterbutter:AwADCAMABAoAAA==.',['N�']='Níghty:AwAHCBUABAoDEgAHAQjlBQBJXTQCBAoAEgAHAQjlBQBIeDQCBAoADAABAQhOaABCs0YABAoAAA==.',Ob='Obscure:AwAICAgABAoAAA==.',Oc='Ocarina:AwAFCAkABAoAAA==.',Oj='Ojsmiteson:AwAFCAoABAoAAA==.',Or='Orm:AwAFCA4ABAoAAA==.',Os='Osserc:AwAHCBUABAoCAwAHAQirQAA38+cBBAoAAwAHAQirQAA38+cBBAoAAA==.',Ph='Phin:AwAHCBEABAoAAA==.',Pr='Primeribeye:AwAFCAwABAoAAA==.',Py='Pyrannor:AwADCAQABAoAAA==.',Qu='Quinnie:AwAGCAEABAoAAA==.',Ra='Ralandrov:AwACCAIABAoAAA==.',Re='Regenerate:AwAHCBcABAoCEwAHAQjEKQAwuoYBBAoAEwAHAQjEKQAwuoYBBAoAAA==.',Rh='Rhaskos:AwACCAIABAoAAQgAAAAICBAABAo=.',Ri='Rikez:AwADCAIABAoAAA==.',Ro='Rorona:AwAHCBMABAoAAA==.Rose:AwADCAMABAoAAA==.Rotnier:AwAFCAYABAoAAA==.Rowsdower:AwAFCAoABAoAAA==.',Ru='Rubez:AwABCAEABAoAAA==.',Sa='Sanquites:AwAFCAMABAoAAA==.Sathalas:AwAHCAoABAoAAA==.',Sc='Scotygrippen:AwAFCAgABAoAAA==.',Se='Seifer:AwAGCBMABAoAAA==.Sembra:AwAGCAoABAoAAA==.',Sh='Shallbear:AwAFCAcABAoAAA==.Shammerz:AwAECAIABAoAAA==.Shaxy:AwAHCBUABAoCAQAHAQitEABM5SsCBAoAAQAHAQitEABM5SsCBAoAAA==.Shindra:AwADCAUABAoAAA==.Shuraina:AwAGCA0ABAoAAA==.',Si='Sikes:AwADCAIABAoAAA==.Silumgar:AwAGCAwABAoAAA==.Sixshotwilly:AwAECAcABAoAAA==.',Sk='Skuna:AwAECAQABAoAAA==.',Sn='Snanth:AwAHCBIABAoAAA==.',Sp='Spalling:AwADCAQABAoAAA==.Speculative:AwAHCA8ABAoAAA==.',Sq='Squee:AwAGCBAABAoAAA==.',St='Stoopedholy:AwADCAQABAoAAA==.',Su='Sumata:AwACCAIABAoAAQgAAAAFCA0ABAo=.Sumato:AwAFCA0ABAoAAA==.Sumtinwon:AwABCAEABAoAAA==.Sunalae:AwAECAQABAoAAA==.Sundeath:AwAGCA4ABAoAAA==.Sunshot:AwADCAkABAoAAA==.',Ta='Taoist:AwAGCAQABAoAAA==.',Te='Teppic:AwAHCBAABAoAAA==.Ternu:AwAHCAcABAoAAA==.',Th='Therealmundy:AwAECAEABAoAAA==.Therin:AwAECAQABAoAAA==.',Ti='Tim:AwAECAIABAoAAA==.Titamao:AwADCAUABAoAAA==.',Tr='Troegenator:AwAGCAcABAoAAA==.',Ts='Tsbaby:AwABCAEABAoAAA==.',Ty='Tylennidar:AwAHCBUABAoCFAAHAQj8HgA77/EBBAoAFAAHAQj8HgA77/EBBAoAAA==.',Un='Unhallowed:AwAHCAEABAoAAA==.',Ur='Urumagus:AwADCAIABAoAAA==.',Va='Valdimir:AwADCAQABAoAAA==.Vanillite:AwAFCAgABAoAAA==.Vanquish:AwAICAgABAoAAQgAAAAICAgABAo=.Vayhunt:AwAGCAoABAoAAA==.',Ve='Verionas:AwAHCBIABAoAAA==.Versal:AwABCAEABRQAAA==.',Vh='Vhx:AwAECAQABAoAAA==.',Vi='Vitamins:AwAGCA0ABAoAAA==.Vixelle:AwADCAIABAoAAA==.',Vo='Voker:AwABCAIABAoAAA==.',['V�']='Vïxenô:AwAHCBkABAoCEwAHAQg2JAA0B6kBBAoAEwAHAQg2JAA0B6kBBAoAAA==.',Wh='Whookie:AwABCAEABAoAAA==.',Wi='Widowmaker:AwABCAEABRQAAA==.Wishes:AwADCAIABAoAAA==.',Wu='Wulfgar:AwAICAgABAoAAA==.',Za='Zahlxr:AwAGCA4ABAoAAA==.Zappyboui:AwADCAMABAoAAA==.Zapraz:AwADCAMABAoAAQgAAAAICBAABAo=.',Ze='Zenrah:AwABCAEABAoAAA==.Zepoly:AwACCAIABAoAAA==.Zeraphole:AwAECAQABAoAAA==.Zerolith:AwADCAkABAoAAA==.',Zo='Zoidbergmd:AwAHCA4ABAoAAA==.',Zr='Zrocks:AwABCAEABAoAAA==.',Zz='Zztank:AwAFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end