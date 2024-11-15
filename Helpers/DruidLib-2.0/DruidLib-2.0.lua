
local MAJOR_VERSION = "DruidLib-2.0"
local MINOR_VERSION = "$Revision: 10240 $"

if not AceLibrary then
	error(MAJOR_VERSION .. " requires AceLibrary")
end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then
	return
end
if not AceLibrary:HasInstance("AceEvent-2.0") then
	error(MAJOR_VERSION .. " requires AceEent-2.0")
end

local DruidLib = {}
local DruidLibTip = CreateFrame("GameTooltip", "DruidLibTip", nil, "GameTooltipTemplate")
local DruidLibOnUpdateFrame = CreateFrame("Frame")

local currInt = 0
local maxMana = 0
local currMana = 0
local subtractMana = 0
local extra = 0
local lowregentimer = 0
local fullmanatimer = 0
local waitonce = nil
local _, playerClass = UnitClass("player")
local inform = UnitPowerType("player") ~= 0
DruidLibTip:SetOwner(WorldFrame, "ANCHOR_NONE")

local BaseMana = {
	[1] =50,
	[2] =57,
	[3] =65,
	[4] =74,
	[5] =84,
	[6] =95,
	[7] =107,
	[8] =120,
	[9] =134,
	[10] =149,
	[11] =165,
	[12] =182,
	[13] =200,
	[14] =219,
	[15] =239,
	[16] =260,
	[17] =282,
	[18] =305,
	[19] =329,
	[20] =354,
	[21] =380,
	[22] =392,
	[23] =420,
	[24] =449,
	[25] =479,
	[26] =509,
	[27] =524,
	[28] =554,
	[29] =584,
	[30] =614,
	[31] =629,
	[32] =659,
	[33] =689,
	[34] =704,
	[35] =734,
	[36] =749,
	[37] =779,
	[38] =809,
	[39] =824,
	[40] =854,
	[41] =869,
	[42] =899,
	[43] =914,
	[44] =944,
	[45] =959,
	[46] =989,
	[47] =1004,
	[48] =1019,
	[49] =1049,
	[50] =1064,
	[51] =1079,
	[52] =1109,
	[53] =1124,
	[54] =1139,
	[55] =1154,
	[56] =1169,
	[57] =1199,
	[58] =1214,
	[59] =1229,
	[60] =1244,
}

local function activate(self, oldLib, oldDeactivate)
	DruidLib = self
	if oldLib then
		oldLib:UnregisterAllEvents()
		oldLib:CancelAllScheduledEvents()
	end
	if oldDeactivate then oldDeactivate(oldLib) end
end

local function external(self, major, instance)
	if major == "AceEvent-2.0" then
		self.SpecialEventScheduler = instance
		self.SpecialEventScheduler:embed(self)
		self:UnregisterAllEvents()
		self:CancelAllScheduledEvents()
		if self.SpecialEventScheduler:IsFullyInitialized() then
			self:AceEvent_FullyInitialized()
			else
			self:RegisterEvent("AceEvent_FullyInitialized", "AceEvent_FullyInitialized", true)
		end
	end
end

local timer = 0
local function DruidLib_OnUpdate()
	timer = timer + arg1
	if lowregentimer > 0 then
		lowregentimer = lowregentimer - arg1
		if lowregentimer <= 0 then
			lowregentimer = 0
		end
	end
	if UnitPowerType("player") ~= 0 then
		fullmanatimer = fullmanatimer + arg1
		if fullmanatimer > 6 and floor((currMana * 100) / maxMana) > 90 then
			currMana = maxMana
			local AceEvent = AceLibrary("AceEvent-2.0")
			AceEvent:TriggerEvent("DruidLib_Manaupdate")
		end
	end
end

function DruidLib:AceEvent_FullyInitialized()
	if playerClass and playerClass == "DRUID" then
		self:RegisterEvent("UNIT_MANA", "OnEvent")
		self:RegisterEvent("UNIT_MAXMANA", "OnEvent")
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "OnEvent")
		self:RegisterEvent("PLAYER_AURAS_CHANGED", "OnEvent")
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS", "OnEvent")
		self:RegisterEvent("SPELLCAST_STOP", "OnEvent")
		currInt = UnitStat("player", 4)
		maxMana = BaseMana[UnitLevel("player")] + 20 + (15 * (currInt - 20))
		currMana = maxMana
		self:MaxManaScript()
		DruidLibOnUpdateFrame:SetScript("OnUpdate", DruidLib_OnUpdate)
		self:TriggerEvent("DruidLib_Enabled")
	end
end

function DruidLib:GetShapeshiftCost()
	subtractMana = 0
	local _, _, c, d = GetSpellTabInfo(4)
	local spelltexture
	for i = 1, c + d, 1 do
		spelltexture = GetSpellTexture(i, BOOKTYPE_SPELL)
		if spelltexture and spelltexture == "Interface\\Icons\\Ability_Racial_BearForm" then
			DruidLibTip:SetSpell(i, 1)
			local msg = DruidLibTipTextLeft2:GetText()
			if msg then
				local params
				_, _, params = strfind(msg, "(%d+) Mana")
				if params then
					subtractMana = tonumber(params)
					if subtractMana and subtractMana > 0 then
						return
					end
				end
			end
		end
	end
