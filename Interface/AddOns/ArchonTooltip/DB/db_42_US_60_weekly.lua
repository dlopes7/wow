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
 local lookup = {'Unknown-Unknown','Hunter-BeastMastery','Evoker-Devastation','DeathKnight-Unholy','Rogue-Assassination','Shaman-Enhancement','DeathKnight-Frost','Mage-Frost','Druid-Balance','Warrior-Protection','Priest-Shadow','Paladin-Retribution','Druid-Feral','Druid-Guardian','Warlock-Demonology','Warlock-Destruction',}; local provider = {region='US',realm='Darkspear',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acidreflux:AwABCAEABAoAAA==.',Ae='Aedas:AwAHCAMABAoAAA==.Aeroma:AwACCAIABAoAAQEAAAAICA8ABAo=.Aerouant:AwADCAMABAoAAA==.',Ag='Agarthans:AwAGCAYABAoAAA==.Aggelos:AwACCAIABAoAAQEAAAAICA8ABAo=.',Ah='Ahnkhan:AwAFCAUABAoAAA==.',Al='Alextrebek:AwADCAgABRQCAgADAQh4BABcDj8BBRQAAgADAQh4BABcDj8BBRQAAA==.Alleksev:AwAFCA8ABAoAAA==.Allpurp:AwABCAEABAoAAA==.Alperen:AwAHCBUABAoCAwAHAQhGBwBcd7QCBAoAAwAHAQhGBwBcd7QCBAoAAA==.',An='Angelis:AwAFCAEABAoAAA==.Angrydh:AwAICAEABAoAAA==.Anticucho:AwACCAIABAoAAA==.',Ar='Arealpal:AwAECAQABAoAAA==.',As='Astrâeâ:AwABCAEABRQCAgAHAQhTOAAyjrwBBAoAAgAHAQhTOAAyjrwBBAoAAA==.Asurmon:AwAFCAIABAoAAA==.',Av='Avraellia:AwAHCBIABAoAAA==.',Ba='Bazual:AwABCAEABAoAAA==.',Be='Beastbane:AwAICBAABAoAAA==.Belowtemp:AwADCAEABAoAAQEAAAAHCA0ABAo=.',Bo='Bozberaz:AwAECAMABAoAAA==.',Bu='Buxbii:AwABCAEABAoAAA==.',By='Bylas:AwAHCBIABAoAAA==.',Ca='Captinblunt:AwAFCAcABAoAAA==.',Ce='Celirra:AwAHCBUABAoCBAAHAQiPCwBbKKMCBAoABAAHAQiPCwBbKKMCBAoAAA==.Cerviche:AwABCAEABAoAAA==.',Ch='Cheekybaby:AwAFCA4ABAoAAA==.',Ci='Cinnascatter:AwAECAEABAoAAA==.',Cl='Clownfu:AwAECAUABAoAAA==.',Co='Coldbrew:AwAECAQABAoAAA==.',['C�']='Cät:AwAECAQABAoAAQEAAAAGCAEABAo=.',Da='Daewar:AwAECAYABAoAAA==.Daizr:AwAICAoABAoAAA==.Daïn:AwACCAQABAoAAA==.',De='Deadbound:AwAFCAUABAoAAA==.Deathmcbones:AwADCAcABAoAAA==.',Dh='Dhämmer:AwAFCAUABAoAAA==.',Dr='Dreambound:AwAICAgABAoAAA==.Druidaman:AwAGCAgABAoAAQUAUGkDCAoABRQ=.',['D�']='Dï:AwAGCAEABAoAAA==.',Ef='Efickaçi:AwADCAUABAoAAA==.',Eg='Eggfreak:AwAHCBIABAoAAA==.',El='Elazr:AwAECAQABAoAAA==.Elizabelle:AwAHCBAABAoAAA==.',Er='Ericolson:AwACCAIABAoAAA==.Eroq:AwAFCAsABAoAAA==.',Ev='Evé:AwAHCBMABAoAAA==.',Ey='Eyehealu:AwACCAIABAoAAQEAAAAICA8ABAo=.',Fa='Faeree:AwAGCAUABAoAAA==.',Fe='Fearx:AwAICAUABAoAAA==.',Fl='Floppii:AwACCAIABAoAAA==.Flourie:AwAGCAMABAoAAA==.',Fo='Fontwonka:AwAICBMABAoAAA==.',Fu='Fupette:AwADCAYABAoAAA==.Fuzzosaurus:AwAECAEABAoAAA==.',Ga='Gandogarr:AwAECAQABAoAAA==.',Gl='Glitterp:AwAHCBUABAoCBgAHAQiqCwBR7IgCBAoABgAHAQiqCwBR7IgCBAoAAA==.',Go='Gonkz:AwACCAEABAoAAA==.',Gr='Gratyr:AwADCAUABAoAAA==.Grimby:AwAICA4ABAoAAA==.',Gu='Guidomidget:AwABCAEABAoAAA==.Guyu:AwAHCAEABAoAAA==.',Ha='Hateförged:AwADCAMABAoAAA==.',He='Hexngone:AwAGCBIABAoAAA==.',Hi='Hitkillã:AwAHCBEABAoAAA==.',Ho='Holyzaimon:AwAGCAsABAoAAA==.',Hu='Huhdean:AwAHCBUABAoDBwAHAQiqAwBTf5kCBAoABwAHAQiqAwBSwpkCBAoABAAFAQj6JQBNcJcBBAoAAA==.Huskydunkers:AwADCAkABAoAAA==.',Il='Illiyanna:AwAICAwABAoAAA==.Illumi:AwACCAIABAoAAQEAAAAECAEABAo=.',Ja='Jabberwock:AwABCAEABAoAAA==.Jackfröst:AwACCAIABAoAAA==.',Je='Jenzilus:AwABCAEABAoAAA==.',Jo='Johnnytran:AwABCAEABRQAAA==.',['J�']='Jáinà:AwAHCBUABAoCCAAHAQhMGgA8weYBBAoACAAHAQhMGgA8weYBBAoAAA==.',Kl='Klivian:AwAHCBAABAoAAA==.',Kr='Krystall:AwAICA8ABAoAAA==.',La='Laenda:AwACCAEABAoAAA==.Laojin:AwAFCAQABAoAAA==.Lardaz:AwABCAEABAoAAA==.Lasrimas:AwAHCAEABAoAAA==.',Li='Lightdrop:AwAFCAsABAoAAA==.Lilina:AwAECAEABAoAAA==.',Lo='Lofe:AwAECAEABAoAAA==.Lovethered:AwAECAUABAoAAA==.',Lu='Luffydonoo:AwABCAEABAoAAA==.Lulafairy:AwADCAYABAoAAA==.Lunatick:AwAICAgABAoAAA==.Lunawa:AwAICBgABAoCCAAIAQgPBwBVi9ACBAoACAAIAQgPBwBVi9ACBAoAAA==.',Ma='Magdagni:AwAGCAwABAoAAA==.Malarkus:AwAICAgABAoAAA==.Malphas:AwAHCBUABAoCBQAHAQiSDwAmsqIBBAoABQAHAQiSDwAmsqIBBAoAAA==.',Mb='Mbappe:AwADCAcABAoAAA==.',Mc='Mclovîn:AwAECAYABAoAAA==.',Me='Meowmander:AwAFCAEABAoAAA==.Merkén:AwAGCAoABAoAAA==.',Mi='Midaerna:AwACCAEABAoAAA==.Minax:AwAFCAYABAoAAA==.Mindari:AwADCAkABAoAAA==.',Mu='Muckstab:AwACCAQABRQAAA==.',My='Myrú:AwAHCBIABAoAAA==.',['M�']='Mãi:AwADCAkABAoAAA==.',Na='Namiella:AwAFCAUABAoAAA==.Narayeda:AwACCAEABAoAAA==.',Ne='Nerftraps:AwAICAgABAoAAA==.',Ni='Nikos:AwABCAEABAoAAA==.',No='Nokie:AwADCAIABAoAAQEAAAAHCBIABAo=.Notåredneck:AwAECAUABAoAAA==.',Nu='Nuvostaph:AwAHCBEABAoAAA==.',['N�']='Nìghtmared:AwAGCBIABAoAAA==.',Oa='Oakshror:AwAFCAgABAoAAA==.',Ol='Ollomer:AwAFCAEABAoAAA==.',On='Onlyflan:AwAFCA8ABAoAAA==.',Oz='Ozzyfozzy:AwAFCAcABAoAAA==.',Pa='Paedria:AwADCAYABAoAAQEAAAAICA8ABAo=.Palpatîne:AwACCAMABAoAAA==.Paltor:AwACCAIABAoAAA==.Papiace:AwACCAIABAoAAQEAAAAGCAMABAo=.',Pi='Pinguoindeat:AwADCAQABAoAAA==.',Po='Pollard:AwAFCAsABAoAAA==.Pooche:AwADCAMABAoAAA==.',Ra='Rahni:AwAFCAkABAoAAA==.Raylith:AwACCAIABAoAAA==.',Ri='Rizowe:AwAICBAABAoAAA==.',Ru='Ruggzzi:AwABCAMABRQCCQAIAQisBQBbkhoDBAoACQAIAQisBQBbkhoDBAoAAA==.',Ry='Ryte:AwAHCBIABAoAAA==.',Sa='Saithe:AwAHCBUABAoCCgAHAQjuBQBFSRUCBAoACgAHAQjuBQBFSRUCBAoAAA==.Sarangoo:AwAFCAUABAoAAA==.',Sh='Shadowbláde:AwAHCBUABAoCCwAHAQhNDwBK/D8CBAoACwAHAQhNDwBK/D8CBAoAAA==.Shivasaurus:AwACCAEABAoAAA==.',Sl='Sloppydrunk:AwACCAIABAoAAA==.Slumlight:AwACCAIABAoAAA==.',So='Souldrain:AwAGCAEABAoAAA==.',Sp='Sparkles:AwADCAgABRQCDAADAQhwBwBE9AIBBRQADAADAQhwBwBE9AIBBRQAAA==.',St='Stepmum:AwAICAgABAoAAA==.Stumpedtotem:AwAHCA0ABAoAAA==.',Sv='Sverandre:AwAGCAwABAoAAA==.',Te='Telps:AwAICAgABAoAAA==.',Th='Thûnderlord:AwACCAIABAoAAA==.',Ti='Tichalock:AwACCAIABAoAAA==.',To='Toot:AwABCAEABAoAAA==.Totemsbro:AwADCAcABAoAAA==.',Tr='Treelimbs:AwAHCBUABAoCDQAHAQiuBQBFVTwCBAoADQAHAQiuBQBFVTwCBAoAAA==.',Tu='Turos:AwABCAEABAoAAA==.',Ty='Tylanar:AwADCAQABAoAAA==.',Va='Varigo:AwACCAIABAoAAA==.',Vi='Vinedragoon:AwACCAIABAoAAQ4AObcBCAIABRQ=.',Wa='Wafflexpress:AwABCAEABAoAAA==.Warwalkerz:AwABCAEABAoAAA==.Wavetek:AwACCAMABAoAAA==.',We='Weediè:AwABCAEABAoAAA==.',Xi='Xiaoshui:AwAECAMABAoAAA==.',Xu='Xugos:AwAHCCIABAoDDwAHAQgjDQAj/o8BBAoADwAHAQgjDQAj/o8BBAoAEAACAQgDcQAigFcABAoAAA==.',Xy='Xyno:AwAHCA8ABAoAAA==.',Ze='Zendrost:AwAHCBAABAoAAA==.',Zi='Zigurous:AwACCAIABAoAAA==.',['À']='Àncksunamun:AwAECAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end