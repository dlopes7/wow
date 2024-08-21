local W, F, E, L, V, P, G = unpack((select(2, ...)))

local pairs = pairs
local tinsert = tinsert
local tostring = tostring

local GetLocale = GetLocale
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_CVar_GetCVarBool = C_CVar.GetCVarBool

-- WindTools
W.Title = L["WindTools"]
W.PlainTitle = gsub(W.Title, "|c........([^|]+)|r", "%1")

-- Environment
W.Locale = GetLocale()
W.ChineseLocale = strsub(W.Locale, 0, 2) == "zh"
W.SupportElvUIVersion = 13.74
W.UseKeyDown = C_CVar_GetCVarBool("ActionButtonUseKeyDown")

-- Game
W.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()
W.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

-- Wait for TWW
-- W.MythicPlusMapData = {
--     -- https://wago.tools/db2/MapChallengeMode
--     -- https://wago.tools/db2/GroupFinderActivityGrp
--     [353] = {abbr = L["[ABBR] Siege of Boralus"], activityID = 146},
--     [375] = {abbr = L["[ABBR] Mists of Tirna Scithe"], activityID = 262},
--     [376] = {abbr = L["[ABBR] The Necrotic Wake"], activityID = 265},
--     [501] = {abbr = L["[ABBR] The Stonevault"], activityID = 328},
--     [502] = {abbr = L["[ABBR] City of Threads"], activityID = 329},
--     [503] = {abbr = L["[ABBR] Ara-Kara, City of Echoes"], activityID = 323},
--     [505] = {abbr = L["[ABBR] The Dawnbreaker"], activityID = 326},
--     [507] = {abbr = L["[ABBR] Grim Batol"], activityID = 56}
-- }

W.MythicPlusMapData = {
    [399] = {abbr = L["[ABBR] Ruby Life Pools"], activityID = 306, timers = {1080, 1440, 1800}},
    [400] = {abbr = L["[ABBR] The Nokhud Offensive"], activityID = 308, timers = {1440, 1920, 2400}},
    [401] = {abbr = L["[ABBR] The Azure Vault"], activityID = 307, timers = {1350, 1800, 2250}},
    [402] = {abbr = L["[ABBR] Algeth'ar Academy"], activityID = 302, timers = {1152, 1536, 1920}},
    [403] = {abbr = L["[ABBR] Uldaman: Legacy of Tyr"], activityID = 309, timers = {1260, 1680, 2100}},
    [404] = {abbr = L["[ABBR] Neltharus"], activityID = 305, timers = {1188, 1584, 1980}},
    [405] = {abbr = L["[ABBR] Brackenhide Hollow"], activityID = 303, timers = {1260, 1680, 2100}},
    [406] = {abbr = L["[ABBR] Halls of Infusion"], activityID = 304, timers = {1260, 1680, 2100}}
}

W.MythicPlusSeasonAchievementData = {
    [19782] = {abbr = L["[ABBR] Dragonflight Keystone Master: Season Four"]},
    [19783] = {abbr = L["[ABBR] Dragonflight Keystone Hero: Season Four"]},
    [20525] = {abbr = L["[ABBR] The War Within Keystone Master: Season One"]},
    [20526] = {abbr = L["[ABBR] The War Within Keystone Hero: Season One"]}
}

-- https://www.wowhead.com/achievements/character-statistics/dungeons-and-raids/the-war-within/
-- var a=""; document.querySelectorAll("tbody.clickable > tr a.listview-cleartext").forEach((h) => a+=h.href.match(/achievement=([0-9]*)/)[1]+',');console.log(a);
W.RaidData = {
    [2388] = {
        abbr = L["[ABBR] Vault of the Incarnates"],
        tex = 4630363,
        achievements = {
            {16359, 16361, 16362, 16366, 16367, 16368, 16369, 16370},
            {16371, 16372, 16373, 16374, 16375, 16376, 16377, 16378},
            {16379, 16380, 16381, 16382, 16383, 16384, 16385, 16386},
            {16387, 16388, 16389, 16390, 16391, 16392, 16393, 16394}
        }
    },
    [2403] = {
        abbr = L["[ABBR] Aberrus, the Shadowed Crucible"],
        tex = 5161748,
        achievements = {
            {18180, 18181, 18182, 18183, 18184, 18185, 18186, 18188, 18187},
            {18189, 18190, 18191, 18192, 18194, 18195, 18196, 18197, 18198},
            {18210, 18211, 18212, 18213, 18214, 18215, 18216, 18217, 18218},
            {18219, 18220, 18221, 18222, 18223, 18224, 18225, 18226, 18227}
        }
    },
    [2502] = {
        abbr = L["[ABBR] Amirdrassil, the Dream's Hope"],
        tex = 5342929,
        achievements = {
            {19348, 19356, 19355, 19354, 19353, 19359, 19352, 19357, 19358},
            {19366, 19362, 19365, 19361, 19367, 19368, 19360, 19364, 19363},
            {19375, 19374, 19369, 19370, 19373, 19372, 19371, 19377, 19376},
            {19385, 19384, 19381, 19379, 19386, 19382, 19383, 19380, 19378}
        }
    },
    [2645] = {
        abbr = L["[ABBR] Nerub-ar Palace"],
        tex = 5779391,
        achievements = {
            {40267, 40271, 40275, 40279, 40283, 40287, 40291, 40295},
            {40268, 40272, 40276, 40280, 40284, 40288, 40292, 40296},
            {40269, 40273, 40277, 40281, 40285, 40289, 40293, 40297},
            {40270, 40274, 40278, 40282, 40286, 40290, 40294, 40298}
        }
    }
}

W.SpecializationInfo = {}

function W:InitializeMetadata()
    for id in pairs(W.MythicPlusMapData) do
        local name, _, timeLimit, tex = C_ChallengeMode_GetMapUIInfo(id)
        W.MythicPlusMapData[id].name = name
        W.MythicPlusMapData[id].tex = tex
        W.MythicPlusMapData[id].idString = tostring(id)
        W.MythicPlusMapData[id].timeLimit = timeLimit
        if W.MythicPlusMapData[id].timers then
            W.MythicPlusMapData[id].timers[#W.MythicPlusMapData[id].timers] = timeLimit
        end
    end

    for id in pairs(W.MythicPlusSeasonAchievementData) do
        W.Utilities.Async.WithAchievementID(
            id,
            function(data)
                W.MythicPlusSeasonAchievementData[id].name = data[2]
                W.MythicPlusSeasonAchievementData[id].tex = data[10]
                W.MythicPlusSeasonAchievementData[id].idString = tostring(id)
            end
        )
    end

    for id in pairs(W.RaidData) do
        local result = {GetLFGDungeonInfo(id)}
        W.RaidData[id].name = result[1]
        W.RaidData[id].idString = tostring(id)
    end

    for classID = 1, 13 do
        local class = {}
        for specIndex = 1, 4 do
            local data = {GetSpecializationInfoForClassID(classID, specIndex)}
            if #data > 0 then
                tinsert(class, {specID = data[1], name = data[2], icon = data[4], role = data[5]})
            end
        end

        tinsert(W.SpecializationInfo, class)
    end

    -- debug: check all achievements
    -- for i, data in ipairs(W.RaidData[2645].achievements) do
    --     for j, id in ipairs(data) do
    --         W.Utilities.Async.WithAchievementID(
    --             id,
    --             function(data)
    --                 E:Delay(1.3 * (i - 1) + j * 0.1, print, data[1], data[2])
    --             end
    --         )
    --     end
    -- end
end
