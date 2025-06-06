local mod	= DBM:NewMod(2400, "DBM-Party-Shadowlands", 3, 1184)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20241214043239")
mod:SetCreatureID(164567)
mod:SetEncounterID(2397)
mod:SetHotfixNoticeRev(20240808000000)
--mod:SetMinSyncRevision(20230922000000)
mod:SetZone(2290)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 321006 323059 323137",
	"SPELL_AURA_REMOVED 321006 323059",
	"SPELL_CAST_START 323057 323149 323137 328756 323138",
--	"SPELL_CAST_SUCCESS 323177",
	"SPELL_PERIODIC_DAMAGE 323250",
	"SPELL_PERIODIC_MISSED 323250"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, change Embrace darkness to a reflect/stopattack warning if strat becomes to stop damage on boss during it
--TODO, timers still feel like a mess so two are disabled entirely until further data is available
--got to be more I can't see on WCL, need trancsriptor and more pull data
--[[
(ability.id = 323149 or ability.id = 323137 or ability.id = 328756 or ability.id = 323138) and type = "begincast"
 or ability.id = 323177 and type = "cast"
 or ability.id = 321006 or ability.id = 323059
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 --]]
--Phases
local warnSoulShackle					= mod:NewTargetNoFilterAnnounce(321005, 3)
local warnDromansWrath					= mod:NewTargetNoFilterAnnounce(323059, 1)

--Boss
local specWarnSpiritBolt				= mod:NewSpecialWarningInterrupt(323057, "HasInterrupt", nil, nil, 1, 2)
local specWarnEmbraceDarkness			= mod:NewSpecialWarningSpell(323149, nil, nil, nil, 2, 2)
local specWarnRepulsiveVisage			= mod:NewSpecialWarningSpell(328756, nil, nil, nil, 2, 2)
--Droman Oulfarran
local specWarnBewilderingPollen			= mod:NewSpecialWarningDodgeCount(323137, "Tank", nil, nil, 1, 15)
local specWarnBewilderingPollenDispel	= mod:NewSpecialWarningDispel(323137, false, nil, 2, 1, 2)--Off by default
local specWarnTearsoftheForrest			= mod:NewSpecialWarningDodge(323177, nil, nil, nil, 2, 2)
local specWarnGTFO						= mod:NewSpecialWarningGTFO(323250, nil, nil, nil, 1, 8)

--Phases
--local timerEmbraceDarknessCD			= mod:NewCDTimer(66.7, 323149, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)
--local timerRepulsiveVisageCD			= mod:NewCDTimer(15.8, 328756, nil, nil, nil, 2, nil, DBM_COMMON_L.MAGIC_ICON)
--Droman Oulfarran
local timerBewilderingPollenCD			= mod:NewCDCountTimer(14.5, 323137, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--14.5-25, unsure if spellqueue causes the variation or just inconsistent energy rates
local timerTearsoftheForestCD			= mod:NewVarCountTimer("v20.3-25", 323177, nil, nil, nil, 3)--20.3-25, unsure if spellqueue causes the variation or just inconsistent energy rates
local timerDromansWrath					= mod:NewBuffActiveTimer(15, 323059, nil, nil, nil, 6)

mod.vb.pollenCount = 0
mod.vb.tearsCount = 0

function mod:OnCombatStart(delay)
	self.vb.pollenCount = 0
	self.vb.tearsCount = 0
	--First soul shackle doesn't always appears in combat log on engage after ENCOUNTER_START
	if self:AntiSpam(3, 1) then
		timerBewilderingPollenCD:Start(7.3, 1)
		--Recheck force compliance/tears on live
		timerTearsoftheForestCD:Start(12, 1)--12-20
	end
--	timerEmbraceDarknessCD:Start(35-delay)--35-41
--	timerRepulsiveVisageCD:Start(44.7-delay)--44.7-46?
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 323057 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnSpiritBolt:Show(args.sourceName)
			specWarnSpiritBolt:Play("kickcast")
		end
	elseif spellId == 323149 then
		specWarnEmbraceDarkness:Show()
		specWarnEmbraceDarkness:Play("aesoon")
	elseif spellId == 323137 then
		self.vb.pollenCount = self.vb.pollenCount + 1
		specWarnBewilderingPollen:Show(self.vb.pollenCount)
		specWarnBewilderingPollen:Play("frontal")
		timerBewilderingPollenCD:Start(nil, self.vb.pollenCount+1)
	elseif spellId == 328756 then
		specWarnRepulsiveVisage:Show()
		specWarnRepulsiveVisage:Play("fearsoon")
		--timerRepulsiveVisageCD:Start()
	elseif spellId == 323138 then--Forced Compliance
		self.vb.tearsCount = self.vb.tearsCount + 1
		specWarnTearsoftheForrest:Schedule(1, self.vb.tearsCount)
		specWarnTearsoftheForrest:ScheduleVoice(1, "watchstep")
		timerTearsoftheForestCD:Start(nil, self.vb.tearsCount+1)
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 323177 then--Tears of forrest actual cast

	end
end
--]]

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 321006 then
		warnSoulShackle:Show(args.destName)
		--Droman
		if self:AntiSpam(3, 1) then
			timerBewilderingPollenCD:Start(7.3, self.vb.pollenCount+1)
			timerTearsoftheForestCD:Start("v12.6-17", self.vb.tearsCount+1)
			--timerEmbraceDarknessCD(35.1)--35.1-39.9
			if self:IsMythic() then
				--timerRepulsiveVisageCD:Start(55.8)
			end
		end
	elseif spellId == 323059 then
		warnDromansWrath:Show(args.destName)
		timerDromansWrath:Start(15)
		--Boss
		--timerEmbraceDarknessCD:Stop()
		--timerRepulsiveVisageCD:Stop()
		--Droman
		timerBewilderingPollenCD:Stop()
		timerTearsoftheForestCD:Stop()
	elseif spellId == 323137 and self:CheckDispelFilter("magic") then
		specWarnBewilderingPollenDispel:CombinedShow(0.3, args.destName)
		specWarnBewilderingPollenDispel:ScheduleVoice(0.3, "helpdispel")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 321006 then
		timerBewilderingPollenCD:Stop()
		timerTearsoftheForestCD:Stop()
	elseif spellId == 323059 then
		timerDromansWrath:Stop()
		--Boss (if they reset)
		--Probably not right
		--timerEmbraceDarknessCD:Start(35.7)--35-40
		--timerRepulsiveVisageCD:Start(32.3)--32-37
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 323250 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257453  then

	end
end
--]]
