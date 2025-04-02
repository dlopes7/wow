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
 local lookup = {'Hunter-BeastMastery','DemonHunter-Vengeance','Unknown-Unknown','DemonHunter-Havoc','Priest-Shadow','Druid-Restoration','Paladin-Holy','DeathKnight-Frost','Warlock-Demonology','Warlock-Destruction','Mage-Fire','Priest-Holy','Priest-Discipline','Shaman-Enhancement','Shaman-Restoration',}; local provider = {region='US',realm="Eldre'Thalas",name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acquirous:AwABCAEABAoAAA==.',An='An:AwABCAEABRQAAQEAR+wDCAkABRQ=.Antari:AwAICBAABAoAAA==.',As='Asteryn:AwAFCAgABAoAAA==.',At='Atherion:AwAFCAQABAoAAA==.',Au='Auburn:AwACCAIABAoAAA==.Auragàsm:AwAECAMABAoAAA==.',Aw='Aw:AwAECAYABAoAAQEAR+wDCAkABRQ=.',Az='Azrastraza:AwABCAEABRQAAA==.',Ba='Babaisyaga:AwABCAIABRQCAQAIAQjKGQBE2YgCBAoAAQAIAQjKGQBE2YgCBAoAAA==.Baker:AwABCAEABAoAAA==.Balinse:AwAECAQABAoAAA==.Bananas:AwAECAcABAoAAA==.Barrelrollin:AwACCAIABAoAAA==.Batrito:AwAGCAIABAoAAA==.',Bh='Bhassie:AwABCAIABRQCAgAIAQi7CQBAMSUCBAoAAgAIAQi7CQBAMSUCBAoAAA==.',Bj='Bjorinn:AwAGCAEABAoAAA==.',Bl='Blizzcon:AwAFCAwABAoAAA==.',Br='Brandywynne:AwAFCAEABAoAAA==.Brightfame:AwAFCAMABAoAAA==.Bronny:AwADCAcABAoAAA==.',Bu='Buffshagwell:AwAICAIABAoAAA==.Butterbllz:AwABCAEABAoAAA==.',Ch='Charlotta:AwAICAgABAoAAA==.Cheeto:AwAECAQABAoAAQMAAAAECAcABAo=.',Ci='Cindera:AwABCAIABRQDBAAIAQgkCgBTl/YCBAoABAAIAQgkCgBTl/YCBAoAAgABAQi4OwA2ikIABAoAAA==.',Cl='Clayier:AwAHCBEABAoAAA==.',Cr='Cromie:AwADCAQABAoAAA==.',Ct='Cthulmoo:AwABCAIABRQCBQAIAQiQBgBTPOECBAoABQAIAQiQBgBTPOECBAoAAA==.',Da='Darkenmicky:AwADCAYABAoAAA==.Darthbobula:AwAICA4ABAoAAA==.Daswar:AwAGCAEABAoAAQMAAAAICBAABAo=.Davilator:AwAICAgABAoAAA==.',De='Demonshunter:AwAFCAEABAoAAA==.',Dh='Dhunter:AwABCAEABRQAAA==.',Di='Dinadan:AwADCAEABAoAAA==.',Ea='Earlgrey:AwADCAUABAoAAA==.Eatmoarjims:AwADCAgABAoAAA==.',Ei='Eigi:AwAGCAoABAoAAA==.',Ek='Ekthelion:AwADCAUABAoAAA==.',El='Eldanon:AwAFCA4ABAoAAA==.Elela:AwADCAEABAoAAA==.Ellra:AwADCAcABAoAAA==.Elwe:AwAECAQABAoAAA==.',Er='Erandria:AwABCAEABAoAAQYARM8BCAEABRQ=.',Es='Esme:AwAGCAEABAoAAA==.',Ex='Ex:AwADCAkABRQCAQADAQhbBwBH7BIBBRQAAQADAQhbBwBH7BIBBRQAAA==.',Fa='Fairious:AwAFCAQABAoAAA==.',Fe='Fet:AwAFCAUABAoAAA==.',Fi='Firelore:AwAICA0ABAoAAQMAAAAICBAABAo=.Fizzlebub:AwADCAMABAoAAA==.',Go='Gooberz:AwADCAUABAoAAA==.',Gu='Gurg:AwADCAYABAoAAA==.',Ha='Haikuyoshi:AwAFCBAABAoAAA==.',He='Hersana:AwAGCAkABAoAAA==.',Ho='Holyyballs:AwADCAcABAoAAA==.',['H�']='Hálfpint:AwADCAgABAoAAQMAAAAHCAcABAo=.',Ja='Jacii:AwAECAYABAoAAA==.',Ju='Junkyardboy:AwAGCAQABAoAAA==.',Ka='Kalcifur:AwABCAIABRQCBwAIAQgzCQA7+C8CBAoABwAIAQgzCQA7+C8CBAoAAA==.Kaliback:AwADCAIABAoAAA==.',Ke='Keldean:AwAFCAsABAoAAA==.Kerica:AwAICA0ABAoAAA==.Keryka:AwABCAIABRQCCAAIAQjdAABdtVQDBAoACAAIAQjdAABdtVQDBAoAAA==.',Kh='Khall:AwAECAgABAoAAA==.',Ko='Kohn:AwAFCAkABAoAAA==.',Lo='Lorern:AwAGCAUABAoAAA==.Lorigosa:AwAFCAcABAoAAQMAAAAHCA4ABAo=.Lorrien:AwAHCA4ABAoAAA==.',Lu='Luluz:AwABCAEABAoAAA==.',Ma='Manhole:AwAECAcABAoAAA==.Maureanna:AwABCAEABRQCBgAHAQjsDgBEzxICBAoABgAHAQjsDgBEzxICBAoAAA==.',Me='Mediti:AwAECAEABAoAAA==.Meriana:AwAECAQABAoAAA==.',Mo='Morlyn:AwAECAQABAoAAA==.Mousemist:AwAECAEABAoAAA==.',Mu='Muzak:AwAECAEABAoAAA==.',Na='Namesgambit:AwAICAkABAoAAA==.',Ne='Near:AwACCAQABAoAAA==.Nervous:AwAICBAABAoAAA==.Nessà:AwABCAEABAoAAA==.',['N�']='Nèzukõ:AwAICAQABAoAAA==.',Oj='Ojoverde:AwABCAEABRQDCQAIAQjnAwA9wmcCBAoACQAIAQjnAwA9wmcCBAoACgABAQiOiAAFSRsABAoAAA==.',Or='Ordenn:AwABCAEABAoAAQMAAAAFCAUABAo=.',Pi='Pigas:AwADCAQABAoAAA==.',Ra='Ramdel:AwAECAkABAoAAA==.Rayziel:AwAHCBUABAoCBwAHAQioBQBT/YUCBAoABwAHAQioBQBT/YUCBAoAAA==.',Re='Replink:AwABCAIABRQCCwAIAQgoEQBMH5wCBAoACwAIAQgoEQBMH5wCBAoAAA==.',Rh='Rheagnar:AwAECAQABAoAAA==.Rhyme:AwACCAMABAoAAA==.',Ro='Robobob:AwAECAIABAoAAA==.Rowynna:AwAGCAUABAoAAA==.',Se='Serandipity:AwABCAIABRQDDAAIAQidDgBIJzcCBAoADAAIAQidDgA/YDcCBAoADQAHAQhbDQA/rScCBAoAAA==.',Sh='Shallator:AwAECAEABAoAAA==.Shammygoat:AwAECAcABAoAAA==.Shaqattaq:AwABCAEABRQAAA==.Sharkmeat:AwAECAMABAoAAA==.Shortbarrel:AwACCAIABAoAAA==.',Si='Sigrunn:AwAGCAkABAoAAA==.',Sp='Sprocketbelt:AwAICBAABAoAAA==.',Sq='Squashfoot:AwACCAIABAoAAA==.',St='Stabyou:AwACCAIABAoAAA==.Stefane:AwAECAEABAoAAA==.Stellaria:AwAECAkABAoAAA==.Steverogers:AwAFCAYABAoAAQMAAAAICAkABAo=.',Su='Supergenius:AwABCAEABAoAAA==.',Sw='Swami:AwACCAIABAoAAA==.',Th='Thaqknight:AwAFCBAABAoAAA==.Theia:AwAICAsABAoAAA==.Thiccklock:AwADCAEABAoAAA==.Thomp:AwADCAUABAoAAA==.',Tu='Turim:AwABCAEABRQCAQAIAQgmMQAtnuQBBAoAAQAIAQgmMQAtnuQBBAoAAA==.',Ty='Tykahndrius:AwAECAQABAoAAA==.Tyrran:AwAECAEABAoAAA==.',['T�']='Týlïus:AwAHCBEABAoAAA==.',Vi='Victorr:AwAFCAwABAoAAA==.',Vy='Vyrubur:AwAGCAEABAoAAQQAU5cBCAIABRQ=.',['V�']='Válidüs:AwAICBQABAoCDAAIAQg1IAAa3osBBAoADAAIAQg1IAAa3osBBAoAAA==.',Wa='Wanhedaa:AwADCAQABAoAAA==.',Zl='Zluco:AwABCAQABRQDDgAIAQjeBABTXAYDBAoADgAIAQjeBABTXAYDBAoADwABAQjwdgASeTgABAoAAA==.Zluuc:AwABCAIABAoAAQ4AU1wBCAQABRQ=.',Zu='Zulfe:AwAICBAABAoAAA==.',Zy='Zym:AwADCA8ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end