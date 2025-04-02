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
 local lookup = {'DemonHunter-Havoc','Warlock-Destruction','Warlock-Affliction','Evoker-Devastation','Warrior-Fury','Unknown-Unknown','Warrior-Protection','Paladin-Protection','Monk-Brewmaster','Monk-Windwalker','Paladin-Holy','Shaman-Elemental',}; local provider = {region='US',realm='Nemesis',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adebaio:AwAGCBAABAoAAA==.',Ag='Agiota:AwAHCBMABAoAAA==.',Al='Albicha:AwADCAQABAoAAA==.Alessan:AwAGCA4ABAoAAA==.Alicel:AwAGCA0ABAoAAA==.Altreir:AwAECAkABAoAAA==.',Am='Amøm:AwAECAkABAoAAA==.',An='Anadirtei:AwAICBgABAoCAQAIAQipFwA5jVkCBAoAAQAIAQipFwA5jVkCBAoAAA==.',Ao='Aokishi:AwADCAMABAoAAA==.',Ap='Apocalipse:AwABCAEABAoAAA==.Apofisdruida:AwAFCAUABAoAAA==.',Ar='Arabhela:AwAFCAsABAoAAA==.',As='Ashabellanar:AwADCAUABAoAAA==.Aslatiel:AwAGCA0ABAoAAA==.Astergilda:AwAGCAkABAoAAA==.',At='Atthena:AwAGCBAABAoAAA==.',Au='Auliel:AwADCAUABAoAAA==.Aurios:AwACCAIABAoAAA==.',Av='Avanthara:AwACCAQABAoAAA==.',Ba='Balto:AwAFCA0ABAoAAA==.',Be='Beegar:AwADCAIABAoAAA==.',Bh='Bherg:AwADCAQABAoAAA==.',Bi='Bizcoiza:AwAGCAEABAoAAA==.',Br='Brazukmaiden:AwACCAIABAoAAA==.',Bu='Bubuya:AwABCAEABAoAAA==.Bullzin:AwAGCAcABAoAAA==.',Ca='Carlopala:AwAGCA4ABAoAAA==.Cathise:AwAGCAYABAoAAA==.',Ce='Cenarioss:AwAECAkABAoAAA==.',Ch='Chevete:AwAECAQABAoAAA==.Chopz:AwAHCAMABAoAAA==.Chucknòórris:AwAECAkABAoAAA==.',Cr='Crazy:AwAHCAYABAoAAA==.Crazyfrog:AwAECAEABAoAAA==.Cronosxd:AwAFCA0ABAoAAA==.Crucyatus:AwAECAQABAoAAA==.',Da='Dauthrir:AwAGCA0ABAoAAA==.',De='Deadcaster:AwAGCCUABAoCAgAGAQgNMQAtqGUBBAoAAgAGAQgNMQAtqGUBBAoAAA==.',Dk='Dkr:AwACCAEABAoAAA==.',Do='Doper:AwACCAIABAoAAA==.',Dp='Dpvat:AwAGCAEABAoAAA==.',Dr='Drakiza:AwAECAUABAoAAQMADn8HCBQABAo=.',Du='Dumat:AwAHCBMABAoAAA==.',Ed='Edthas:AwACCAIABAoAAA==.',El='Eldrítch:AwADCAEABAoAAA==.Elfyss:AwAHCBMABAoAAA==.Elleria:AwAECAUABAoAAA==.',En='Encanis:AwAECAcABAoAAA==.',Ex='Exo:AwAECAQABAoAAA==.',Fe='Feanori:AwAFCBAABAoAAA==.',Fl='Fluaba:AwAHCBMABAoAAA==.',Fo='Forestsong:AwAECAIABAoAAA==.',Fr='Frostkill:AwAGCA0ABAoAAA==.',Ga='Ganaar:AwADCAMABAoAAA==.Ganor:AwADCAIABAoAAA==.',Gh='Gherthrud:AwAGCAkABAoAAA==.',Gl='Glyndra:AwAECAQABAoAAQQAUUMBCAEABRQ=.',Gn='Gnomagro:AwADCAIABAoAAA==.',Go='Gommamon:AwABCAEABRQCBQAIAQiiJQAUTZYBBAoABQAIAQiiJQAUTZYBBAoAAA==.',Gr='Greylordp:AwAGCBMABAoAAA==.',Ha='Haggendaz:AwAECAQABAoAAQUAFE0BCAEABRQ=.Hammer:AwAFCAQABAoAAA==.Hancalimon:AwACCAMABAoAAA==.',He='Heiláng:AwADCAUABAoAAA==.',Hi='Hitkins:AwABCAEABAoAAA==.',Ho='Hofkari:AwAGCAoABAoAAA==.',Hu='Huldan:AwADCAQABAoAAA==.',Hy='Hypnøs:AwAFCAsABAoAAA==.',Il='Illidanod:AwACCAIABAoAAQYAAAAFCAcABAo=.',In='Inot:AwADCAEABAoAAA==.',It='Italodpz:AwAGCA4ABAoAAA==.',Je='Jedo:AwACCAIABAoAAA==.',Jp='Jpleuk:AwAFCAYABAoAAA==.',Ju='Jubicleia:AwAHCBAABAoAAA==.Juréia:AwAGCAkABAoAAA==.',Ka='Kaju:AwAGCAoABAoAAA==.Kalango:AwACCAIABAoAAA==.Kalleg:AwAFCAEABAoAAA==.Karemÿrpowa:AwACCAEABAoAAA==.',Ke='Keinyan:AwAGCAoABAoAAA==.',Kh='Khallyfa:AwAECAUABAoAAA==.Khasin:AwAFCAIABAoAAA==.',Ki='Kilb:AwAHCBIABAoAAA==.Kiqzin:AwAFCAsABAoAAA==.',Kl='Kllauzz:AwADCAMABAoAAQYAAAADCAYABAo=.Kllauzzpalla:AwADCAYABAoAAA==.',Kr='Krastian:AwAGCAwABAoAAA==.Kratorian:AwACCAEABAoAAA==.Krupper:AwAGCAEABAoAAA==.',['K�']='Köndmänö:AwAGCA4ABAoAAA==.',La='Lailea:AwAECAUABAoAAA==.Langratixa:AwAGCA4ABAoAAA==.Laurëel:AwABCAEABAoAAA==.',Le='Leedsmage:AwABCAEABRQAAA==.Lennard:AwACCAIABAoAAA==.Lestard:AwAECAoABAoAAA==.',Li='Liftshertail:AwAHCBMABAoAAA==.',Ll='Lliidan:AwAGCA0ABAoAAA==.',Lo='Lotharayn:AwACCAIABAoAAA==.',Lu='Lucasbrb:AwAECAYABAoAAA==.Lucasyeah:AwAGCBEABAoAAA==.Luktron:AwAECAoABAoAAA==.Luzdacelesc:AwADCAEABAoAAQYAAAAFCAwABAo=.',Ly='Lyänn:AwABCAEABAoAAA==.',Ma='Magodanilo:AwAGCAcABAoAAA==.Makenai:AwAFCAwABAoAAA==.Marycristiny:AwAGCAkABAoAAA==.Matamato:AwACCAIABAoAAA==.',Me='Melkkor:AwAECAkABAoAAA==.Melyodas:AwACCAEABAoAAA==.Menhit:AwABCAEABRQCBwAHAQj8BgA8aeQBBAoABwAHAQj8BgA8aeQBBAoAAA==.Mereen:AwADCAMABAoAAA==.',Mi='Midnights:AwADCAQABAoAAA==.Minimbatível:AwAGCAEABAoAAA==.Miragen:AwACCAIABAoAAA==.',Mn='Mnemosinë:AwACCAIABAoAAA==.',Mo='Mogan:AwABCAMABAoAAA==.Moostoration:AwAGCA8ABAoAAA==.',['M�']='Mädjax:AwAGCBIABAoAAA==.Mällü:AwACCAEABAoAAA==.Mälthazar:AwAGCA0ABAoAAA==.Mðrtalstryke:AwAGCAcABAoAAA==.',Na='Nabinhaa:AwAGCAcABAoAAA==.Narigdan:AwAGCBAABAoAAA==.Narjes:AwAFCAMABAoAAA==.Nazlash:AwAGCAwABAoAAA==.',Ne='Necromantus:AwAFCAMABAoAAA==.Necronmonk:AwAECAkABAoAAA==.Neravarian:AwAGCAwABAoAAA==.',Ni='Nidavellïr:AwAECAQABAoAAA==.Nightforms:AwACCAIABAoAAA==.Nitrofera:AwAGCAUABAoAAA==.',Ny='Nynnax:AwACCAMABAoAAA==.',Ok='Okasaki:AwAGCBAABAoAAA==.Okungfupanda:AwAFCAwABAoAAA==.',On='Onslaught:AwABCAEABRQAAA==.',Or='Organya:AwAFCAUABAoAAA==.',Oz='Ozymidas:AwAECAIABAoAAA==.',Pa='Palacktrum:AwAECAQABAoAAA==.Panqueka:AwAECAUABAoAAA==.',Pc='Pcdapositivo:AwAECAMABAoAAA==.',Pe='Pepito:AwAGCA4ABAoAAA==.Perciwal:AwABCAIABAoAAQYAAAAECAkABAo=.',Pr='Prysten:AwABCAIABAoAAA==.',['P�']='Pöww:AwADCAMABAoAAA==.',Ra='Raewyn:AwAGCA0ABAoAAA==.Rafaelgame:AwADCAMABAoAAA==.Ragnaryos:AwAHCBcABAoCCAAHAQi9EQAr3XABBAoACAAHAQi9EQAr3XABBAoAAA==.Rahyi:AwADCAUABAoAAA==.Ravaella:AwADCAQABAoAAA==.Raxamonk:AwAFCA0ABAoAAA==.',Rh='Rhegium:AwAECAQABAoAAA==.',Ri='Rilëy:AwAGCAwABAoAAA==.',Ro='Romao:AwAFCAQABAoAAA==.',Ru='Rudder:AwAHCBQABAoDCQAHAQj+CQApZmUBBAoACQAHAQj+CQAmbmUBBAoACgAEAQjOMAAn89AABAoAAA==.',['R�']='Räidela:AwAGCBMABAoAAA==.',Sa='Sacha:AwAGCAsABAoAAA==.Samidemon:AwAGCA8ABAoAAA==.',Sc='Scarfdeath:AwAFCAwABAoAAA==.',Se='Seelyvorey:AwAHCBMABAoAAA==.Selph:AwAECAkABAoAAA==.Sepultura:AwAFCAUABAoAAA==.Setecopa:AwACCAEABAoAAA==.',Sh='Shadontrap:AwABCAEABAoAAA==.Shafer:AwAECAIABAoAAA==.Shawcram:AwAECAEABAoAAA==.Shigami:AwAFCAQABAoAAA==.Shinobü:AwAECAQABAoAAA==.Shizumonk:AwABCAEABAoAAQsASfsCCAQABRQ=.Shîvas:AwAECAcABAoAAA==.',Si='Sindromy:AwADCAcABAoAAA==.',So='Solsar:AwAFCAgABAoAAA==.Solsurr:AwAGCAwABAoAAA==.Soneca:AwADCAMABAoAAA==.Soryosenshi:AwADCAEABAoAAA==.Sougigante:AwADCAcABAoAAA==.',Sp='Sprotchi:AwAFCAcABAoAAA==.',St='Stanyz:AwABCAEABAoAAQYAAAAGCBAABAo=.Stronoffgard:AwAHCBMABAoAAA==.',Su='Sulfur:AwAHCBMABAoAAA==.',Sy='Syllä:AwAECAcABAoAAA==.',Ta='Taloco:AwAGCAgABAoAAA==.',Te='Tekari:AwAGCAIABAoAAA==.',Th='Thagaryen:AwAFCAYABAoAAQIAK8cGCBMABAo=.Thornus:AwAGCA0ABAoAAA==.Thranduîl:AwABCAEABAoAAA==.',Tk='Tkr:AwADCAEABAoAAA==.',To='Tosteque:AwAECAYABAoAAA==.',Tr='Tridënt:AwABCAEABAoAAA==.',Tu='Turles:AwABCAIABAoAAA==.',Tw='Twistercolt:AwADCAUABAoAAA==.',Ty='Tyolla:AwADCAUABAoAAA==.',Um='Umtrutaai:AwABCAEABAoAAA==.',Ur='Urgath:AwAECAQABAoAAA==.Uron:AwACCAMABAoAAA==.',Va='Vallyri:AwABCAEABAoAAA==.',Ve='Vellami:AwAFCAkABAoAAA==.Vento:AwAFCAQABAoAAA==.',Vi='Vikat:AwAFCAMABAoAAA==.Vits:AwAGCAYABAoAAA==.',Vr='Vrauzer:AwAICBkABAoCDAAIAQgiBABSswUDBAoADAAIAQgiBABSswUDBAoAAA==.',Vu='Vulrin:AwACCAIABAoAAA==.',['V�']='Vÿk:AwAGCA4ABAoAAA==.',Wi='Wildspirit:AwAICAgABAoAAA==.Willvictory:AwAHCBEABAoAAA==.Winnettou:AwAFCAoABAoAAA==.',Wu='Wunjo:AwAECAQABAoAAA==.',['W�']='Wälls:AwAGCAQABAoAAA==.',Xa='Xamâbulança:AwABCAEABAoAAA==.Xanasmanas:AwAFCAsABAoAAA==.',Xh='Xharlios:AwADCAgABAoAAA==.',Xu='Xubrao:AwAFCAgABAoAAQQAUWoCCAQABRQ=.',Xx='Xxandiin:AwAICAgABAoAAA==.Xxbizu:AwACCAIABAoAAA==.',Ya='Yatz:AwABCAIABAoAAA==.',Yo='Yoriko:AwAFCAoABAoAAQQAUUMBCAEABRQ=.',Za='Zaochi:AwAICAgABAoAAA==.',Zh='Zharock:AwAHCBIABAoAAA==.',['Ä']='Äleera:AwADCAcABAoAAA==.',['Æ']='Ærikão:AwAHCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end