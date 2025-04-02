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
 local lookup = {'Shaman-Enhancement','Mage-Frost','Unknown-Unknown','Hunter-BeastMastery','Warrior-Arms','Warrior-Fury','Paladin-Retribution','Mage-Fire','Shaman-Restoration','Warrior-Protection','DeathKnight-Unholy','DeathKnight-Blood',}; local provider = {region='US',realm='Hellscream',name='US',type='weekly',zone=42,date='2025-03-28',data={Ac='Acekid:AwADCAEABAoAAA==.',Ai='Aiel:AwAHCA8ABAoAAA==.',Al='Alaeus:AwACCAIABRQCAQAIAQhVBABUaBADBAoAAQAIAQhVBABUaBADBAoAAA==.Alestorm:AwACCAIABAoAAA==.Allzera:AwADCAQABAoAAA==.',An='Anibella:AwAFCAkABAoAAA==.',Ar='Armin:AwAECAIABAoAAA==.Arrowhoof:AwACCAEABAoAAA==.',As='Asya:AwAICAoABAoAAA==.',At='Atom:AwABCAEABRQCAgAIAQitDQBB9GICBAoAAgAIAQitDQBB9GICBAoAAA==.Attilathepun:AwAICBMABAoAAA==.',Au='Augmentious:AwAGCAEABAoAAA==.',Ba='Bakugo:AwABCAEABAoAAA==.Barrlidan:AwAHCA8ABAoAAA==.Barrthas:AwACCAIABAoAAQMAAAAHCA8ABAo=.Bastenwode:AwACCAIABAoAAA==.',Be='Beartab:AwADCAQABAoAAA==.',Bi='Bighealz:AwAGCAIABAoAAA==.Bigjim:AwACCAIABAoAAA==.',Bl='Blackmagma:AwAECAEABAoAAA==.Blackpinkk:AwAHCBQABAoCBAAHAQh0HwBJAVECBAoABAAHAQh0HwBJAVECBAoAAA==.Blindmelon:AwAECAEABAoAAA==.Bloodbunny:AwABCAEABAoAAA==.Bluddbeard:AwAECAYABAoAAA==.',Br='Brocknor:AwAGCBAABAoAAA==.Bruur:AwABCAEABAoAAA==.',By='Byleto:AwAHCAQABAoAAA==.Byte:AwADCAMABAoAAA==.',['B�']='Bírd:AwAICAgABAoAAA==.',Ci='Citrusfiesta:AwABCAIABAoAAA==.',Cl='Cloudsinger:AwAECAEABAoAAA==.',Co='Conrad:AwADCAUABAoAAA==.Coomie:AwADCAMABAoAAA==.Copperheadj:AwABCAEABAoAAA==.',Cr='Croketita:AwAGCAoABAoAAA==.',Cy='Cytara:AwAICAgABAoAAA==.',['C�']='Câp:AwAICAwABAoAAA==.',Da='Daniellia:AwACCAEABAoAAA==.Dar:AwACCAIABAoAAA==.',De='Deathstomper:AwACCAMABRQDBQAIAQjsAwBWYOECBAoABQAIAQjsAwBWYOECBAoABgADAQizPwA8a+IABAoAAA==.Delnarian:AwADCAMABAoAAA==.',Di='Dirtslinger:AwACCAIABAoAAA==.Divinehooves:AwAFCAwABAoAAA==.',Dr='Draykor:AwAICA4ABAoAAA==.Drotara:AwAGCAsABAoAAA==.',Du='Dualadin:AwAFCAkABAoAAA==.',['D�']='Dànger:AwAECAIABAoAAA==.',Ef='Efu:AwAICBEABAoAAA==.',Em='Emagonagrip:AwAHCBIABAoAAA==.Emonlord:AwAECAEABAoAAA==.',En='Endwar:AwABCAQABRQAAA==.',Er='Erikprince:AwADCAEABAoAAA==.',Et='Eternalpaín:AwAGCBYABAoCBwAGAQhhKgBYqzoCBAoABwAGAQhhKgBYqzoCBAoAAA==.',Fa='Fayb:AwACCAIABAoAAA==.',Fe='Fendretta:AwAGCB4ABAoCBAAGAQjSJABSCikCBAoABAAGAQjSJABSCikCBAoAAA==.',Fi='Fistö:AwADCAQABAoAAA==.',Ge='Geniver:AwADCAMABAoAAA==.Geru:AwAECAMABAoAAA==.',Gl='Glad:AwAFCAMABAoAAA==.',Go='Gomory:AwADCAMABAoAAA==.Gorgoz:AwADCAEABAoAAA==.',Gr='Gremlìn:AwACCAMABAoAAA==.Grimlight:AwADCAcABRQCBwADAQj1BABMYCIBBRQABwADAQj1BABMYCIBBRQAAA==.',Ha='Haktori:AwAFCAEABAoAAA==.Harlequins:AwAFCAIABAoAAA==.',He='Hetepiir:AwAHCAsABAoAAA==.',Ho='Howeird:AwAECAIABAoAAQMAAAAECAcABAo=.',Ht='Htownprot:AwACCAMABAoAAA==.',Hw='Hwoarang:AwAHCBAABAoAAA==.',In='Innovates:AwACCAIABAoAAA==.',Ja='Jasminsparks:AwAICAcABAoAAA==.',Je='Jetpilot:AwADCAQABAoAAA==.',Ju='Juddii:AwADCAMABAoAAA==.',Ka='Kamikaze:AwADCAQABAoAAA==.Katielynn:AwABCAEABAoAAA==.',Ke='Kegroll:AwAICAUABAoAAA==.',Kh='Khiwi:AwAHCAwABAoAAA==.',Ki='Kimpossumble:AwAFCAUABAoAAA==.',Ko='Koro:AwAECAYABAoAAA==.',Kr='Krelid:AwADCAIABAoAAA==.Krüsh:AwADCAMABAoAAA==.',Ku='Kurzak:AwAHCBMABAoAAA==.Kuszz:AwAGCAoABAoAAA==.',Ky='Kyonna:AwACCAIABAoAAA==.',La='Ladeiene:AwADCAQABAoAAA==.Lardna:AwAFCA0ABAoAAA==.',Le='Leon:AwAICAMABAoAAA==.',Li='Lichèn:AwAFCAQABAoAAA==.',['L�']='Lòck:AwACCAIABAoAAA==.',Ma='Magicenjoyer:AwABCAEABRQCCAAHAQj7JwA7jbwBBAoACAAHAQj7JwA7jbwBBAoAAA==.Maidenofbees:AwADCAcABRQCCQADAQguAgBWNSgBBRQACQADAQguAgBWNSgBBRQAAA==.Maitrii:AwADCAQABAoAAA==.Marmalade:AwAECAMABAoAAA==.',Mi='Michoa:AwAFCAkABAoAAA==.Minari:AwAGCBEABAoAAA==.Mistweaving:AwAGCBMABAoAAA==.',Mo='Moistfeet:AwADCAYABAoAAA==.',Mu='Mugo:AwAECAMABAoAAA==.',My='Mythbris:AwAFCAwABAoAAA==.',Na='Nano:AwAFCA0ABAoAAA==.',Ne='Necronomica:AwAGCAsABAoAAA==.Nefarius:AwAGCBEABAoAAA==.Neotoldir:AwAGCAoABAoAAA==.Nevershocked:AwAGCAsABAoAAA==.',No='Noemia:AwACCAUABAoAAQMAAAAHCAwABAo=.Notintheface:AwAECAEABAoAAA==.',Ok='Okar:AwAECAIABAoAAA==.Oktal:AwAFCA0ABAoAAA==.',On='Onslaught:AwAECAIABAoAAQIAQfQBCAEABRQ=.',Or='Orcthas:AwACCAIABAoAAA==.Oreck:AwAECAYABAoAAA==.',Pa='Paranoir:AwAECAcABAoAAA==.',Ph='Phage:AwADCAIABAoAAA==.Pheel:AwAGCBEABAoAAA==.',Pk='Pkrage:AwABCAIABRQDCgAHAQgDBQBJ+iwCBAoACgAHAQgDBQBI1CwCBAoABQABAQiUPAA7yEMABAoAAA==.',Pl='Platombu:AwADCAIABAoAAA==.',Re='Regentofbees:AwADCAMABRQAAA==.Reileii:AwACCAIABAoAAA==.',Ro='Robrõy:AwAFCAcABAoAAA==.Roseclaw:AwECCAIABAoAAQQARygBCAEABRQ=.Roseclawed:AwEBCAEABRQCBAAIAQipEwBHKLUCBAoABAAIAQipEwBHKLUCBAoAAA==.Roxcee:AwABCAEABAoAAA==.Roxso:AwAECAgABAoAAA==.',['R�']='Ròbroy:AwACCAEABAoAAA==.',Sa='Samiam:AwAICAkABAoAAA==.Sarkozy:AwAFCBAABAoAAA==.',Sc='Scarletteeth:AwAICBAABAoAAA==.',Se='Seiraa:AwAICAcABAoAAA==.',Sh='Sharana:AwAECAQABAoAAA==.Shlapy:AwAICAgABAoAAA==.',Si='Sinful:AwAGCA0ABAoAAA==.',Sk='Skolivia:AwAHCBEABAoAAA==.Skophie:AwADCAMABAoAAQMAAAAHCBEABAo=.',Sl='Sloppysteaks:AwABCAMABRQCCgAIAQh3BwAvVdMBBAoACgAIAQh3BwAvVdMBBAoAAA==.',Sn='Sniffledoo:AwACCAIABAoAAA==.Snin:AwABCAMABRQCBwAHAQisTQAtHacBBAoABwAHAQisTQAtHacBBAoAAA==.',So='Sourfangs:AwAHCBEABAoAAA==.',Sp='Spicymilk:AwAHCA8ABAoAAA==.Spicypeño:AwACCAEABAoAAA==.Sprawl:AwAECAIABAoAAA==.',St='Starnights:AwAECAIABAoAAA==.Steelbubble:AwACCAQABAoAAA==.Stormtide:AwAICAoABAoAAA==.Strela:AwAFCBkABAoCBAAFAQisZwAkvOoABAoABAAFAQisZwAkvOoABAoAAA==.',Su='Summonstella:AwACCAMABAoAAA==.Suraki:AwADCAgABAoAAA==.',Ta='Taurym:AwACCAIABAoAAA==.',Th='Thalion:AwAHCBIABAoAAA==.',Tr='Trîgger:AwABCAMABRQCCwAIAQhtBQBYrwgDBAoACwAIAQhtBQBYrwgDBAoAAA==.',Um='Ume:AwAHCAEABAoAAA==.',Va='Vaasik:AwACCAMABAoAAA==.',Vi='Vinhelsin:AwABCAEABAoAAA==.',Vo='Voidwrld:AwAICAEABAoAAA==.Voron:AwADCAEABAoAAA==.',Vy='Vyndara:AwAICAgABAoAAA==.',Wa='Warsteel:AwAFCAQABAoAAA==.Waterwhip:AwAICA4ABAoAAA==.',We='Westfall:AwAHCBgABAoCDAAHAQhdEwAyD6IBBAoADAAHAQhdEwAyD6IBBAoAAA==.',Wo='Worth:AwAFCAwABAoAAA==.Wou:AwAFCAgABAoAAA==.',['W�']='Wíckedwítch:AwAICAsABAoAAA==.',Yi='Yiro:AwAECA0ABAoAAA==.',Za='Zachsparrow:AwADCAMABAoAAA==.',Ze='Zeesaw:AwADCAUABAoAAA==.',Zl='Zlutar:AwAICA4ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end