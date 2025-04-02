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
 local lookup = {'Evoker-Devastation','Unknown-Unknown','Shaman-Elemental','Warlock-Destruction','Warlock-Demonology','Hunter-BeastMastery','Monk-Mistweaver','Shaman-Enhancement','Druid-Balance',}; local provider = {region='US',realm='Boulderfist',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adventureux:AwAHCA8ABAoAAA==.',Ag='Agnos:AwAHCBAABAoAAA==.',Al='Alacuma:AwAGCA8ABAoAAA==.Alucard:AwADCAYABAoAAA==.',An='Angerforge:AwAICAEABAoAAA==.',Ap='Apolynedas:AwAECAYABAoAAA==.',Ar='Arrowedice:AwABCAEABAoAAA==.',Aw='Awayishock:AwAGCAYABAoAAA==.',Ay='Ayen:AwAGCAYABAoAAA==.',Ba='Babagooney:AwADCAYABAoAAA==.Balthromaw:AwACCAIABAoAAA==.Batang:AwAECAkABRQCAQAEAQgkAQBKz30BBRQAAQAEAQgkAQBKz30BBRQAAA==.Batfistman:AwAFCAoABAoAAA==.',Bc='Bckalleydoc:AwAICA0ABAoAAA==.',Be='Beeto:AwABCAEABRQAAA==.',Bi='Bilf:AwADCAQABAoAAA==.',Bl='Blindfury:AwABCAIABAoAAA==.',Br='Brickeddown:AwAHCAMABAoAAA==.',Bu='Bubbleoshift:AwADCAMABAoAAA==.',Ca='Cadroyd:AwAGCAMABAoAAA==.Caelin:AwAGCAMABAoAAA==.Caishana:AwAHCBIABAoAAA==.',Ch='Chaddingus:AwADCAQABAoAAA==.Chugbleach:AwAHCAQABAoAAA==.',Cl='Clique:AwADCAgABAoAAA==.',Cy='Cyndle:AwAGCAYABAoAAA==.',Da='Darkalt:AwADCAYABAoAAA==.Daveyjoness:AwAGCAsABAoAAA==.Davinki:AwAGCAcABAoAAA==.',De='Demonchocc:AwADCAIABAoAAQIAAAAHCBAABAo=.',Di='Dirtyphish:AwACCAEABAoAAA==.Dirtysham:AwABCAEABRQCAwAIAQhpEAA49C8CBAoAAwAIAQhpEAA49C8CBAoAAA==.',Do='Downbad:AwAHCBcABAoDBAAHAQhbGwBBpQ0CBAoABAAHAQhbGwBBpQ0CBAoABQABAQjIRgAOaxcABAoAAA==.',Dr='Drakulya:AwACCAIABAoAAA==.Dramagos:AwAHCBYABAoCBgAHAQiaNwAvocABBAoABgAHAQiaNwAvocABBAoAAA==.Dreadz:AwAGCA0ABAoAAA==.',Eb='Ebin:AwACCAIABAoAAA==.',En='Endlesshour:AwAECAYABAoAAA==.Enoka:AwAGCBAABAoAAA==.',Et='Ether:AwAGCAUABAoAAA==.',Ev='Evgenimalkin:AwAGCAkABAoAAA==.',Fa='Fariebubbles:AwACCAUABAoAAA==.',Fe='Felfiend:AwAFCAEABAoAAA==.',Fr='Frostpoptart:AwAFCAEABAoAAA==.',Fu='Furiousgeorg:AwACCAEABAoAAA==.Fuzzymon:AwABCAEABAoAAA==.',Ga='Garrick:AwAFCAwABAoAAA==.',Go='Gooze:AwACCAIABAoAAQIAAAAGCAwABAo=.Gorshot:AwAFCAwABAoAAA==.',Gr='Grimmjob:AwAGCBEABAoAAA==.',Gu='Guess:AwAGCAwABAoAAA==.',Ha='Harmonee:AwAGCAYABAoAAA==.Harrywizzard:AwAGCAwABAoAAA==.Hauntter:AwABCAEABAoAAA==.',Ho='Holydice:AwAGCAkABAoAAA==.Holyshirts:AwAHCAwABAoAAA==.',Il='Ilesh:AwADCAQABAoAAA==.Iliketmoist:AwAGCAEABAoAAA==.',Ir='Ironic:AwAGCAcABAoAAA==.',Is='Isaidnoice:AwAHCAkABAoAAA==.Ishiftmyself:AwAGCAkABAoAAA==.',Ja='Jacked:AwAGCAwABAoAAA==.',Je='Jecthyr:AwAFCA8ABAoAAA==.Jenka:AwAHCBIABAoAAA==.',Jo='Jordana:AwADCAMABAoAAA==.Jornnathan:AwAGCA0ABAoAAA==.',Ka='Kalixta:AwAHCAwABAoAAA==.Kalrathen:AwAECAIABAoAAA==.Kazadax:AwAFCAwABAoAAA==.',Kd='Kdb:AwAICBYABAoCBwAIAQhkBgBQZ+QCBAoABwAIAQhkBgBQZ+QCBAoAAA==.',Ke='Kerlix:AwAICAgABAoAAA==.Keuaakepo:AwAGCAIABAoAAA==.',Ki='Kienne:AwAGCA4ABAoAAA==.Kinnison:AwAICAoABAoAAA==.',Le='Lementz:AwACCAUABRQCCAACAQhRBQBIo8gABRQACAACAQhRBQBIo8gABRQAAA==.',Li='Linguini:AwAGCA4ABAoAAA==.',Ll='Llrhaenys:AwAGCAUABAoAAA==.',Ma='Magoon:AwABCAEABAoAAA==.Maktah:AwAGCBIABAoAAA==.Malpractice:AwAGCAwABAoAAA==.Mathematix:AwABCAEABAoAAA==.Maybedragon:AwAHCAEABAoAAA==.',Me='Mentos:AwAECAQABAoAAA==.',Mi='Mikeoxhard:AwAGCBIABAoAAA==.Mionn:AwACCAIABAoAAA==.',Ml='Mlleena:AwAFCA4ABAoAAA==.',Na='Narc:AwADCAYABAoAAA==.',Ni='Nick:AwAICAQABAoAAA==.',No='Nohan:AwADCAIABAoAAA==.',Nu='Nunu:AwAFCAUABAoAAA==.',Ny='Nythendrac:AwAGCA0ABAoAAA==.',Ob='Obliverat:AwAICAgABAoAAA==.',Ol='Oldzygs:AwAGCAEABAoAAA==.',Oz='Ozymandias:AwAGCAkABAoAAA==.',Pa='Partypizza:AwADCAUABAoAAA==.Pasky:AwADCAMABAoAAA==.Patroll:AwADCAEABAoAAA==.',Pi='Pivnert:AwAGCAMABAoAAA==.',Pk='Pkshaman:AwAICAwABAoAAA==.',Pr='Proko:AwAGCA8ABAoAAA==.',Ra='Rallek:AwADCAUABAoAAA==.',Re='Reidron:AwADCAYABAoAAA==.Reilla:AwACCAIABAoAAA==.',Rh='Rhuk:AwAICAMABAoCBgACAQgcrwAUiTUABAoABgACAQgcrwAUiTUABAoAAA==.',Ro='Roadi:AwAFCAEABAoAAQIAAAAHCBIABAo=.',Ry='Ryoko:AwABCAEABAoAAA==.',Sc='Scrumbag:AwAICAgABAoAAA==.',Sh='Shammwoww:AwAGCBEABAoAAA==.Shockakhan:AwADCAMABAoAAA==.Shrafu:AwAECAYABAoAAA==.Shâdôw:AwAHCAEABAoAAA==.',Si='Sinroth:AwAICAgABAoAAA==.Sitnspin:AwAECAYABAoAAA==.Sixthsin:AwAGCA0ABAoAAA==.',Sm='Smokindots:AwAHCAoABAoAAA==.Smokintotem:AwADCAMABAoAAA==.',Sn='Snowberry:AwABCAIABAoAAA==.',Sp='Spaghet:AwAECAEABAoAAQEASP8BCAEABRQ=.',Sq='Square:AwACCAIABAoAAA==.',St='Stormz:AwAGCAcABAoAAA==.',Su='Sutri:AwAGCA8ABAoAAA==.',Sy='Synjo:AwAGCBAABAoAAA==.',Ta='Taxii:AwAFCAgABAoAAA==.',Te='Teapots:AwAHCBIABAoAAA==.',Th='Thayelith:AwADCAYABRQCCQADAQiIBgBD3gABBRQACQADAQiIBgBD3gABBRQAAA==.Thedeus:AwADCAYABAoAAA==.Theralendris:AwADCAgABAoAAA==.Thúnder:AwAFCAEABAoAAA==.',Tr='Tri:AwADCAMABAoAAA==.',Ty='Tyllan:AwAHCA8ABAoAAA==.',Va='Vampirate:AwADCAMABAoAAA==.Vandeadly:AwAFCAgABAoAAA==.',['V�']='Víberaider:AwABCAEABAoAAA==.',Xf='Xfu:AwAGCA0ABAoAAA==.',Xx='Xxev:AwAICAgABAoAAA==.',Ya='Yaoden:AwACCAIABAoAAQIAAAAGCA8ABAo=.',Yu='Yummyhumans:AwAGCAsABAoAAA==.Yun:AwAFCAgABAoAAA==.',Za='Zaka:AwACCAUABAoAAA==.Zanosuke:AwAFCAEABAoAAA==.Zaria:AwAGCA0ABAoAAA==.',Zl='Zlayer:AwAGCAoABAoAAA==.',['É']='Éstéla:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end