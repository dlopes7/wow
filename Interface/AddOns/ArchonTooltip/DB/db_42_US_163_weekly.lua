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
 local lookup = {'Rogue-Assassination','Rogue-Subtlety','Hunter-BeastMastery','Hunter-Marksmanship','Paladin-Protection','Unknown-Unknown','Paladin-Retribution','Mage-Frost','Rogue-Outlaw','Warrior-Fury','Warrior-Arms','DemonHunter-Havoc','Evoker-Devastation','Warlock-Destruction','Warlock-Demonology','DeathKnight-Unholy','Mage-Arcane','Druid-Guardian','Priest-Discipline','Priest-Holy','Mage-Fire','Druid-Restoration','Warrior-Protection','Shaman-Restoration',}; local provider = {region='US',realm='Nathrezim',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adorabull:AwACCAIABAoAAA==.',An='Anastasía:AwAGCA0ABAoAAA==.Anzul:AwADCAUABAoAAA==.',Az='Azeras:AwAGCBAABAoAAA==.Azerith:AwADCAMABAoAAA==.',Ba='Bamboo:AwADCAMABAoAAA==.',Be='Benzmonk:AwAHCBEABAoAAA==.',Bi='Bianka:AwAHCA0ABAoAAA==.',Bl='Blackheart:AwAHCBIABAoAAA==.',Bu='Bussiah:AwAHCBUABAoDAQAHAQg8BwBRTW0CBAoAAQAHAQg8BwBRTW0CBAoAAgAEAQj4HwAtZOMABAoAAA==.',Ca='Cadbury:AwACCAIABAoAAA==.Catalya:AwABCAEABAoAAA==.',Ch='Chaw:AwACCAQABRQDAwAIAQggDgBSBe4CBAoAAwAIAQggDgBQie4CBAoABAAGAQjOFwBO6nkBBAoAAA==.Chenkenichi:AwABCAEABAoAAA==.',Ci='Cinnabons:AwACCAIABAoAAA==.',Co='Cooldukenuke:AwABCAEABRQAAA==.',Cs='Csorba:AwAFCA0ABAoAAA==.',Cu='Cursedlight:AwACCAUABRQCBQACAQh4BAA9GJgABRQABQACAQh4BAA9GJgABRQAAA==.',Di='Dismonk:AwACCAMABAoAAA==.',Dr='Dracz:AwACCAIABAoAAQYAAAAGCAkABAo=.Dronzer:AwAFCAYABAoAAA==.',Eg='Egohakai:AwACCAMABRQCBwAIAQh0DABWcg0DBAoABwAIAQh0DABWcg0DBAoAAA==.',Er='Erret:AwACCAQABRQCCAAIAQg7BgBRLuECBAoACAAIAQg7BgBRLuECBAoAAA==.Erretic:AwAFCAwABAoAAQgAUS4CCAQABRQ=.',Et='Eth:AwAGCBAABAoAAA==.Ethaka:AwAGCAkABAoAAA==.',Ev='Everlast:AwABCAEABAoAAA==.',Fa='Fazeup:AwAICAwABAoAAA==.',Fi='Finnin:AwAGCA4ABAoAAA==.',Fr='Freidafondle:AwAECAoABAoAAA==.',Fu='Furba:AwABCAEABAoAAA==.Furybolt:AwABCAEABAoAAA==.',Gl='Glossy:AwACCAUABRQDCQACAQixAABYR9IABRQACQACAQixAABYR9IABRQAAgABAQj6CQBPT00ABRQAAA==.',Ha='Harmonize:AwAGCAYABAoAAA==.Hathbubble:AwACCAIABAoAAQoAYUQBCAMABRQ=.Hathina:AwABCAMABRQDCgAIAQh0AABhRIMDBAoACgAIAQh0AABhRIMDBAoACwABAQgQQwAuWTEABAoAAA==.',Hi='Hiveglaives:AwABCAEABRQCDAAIAQjjKwAegsEBBAoADAAIAQjjKwAegsEBBAoAAA==.',Ho='Hobble:AwACCAIABAoAAA==.Holiy:AwAECAoABAoAAA==.Holts:AwACCAMABAoAAA==.',In='Indomitabull:AwACCAMABRQCDQAIAQgpAwBWgBUDBAoADQAIAQgpAwBWgBUDBAoAAA==.',Ja='Jagerin:AwAGCBAABAoAAA==.',Je='Jesse:AwAICAgABAoAAA==.',Ju='Jubag:AwAHCBAABAoAAA==.Jubbs:AwADCAQABAoAAA==.',Ka='Kao:AwAFCAYABAoAAA==.Katarina:AwAECAsABAoAAA==.',Ke='Kergshot:AwAGCA0ABAoAAA==.',Ko='Komojo:AwABCAEABAoAAA==.',Kr='Kreamed:AwACCAMABAoAAA==.Krystagosa:AwAGCAMABAoAAA==.',['K�']='Kìngpanda:AwABCAEABAoAAA==.',La='Lang:AwAGCA0ABAoAAA==.',Lo='Loopey:AwAGCAQABAoAAA==.',Ma='Magwar:AwACCAQABRQCCgAIAQiVDQBBTpUCBAoACgAIAQiVDQBBTpUCBAoAAA==.Maike:AwABCAEABAoAAA==.Marothius:AwACCAMABRQDDgAIAQgXCABNk9YCBAoADgAIAQgXCABL59YCBAoADwABAQieOwAnfEYABAoAAA==.Martaug:AwABCAEABRQAAA==.Marune:AwAGCAoABAoAAA==.Maverage:AwAGCAwABAoAAA==.',Me='Meanmullet:AwABCAEABRQCEAAHAQhuFQA9jykCBAoAEAAHAQhuFQA9jykCBAoAAA==.Melee:AwACCAMABRQCBwAIAQh6BQBihlADBAoABwAIAQh6BQBihlADBAoAAA==.',Mi='Mirquizz:AwAHCBUABAoCEQAHAQh8AQBN92ICBAoAEQAHAQh8AQBN92ICBAoAAA==.',Mj='Mjolnïr:AwADCAoABAoAAA==.',Mo='Mooplexity:AwAGCAsABAoAAA==.Moor:AwADCAMABAoAAA==.Morior:AwAHCBYABAoCDgAHAQg0IAA4tecBBAoADgAHAQg0IAA4tecBBAoAAA==.',Mu='Musk:AwADCAcABAoAAA==.',['M�']='Móngol:AwADCAUABAoAAA==.Möokss:AwACCAIABAoAAA==.',Na='Nailo:AwAHCBYABAoCEgAHAQgQBQAzDbMBBAoAEgAHAQgQBQAzDbMBBAoAAA==.',No='Nobudy:AwACCAUABRQDEwACAQjMBgA1LqoABRQAEwACAQjMBgA1LqoABRQAFAABAQiCDgAwPEEABRQAAA==.Noel:AwACCAUABAoAAA==.Nonospot:AwAGCAwABAoAAA==.Noobudie:AwABCAEABAoAAA==.Noraboo:AwAFCA0ABAoAAA==.Nosugar:AwABCAEABAoAAA==.',Nu='Nunbehavior:AwAHCBYABAoDFAAHAQgxJAAiImwBBAoAFAAHAQgxJAAiImwBBAoAEwAGAQieKAAUJQcBBAoAAA==.',Ny='Nyctt:AwAHCBUABAoCAQAHAQg1CwA7bgQCBAoAAQAHAQg1CwA7bgQCBAoAAA==.Nyzstra:AwAHCBYABAoEFQAHAQiOHgBLGRYCBAoAFQAHAQiOHgBBbxYCBAoAEQAEAQjVBABELE4BBAoACAABAQjsewABdgYABAoAAA==.',Ov='Overheat:AwAGCBAABAoAAA==.',Pa='Palmiste:AwADCAQABAoAAA==.Pastrydragon:AwACCAMABRQCDQAIAQjmBQBUaNICBAoADQAIAQjmBQBUaNICBAoAAA==.Pastrysywyn:AwAGCAQABAoAAQ0AVGgCCAMABRQ=.',Pi='Pitviper:AwAGCBAABAoAAA==.',Ps='Psiyaad:AwAGCA0ABAoAAA==.',Ra='Ragnar:AwAFCAIABAoAAA==.Ramyourazz:AwACCAIABAoAAA==.Razzu:AwAECAwABAoAAA==.',Re='Realtree:AwAGCAYABAoAAA==.',Se='Sel:AwACCAMABRQDEwAIAQiwBgBQrKoCBAoAEwAIAQiwBgBIvaoCBAoAFAACAQiXRgBFuKMABAoAAA==.Sevatar:AwACCAMABAoAAA==.',St='Stazh:AwAGCA4ABAoAAA==.',Ta='Tallron:AwACCAUABRQCFgACAQiFBABQ1r4ABRQAFgACAQiFBABQ1r4ABRQAAA==.',Te='Tewty:AwAGCBAABAoAAA==.',Ti='Timir:AwACCAIABAoAAA==.Tinytìna:AwAECAYABAoAAA==.',To='Totenhammer:AwACCAIABAoAAA==.Touchurbible:AwAGCAcABAoAAA==.',Ty='Tyrolia:AwAECAQABAoAAA==.',Ve='Venji:AwAGCAwABAoAAA==.Vextt:AwAECAQABAoAAA==.',Vi='Vinni:AwAECAgABAoAAA==.',Vu='Vulpes:AwAECAYABAoAAA==.',Wa='Warkwark:AwAGCBAABAoAAA==.',We='Weledish:AwAGCAcABAoAAA==.Weston:AwAICAgABAoAAA==.',Wh='Whitetotem:AwAGCAUABAoAAA==.',Xe='Xebeche:AwABCAEABAoAAA==.',Za='Zarewien:AwAFCAsABAoAAA==.',Zo='Zomgofwar:AwAHCBQABAoCFwAHAQj4BQBBsBQCBAoAFwAHAQj4BQBBsBQCBAoAAA==.Zomgpally:AwACCAIABAoAARcAQbAHCBQABAo=.',Zu='Zurishmi:AwACCAUABRQCGAACAQj6BwA60qAABRQAGAACAQj6BwA60qAABRQAAA==.Zurishmy:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end