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
 local lookup = {'Shaman-Elemental','Shaman-Restoration','Unknown-Unknown','Hunter-BeastMastery','Warrior-Fury','Warrior-Arms','Paladin-Holy','Paladin-Retribution','Priest-Holy','Evoker-Devastation','Evoker-Preservation','Druid-Feral','Druid-Balance','DeathKnight-Frost','Mage-Arcane','Mage-Fire','Rogue-Assassination','Mage-Frost','Druid-Restoration','Priest-Discipline','Priest-Shadow','Monk-Windwalker','DemonHunter-Havoc','DeathKnight-Unholy','Shaman-Enhancement','Druid-Guardian','Warlock-Destruction','Warlock-Affliction','Monk-Brewmaster',}; local provider = {region='US',realm='Korgath',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abbygrace:AwAFCAQABAoAAA==.',Af='Afterearth:AwADCAMABRQCAQAIAQgGAwBbsCMDBAoAAQAIAQgGAwBbsCMDBAoAAA==.',Ai='Ailie:AwAHCBEABAoAAA==.',Ak='Akelaii:AwACCAMABAoAAA==.',Al='Allanhouston:AwABCAEABRQAAA==.Allansc:AwAFCAEABAoAAA==.Alverez:AwACCAMABRQCAgAIAQjEBABYm/gCBAoAAgAIAQjEBABYm/gCBAoAAA==.',An='Anahera:AwAICAUABAoAAQMAAAAICAsABAo=.Angako:AwAHCBAABAoAAA==.Anith:AwAHCBEABAoAAA==.',Ar='Arinn:AwADCAQABRQCBAAIAQjEBgBWkjIDBAoABAAIAQjEBgBWkjIDBAoAAA==.Arispewpew:AwAECAcABAoAAQMAAAAECA0ABAo=.',Av='Avaleir:AwADCAQABAoAAA==.',Ax='Axul:AwAHCBUABAoDBQAHAQi1GQA5AgcCBAoABQAHAQi1GQA5AgcCBAoABgABAQi/QQAWOi8ABAoAAA==.Axx:AwAGCAEABAoAAA==.',Az='Azerite:AwABCAIABRQAAA==.Azerwann:AwADCAMABAoAAA==.',Ba='Baandayd:AwAFCAEABAoAAA==.Babies:AwAECAcABAoAAA==.Bailora:AwACCAcABAoAAA==.Bandaayd:AwABCAEABRQDBwAIAQhuDAArtOYBBAoABwAIAQhuDAArtOYBBAoACAAGAQgEVgAzGIkBBAoAAA==.',Bb='Bbldrizzyy:AwAFCAIABAoAAA==.',Be='Bellgara:AwAGCAUABAoAAA==.Benni:AwAHCAMABAoAAA==.',Bi='Biekdafreak:AwAFCAoABAoAAA==.Bigbuds:AwADCAMABAoAAA==.Biggiphd:AwABCAIABRQAAA==.Bigpawz:AwAHCBAABAoAAA==.Bingberries:AwABCAEABRQAAA==.Biters:AwAFCAgABAoAAA==.',Bl='Blacksray:AwAICBAABAoAAA==.Blaire:AwAGCA4ABAoAAA==.Blakes:AwAECAoABAoAAA==.Blessedd:AwAGCBYABAoCCQAGAQipKwAieywBBAoACQAGAQipKwAieywBBAoAAA==.Blubberz:AwAHCAoABAoAAA==.Bludlung:AwABCAIABRQDCgAHAQjYBwBWE6ECBAoACgAHAQjYBwBWE6ECBAoACwABAQiqHQAiVTAABAoAAA==.Bludthurst:AwAHCBIABAoAAA==.Blueteam:AwADCAUABAoAAA==.',Bo='Bohica:AwADCAYABAoAAA==.Bolsak:AwAGCAEABAoAAA==.Boochlord:AwAGCAQABAoAAA==.Bootyslaps:AwAICAgABAoAAA==.Botany:AwACCAIABRQDDAAIAQiJAgBTDNkCBAoADAAIAQiJAgBMPdkCBAoADQABAQgYXABcAWcABAoAAA==.Bowpeep:AwADCAMABAoAAA==.',Br='Brezel:AwADCAMABAoAAA==.Bruniik:AwAGCAEABAoAAA==.',Bu='Buddyolpal:AwABCAIABRQAAA==.Buffvdh:AwAHCAsABAoAAA==.Bussyyogurt:AwADCAYABAoAAA==.',Ca='Camula:AwAHCBAABAoAAA==.Carpedonktum:AwADCAMABAoAAA==.Casden:AwABCAIABAoAAA==.',Ch='Cheddar:AwADCAMABAoAAA==.Chellé:AwAECAEABAoAAA==.Chipm:AwADCAUABAoAAQMAAAAHCAsABAo=.Chithelia:AwAFCAQABAoAAA==.Chodeluv:AwAICAgABAoAAA==.',Cl='Clapcheeks:AwAECAQABAoAAA==.Cleve:AwAHCBUABAoCDgAHAQg3AwBX6a8CBAoADgAHAQg3AwBX6a8CBAoAAA==.Cloacussy:AwAFCAUABAoAAA==.',Co='Convergent:AwABCAEABAoAAA==.Coosh:AwADCAUABRQDDwADAQimAAA6kVkABRQAEAACAQj2DQBEWKQABRQADwABAQimAAAnA1kABRQAAA==.Cornydog:AwADCAMABAoAAA==.Courigon:AwAFCAUABAoAAA==.',Cr='Crippler:AwAECAQABAoAAA==.Crits:AwAGCAwABAoAAA==.Crozooka:AwAGCAsABAoAAA==.Cròssblesser:AwAGCAgABAoAAA==.',Cu='Cummins:AwAGCBEABAoAAA==.',Da='Daddyysrod:AwAHCAEABAoAAA==.Dagro:AwAFCAgABAoAAA==.Daiyu:AwACCAIABAoAAA==.Dangerz:AwAICAgABAoAAA==.Darkmaester:AwAHCBUABAoCBgAHAQjLCQBHj08CBAoABgAHAQjLCQBHj08CBAoAAA==.',De='Deathbyarow:AwAFCAUABAoAAA==.Deathhammer:AwADCAMABAoAAA==.Demontimee:AwACCAIABAoAAA==.Devantae:AwAECAQABAoAAA==.',Dh='Dhuru:AwAGCA4ABAoAAQMAAAAHCAcABAo=.',Di='Dinkydoofee:AwAGCAwABAoAAA==.Dirtystaff:AwAFCAkABAoAAA==.Dirtyswords:AwAECAcABAoAAA==.',Dr='Dractharin:AwADCAQABAoAAQQAVpIDCAQABRQ=.Dragonoied:AwADCAIABAoAAA==.Drlawyerphd:AwAHCBAABAoAAA==.',Ds='Dsixxfour:AwADCAoABAoAAA==.',Dw='Dwarfimar:AwEBCAEABAoAAQMAAAAHCBAABAo=.Dweedle:AwABCAEABAoAAA==.',Ek='Ekkzdee:AwAHCBUABAoCEQAHAQiuAwBZTdkCBAoAEQAHAQiuAwBZTdkCBAoAAA==.',En='Enazenoth:AwACCAQABRQCCgAIAQg2CgBGvGwCBAoACgAIAQg2CgBGvGwCBAoAAA==.',Er='Errthang:AwAHCAkABAoAAA==.',Es='Esharå:AwAHCAoABAoAAA==.',Et='Ethre:AwAFCAkABAoAAA==.',Ey='Eyri:AwAECAsABAoAAA==.',Ez='Ezzie:AwADCAMABAoAAA==.',Fa='Fatdabs:AwAFCAIABAoAAA==.',Fe='Femme:AwADCAMABAoAAA==.Feonix:AwAHCBUABAoEDwAHAQh5AABdggIDBAoADwAHAQh5AABdggIDBAoAEAAEAQiVQgAuT/4ABAoAEgACAQiCVgA26X4ABAoAAA==.Fewsha:AwABCAEABRQCAQAHAQh+CgBTYYMCBAoAAQAHAQh+CgBTYYMCBAoAAA==.',Fl='Flaxy:AwAICAgABAoAAA==.',Fr='Fridgefister:AwAFCAEABAoAAA==.',Fu='Fugzy:AwAGCAMABAoAAA==.',Ga='Gahbage:AwAECAkABAoAAA==.Galedori:AwADCAMABAoAAA==.Gassman:AwAECAUABAoAAA==.',Gh='Ghostdance:AwABCAEABAoAARMAXBsDCAQABRQ=.',Gi='Giggz:AwAHCBAABAoAAA==.',Gl='Glaven:AwAFCAsABAoAAA==.Glowing:AwAFCAUABAoAAA==.',Gr='Grimwheezér:AwABCAEABAoAAA==.Grogimus:AwAGCAsABAoAAA==.Gruhan:AwAFCAoABAoAAA==.',Gu='Gunnss:AwAFCBAABAoAAA==.',Ha='Haagendots:AwADCAMABAoAAA==.Hadahaa:AwAGCAkABAoAAA==.Hagshifter:AwAGCBEABAoAAA==.Halesowen:AwACCAIABAoAAA==.Haleynicole:AwADCAMABAoAAA==.Hasted:AwABCAEABRQAAA==.',He='Hennessy:AwAFCAQABAoAAA==.',Ho='Holdmybear:AwAICBAABAoAAA==.Holybunger:AwAFCAEABAoAAA==.Holyscheisse:AwAICAsABAoAAA==.Hose:AwAICAUABAoAAA==.',Hu='Hueycheeks:AwAFCA4ABAoAAA==.Hugeguy:AwACCAMABAoAAA==.Huxium:AwAECAkABAoAAA==.',Hy='Hymnpossible:AwAFCAUABAoAAA==.',In='Invv:AwAHCBUABAoDBwAHAQgfEwAlO3MBBAoABwAHAQgfEwAlO3MBBAoACAABAQhaAAEO4ycABAoAAA==.',Ja='Jabbyjr:AwABCAEABRQAAA==.Jagersblazin:AwAICBEABAoAAA==.Jangens:AwABCAEABRQDFAAIAQgQAgBZNi0DBAoAFAAIAQgQAgBZNi0DBAoAFQABAQgCSgAE/ywABAoAAA==.Jaynine:AwAFCBAABAoAAA==.',Ji='Jirm:AwAICBYABAoCBQAIAQjfDwA8XnECBAoABQAIAQjfDwA8XnECBAoAAA==.',Jo='Jorian:AwACCAMABAoAAA==.',Ju='Jumblo:AwADCAMABAoAAA==.Jupileo:AwAFCA0ABAoAAA==.Justaburden:AwADCAMABAoAAA==.Justinious:AwACCAcABAoAAA==.',Ka='Kaantu:AwACCAMABRQDAgAIAQi+AwBbzQ4DBAoAAgAIAQi+AwBbzQ4DBAoAAQABAQiHTAAzBTYABAoAAA==.Kailee:AwABCAMABRQCFgAIAQhtBABWLAgDBAoAFgAIAQhtBABWLAgDBAoAAA==.Kassanence:AwABCAEABRQAARUANsIFCAsABRQ=.',Ko='Koncretekess:AwAICAgABAoAAA==.Koreanpistol:AwAGCAYABAoAAA==.Kosumi:AwAHCBIABAoAAA==.',Kr='Krysys:AwACCAIABAoAAA==.',['K�']='Káloogi:AwADCAgABAoAAA==.',La='Laquince:AwAFCAIABAoAAA==.Laundryday:AwAHCAcABAoAAA==.',Li='Litzdh:AwADCAMABAoAAA==.',Lo='Lockuru:AwAHCAcABAoAAA==.Lolvarianced:AwAFCA4ABAoAAA==.Lolxbullshxt:AwABCAEABAoAAA==.',Lu='Lunå:AwAGCAoABAoAAA==.Lutra:AwAHCBEABAoAAA==.',Ly='Lynei:AwADCAMABAoAAA==.Lyx:AwAECAYABAoAAA==.',Ma='Madpayne:AwADCAYABAoAAA==.Malzeynas:AwAECAEABAoAAA==.Mamif:AwADCAMABAoAAA==.Mapl:AwAGCA4ABAoAAA==.Markatron:AwAGCAYABAoAAA==.Maxsi:AwACCAIABAoAAA==.',Mc='Mcpaladin:AwAGCAwABAoAAA==.',Me='Meleys:AwAGCAkABAoAAA==.Memoryleak:AwAECAQABAoAAA==.Merza:AwACCAQABAoAARcAOMsBCAEABRQ=.Merzinator:AwABCAEABRQCFwAIAQiXGAA4y1ECBAoAFwAIAQiXGAA4y1ECBAoAAA==.',Mi='Midev:AwAGCBEABAoAAA==.Milkan:AwABCAIABAoAAA==.Minitonka:AwAICBAABAoAAA==.Missyeetus:AwAFCAwABAoAAA==.',Mo='Moodoon:AwADCAMABAoAAA==.Moraxy:AwADCAQABAoAAA==.',Mu='Murdok:AwAFCAoABAoAAA==.',My='Mystíle:AwABCAEABRQCGAAIAQjqAgBeND0DBAoAGAAIAQjqAgBeND0DBAoAAA==.',Na='Nachtmerrie:AwAECAEABAoAAA==.Naraim:AwAECAcABAoAAA==.Nazem:AwADCAQABAoAAA==.',Ne='Nevadawolff:AwACCAIABAoAAA==.',Ni='Nikkari:AwADCAYABAoAAA==.Nix:AwAFCAEABAoAAA==.',No='Noobak:AwADCAMABAoAAA==.Northwing:AwAHCBEABAoAAA==.',Ny='Nyreeh:AwAFCAkABAoAAA==.Nytearcher:AwACCAQABAoAAA==.',Os='Oschun:AwAGCBUABAoCCAAGAQg7agAnD0kBBAoACAAGAQg7agAnD0kBBAoAAA==.Oshaviolator:AwAECAgABAoAAA==.',Ot='Otomeae:AwAFCAMABAoAAA==.',Pa='Palanar:AwAHCBQABAoCGAAGAQjUDABduYUCBAoAGAAGAQjUDABduYUCBAoAAA==.Pallyboi:AwACCAIABAoAAA==.Pandemonium:AwEHCBAABAoAAA==.',Pe='Pelayo:AwADCAMABAoAAA==.Pentricia:AwAGCAsABAoAAA==.',Ph='Phacku:AwAFCAUABAoAAQMAAAAGCAMABAo=.Phaq:AwACCAIABAoAAQMAAAADCAYABAo=.Phixler:AwACCAIABAoAAA==.Phury:AwABCAEABAoAAA==.',Po='Pokepokepoke:AwADCAMABAoAAA==.',Pr='Prahs:AwAECAQABAoAAA==.Prankenhieb:AwAGCAoABAoAAA==.Protsmoke:AwAGCA0ABAoAAA==.',['P�']='Pèppèrmagè:AwACCAIABAoAAA==.Pöppop:AwADCAMABAoAAA==.',Qq='Qq:AwADCAMABAoAAA==.Qqxxddfd:AwEFCAUABAoAAA==.',Ra='Radiation:AwAFCAEABAoAAA==.Raefe:AwAECAQABAoAAA==.Raffaj:AwADCAMABAoAAA==.Rakild:AwAGCA8ABAoAAA==.Rancora:AwAHCBIABAoAAA==.Rarebreed:AwAHCBIABAoAAA==.Raugfaron:AwADCAMABAoAAA==.Rawbacon:AwAHCAIABAoAAA==.Raxxor:AwAFCAQABAoAAA==.',Re='Read:AwAFCAEABAoAAA==.Relafen:AwADCAMABAoAAA==.Reptilia:AwAGCA4ABAoAAA==.Reveri:AwAICA8ABAoAAA==.',Ri='Richa:AwAECAYABAoAAA==.Riikarii:AwAFCAkABAoAAA==.Rinzpriest:AwADCAMABAoAAA==.',Ro='Robific:AwAICAMABAoAAA==.Rosaire:AwAFCAUABAoAAA==.',Ru='Runestro:AwADCAEABAoAAA==.Rustibox:AwAFCAUABAoAAA==.',Sa='Sammichomg:AwAHCBAABAoAAA==.Sammyfuego:AwADCAMABAoAAA==.',Sc='Scoopdizzle:AwABCAEABAoAAA==.',Se='Searing:AwADCAkABRQCCAADAQguBwAwavQABRQACAADAQguBwAwavQABRQAAA==.Segfaults:AwABCAEABRQCGQAHAQj5EwA5wPkBBAoAGQAHAQj5EwA5wPkBBAoAAA==.Serpent:AwACCAIABAoAAA==.',Sh='Shaadas:AwAHCBMABAoAAA==.Shadeau:AwAECAQABAoAAA==.Shadokitty:AwAHCA8ABAoAAA==.Shockcollar:AwACCAQABAoAAA==.',Si='Sidewinder:AwADCAYABAoAAA==.Silia:AwAGCAEABAoAAA==.Sindayn:AwACCAIABAoAAA==.',Sk='Skidoler:AwAFCA0ABAoAAA==.Skidolior:AwAECAUABAoAAQMAAAAFCA0ABAo=.Skrtskrt:AwAGCA4ABAoAAA==.Skyvestris:AwAFCAkABAoAAA==.',Sm='Smellmygas:AwAECAYABAoAAA==.',Sn='Sneaky:AwAFCAwABAoAAA==.Sneakyr:AwAHCBUABAoCGgAHAQjRAABfXgADBAoAGgAHAQjRAABfXgADBAoAAA==.Snoodle:AwAHCA4ABAoAAA==.Snova:AwADCAMABAoAAA==.',So='Sole:AwAFCAUABAoAAA==.Solod:AwABCAEABRQDGwAIAQioDQBQ6IkCBAoAGwAIAQioDQBQUYkCBAoAHAAEAQh6DwBL0QsBBAoAAA==.Somavanna:AwADCAMABAoAAA==.Sorbet:AwAHCBUABAoCEgAHAQjjBwBYaLgCBAoAEgAHAQjjBwBYaLgCBAoAAA==.',Sp='Spicyboltz:AwADCAUABAoAAA==.Splõõsh:AwAECAUABAoAAA==.Sprodumpy:AwABCAEABAoAAQMAAAACCAIABAo=.Spyrogos:AwAECAEABAoAAA==.',St='Stabzerite:AwAFCA4ABAoAAA==.Starkatt:AwACCAMABAoAAA==.Stasis:AwAHCBAABAoAAA==.Stel:AwADCAEABAoAAA==.',Sy='Sythila:AwACCAUABRQCFwACAQihCQBK6rMABRQAFwACAQihCQBK6rMABRQAAA==.',['S�']='Söl:AwAGCAoABAoAAA==.',Ta='Takeitoff:AwABCAEABAoAAA==.Talleth:AwAECA0ABAoAAA==.Tassyn:AwAHCBMABAoAAA==.Tazlor:AwADCAMABAoAAA==.',Te='Teknar:AwAFCAsABAoAAA==.',Th='Thoian:AwAHCAsABAoAAA==.',Ti='Tiblock:AwAECAgABAoAAA==.Timore:AwABCAEABAoAAA==.Tizpally:AwABCAEABAoAAA==.',To='Tortilla:AwAGCAkABAoAAA==.',Tu='Tumtums:AwACCAIABAoAAR0ASdIBCAMABRQ=.Turlane:AwAICAIABAoAAA==.',Tz='Tz:AwACCAIABAoAAA==.',['T�']='Tørvald:AwABCAEABRQAAA==.Týco:AwAHCBMABAoAAA==.',Us='Uslurper:AwAICBUABAoCCAAIAQglLQBHqC4CBAoACAAIAQglLQBHqC4CBAoAAA==.',Va='Valaen:AwACCAIABAoAAA==.Valentina:AwAGCAYABAoAARYAViwBCAMABRQ=.Varenar:AwAHCBEABAoAAA==.',Ve='Veralith:AwAECAgABAoAAA==.',Vi='Vipergrip:AwAGCAYABAoAAA==.Virlomi:AwABCAEABRQCEwAIAQjQAgBaxw0DBAoAEwAIAQjQAgBaxw0DBAoAAA==.Vivec:AwADCAQABAoAAA==.',Vo='Vorthax:AwABCAEABAoAAA==.',Vy='Vynx:AwADCAYABAoAAA==.Vytharia:AwAHCA4ABAoAAA==.',['V�']='Válar:AwABCAEABAoAAA==.',Wa='Walakapino:AwACCAIABAoAAA==.Wartooth:AwACCAIABAoAAA==.',We='Welari:AwADCAQABAoAAA==.',Wh='Whurstresort:AwAECAQABAoAAA==.',Xy='Xyzpdq:AwADCAQABAoAAA==.',Yy='Yyna:AwAECAIABAoAAA==.',Za='Zallamun:AwADCAQABAoAAA==.',Ze='Zeelos:AwACCAYABRQCBAACAQh3EgArl4kABRQABAACAQh3EgArl4kABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end