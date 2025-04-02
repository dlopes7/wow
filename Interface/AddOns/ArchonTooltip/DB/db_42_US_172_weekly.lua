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
 local lookup = {'Warrior-Protection','Druid-Restoration','Unknown-Unknown','DeathKnight-Unholy','DeathKnight-Blood','Paladin-Retribution','Monk-Windwalker','Monk-Mistweaver','Druid-Balance',}; local provider = {region='US',realm='Perenolde',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adrador:AwAECAgABAoAAA==.Adrenaline:AwABCAIABRQCAQAIAQgIAgBSutwCBAoAAQAIAQgIAgBSutwCBAoAAA==.',Al='Alca:AwAFCAMABAoAAA==.',An='Angau:AwAICAkABAoAAA==.',At='Attilock:AwAECAUABAoAAA==.',Av='Avaryn:AwABCAIABRQCAgAIAQjZCABMNXUCBAoAAgAIAQjZCABMNXUCBAoAAA==.',Ba='Badaracka:AwADCAUABAoAAA==.Bahamuth:AwAFCAYABAoAAA==.',Be='Beans:AwADCAMABAoAAA==.Bearackobamà:AwACCAIABAoAAQMAAAAICAsABAo=.Beeffalo:AwAICAgABAoAAA==.Bexley:AwAECAUABAoAAA==.',Bi='Bigdoctor:AwACCAEABAoAAA==.Biggerbunny:AwAFCAMABAoAAA==.',Br='Braneour:AwAFCAEABAoAAA==.Broswen:AwAECAYABAoAAA==.',Bz='Bzspy:AwACCAYABAoAAA==.',Ca='Calyptus:AwAECAUABAoAAA==.Cassandrah:AwAGCAcABAoAAA==.',Ch='Chadmessiah:AwAECAIABAoAAA==.',Co='Cox:AwACCAIABAoAAA==.',Cr='Crazycrocey:AwACCAQABAoAAA==.',Cu='Curtastrophe:AwAGCBIABAoAAA==.Curticus:AwACCAIABAoAAA==.',Cy='Cynsia:AwAICAcABAoAAA==.',De='Deathdemon:AwACCAIABAoAAA==.Decimated:AwAICBUABAoCBAAIAQgaDwBJG28CBAoABAAIAQgaDwBJG28CBAoAAA==.Destriona:AwACCAIABAoAAA==.',Di='Diamondback:AwAGCBIABAoAAA==.',Do='Dorcath:AwAFCAEABAoAAA==.',Dr='Drinny:AwAFCAQABAoAAA==.',El='Elindria:AwAFCAsABAoAAA==.',Fa='Falan:AwACCAEABAoAAA==.',Fi='Filledejoie:AwAECAYABAoAAA==.',Fo='Foog:AwACCAIABAoAAA==.Foxymagi:AwAICAYABAoAAQMAAAAICAgABAo=.',Gl='Glaivan:AwABCAIABRQDBAAIAQg5DABIMZkCBAoABAAIAQg5DABIMZkCBAoABQABAQhWOABRW1YABAoAAA==.',Gr='Groudon:AwAFCAYABAoAAA==.',Gu='Gunter:AwACCAIABAoAAQQASRsICBUABAo=.',Ha='Hailmaker:AwAECAYABAoAAA==.',He='Hector:AwADCAUABAoAAA==.',Hi='Hidethetotem:AwADCAUABAoAAA==.Hikari:AwABCAEABRQCBgAHAQh3JgBK7lkCBAoABgAHAQh3JgBK7lkCBAoAAA==.',Ho='Honiahaka:AwAFCAYABAoAAA==.',Hu='Humanoidead:AwABCAEABAoAAQMAAAAICA8ABAo=.Humanoidholy:AwABCAEABAoAAQMAAAAICA8ABAo=.Humanoidsham:AwAICA8ABAoAAA==.',It='Ithurtshuh:AwACCAQABAoAAA==.',Je='Jequalsjosh:AwADCAMABAoAAA==.',Ji='Jilara:AwAECAkABAoAAA==.',Jo='Jokker:AwABCAIABRQDBwAIAQg2CQBOIKcCBAoABwAHAQg2CQBWLKcCBAoACAABAQgwXQBAbU0ABAoAAA==.',Ka='Kaiatra:AwADCAUABAoAAA==.Kaln:AwACCAIABAoAAA==.Kastari:AwADCAIABAoAAA==.',Kh='Khai:AwAICAgABAoCBgAIAQgeiAAa6wYBBAoABgAIAQgeiAAa6wYBBAoAAA==.Kholin:AwABCAEABAoAAA==.',Ku='Kuroyukihime:AwAGCA4ABAoAAA==.',Ky='Kyogré:AwACCAMABAoAAA==.',La='Larradra:AwAFCAEABAoAAA==.Laughter:AwADCAUABAoAAA==.',Lu='Lunasnow:AwABCAEABAoAAA==.',Ma='Manmade:AwAFCAsABAoAAA==.',Mi='Midget:AwACCAIABAoAAA==.',Mo='Montyraa:AwACCAEABAoAAA==.',Na='Naseira:AwABCAEABAoAAA==.',Ni='Nike:AwAECAYABAoAAQMAAAAECAcABAo=.Nilvalor:AwAFCAgABAoAAA==.',Pa='Pallyandtank:AwABCAEABAoAAA==.',Pi='Pirodeath:AwAGCAUABAoAAA==.',Po='Poof:AwAGCAYABAoAAA==.',Pr='Pray:AwAFCAYABAoAAA==.Prodarkangel:AwAECAUABAoAAA==.',Ra='Ragius:AwABCAEABAoAAQQASRsICBUABAo=.Raistlin:AwAGCAsABAoAAA==.Ravenlight:AwABCAEABRQCBgAIAQhmEwBPtdMCBAoABgAIAQhmEwBPtdMCBAoAAA==.',Ru='Rubjab:AwAGCAwABAoAAA==.',Sa='Sabazia:AwAFCAkABAoAAA==.Salios:AwAFCAUABAoAAA==.',Sc='Scrept:AwACCAQABAoAAA==.',Se='Sedaline:AwABCAEABAoAAA==.Selatre:AwADCAMABAoAAA==.Sephy:AwAFCAUABAoAAA==.',Sh='Shockthêràpy:AwAICAsABAoAAA==.Shoes:AwAGCBEABAoAAA==.',Si='Simp:AwAECAIABAoAAA==.',Sl='Slurpington:AwAFCAUABAoAAA==.',Sn='Sneakybeach:AwAFCAgABAoAAA==.',So='Sovelis:AwACCAIABAoAAA==.',Sp='Spellumgud:AwADCAMABAoAAA==.',Sq='Squavagê:AwABCAEABAoAAA==.Squiby:AwAGCAcABAoAAA==.',St='Stardra:AwADCAgABAoAAA==.Stirlingskat:AwAECAgABAoAAA==.',Ta='Taurne:AwABCAIABRQCCQAIAQj/EwBDTFsCBAoACQAIAQj/EwBDTFsCBAoAAA==.Tazerath:AwAICAgABAoAAA==.',Te='Teknoman:AwAFCAMABAoAAA==.Tempered:AwAICBAABAoAAA==.',Th='Thecurt:AwAFCAYABAoAAA==.Theholylight:AwACCAIABAoAAA==.Therm:AwAFCAMABAoAAA==.Throatplugs:AwAICAgABAoAAA==.Thyistra:AwACCAQABAoAAA==.',To='Tokoyami:AwAECAYABAoAAA==.',Tr='Treezus:AwABCAEABAoAAQMAAAACCAIABAo=.',Tu='Turkish:AwAECAsABAoAAA==.',Va='Vahsha:AwAICBAABAoAAA==.',Vh='Vhince:AwAECAoABAoAAA==.',Vo='Volt:AwAECAcABAoAAA==.Voychek:AwAFCAkABAoAAA==.',Wh='Whashaman:AwABCAIABAoAAA==.',Wr='Wrongturn:AwADCAMABAoAAA==.',Ya='Yaan:AwACCAMABAoAAA==.',Za='Zariea:AwAFCAUABAoAAA==.',Zu='Zurtrinik:AwADCAUABRQCAQADAQjqAQAdSKQABRQAAQADAQjqAQAdSKQABRQAAA==.',Zz='Zzonked:AwAGCAwABAoAAA==.',['Ä']='Äshnärd:AwAFCAMABAoAAA==.',['Ð']='Ðruidess:AwAECAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end