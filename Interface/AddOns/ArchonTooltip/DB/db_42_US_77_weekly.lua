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
 local lookup = {'Priest-Shadow','Druid-Balance','Unknown-Unknown','Rogue-Assassination','Evoker-Devastation','Evoker-Preservation','Shaman-Enhancement','Mage-Fire',}; local provider = {region='US',realm='Drakkari',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aahomine:AwAFCAUABAoAAA==.',Ab='Abuelacoco:AwAFCAkABAoAAA==.',Ak='Akthos:AwABCAEABAoAAA==.',Al='Alistarona:AwABCAEABAoAAA==.Alliesh:AwAECAIABAoAAA==.',Am='Amautista:AwABCAEABAoAAA==.Amor:AwACCAEABAoAAA==.',Ao='Aom:AwADCAIABAoAAA==.Aomesan:AwACCAIABAoAAA==.',Ar='Arcrav:AwAFCAIABAoAAA==.Arkanoidet:AwAFCAMABAoAAA==.Artimos:AwABCAEABAoAAA==.Arts:AwADCAEABAoAAA==.Arvell:AwAFCAEABAoAAA==.',As='Asdelaguinda:AwABCAEABAoAAA==.',Au='Auranix:AwABCAEABAoAAA==.',Az='Azaleas:AwAECAwABAoAAA==.Azarel:AwACCAEABAoAAA==.Azelfafage:AwADCAEABAoAAA==.',Be='Beliin:AwAICAgABAoAAA==.Beterano:AwAFCAkABAoAAA==.',Bi='Bigbe:AwACCAEABAoAAA==.',Bl='Blackdeatht:AwAECA0ABAoAAA==.Blackkô:AwAFCAEABAoAAA==.Bloodoroth:AwACCAIABAoAAA==.',Bo='Bonnibel:AwABCAEABRQAAA==.Borutoshino:AwACCAMABAoAAA==.',Bu='Bullchill:AwAFCAwABAoAAA==.Bullich:AwACCAIABAoAAA==.Burningsight:AwACCAEABAoAAA==.',By='Byk:AwABCAEABAoAAA==.',['B�']='Bélhan:AwAECAUABAoAAA==.',Ca='Caberlock:AwACCAMABAoAAA==.Cartaca:AwABCAEABAoAAA==.Cassiusclay:AwACCAMABRQCAQAIAQjuFwAier4BBAoAAQAIAQjuFwAier4BBAoAAA==.Cawboy:AwACCAQABAoAAA==.Cazademonios:AwACCAEABAoAAA==.',Ch='Chamaang:AwABCAEABAoAAA==.Chikoritå:AwABCAEABAoAAA==.Chiquiña:AwAECAUABAoAAA==.Chrysaor:AwADCAMABAoAAA==.Chyn:AwACCAMABAoAAA==.',Cl='Clavakchan:AwADCAEABAoAAA==.',Cr='Cristthell:AwADCAIABAoAAA==.Cryoslypse:AwACCAEABAoAAA==.',Da='Danhole:AwADCAIABAoAAA==.Dantefreak:AwADCAQABAoAAA==.',De='Deblimoon:AwADCAEABAoAAA==.',Dh='Dhaan:AwABCAIABRQAAA==.',Di='Diaconofroz:AwACCAIABAoAAA==.Diechaos:AwACCAMABAoAAA==.',Dr='Dragenh:AwADCAEABAoAAA==.Dranagor:AwAECAIABAoAAA==.',Du='Duduß:AwADCAIABAoAAA==.Dulcegema:AwABCAIABRQCAgAHAQgOHgBAsfUBBAoAAgAHAQgOHgBAsfUBBAoAAA==.',Ea='Eagleheart:AwACCAIABAoAAA==.',Ec='Eclipsa:AwAFCA0ABAoAAA==.',El='Electricsham:AwAFCAUABAoAAA==.Elhii:AwACCAMABAoAAQMAAAABCAEABRQ=.Elpolloloco:AwACCAEABAoAAA==.',Em='Emms:AwABCAEABAoAAQQAMssDCAUABRQ=.',En='Enror:AwAGCAEABAoAAA==.',Es='Esnad:AwAECAYABAoAAA==.',Et='Ethene:AwAFCAkABAoAAA==.',Eu='Euphinho:AwACCAMABRQDBQAHAQjICgBOzGcCBAoABQAHAQjICgBOzGcCBAoABgABAQgtHAA8CUAABAoAAA==.',Ex='Exado:AwADCAEABAoAAA==.Extermíneó:AwAGCAEABAoAAA==.',Fe='Fexmenz:AwAECAQABAoAAA==.',Fh='Fhyse:AwAICBMABAoAAQcASMcDCAcABRQ=.Fhyze:AwADCAcABRQCBwADAQicAgBIxx4BBRQABwADAQicAgBIxx4BBRQAAA==.',Fo='Foxtaz:AwABCAEABAoAAA==.',Fr='Frozenneitor:AwABCAEABRQAAA==.',Ga='Gadito:AwABCAIABRQAAA==.Gagham:AwAECAUABAoAAA==.Galadhriell:AwAICBAABAoAAA==.Galligan:AwACCAEABAoAAA==.Gazi:AwAFCAcABAoAAA==.',Gi='Gingerfox:AwABCAIABRQAAA==.',Gl='Glimdar:AwAECAEABAoAAA==.Glørious:AwAGCAQABAoAAA==.',Go='Gondal:AwAECAEABAoAAA==.',Gw='Gwendevere:AwADCAQABAoAAA==.',Ha='Hashirma:AwABCAEABAoAAA==.Hathyr:AwACCAIABAoAAA==.Hazy:AwACCAQABAoAAA==.',He='Hekan:AwAGCAcABAoAAA==.Heliuwr:AwAFCAsABAoAAA==.Hellwrath:AwAFCAEABAoAAA==.',Ho='Holokenzoku:AwACCAMABRQAAA==.Holynevits:AwAGCAsABAoAAA==.Hovz:AwADCAEABAoAAA==.',Il='Illiyzaelle:AwADCAMABAoAAA==.Ilovemooncyi:AwABCAEABAoAAA==.',In='Inquisicion:AwABCAEABRQAAA==.Inspert:AwABCAEABAoAAA==.',Ja='Jadepicon:AwABCAEABAoAAA==.',Jh='Jhondesertor:AwADCAMABAoAAA==.',Ju='Julielchaman:AwADCAIABAoAAA==.Juoman:AwABCAIABAoAAA==.',Ka='Kachupinsito:AwAGCAEABAoAAA==.Kaithar:AwAGCAkABAoAAA==.Kalocha:AwAHCAIABAoAAA==.Kaltozz:AwAHCBAABAoAAA==.Kanao:AwAFCAYABAoAAA==.Kaycilius:AwACCAEABAoAAA==.',Kc='Kcloud:AwAECAQABAoAAA==.',Ke='Kelsir:AwABCAEABAoAAA==.Kerartas:AwACCAEABAoAAA==.',Kh='Khafka:AwAECAsABAoAAA==.Khazadora:AwACCAEABAoAAA==.Khurisu:AwACCAIABAoAAA==.',Ko='Korgancio:AwAGCAkABAoAAA==.',Kr='Kryptos:AwABCAEABAoAAA==.',Ku='Kulcukan:AwAECAkABAoAAA==.',Kw='Kwelps:AwADCAIABAoAAA==.',['K�']='Kötur:AwACCAIABAoAAA==.',La='Lagartisomms:AwAGCAcABAoAAA==.Laidlytyr:AwADCAUABAoAAA==.Lanáya:AwADCAEABAoAAA==.',Le='Leomon:AwAGCA0ABAoAAA==.Lethrock:AwAFCAgABAoAAA==.Lexozo:AwAFCAcABAoAAA==.',Li='Liftiz:AwAHCAQABAoAAA==.Liliiana:AwAECAEABAoAAA==.Lindeallá:AwAFCAIABAoAAA==.Litha:AwABCAEABAoAAA==.Lithelian:AwADCAEABAoAAA==.',Lo='Losplones:AwADCAEABAoAAA==.',Lu='Luchitoxd:AwABCAEABAoAAA==.Lunainverse:AwADCAMABAoAAA==.',['L�']='Lást:AwADCAIABAoAAA==.',Ma='Maehhl:AwABCAEABAoAAA==.Malextrasa:AwAFCAIABAoAAA==.Mamamiax:AwABCAEABAoAAA==.Mamásilvi:AwACCAEABAoAAA==.Maskjora:AwADCAYABAoAAA==.Matusalix:AwACCAIABAoAAA==.',Me='Medaly:AwAGCAMABAoAAA==.Megumyxd:AwAECAEABAoAAA==.Melhí:AwABCAEABRQAAA==.Meloktwo:AwAFCAIABAoAAA==.Meltrix:AwAECAEABAoAAA==.Meredîthita:AwADCAUABAoAAA==.Meryenda:AwACCAEABAoAAA==.',Mi='Michineitor:AwADCAEABAoAAA==.Miléidi:AwACCAMABAoAAA==.',Mo='Morilex:AwABCAIABRQAAA==.Morthuus:AwACCAEABAoAAA==.Moruthay:AwAECAEABAoAAA==.',My='Myrinna:AwACCAEABAoAAA==.',Na='Nacro:AwACCAEABAoAAA==.Naratter:AwACCAIABAoAAA==.Naxxoll:AwADCAMABAoAAA==.Nazadrok:AwAICAgABAoAAA==.',Ne='Nefële:AwADCAUABAoAAA==.Nelwolf:AwAFCAkABAoAAA==.',Ni='Nirviil:AwABCAIABRQCCAAIAQizHgA3+BYCBAoACAAIAQizHgA3+BYCBAoAAA==.',No='Nomal:AwABCAEABAoAAA==.',Ny='Nyler:AwAFCAEABAoAAA==.',Ol='Olaznog:AwAGCBMABAoAAA==.',Om='Omnig:AwACCAIABAoAAA==.',On='Onitsume:AwABCAEABAoAAA==.',Op='Opusdiáboli:AwADCAEABAoAAA==.',Or='Originalsoul:AwAFCAgABAoAAA==.',Pa='Pachosapo:AwADCAMABAoAAA==.Palatruxo:AwAECAcABAoAAA==.Pandepascuas:AwADCAIABAoAAA==.Paradiseholy:AwAECAYABAoAAA==.Patafuria:AwAECAUABAoAAA==.',Pe='Pentauret:AwAECAYABAoAAA==.Pepitaa:AwAECAQABAoAAA==.Perrobrimbor:AwACCAEABAoAAA==.',Pi='Pibon:AwACCAIABAoAAA==.Picklesacred:AwAGCAQABAoAAA==.',Pl='Plegariaa:AwACCAEABAoAAA==.',Po='Porongón:AwAFCAsABAoAAA==.',Qo='Qorianka:AwAFCAwABAoAAA==.',Ra='Rackham:AwABCAEABRQAAA==.',Re='Rechmage:AwAFCAMABAoAAA==.Restorátion:AwABCAEABAoAAA==.',Rh='Rhayzasham:AwAHCAEABAoAAA==.',Ri='Rilandris:AwACCAEABAoAAA==.Risko:AwAECAMABAoAAA==.Rivmed:AwACCAEABAoAAA==.',Ro='Rodkash:AwAFCA4ABAoAAA==.Rolee:AwAHCAsABAoAAA==.Ronín:AwAFCAgABAoAAA==.Rotls:AwAFCAEABAoAAA==.',Ru='Rugal:AwAECAgABAoAAA==.',['R�']='Ráyan:AwADCAYABAoAAA==.',Sa='Safrata:AwACCAEABAoAAA==.Sanguinariio:AwACCAIABAoAAA==.Sanndir:AwAECAMABAoAAA==.Saycox:AwADCAQABAoAAA==.',Se='Sebvz:AwAECAQABAoAAA==.Sefmer:AwABCAEABRQAAA==.Serotonin:AwAHCAYABAoAAA==.',Sh='Shadoweak:AwAECAIABAoAAA==.Shadowlobo:AwAGCAEABAoAAA==.Shamantaz:AwABCAEABAoAAA==.Shaomunz:AwADCAIABAoAAA==.Sharthis:AwAECAUABAoAAA==.Shibamiyuki:AwABCAEABRQAAA==.Shimuu:AwACCAEABAoAAA==.Shmith:AwACCAEABAoAAA==.Shyvannaa:AwAFCAYABAoAAA==.Shârpblade:AwACCAMABAoAAA==.',Si='Sicklock:AwAICAIABAoAAA==.Silverkiller:AwAFCAkABAoAAA==.Sitvar:AwAECAYABAoAAA==.Sixteco:AwACCAEABAoAAA==.',Sk='Skkaði:AwADCAQABAoAAA==.',Sm='Smaul:AwABCAEABAoAAA==.',So='Sochiee:AwACCAEABAoAAA==.Soulheavens:AwAECAYABAoAAA==.',Sp='Spring:AwACCAMABAoAAA==.',St='Starknight:AwAFCAcABAoAAA==.Strokezz:AwAFCAsABAoAAA==.',Su='Sukaritas:AwAECAEABAoAAA==.',Sw='Swinnger:AwAECAIABAoAAA==.',Ta='Taringa:AwACCAEABAoAAA==.Tazg:AwACCAIABAoAAA==.',Te='Tensenrin:AwADCAMABAoAAA==.Terradarkin:AwAECAIABAoAAA==.',Th='Thoritank:AwAHCAkABAoAAA==.Thunderoth:AwAECAMABAoAAA==.',To='Tombiz:AwAGCBMABAoAAA==.Tornhorn:AwAFCAwABAoAAA==.Torujo:AwAFCAIABAoAAA==.',Tr='Trost:AwAFCAIABAoAAA==.Tryzthano:AwAECAgABAoAAA==.',Tu='Tumque:AwABCAEABAoAAA==.',Ty='Tyranna:AwABCAIABAoAAA==.Tyranïtar:AwACCAEABAoAAA==.Tyruz:AwABCAEABAoAAA==.',Uc='Uchida:AwAFCAMABAoAAA==.',Un='Unaixo:AwADCAMABAoAAA==.Unlactosed:AwADCAYABAoAAA==.Unly:AwACCAEABAoAAA==.',Va='Valmonkey:AwADCAMABAoAAA==.Valquirie:AwAHCAEABAoAAA==.Vanderiel:AwADCAEABAoAAA==.',Ve='Vejetacion:AwAHCBUABAoCAgAHAQjSKgAm/IsBBAoAAgAHAQjSKgAm/IsBBAoAAA==.Vermith:AwACCAIABAoAAA==.',Vi='Vichizz:AwACCAEABAoAAA==.Viciecaal:AwACCAEABAoAAA==.Viejosabrosö:AwABCAEABRQAAA==.Visenyax:AwAICBAABAoAAA==.',['V�']='Véra:AwACCAEABAoAAA==.',Wa='Waflles:AwAECAcABAoAAA==.',Xd='Xdblakexd:AwADCAQABAoAAA==.',Xh='Xhytta:AwABCAEABRQAAA==.',Ya='Yamisan:AwADCAIABAoAAA==.',Ye='Yee:AwAHCA8ABAoAAA==.',Yt='Ytsedwarf:AwAFCAUABAoAAA==.',Yu='Yuumil:AwACCAIABAoAAA==.',Za='Zafirov:AwAHCA0ABAoAAA==.Zaracachunga:AwACCAIABAoAAA==.',Ze='Zephyroth:AwABCAEABAoAAA==.',Zh='Zhatx:AwABCAEABAoAAA==.Zhenna:AwAFCA8ABAoAAA==.',['Z�']='Zäöry:AwABCAEABRQAAA==.',['Á']='Álibéll:AwACCAEABAoAAA==.',['É']='Évé:AwAHCBMABAoAAA==.',['Ê']='Êctheliøn:AwACCAQABAoAAA==.',['Ë']='Ën:AwACCAIABAoAAA==.',['Ð']='Ðagûra:AwADCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end