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
 local lookup = {'Priest-Shadow','Priest-Discipline','Hunter-BeastMastery','Hunter-Marksmanship','DemonHunter-Havoc','Priest-Holy','Unknown-Unknown','Mage-Frost','Mage-Fire','Paladin-Retribution','Rogue-Assassination','Evoker-Devastation','Shaman-Enhancement','Warlock-Demonology','Warlock-Destruction','Warrior-Arms','Warlock-Affliction','Druid-Feral','DemonHunter-Vengeance','Druid-Balance','Druid-Restoration','Shaman-Restoration','Shaman-Elemental','Monk-Brewmaster','Monk-Mistweaver','Druid-Guardian','Paladin-Holy',}; local provider = {region='US',realm='Gilneas',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeolock:AwADCAYABAoAAA==.Aerwynn:AwAHCA4ABAoAAA==.',Ag='Aggretsuko:AwACCAIABAoAAA==.Agronub:AwABCAEABAoAAA==.',Ah='Ahnkhano:AwAGCA4ABAoAAA==.',Ak='Akbartheiiv:AwACCAQABRQDAQAIAQhVAgBbREMDBAoAAQAIAQhVAgBbREMDBAoAAgABAQhEVgAJ5S0ABAoAAA==.',Al='Alyx:AwAHCCIABAoDAwAHAQjmEwBZCbkCBAoAAwAHAQjmEwBZCbkCBAoABAAEAQhaJwBARc4ABAoAAA==.',An='Anrion:AwAHCBQABAoCBQAHAQgNIgA5RQoCBAoABQAHAQgNIgA5RQoCBAoAAA==.Antlers:AwAFCAkABAoAAA==.',Aq='Aquroria:AwAICAgABAoAAA==.',Ar='Aritus:AwACCAQABAoAAA==.',Au='Auranar:AwADCAIABAoAAA==.',Ba='Bar:AwAHCBcABAoDAQAHAQheEABImy4CBAoAAQAHAQheEABImy4CBAoABgADAQgsTQAfCYUABAoAAA==.',Be='Bellakuma:AwADCAMABAoAAA==.Bermy:AwAECAkABAoAAA==.Bewildert:AwACCAIABAoAAA==.',Bi='Bigfatmama:AwABCAEABAoAAA==.',Bl='Blende:AwABCAEABAoAAQcAAAADCAgABAo=.Bloodshadow:AwAHCBEABAoAAA==.',Bo='Bobble:AwACCAIABAoAAA==.',Br='Braxus:AwACCAQABRQDCAAIAQjGCQBJ550CBAoACAAIAQjGCQBJ550CBAoACQABAQj8egAC3BUABAoAAA==.Bretcoe:AwAECAUABAoAAA==.Bricked:AwAHCBAABAoAAA==.',Ca='Caw:AwAICAgABAoAAQcAAAADCAMABRQ=.',Ce='Celani:AwAFCAsABAoAAA==.',Ch='Chairs:AwADCAEABAoAAA==.',Ci='Cires:AwAFCAkABAoAAA==.',Co='Colanasou:AwADCAYABAoAAA==.Cowboyy:AwABCAEABAoAAA==.',Cr='Cracked:AwACCAIABAoAAA==.Crow:AwADCAMABRQAAA==.',Cy='Cydric:AwAHCBUABAoCCgAHAQhSIgBQ53ACBAoACgAHAQhSIgBQ53ACBAoAAA==.',Da='Daarrkstar:AwADCAgABAoAAA==.Darkane:AwACCAQABRQDAwAIAQjoFgBQHqECBAoAAwAIAQjoFgBOfaECBAoABAADAQg5IQBWAQsBBAoAAA==.',De='Demoray:AwAECAgABRQDAwAEAQiYAgBRlGkBBRQAAwAEAQiYAgBPY2kBBRQABAABAQg7BgBFSFcABRQAAA==.Dethrone:AwABCAEABRQAAA==.',Di='Dirtydragon:AwADCAMABAoAAA==.',Do='Dontkare:AwAHCAsABAoAAA==.',Dr='Droobear:AwAECAMABAoAAA==.Droobman:AwAFCAUABAoAAA==.Drwho:AwAGCBIABAoAAA==.',Ed='Edorus:AwABCAEABRQCCwAIAQj9BgBAVHUCBAoACwAIAQj9BgBAVHUCBAoAAA==.',El='Elfadwagon:AwACCAQABRQCDAAIAQg/BABVE/gCBAoADAAIAQg/BABVE/gCBAoAAA==.Elfbow:AwAECAgABAoAAA==.',Er='Erdor:AwAECAgABAoAAA==.Erzareth:AwABCAEABAoAAA==.',Et='Etheman:AwAICBAABAoAAA==.',Ex='Excuses:AwACCAQABRQCDQAIAQg1BgBWeOsCBAoADQAIAQg1BgBWeOsCBAoAAA==.',Fa='Facestealerr:AwADCAYABAoAAA==.',Fl='Flairrick:AwADCAIABAoAAA==.',Fo='Fondaloxx:AwABCAEABAoAAA==.',Fr='Freeguy:AwADCAcABAoAAA==.Freesum:AwADCAQABRQDDgAIAQifAABcUi4DBAoADgAIAQifAABcUi4DBAoADwACAQj/bAAiYmUABAoAAA==.',Fu='Fuddmon:AwAECAgABAoAAA==.Fuddmore:AwAECAkABAoAAA==.Fuddster:AwAECAUABAoAAQcAAAAECAkABAo=.',Gh='Ghaníma:AwADCAQABAoAAA==.',Go='Gonefishing:AwAGCAsABAoAAA==.',Gu='Gumber:AwACCAQABRQCEAAIAQiaBQBFW7gCBAoAEAAIAQiaBQBFW7gCBAoAAA==.Gummibear:AwABCAEABAoAAA==.',Ha='Harthoon:AwAHCBcABAoCCAAHAQjhDABTgnQCBAoACAAHAQjhDABTgnQCBAoAAA==.',He='Helenkeller:AwAGCAwABAoAAA==.',Ho='Holiebelle:AwACCAEABAoAAA==.Hotdwarf:AwACCAIABAoAAA==.',Hu='Hubbabubbles:AwADCAMABAoAAA==.Hullkk:AwAHCBcABAoCEAAHAQhfCABU1nUCBAoAEAAHAQhfCABU1nUCBAoAAA==.',Hy='Hydro:AwADCAMABAoAAA==.',In='Inseng:AwAFCAIABAoAAA==.',Ja='Jacmus:AwACCAIABAoAAQMAUB4CCAQABRQ=.Jassykins:AwADCAIABAoAAA==.',Ji='Jindouyun:AwADCAcABAoAAA==.',Jo='Joanofarc:AwAGCA4ABAoAAA==.Joloc:AwADCAUABAoAAA==.',Ka='Kalamara:AwADCAQABAoAAA==.Kalrosa:AwAECA4ABAoAAA==.',Ke='Keedros:AwAFCAcABAoAAA==.Kermonature:AwADCAcABAoAAA==.Kerogen:AwAECAkABAoAAA==.',Kh='Kholdharted:AwAICBAABAoAAA==.',Ki='Kiizo:AwAECAUABAoAAA==.',Kn='Knaveztine:AwADCAIABAoAAA==.',Ko='Koltaros:AwAHCBYABAoDDwAHAQg0EgBNhF4CBAoADwAHAQg0EgBNhF4CBAoAEQADAQidGgAvSJgABAoAAA==.',Ku='Kuragaru:AwAHCBcABAoCCwAHAQiTCQBFty8CBAoACwAHAQiTCQBFty8CBAoAAA==.',Ky='Kypalgo:AwAGCBAABAoAAA==.',La='Lanastor:AwACCAQABAoAAA==.',Le='Leftraro:AwAECAkABAoAAA==.Leiyna:AwAHCBUABAoCEgAHAQjbAgBaE80CBAoAEgAHAQjbAgBaE80CBAoAAA==.Leovarne:AwABCAEABAoAAQcAAAABCAEABAo=.Leoverdi:AwABCAEABAoAAA==.Lester:AwADCAcABAoAAA==.',Li='Lidrael:AwAHCBQABAoCEwAHAQhZDQBBP90BBAoAEwAHAQhZDQBBP90BBAoAAA==.Liliria:AwAHCBUABAoCBgAHAQizJwAhL1IBBAoABgAHAQizJwAhL1IBBAoAAA==.Littlë:AwABCAIABRQDFAAIAQhxCQBUv+ECBAoAFAAIAQhxCQBUv+ECBAoAFQADAQi+SAAO8moABAoAAA==.',Lo='Locojoe:AwAECAcABAoAAA==.',Lu='Lucariõ:AwACCAYABRQCBgACAQjiBABPvLoABRQABgACAQjiBABPvLoABRQAAA==.Lucenttopaz:AwADCAUABAoAAA==.Lumina:AwADCAIABAoAAA==.',['L�']='Lïttle:AwACCAIABAoAARQAVL8BCAIABRQ=.',Ma='Magicae:AwACCAMABAoAAA==.',Mo='Moezilla:AwAHCBcABAoDFgAHAQhVHQA9stsBBAoAFgAHAQhVHQA9stsBBAoAFwACAQgjSgAMEU4ABAoAAA==.Molvnma:AwADCAEABAoAAA==.Moochy:AwACCAIABRQAAA==.Moxxie:AwADCAIABAoAAA==.',Mu='Murfie:AwAECAkABAoAAA==.',My='Myrallia:AwAGCBAABAoAAA==.',['M�']='Mìr:AwAHCBcABAoCBQAHAQgtFgBQHm4CBAoABQAHAQgtFgBQHm4CBAoAAA==.',Na='Nagoo:AwAHCBUABAoCGAAHAQgVBgBEYO0BBAoAGAAHAQgVBgBEYO0BBAoAAA==.Nashness:AwAFCAkABAoAAA==.Natharion:AwAHCBUABAoDEQAHAQhtBQA/7+cBBAoAEQAHAQhtBQA/7+cBBAoADwACAQgkfwAIEzEABAoAAA==.',Ne='Nevari:AwAECAMABAoAAA==.',Ni='Nido:AwAGCAEABAoAAA==.',Nn='Nn:AwADCAQABAoAAA==.',Nu='Nu:AwACCAIABAoAAA==.',Od='Odinrex:AwAICAEABAoAAA==.',Pa='Pallypaladin:AwABCAIABRQCCgAIAQglJgBCCFsCBAoACgAIAQglJgBCCFsCBAoAAA==.Partywolf:AwADCAYABAoAAA==.',Po='Popsicles:AwACCAIABAoAAA==.',Ps='Psyop:AwAECBEABAoAAA==.',Py='Pyricia:AwADCAYABAoAAA==.',Ra='Rayia:AwAHCA0ABAoAAA==.',Rh='Rhodraco:AwADCAQABAoAAA==.',Ri='Riktorr:AwABCAIABAoAAA==.',Ro='Rohesia:AwAFCAoABAoAAA==.Romulusinc:AwABCAIABAoAAA==.Rosabee:AwADCAYABAoAAA==.',Ru='Rulette:AwABCAEABAoAAA==.',Se='Selphie:AwAGCAoABAoAAA==.Senile:AwADCAIABAoAAA==.Senordrains:AwABCAEABAoAAA==.Sesnic:AwAGCBIABAoAAA==.Sevika:AwAHCBUABAoCFAAHAQgSFgBI+EUCBAoAFAAHAQgSFgBI+EUCBAoAAA==.',Sh='Shazoth:AwACCAIABAoAAA==.',Sk='Skinrot:AwABCAEABRQAAA==.',Sn='Snakedrake:AwAECAQABAoAAA==.',So='Soeki:AwADCAQABAoAAA==.Soullove:AwAECAcABAoAAA==.Soulviver:AwADCAcABAoAAA==.Soulzdragon:AwAFCA4ABAoAAA==.',Sp='Spicytuna:AwAGCA0ABAoAAA==.Spiritwarden:AwAFCAkABAoAAA==.Spure:AwABCAEABAoAAA==.',Sq='Squishydruid:AwAHCBcABAoCFAAHAQgFJwAth6oBBAoAFAAHAQgFJwAth6oBBAoAAA==.',Sw='Swolegoose:AwAICAQABAoAAA==.',Ta='Tarrzok:AwAHCBUABAoCFwAHAQgNEABPwjQCBAoAFwAHAQgNEABPwjQCBAoAAA==.',Te='Tempani:AwADCAMABAoAAA==.',Th='Thereally:AwACCAEABAoAAA==.Thrakara:AwAHCBcABAoCGQAHAQjTEABN2T0CBAoAGQAHAQjTEABN2T0CBAoAAA==.Thunderhorns:AwADCAIABAoAAA==.',Ts='Tsuo:AwAHCBcABAoCGgAHAQhCAQBaIcgCBAoAGgAHAQhCAQBaIcgCBAoAAA==.',Ty='Tymptriss:AwADCAYABAoAAA==.Tyrick:AwAFCA0ABAoAAA==.',Ve='Venotu:AwAECAgABAoAAA==.',Vh='Vholprime:AwADCAEABAoAAA==.',Vi='Viviel:AwAECA8ABAoAAA==.',Wa='Warmongral:AwAECAcABAoAAA==.',We='Wendi:AwAECAcABAoAAA==.',Wi='Windcrow:AwACCAIABAoAAA==.',Wo='Wombo:AwADCAcABAoAAA==.',Wu='Wut:AwACCAIABAoAAA==.',Ya='Yaeyo:AwABCAEABRQCGQAIAQjRCABTBrgCBAoAGQAIAQjRCABTBrgCBAoAAA==.Yarper:AwAGCAEABAoAAA==.',Za='Zaier:AwAHCBUABAoCGwAHAQjBCgBDbAwCBAoAGwAHAQjBCgBDbAwCBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end