end

function DruidLib:MaxManaScript()
	local _, int = UnitStat("player", 4);
	self:GetShapeshiftCost();
	if UnitPowerType("player") == 0 then
		if UnitManaMax("player") > 0 then
			maxMana = UnitManaMax("player");
			currMana = UnitMana("player");
			currInt = int;
			self.SpecialEventScheduler:TriggerEvent("DruidManaLib_Manaupdate")
		end
	elseif UnitPowerType("player") ~= 0 then
		if currInt ~= int then
			if int > currInt then
				local diff = int - currInt;
				maxMana = maxMana + (diff * 15);
				currInt = int;
			elseif int < currInt then
				local diff = currInt - int;
				maxMana = maxMana - (diff * 15);
				currInt = int;
			end
		end
		if currMana > maxMana then
			currMana = maxMana;
		end
	end
	extra = 0;
	for i = 1, 18 do
		DruidLibTip:ClearLines();
		DruidLibTip:SetInventoryItem("player", i);
		for j = 1, DruidLibTip:NumLines() do
			local strchek = getglobal("DruidLibTipTextLeft"..j):GetText();
			if strchek then
				if strfind(strchek, "Equip: Restores %d+ mana per 5 sec.") then
					local num = string.gsub(strchek, "Equip: Restores (%d+) mana per 5 sec.", "%1")
					extra = extra or 0 + tonumber(num or "0")
				end
				if strfind(strchek, "Mana Regen %d+ per 5 sec.") then
					local num = string.gsub(strchek, "Mana Regen (%d+) per 5 sec.", "%1")
					extra = extra or 0 + tonumber(num or "0")
				end
			end
		end
	end
	extra = ceil((extra * 2) / 5)
end

function DruidLib:Subtract()
	local j = 1;
	local icon
	while (UnitBuff("player",j)) do
		icon = UnitBuff("player",j)
		if icon and icon == "Interface\\Icons\\Inv_Misc_Rune_06" then
			return
		end
		j = j + 1
	end
	currMana = currMana - (subtractMana or 0);
	self.SpecialEventScheduler:TriggerEvent("DruidLib_Manaupdate")
end

function DruidLib:ReflectionCheck()
	local managain = 0;
	local j = 1;
	local icon
	while (UnitBuff("player",j)) do
		icon = UnitBuff("player",j)
		if icon and icon == "Interface\\Icons\\Spell_Nature_Lightning" then
			return ((ceil(UnitStat(arg1,5) / 5)+15) * 5);
		end
		j = j + 1;
	end
	if lowregentimer > 0 then 
		if waitonce then
			local _, _, _, _, rank = GetTalentInfo(3, 6);
			if rank == 0 then return 0; else
				managain = ceil(((UnitStat("player",5) / 5)+15) * (0.05 * rank));
			end
		else
			waitonce = true;
		end
	elseif lowregentimer <= 0 then
		managain = (ceil(UnitStat("player",5) / 5)+15);
	end
	return managain;
end

function DruidLib:OnEvent()
	if event == "UNIT_MAXMANA" and arg1 == "player" then
		self:MaxManaScript();
	elseif event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		self:MaxManaScript();
	elseif event == "UNIT_MANA" and arg1 == "player" then
		if UnitPowerType(arg1) == 0 then
			currMana = UnitMana(arg1);
			self.SpecialEventScheduler:TriggerEvent("DruidLib_Manaupdate")
		elseif currMana < maxMana then
			local add = self:ReflectionCheck();
			currMana = currMana + add + extra;
			self.SpecialEventScheduler:TriggerEvent("DruidLib_Manaupdate")
			if currMana > maxMana then currMana = maxMana; end
		end
		fullmanatimer = 0
	elseif event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_SHAPESHIFT_FORMS" then
		if UnitPowerType("player") == 1 and not inform then
			--Bear
			inform = true
			self:Subtract()
		elseif UnitPowerType("player") == 3 and not inform then
			--Cat
			inform = true
			self:Subtract()
		elseif UnitPowerType("player") == 0 and inform then
			inform = nil
			currMana = UnitMana("player")
			maxMana = UnitManaMax("player")
			self.SpecialEventScheduler:TriggerEvent("DruidLib_Manaupdate")
			--player/aqua/travel
		end
	elseif (event == "SPELLCAST_STOP") then
		if UnitPowerType("player") == 0 then
			lowregentimer = 5
			waitonce = nil
		end
	end
end

function DruidLib:GetMana()
	return currMana, maxMana
end

AceLibrary:Register(DruidLib, MAJOR_VERSION, MINOR_VERSION, activate, nil, external)
DruidLib = nil