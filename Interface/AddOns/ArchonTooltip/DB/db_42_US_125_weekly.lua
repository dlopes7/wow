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
 local lookup = {'Paladin-Holy','DemonHunter-Havoc','Monk-Mistweaver','Rogue-Assassination','Rogue-Subtlety','Druid-Balance','Unknown-Unknown','Paladin-Retribution','Shaman-Restoration','Hunter-Marksmanship','Hunter-BeastMastery','Warlock-Demonology','Warlock-Destruction','Shaman-Enhancement','Paladin-Protection','Mage-Frost','Mage-Fire','Warlock-Affliction','Warrior-Arms','Warrior-Fury','Druid-Feral','DeathKnight-Unholy','DeathKnight-Blood','Druid-Restoration',}; local provider = {region='US',realm="Jubei'Thos",name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abelas:AwACCAUABRQCAQACAQhGAwBYlMYABRQAAQACAQhGAwBYlMYABRQAAA==.',Ae='Aelr:AwAGCBEABAoAAA==.',Ah='Ahnakka:AwAGCAkABAoAAA==.Ahrai:AwACCAMABRQCAgAIAQjwCwBR198CBAoAAgAIAQjwCwBR198CBAoAAA==.',Al='Alalara:AwAGCBIABAoAAA==.Albobom:AwAGCBQABAoCAwAGAQjULAAvvUIBBAoAAwAGAQjULAAvvUIBBAoAAA==.Alexmeister:AwABCAIABRQAAA==.Alliete:AwADCAYABRQDBAADAQgVBQARKHAABRQABQACAQinCAAXgn8ABRQABAACAQgVBQAPC3AABRQAAA==.Aloine:AwAGCBMABAoAAA==.',Am='Amazon:AwAFCAgABAoAAA==.',An='Angs:AwAFCAcABAoAAA==.Anneke:AwAFCAUABAoAAQQAESgDCAYABRQ=.',Ar='Arbitera:AwAFCA0ABAoAAA==.',As='Asethetics:AwAGCAsABAoAAA==.',At='Atmemory:AwAICAgABAoAAA==.',Av='Avaltasia:AwACCAEABAoAAA==.',Ax='Axelgria:AwAFCAgABAoAAA==.',Ay='Ayoshii:AwABCAIABAoAAA==.',Az='Azazêll:AwAGCAsABAoAAA==.Azurgosa:AwACCAQABAoAAA==.',Ba='Bareas:AwAECAIABAoAAA==.Bazaseal:AwACCAIABAoAAA==.',Be='Beauranged:AwADCAMABAoAAA==.Bebekrebus:AwABCAEABAoAAA==.Bellamere:AwACCAEABAoAAA==.',Bf='Bfev:AwAGCAYABAoAAA==.',Bi='Bid:AwAECAsABAoAAA==.Bierfiendx:AwAECAoABAoAAA==.Bigdragon:AwAECAIABAoAAA==.Bigjacko:AwAECAkABAoAAA==.Bigstinky:AwAHCBIABAoAAA==.',Bl='Blooms:AwAICBgABAoCBgAIAQhcBwBaKgADBAoABgAIAQhcBwBaKgADBAoAAA==.',Bo='Boogeyman:AwADCAEABAoAAA==.Booji:AwADCAIABAoAAQcAAAABCAEABRQ=.',Br='Brodess:AwAFCAwABAoAAA==.',Ch='Chadrage:AwAICAgABAoAAA==.Chaewon:AwABCAEABAoAAA==.Charbel:AwACCAIABAoAAA==.Cheeseia:AwAECAUABAoAAA==.Chikendinner:AwADCAcABAoAAA==.Chomd:AwADCAMABAoAAA==.Chomz:AwAFCAEABAoAAA==.',Ci='Ciyus:AwAGCBMABAoAAA==.',Cl='Cleaver:AwAICAQABAoAAA==.',Co='Cordeilia:AwAGCA0ABAoAAA==.',Cr='Criznara:AwAICAgABAoAAA==.',Cy='Cyanite:AwABCAEABRQAAQMAOzcDCAYABRQ=.Cyberwog:AwACCAMABRQCCAAIAQi+EABdcegCBAoACAAIAQi+EABdcegCBAoAAA==.',Da='Daneinei:AwADCAUABAoAAA==.Dapope:AwACCAUABAoAAA==.',De='Deathax:AwAGCBAABAoAAA==.Destruction:AwAICBAABAoAAA==.',Di='Dixenormous:AwAECAEABAoAAA==.',Do='Dolgrin:AwAICAgABAoAAA==.Dorafault:AwAICBsABAoCAwAIAQjMEQA8sS8CBAoAAwAIAQjMEQA8sS8CBAoAAA==.',Dr='Dreaddlord:AwADCAMABAoAAA==.',Du='Durrin:AwACCAMABAoAAA==.',Dw='Dwaka:AwEECAYABAoAAQcAAAAECAQABRQ=.',['D�']='Døden:AwABCAEABAoAAQUASj0HCBkABAo=.',Ee='Eetswah:AwAGCBEABAoAAA==.',El='Ellell:AwAECAkABAoAAA==.Elosxa:AwADCAMABAoAAA==.',Fa='Faerie:AwAICAgABAoAAA==.Falion:AwAGCAUABAoAAQkANcEDCAUABRQ=.Faneto:AwAGCA0ABAoAAA==.Fatrider:AwAGCBUABAoCCAAGAQhFOQBQAAQCBAoACAAGAQhFOQBQAAQCBAoAAA==.',Fe='Felicìa:AwAHCBAABAoAAA==.',Fi='Filthypally:AwAGCBMABAoAAA==.',Fl='Flashheart:AwAFCAUABAoAAA==.',Fr='Frostxfury:AwADCAQABAoAAA==.',Fy='Fyfedk:AwAGCA0ABAoAAA==.Fyleep:AwAICA0ABAoAAA==.',['F�']='Füñk:AwAGCBMABAoAAA==.',Ga='Gank:AwAHCBkABAoCBQAHAQhOCgBKPV4CBAoABQAHAQhOCgBKPV4CBAoAAA==.Garius:AwAECAUABAoAAA==.',Gi='Giochino:AwADCAcABAoAAA==.Gizoogle:AwAFCA0ABAoAAA==.',Go='Gobblawbster:AwAFCAUABAoAAA==.Gohan:AwAGCA0ABAoAAA==.',Gr='Grantox:AwADCAQABAoAAQoAT/4CCAIABRQ=.Granttoz:AwACCAIABRQCCgAIAQiWBQBP/rECBAoACgAIAQiWBQBP/rECBAoAAA==.',Gu='Gummii:AwAGCAYABAoAAA==.',Ha='Haruk:AwAGCBIABAoAAA==.Hayley:AwAECAsABAoAAA==.',He='Heåls:AwADCAQABAoAAA==.',Hh='Hhots:AwADCAgABAoAAA==.',Ho='Honeydew:AwACCAQABRQCAwAIAQjmDgBEl1cCBAoAAwAIAQjmDgBEl1cCBAoAAA==.',Hr='Hruu:AwACCAIABAoAAA==.',Im='Imortallemon:AwACCAIABRQCCwAIAQjEEgBWFsQCBAoACwAIAQjEEgBWFsQCBAoAAA==.Imugi:AwAFCAoABAoAAQQAESgDCAYABRQ=.',In='Inspectadeck:AwAGCA4ABAoAAA==.',Ja='Jacknjill:AwAECAcABAoAAA==.Jackpriest:AwAHCAkABAoAAA==.',Ji='Jibberwish:AwAECAsABAoAAA==.',Ju='Juuju:AwACCAIABAoAAA==.',Ka='Kadashy:AwACCAIABAoAAA==.Kaelethas:AwABCAEABAoAAA==.Kamikasi:AwABCAEABAoAAA==.',Ke='Kechh:AwAECAUABAoAAA==.Kegaz:AwADCAYABRQCCQADAQjoBAArhd0ABRQACQADAQjoBAArhd0ABRQAAA==.',Ko='Korell:AwACCAIABAoAAA==.',Kr='Krankiekunt:AwAFCAYABAoAAA==.Krellhim:AwAFCAUABAoAAA==.',Ks='Ksiyu:AwAECAQABAoAAA==.',Ku='Kurirn:AwADCAUABAoAAA==.Kushkitten:AwAFCAkABAoAAA==.',La='Landwalker:AwAFCAEABAoAAA==.Langasenh:AwAICBAABAoAAA==.',Le='Lettucelordh:AwAGCBAABAoAAA==.',Lo='Loretta:AwABCAEABAoAAA==.',Ly='Lyianara:AwAGCAYABAoAAA==.',Ma='Magharitta:AwAFCAsABAoAAA==.',Mi='Misto:AwADCAYABRQCAwADAQhQBQA7NwEBBRQAAwADAQhQBQA7NwEBBRQAAA==.',Mo='Monkydluffy:AwACCAIABAoAAA==.Monotití:AwAGCA4ABAoAAA==.Moomoos:AwAGCBIABAoAAA==.Movski:AwACCAIABAoAAA==.',Mu='Murican:AwAFCA0ABAoAAA==.',My='Myssfyre:AwABCAEABRQAAA==.Mysticalzz:AwACCAIABAoAAA==.',Na='Nargothrond:AwAECAQABAoAAA==.Narkruul:AwABCAEABAoAAA==.Narîsa:AwEDCAUABAoAAA==.Nassar:AwACCAUABAoAAA==.Naw:AwAGCAMABAoAAA==.',Ni='Nintone:AwAECAcABAoAAA==.Niyàti:AwADCAQABAoAAA==.',No='Noep:AwADCAEABAoAAA==.',Nu='Nubishe:AwAECAEABAoAAA==.',Oh='Ohhkunt:AwAICA0ABAoAAA==.',Pa='Palala:AwAECAEABAoAAA==.Palthe:AwADCAQABAoAAA==.Pandalini:AwACCAIABAoAAA==.Pandaren:AwAICAgABAoAAQcAAAACCAIABRQ=.Papíaíyúyü:AwACCAEABAoAAA==.',Pg='Pgundry:AwAECAQABAoAAA==.',Pi='Pieass:AwAFCAYABAoAAA==.Pinkyblue:AwACCAIABRQDDAAIAQgQBgBBqSACBAoADAAHAQgQBgA8mSACBAoADQAHAQh3GwA/vQ0CBAoAAA==.',Ps='Psyched:AwAFCAUABAoAAA==.',Pt='Ptreei:AwAHCA4ABAoAAA==.',Pu='Pudgeys:AwACCAIABRQCDgAIAQhPCQBKerMCBAoADgAIAQhPCQBKerMCBAoAAA==.',Py='Pyneapples:AwADCAMABAoAAA==.',Qu='Quarîzma:AwABCAEABRQCBgAGAQgNGwBXWhICBAoABgAGAQgNGwBXWhICBAoAAA==.',Ra='Rano:AwAGCBIABAoAAA==.Rawrnik:AwADCAEABAoAAA==.Rax:AwAFCAwABAoAAA==.',Re='Reflex:AwAHCBkABAoCCwAHAQiVHABM9nICBAoACwAHAQiVHABM9nICBAoAAA==.Revii:AwAHCAEABAoAAQcAAAAICBAABAo=.',Rh='Rhaella:AwAECAoABAoAAA==.Rhvbarb:AwADCAUABAoAAA==.',Ri='Rilirian:AwAICAgABAoAAA==.Rinmage:AwAECAMABAoAAA==.Riseth:AwAFCAMABAoAAA==.Rivèr:AwAGCAwABAoAAA==.',Ro='Robert:AwAICBAABAoAAA==.Roni:AwAGCAYABAoAAA==.Roussalie:AwABCAEABAoAAA==.',Ru='Rutee:AwABCAEABAoAAA==.Ruxe:AwEDCAMABAoAAA==.',Sa='Safh:AwABCAEABAoAAA==.Safx:AwAGCAEABAoAAA==.Sanosan:AwAFCA0ABAoAAA==.',Sc='Scabbo:AwAECAsABAoAAA==.Scalesoul:AwACCAIABAoAAA==.',Sd='Sdsgoose:AwAGCAIABAoAAA==.',Se='Seeaew:AwAFCAwABAoAAA==.Seiveril:AwADCAgABRQCAgADAQj4BQBJBxkBBRQAAgADAQj4BQBJBxkBBRQAAA==.',Sh='Shaddai:AwABCAEABRQAAA==.Shakydog:AwACCAIABAoAAA==.Shamankiller:AwABCAEABRQAAA==.Shamiracle:AwABCAEABRQAAA==.Shaolie:AwACCAEABAoAAA==.Sharftay:AwAFCAUABAoAAQsAHMoDCAsABRQ=.',Si='Sickomode:AwAHCAIABAoAAA==.Sinadri:AwAECAMABAoAAA==.Sinfulpally:AwAGCBQABAoDDwAGAQisCgBQJAACBAoADwAGAQisCgBQJAACBAoACAADAQidwQAoaI4ABAoAAA==.Sippycup:AwAHCA4ABAoAAA==.',Sm='Smashhard:AwACCAIABRQAAA==.Smokeyz:AwAICBYABAoDEAAIAQhSBQBYa/YCBAoAEAAHAQhSBQBfR/YCBAoAEQAIAQj3FQA/xWoCBAoAAA==.',Sn='Snorlax:AwAGCBQABAoCCQAGAQh0DQBf3XICBAoACQAGAQh0DQBf3XICBAoAAA==.',So='Sorbies:AwAFCA0ABAoAAA==.Sourgumybear:AwAHCBQABAoCCwAHAQhCIABH91UCBAoACwAHAQhCIABH91UCBAoAAA==.',Sp='Spectori:AwADCAMABAoAAA==.',St='Sthetic:AwAGCBYABAoEDQAGAQiMQABUJBUBBAoADQADAQiMQABbBxUBBAoADAACAQjIJABZ7b0ABAoAEgACAQg7GgBAI5sABAoAAA==.Stormwrath:AwAICAEABAoAAA==.Stoutbrew:AwAICAIABAoAAA==.Stãria:AwADCAQABAoAAA==.Stårlå:AwAFCAMABAoAAA==.',Su='Sudun:AwAGCA0ABAoAAA==.Sugarburst:AwAECAcABAoAAA==.Sumcat:AwAHCAIABAoAAA==.',Sw='Swinginwilly:AwAGCAYABAoAAA==.',Sy='Sylvanâs:AwAGCBEABAoAAA==.',Ta='Taffy:AwAECAoABAoAAA==.Tanags:AwADCAMABAoAAA==.',Th='Thalia:AwAHCBAABAoAAA==.Theretdream:AwAHCBEABAoAAA==.Thesean:AwABCAEABAoAAA==.Theshowerman:AwACCAUABRQCCQACAQjRBQBWLcMABRQACQACAQjRBQBWLcMABRQAAA==.Thors:AwAHCAsABAoAAA==.Thunderzz:AwAFCAUABAoAAA==.Thurmia:AwAGCBEABAoAAA==.',Ti='Tienchi:AwAGCA8ABAoAAA==.',Tl='Tlo:AwAFCBAABAoAAA==.',To='Tolva:AwADCAYABRQDEwADAQioAwA4Ja0ABRQAEwACAQioAwBHIa0ABRQAFAACAQhkCgAsnqkABRQAAA==.Tonalddrump:AwAICA8ABAoCAgAIAQi/YgAPnZoABAoAAgAIAQi/YgAPnZoABAoAAA==.Tourach:AwABCAIABRQDCAAHAQiIGwBQ7ZkCBAoACAAHAQiIGwBQ7ZkCBAoADwABAQg7QwAIphMABAoAAA==.',Tr='Trapz:AwACCAIABAoAAQcAAAADCAQABAo=.Traytas:AwAECAgABAoAAA==.Truwar:AwABCAEABRQAAA==.',Tw='Twiggz:AwACCAIABAoAAA==.',Ty='Tyth:AwAECAwABAoAAA==.',['T�']='Tânk:AwAECAQABAoAAA==.Tånk:AwAGCAUABAoAAA==.Tèmpèst:AwAICAMABAoAAA==.',Us='Useacooldown:AwAFCAYABAoAAA==.',Va='Valkyrion:AwAICAcABAoAAA==.',Ve='Velrayne:AwAHCBIABAoAAA==.Versta:AwAECAQABAoAAA==.',Vi='Violettmoon:AwABCAEABRQCFQAHAQhzBABIQngCBAoAFQAHAQhzBABIQngCBAoAAA==.',Vo='Voidberg:AwAHCBQABAoCCAAHAQh5PwA/q+sBBAoACAAHAQh5PwA/q+sBBAoAAA==.',Vz='Vzvie:AwAHCAQABAoAAA==.',Wa='Wavery:AwABCAEABAoAAA==.Wayvee:AwABCAMABAoAAA==.',Wo='Woolieslyfe:AwADCAcABAoAAQcAAAAGCBIABAo=.',['X�']='Xêv:AwAHCBAABAoDFgAHAQgNGwBK5PMBBAoAFgAGAQgNGwBMm/MBBAoAFwABAQizOwBAm0QABAoAAA==.',Za='Zatasia:AwAICAgABAoAARgASpoBCAIABRQ=.',Zi='Zinix:AwAFCAkABAoAAA==.',Zu='Zuziacheck:AwAFCA8ABAoAAA==.',['Ý']='Ýp:AwACCAQABAoAAA==.',['ß']='ßasket:AwABCAEABRQEDAAIAQjsBgBZ/AgCBAoADAAFAQjsBgBcfggCBAoAEgADAQifEgBPJ+oABAoADQACAQjaUgBT88IABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end