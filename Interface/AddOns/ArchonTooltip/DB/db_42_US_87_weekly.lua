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
 local lookup = {'Unknown-Unknown','DeathKnight-Unholy','Hunter-BeastMastery','Monk-Windwalker','Paladin-Retribution','Priest-Holy','Mage-Fire','Warrior-Arms','Warrior-Protection','Druid-Restoration',}; local provider = {region='US',realm='Elune',name='US',type='weekly',zone=42,date='2025-03-28',data={Ae='Aedory:AwAECAYABAoAAA==.',Ag='Agoni:AwACCAIABAoAAA==.',Ak='Aknologia:AwAECAkABAoAAQEAAAAFCAcABAo=.',Al='Aledis:AwAICBUABAoCAgAIAQjvCABQ7cUCBAoAAgAIAQjvCABQ7cUCBAoAAA==.Allanøn:AwACCAIABAoAAA==.Almuqit:AwAGCA0ABAoAAA==.Alucaryn:AwADCAMABAoAAQEAAAAFCAoABAo=.',Am='Amowrath:AwAGCBAABAoAAA==.Amyxia:AwADCAIABAoAAA==.',An='Anitajones:AwABCAEABRQAAA==.Ankzu:AwACCAIABAoAAQEAAAAGCA4ABAo=.Anom:AwADCAMABAoAAA==.',Ar='Aradoa:AwAGCAwABAoAAA==.Ark:AwAECAkABAoAAA==.Arturía:AwAICBYABAoCAwAIAQh7HgA4xFkCBAoAAwAIAQh7HgA4xFkCBAoAAA==.',As='Asharila:AwACCAIABAoAAA==.Astreri:AwADCAQABAoAAA==.',Av='Avi:AwAFCAwABAoAAQEAAAAGCBAABAo=.',Ay='Ayiasofia:AwAGCAMABAoAAA==.Aylan:AwAFCAgABAoAAA==.',Az='Azureshal:AwAECAUABAoAAA==.Azuros:AwABCAEABAoAAA==.',Ba='Baryll:AwADCAEABAoAAA==.',Be='Benedictas:AwAICAoABAoAAA==.',Bi='Biggame:AwADCAIABAoAAA==.',Bo='Bourz:AwADCAMABAoAAA==.',Br='Briset:AwADCAQABAoAAA==.',Bz='Bz:AwAICAwABAoAAA==.',Ca='Cait:AwAECAkABAoAAA==.Calinda:AwACCAMABAoAAA==.Canis:AwADCAEABAoAAA==.Carefreè:AwABCAIABRQCBAAIAQh1BQBUo/ECBAoABAAIAQh1BQBUo/ECBAoAAA==.',Ce='Celerity:AwAGCBAABAoAAA==.',Ch='Chamanita:AwADCAEABAoAAA==.Chaospho:AwAGCAMABAoAAA==.Cheesebread:AwACCAIABAoAAA==.Choson:AwAFCA8ABAoAAA==.Chronis:AwABCAEABAoAAA==.',Cr='Critkiller:AwACCAIABAoAAA==.',Cu='Curzøn:AwAGCAwABAoAAA==.',Cy='Cynardria:AwAECAQABAoAAQEAAAAGCBAABAo=.',Da='Dagons:AwADCAUABAoAAA==.Danabell:AwAECAkABAoAAA==.Dawnshott:AwAGCAsABAoAAA==.',Do='Dochollidày:AwAECAUABAoAAA==.',Dr='Draconîs:AwAICAgABAoAAA==.Drysua:AwAGCBMABAoAAA==.',Du='Duskfire:AwAICAgABAoAAA==.',Dz='Dzret:AwAICAgABAoAAA==.',['D�']='Dàx:AwADCAQABAoAAQEAAAAGCAwABAo=.',El='Elaynne:AwAGCAMABAoAAA==.Eliteelf:AwADCAoABAoAAA==.Elloro:AwABCAIABRQCBQAHAQgHLABMqTMCBAoABQAHAQgHLABMqTMCBAoAAA==.Eloro:AwAGCAMABAoAAQUATKkBCAIABRQ=.',Fa='Fax:AwAECAkABAoAAA==.',Fe='Fearmeh:AwAGCAkABAoAAA==.Ferangdh:AwAGCA8ABAoAAA==.Fevion:AwACCAIABRQCAwAIAQgkFgBDH58CBAoAAwAIAQgkFgBDH58CBAoAAA==.Fevius:AwADCAMABAoAAQMAQx8CCAIABRQ=.',Fi='Finduilas:AwAGCAMABAoAAA==.Firewillow:AwAICBAABAoAAA==.',Fr='Freecakes:AwAFCAYABAoAAA==.',Fu='Fuzzybuddy:AwAGCAwABAoAAA==.',['F�']='Fâîth:AwAGCBEABAoAAA==.',Ga='Galatea:AwADCAMABAoAAA==.',Gr='Graxion:AwAFCAoABAoAAA==.Grendy:AwABCAEABAoAAA==.',Gw='Gwynorra:AwABCAIABAoAAA==.',Ha='Habibi:AwACCAIABAoAAA==.Hagger:AwAICAcABAoAAA==.Hammur:AwAGCAMABAoAAA==.Hampter:AwACCAIABAoAAA==.Haralda:AwAECAQABAoAAA==.Harshblue:AwAGCAMABAoAAA==.',He='Hellodc:AwAGCA0ABAoAAA==.Hercy:AwACCAMABAoAAA==.',Ho='Hoj:AwAECAkABAoAAA==.',Hu='Huntli:AwADCAgABAoAAA==.',Ic='Icecreamcake:AwACCAQABRQCBgAIAQguBwBOnqUCBAoABgAIAQguBwBOnqUCBAoAAA==.',Ir='Irulanni:AwAFCA4ABAoAAA==.',Jo='Johchi:AwAGCA0ABAoAAA==.',Ju='Jusis:AwAFCAcABAoAAA==.Juvenate:AwAGCBAABAoAAA==.',Ka='Kanab:AwAECAIABAoAAA==.Kaygome:AwAGCBAABAoAAA==.',Ke='Kelarik:AwACCAQABAoAAA==.',Ku='Kurenay:AwAECAIABAoAAA==.',La='Latriah:AwAFCAMABAoAAA==.',Le='Legolamb:AwAECAEABAoAAA==.Leicht:AwAECAUABAoAAA==.Leviasaint:AwABCAEABRQAAA==.',Ma='Madglowup:AwADCAUABAoAAA==.',Mc='Mcfall:AwACCAIABAoAAA==.',Mo='Mockradin:AwADCAcABAoAAA==.Morphaz:AwAFCAEABAoAAA==.',Mu='Muehzalan:AwAGCAEABAoAAA==.Muethorian:AwAECAEABAoAAA==.Murdrmittens:AwAECAoABAoAAA==.',My='Mynxe:AwAGCAYABAoAAA==.',Na='Naldon:AwAECAMABAoAAA==.',Ni='Nihalunk:AwABCAEABAoAAA==.Nihalus:AwAHCBUABAoCBwAHAQhzIgA3QekBBAoABwAHAQhzIgA3QekBBAoAAA==.',Pa='Pamaran:AwABCAEABRQAAA==.Patissier:AwAGCAsABAoAAA==.',Ps='Psyop:AwADCAQABAoAAA==.',Pu='Purenindrawr:AwAFCAUABAoAAA==.',Qb='Qberks:AwAICB8ABAoCAgAIAQj3BQBWA/0CBAoAAgAIAQj3BQBWA/0CBAoAAQIAIpMECAcABRQ=.',Ra='Raganthor:AwABCAEABRQAAA==.Rahne:AwAHCBYABAoDCAAHAQhwGQAbFGEBBAoACAAHAQhwGQAVb2EBBAoACQACAQj8IQAZfEQABAoAAA==.Rainbeams:AwADCAUABAoAAA==.Raizejahi:AwACCAMABAoAAA==.Ranico:AwAGCA4ABAoAAA==.',Re='Rekviem:AwAGCBAABAoAAA==.Relifus:AwAECAkABAoAAA==.Rexxaran:AwEFCAsABAoAAA==.',Ri='Rienni:AwACCAMABAoAAA==.Rime:AwAECAkABAoAAA==.Rinelock:AwAICAgABAoAAA==.Rip:AwAFCAsABAoAAA==.Riverwolf:AwAICBAABAoAAA==.',Ro='Rockfyst:AwADCAIABAoAAA==.Royalnewb:AwAFCBEABAoAAA==.',Ru='Runicpowers:AwABCAEABAoAAA==.Ruperd:AwAGCBAABAoAAA==.',Ry='Rynsidious:AwAGCAMABAoAAA==.',Sa='Saladfingrs:AwACCAQABRQCCgAIAQhvAQBelT8DBAoACgAIAQhvAQBelT8DBAoAAA==.',Sh='Shadowfiendd:AwAGCA0ABAoAAA==.Shadowveel:AwAFCAsABAoAAQMATbMHCBQABAo=.Shaldole:AwADCAcABAoAAA==.',Si='Silverback:AwAICBAABAoAAA==.Sindarian:AwAECAYABAoAAA==.Sink:AwACCAIABAoAAA==.',Sk='Skor:AwACCAMABAoAAA==.Skyfallen:AwAGCA4ABAoAAA==.',Sl='Slivah:AwADCAMABAoAAA==.',Sm='Smoosh:AwAGCAwABAoAAQIAIpMECAcABRQ=.',Sn='Sniffy:AwAECAUABAoAAA==.',So='Solgon:AwAECAYABAoAAA==.Solo:AwACCAEABAoAAA==.',St='Stalk:AwAGCAIABAoAAA==.Stehlina:AwACCAIABAoAAA==.Stumpyfoot:AwAECAkABAoAAA==.',Ta='Talial:AwAECAkABAoAAA==.',Te='Terraquis:AwAFCAIABAoAAA==.',Th='Thalyon:AwAICAgABAoAAA==.Thesloth:AwAECAEABAoAAA==.Thorgyllan:AwADCAYABAoAAA==.Thorr:AwAGCAcABAoAAA==.',Ti='Tigra:AwAGCAwABAoAAA==.',To='Took:AwAECAcABAoAAA==.',Tr='Trusker:AwAGCBAABAoAAA==.',Ty='Tyraxis:AwAGCAwABAoAAA==.',Ul='Ulasar:AwACCAIABAoAAA==.',Un='Unholyviper:AwACCAIABAoAAA==.',Va='Valkkar:AwAECAcABAoAAA==.Valorfist:AwACCAIABAoAAA==.',Ve='Veroswen:AwAECAoABAoAAA==.Verratanikto:AwAICAIABAoAAA==.',Vi='Viki:AwACCAEABAoAAA==.Virusgt:AwADCAUABAoAAA==.',['V�']='Vânden:AwAECAcABAoAAA==.Vèel:AwAHCBQABAoCAwAHAQgnHwBNs1MCBAoAAwAHAQgnHwBNs1MCBAoAAA==.',Wa='Walk:AwABCAIABAoAAA==.',Wi='Witpally:AwAGCAsABAoAAA==.',Wy='Wysp:AwABCAEABAoAAA==.',Xa='Xaida:AwAGCBAABAoAAA==.',Xh='Xhar:AwAECAEABAoAAA==.',Yb='Yb:AwAGCBAABAoAAA==.',Yr='Yrhe:AwACCAIABAoAAA==.',Za='Zaela:AwAGCBAABAoAAA==.',Ze='Zeroximo:AwADCAcABAoAAA==.',Zo='Zoraell:AwADCAcABAoAAA==.',['Ä']='Äñûßîs:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end