-- The purpose of this script is to create simple health and mana bars for the player.
local _G = getfenv(0)

-- Registering the addon element
local element = SimpleBars:register({
    title = "Resource Bars",
    description = "Display simple health and mana statusbars.",
    enabled = nil,
})

-- Library reference for Druid-specific functionality
local DruidLib = AceLibrary("DruidManaLib-1.0")
local _, playerClass = UnitClass("player")
-- Function to initialize the element
element.enable = function()
    -- Create main frame for status bars
    local statusbars = CreateFrame("Frame")
    SimpleBars.statusbars = statusbars

    -- Function to initialize frame border
    local function InitializeBorder(parent, borderTexture)
        local border = CreateFrame("Frame", nil, parent)
        border:SetBackdrop({
            edgeFile = borderTexture,
            edgeSize = SimpleBarsDB.borderSize,
        })
        --border:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
        border:SetFrameLevel(4)
        border:EnableMouse(false)
        return border
    end

    -- Health and Mana frame references
    local HealthBar, ManaBar, PetBar = _G["SimpleBarsHealthFrame"], _G["SimpleBarsManaFrame"], _G["SimpleBarsPetFrame"]
    local HealthStatus, ManaStatus, PetStatus = _G["SimpleBars_HealthBar"], _G["SimpleBars_ManaBar"],
        _G["SimpleBars_PetBar"]
    local HealthText, ManaText, PetText = _G["SimpleBars_HealthBarText"], _G["SimpleBars_ManaBarText"],
        _G["SimpleBars_PetBarText"]
    local AltPower, AltPowerText = _G["SimpleBars_AltPower"], _G["SimpleBars_AltPowerText"]
    local healthSettings, manaSettings, petSettings = SimpleBarsDB.healthFrame, SimpleBarsDB.manaFrame,
        SimpleBarsDB.petFrame

    -- Initialize Health Bar
    HealthBar:ClearAllPoints()
    HealthBar:SetPoint(healthSettings.point, UIParent, healthSettings.relativePoint, healthSettings.xOfs,
        healthSettings.yOfs)
    HealthBar:RegisterForDrag("LeftButton")
    HealthBar:SetFrameLevel(3)
    HealthStatus:ClearAllPoints()
    HealthStatus:SetAllPoints(HealthBar)
    HealthStatus:SetMinMaxValues(0, UnitHealthMax("player"))
    HealthStatus:SetStatusBarColor(unpack(healthSettings.statusBarColor))
    HealthStatus:SetFrameLevel(3)
    HealthText:ClearAllPoints()
    HealthText:SetPoint("CENTER", HealthStatus, "CENTER", 0, 0)
    HealthText:SetWidth(SimpleBarsDB.manaFrame.width)
    HealthText:SetFontObject(SimpleBarsCustomFont)
    HealthText:SetJustifyH("CENTER")
    HealthText:Hide()
    HealthBar.border = InitializeBorder(HealthBar, SimpleBarsDB.globalBorder)
    HealthBar.border:SetPoint("CENTER", 0, 0)

    local PlayerFrameDropDown = CreateFrame("Frame", "PlayerFrameDropDown", UIParent)


    local function initPlayerDropDown(self, level)
        UnitPopup_ShowMenu(PlayerFrameDropDown, "SELF", "player")
        if not (UnitInRaid("player") or GetNumPartyMembers() > 0) or UnitIsPartyLeader("player") and PlayerFrameDropDown.init and not CanShowResetInstances() then
            PlayerFrameDropDown.init = nil
        end
    end

    local function ShowMenu()
        if (this.unit == "player") then
            UIDropDownMenu_Initialize(PlayerFrameDropDown, initPlayerDropDown, "MENU")
            PlayerFrameDropDown.init = true
            ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor")
        elseif (this.unit == "pet") then
            ToggleDropDownMenu(1, nil, PetFrameDropDown, "cursor")
        elseif (this.unit == "target") then
            ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
        elseif (this.unitGroup == "party") then
            local partyFrameDropdown = getglobal("PartyMemberFrame" .. string.sub(this.unit, 6) .. "DropDown")
            if partyFrameDropdown then
                ToggleDropDownMenu(1, nil, partyFrameDropdown, "cursor")
            end
        elseif (this.unitGroup == "raid") then
            HideDropDownMenu(1)
            local name = UnitName(this.unit)
            local id = string.sub(this.unit, 5)
            local unit = this.unit
            local menuFrame = FriendsDropDown
            menuFrame.displayMode = "MENU"
            menuFrame.initialize = function() UnitPopup_ShowMenu(getglobal(UIDROPDOWNMENU_OPEN_MENU), "PARTY", unit, name, id) end
            ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
        end
    end

    local function OnClick(button)
        --[[ if arg1 == "UNKNOWN" then
            arg1 =
        end ]]
        --local button = ( IsControlKeyDown() and "Ctrl-" or "" ) .. ( IsShiftKeyDown() and "Shift-" or "" ) .. ( IsAltKeyDown() and "Alt-" or "" ) .. arg1
        if button == "RightButton" then
            this:ShowMenu()
        elseif button == "LeftButton" then
            TargetUnit(this.unit)
        end
    end

    HealthBar:RegisterForClicks('LeftButtonUp', 'RightButtonUp', 'MiddleButtonUp')
    HealthBar.unit = "player"
    HealthBar.ShowMenu = ShowMenu
    HealthBar:SetScript("OnClick", function()
        OnClick(arg1)
    end)
    HealthBar:SetClampedToScreen(1)



    -- Initialize Mana Bar
    ManaBar:ClearAllPoints()
    ManaBar:SetPoint(manaSettings.point, UIParent, manaSettings.relativePoint, manaSettings.xOfs, manaSettings.yOfs)
    ManaBar:RegisterForDrag("LeftButton")
    ManaBar:SetFrameLevel(3)
    ManaStatus:ClearAllPoints()
    ManaStatus:SetAllPoints(ManaBar)
    ManaStatus:SetMinMaxValues(0, UnitManaMax("player"))
    ManaStatus:SetValue(UnitMana("player"))
    ManaStatus:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
    ManaStatus:SetFrameLevel(3)
    ManaText:ClearAllPoints()
    ManaText:SetPoint("CENTER", ManaStatus, "CENTER", 0, 0)
    ManaText:SetWidth(SimpleBarsDB.manaFrame.width)
    ManaText:SetFontObject(SimpleBarsCustomFont)
    ManaText:SetJustifyH("CENTER")
    ManaText:Hide()
    ManaBar.border = InitializeBorder(ManaBar, SimpleBarsDB.globalBorder)
    ManaBar.border:SetPoint("CENTER", 0, 0)


    -- Initialize Pet Bar
    PetBar:ClearAllPoints()
    PetBar:SetPoint(petSettings.point, UIParent, petSettings.relativePoint, petSettings.xOfs, petSettings.yOfs)
    PetBar:RegisterForDrag("LeftButton")
    PetBar:SetFrameLevel(3)
    PetStatus:ClearAllPoints()
    PetStatus:SetAllPoints(PetBar)
    PetStatus:SetMinMaxValues(0, UnitHealthMax("player"))
    PetStatus:SetStatusBarColor(unpack(petSettings.statusBarColor))
    PetStatus:SetFrameLevel(3)
    PetText:SetFontObject(SimpleBarsCustomFont_Pet)
    PetText:Hide()
    PetBar.border = InitializeBorder(PetBar, SimpleBarsDB.globalBorder)
    PetBar.border:SetPoint("CENTER", 0, 0)

    PetBar:RegisterForClicks('LeftButtonUp', 'RightButtonUp', 'MiddleButtonUp')
    PetBar.unit = "pet"
    PetBar.ShowMenu = ShowMenu
    PetBar:SetScript("OnClick", function()
        OnClick(arg1)
    end)
    PetBar:SetClampedToScreen(1)


    AltPower:SetWidth(manaSettings.width / 2)
    AltPower:SetHeight(12)
    AltPower:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
    AltPower:SetFrameLevel(1)
    AltPower:Hide()
    AltPowerText:SetFontObject(SimpleBarsCustomFont_Alt)
    AltPowerText:Hide()

    local bg = AltPower:CreateTexture("$parentBackground", "BACKGROUND")
    bg:SetAllPoints(AltPower)
    bg:SetTexture("Interface\\AddOns\\SimpleBars\\Media\\background.blp")
    bg:SetVertexColor(1, 1, 1, 1)
    AltPower.bg = bg

    local bd = CreateFrame("Frame", "$parentBorder", AltPower)
    bd:SetWidth(manaSettings.width / 2 + SimpleBarsDB.borderInset)
    bd:SetHeight(SimpleBarsDB.altFrame.height + SimpleBarsDB.borderInset)
    bd:SetPoint("CENTER", 0, 0)
    bd:SetBackdrop({
        edgeFile = SimpleBarsDB.globalBorder,
        edgeSize = SimpleBarsDB.borderSize,
    })
    --bd:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
    bd:SetFrameLevel(AltPower:GetFrameLevel() + 1)
    AltPower.bd = bd

    --[[     local bd = AltPower:CreateTexture("$parentBorder", "OVERLAY")
	bd:SetWidth(SimpleBarsDB.manaFrame.width / 2 + 18)
	bd:SetHeight(18)
	bd:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
    bd:SetPoint("CENTER",AltPower, "CENTER", 0, -2)
    bd:SetTexCoord(0.0234375, 0.6875, 1.0, 0.0)
    bd:SetVertexColor(0.25, 0.25, 0.25, 1)
    AltPower.bd = bd ]]


    SetTextStatusBarText(AltPower, AltPowerText)
    AltPower.textLockable = 1
    AltPower.text = AltPowerText

    local function SetupMouseover(frame, text)
        frame:SetScript("OnEnter", function()
            text:Show()
        end)

        frame:SetScript("OnLeave", function()
            text:Hide()
        end)
    end

    if SimpleBarsDB.mouseOverText then
        SetupMouseover(HealthBar, HealthText)
        SetupMouseover(ManaBar, ManaText)
        SetupMouseover(PetBar, PetText)
        SetupMouseover(AltPower, AltPowerText)
    else
        HealthText:Show()
        ManaText:Show()
        PetText:Show()
        AltPowerText:Show()
    end

    local function UpdateAltPowerValue()
        local currMana, maxMana = DruidLib:GetMana()
        AltPower:SetMinMaxValues(0, maxMana)
        AltPower:SetValue(currMana)
        AltPowerText:SetText(currMana .. "/" .. maxMana)
    end

    local function UpdateAltPower()
        if UnitPowerType("player") ~= 0 and playerClass == "DRUID" then
            AltPower:Show()
            bd:SetWidth(manaSettings.width / 2 + SimpleBarsDB.borderInset)
            bd:SetHeight(SimpleBarsDB.altFrame.height + SimpleBarsDB.borderInset)
        else
            AltPower:Hide()
        end
    end


    function AltOnEvent(event)
        if event == "PLAYER_ENTERING_WORLD" then
            UpdateAltPower()
        end
        if event == "PLAYER_AURAS_CHANGED" or event == "SPELLCAST_STOP" then
            UpdateAltPower()
            UpdateAltPowerValue()
        end
        if event == "UNIT_MANA" or event == "UNIT_MAXMANA" then
            UpdateAltPowerValue()
        elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_ENABLED" then
            UpdateAltPowerValue()
        end
    end

    function AltOnUpdate()
        UpdateAltPowerValue()
    end

    -- Function to update health bar values
    function SB_UpdateHealth(statusbar, fontString)
        local currentHealth = UnitHealth("player")
        local maxHealth = UnitHealthMax("player")
        if SimpleBarsDB.useClassColorForHealth then
            local _, class = UnitClass("player")
            local classColor = RAID_CLASS_COLORS[class]
            if classColor then
                statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            end
        else
            statusbar:SetStatusBarColor(unpack(healthSettings.statusBarColor))
        end

        statusbar:SetMinMaxValues(0, maxHealth)
        statusbar:SetValue(currentHealth)
        fontString:SetText(currentHealth .. " / " .. maxHealth)
    end

    -- Function to update mana bar values
    local function UpdateMana(statusbar, fontString)
        local currentMana = UnitMana("player")
        local maxMana = UnitManaMax("player")
        statusbar:SetMinMaxValues(0, maxMana)
        statusbar:SetValue(currentMana)
        fontString:SetText(currentMana .. " / " .. maxMana)
    end

    local function UpdatePet(statusbar, fontString)
        local currHealth = UnitHealth("pet")
        local maxHealth = UnitHealthMax("pet")
        if SimpleBarsDB.useClassColorForHealth then
            local _, class = UnitClass("player")
            local classColor = RAID_CLASS_COLORS[class]
            if classColor then
                statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            end
        else
            statusbar:SetStatusBarColor(unpack(petSettings.statusBarColor))
        end
        statusbar:SetMinMaxValues(0, maxHealth)
        statusbar:SetValue(currHealth)
        fontString:SetText(currHealth .. " / " .. maxHealth)
    end

    local function UpdatePowerType(statusbar)
        local powerType = UnitPowerType("player")
        if powerType == 0 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
        elseif powerType == 3 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.energy))
        elseif powerType == 1 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.rage))
        end
    end


    function SetManaEvent(event)
        if event == "PLAYER_ENTERING_WORLD" then
            UpdatePowerType(ManaStatus)
        elseif event == "UNIT_MANA" or event == "UNIT_MAXMANA" or event == "PLAYER_AURAS_CHANGED" then
            UpdateMana(ManaStatus, ManaText)
            UpdatePowerType(ManaStatus)
        end
        if event == "UNIT_ENERGY" or event == "UNIT_MAXENERGY" then
            UpdateMana(ManaStatus, ManaText)
            UpdatePowerType(ManaStatus)
        end
        if event == "UNIT_RAGE" or event == "UNIT_MAXRAGE" then
            UpdateMana(ManaStatus, ManaText)
            UpdatePowerType(ManaStatus)
        end
    end

    function SetHealthEvent(event)
        if event == "PLAYER_ENTERING_WORLD" then
            SB_UpdateHealth(HealthStatus, HealthText)
        elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "PLAYER_AURAS_CHANGED" then
            SB_UpdateHealth(HealthStatus, HealthText)
        end
    end

    function SetPetEvent(event)
        if event == "PLAYER_ENTERING_WORLD" then
            UpdatePet(PetStatus, PetText)
        elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "PLAYER_AURAS_CHANGED" then
            UpdatePet(PetStatus, PetText)
        end
    end

    -- Update functions to manage bar visibility
    function SB_UpdateHealthVisibility()
        if SimpleBarsDB.enableHealth then
            HealthBar:Show()
        else
            HealthBar:Hide()
        end
        HealthBar:SetWidth(healthSettings.width)
        HealthBar:SetHeight(healthSettings.height)
        HealthBar.border:SetWidth(healthSettings.width + SimpleBarsDB.borderInset)
        HealthBar.border:SetHeight(healthSettings.height + SimpleBarsDB.borderInset)
        SimpleBarsCustomFont:SetFont(SimpleBarsDB.globalFont, SimpleBarsDB.mainFontSize, "")
    end

    function SB_UpdateManaVisibility()
        if SimpleBarsDB.enableMana then
            ManaBar:Show()
        else
            ManaBar:Hide()
        end
        ManaBar:SetWidth(manaSettings.width)
        ManaBar:SetHeight(manaSettings.height)
        ManaBar.border:SetWidth(manaSettings.width + SimpleBarsDB.borderInset)
        ManaBar.border:SetHeight(manaSettings.height + SimpleBarsDB.borderInset)
        AltPower:SetWidth(manaSettings.width / 2)
        AltPower.bd:SetWidth(manaSettings.width / 2 + SimpleBarsDB.borderInset)
        AltPower.bd:SetHeight(SimpleBarsDB.altFrame.height + SimpleBarsDB.borderInset)
        SimpleBarsCustomFont:SetFont(SimpleBarsDB.globalFont, SimpleBarsDB.mainFontSize, "")
        SimpleBarsCustomFont_Alt:SetFont(SimpleBarsDB.globalFont, 12, "")
    end

    function SB_UpdatePetVisibility()
        if SimpleBarsDB.enablePet then
            if playerClass == "HUNTER" or playerClass == "WARLOCK" then
                PetBar:Show()
            else
                PetBar:Hide()
            end
        else
            PetBar:Hide()
        end
        PetBar:SetWidth(petSettings.width)
        PetBar:SetHeight(petSettings.height)
        PetBar.border:SetWidth(petSettings.width + SimpleBarsDB.borderInset)
        PetBar.border:SetHeight(petSettings.height + SimpleBarsDB.borderInset)
        SimpleBarsCustomFont_Pet:SetFont(SimpleBarsDB.globalFont, SimpleBarsDB.petFontSize, "")
    end

    function SB_UpdateFade()
        if SimpleBarsDB.oocFade then
            if UnitAffectingCombat("player") then
                HealthBar:SetAlpha(1)
                ManaBar:SetAlpha(1)
                PetBar:SetAlpha(1)
            else
                HealthBar:SetAlpha(SimpleBarsDB.oocFadeAlpha)
                ManaBar:SetAlpha(SimpleBarsDB.oocFadeAlpha)
                PetBar:SetAlpha(SimpleBarsDB.oocFadeAlpha)
            end
        else
            HealthBar:SetAlpha(1)
            ManaBar:SetAlpha(1)
            PetBar:SetAlpha(1)
        end
    end

    function SB_UpdateBorder()
        local borderDB = SimpleBarsDB.globalBorder
        HealthBar.border:SetBackdrop({
            edgeFile = borderDB,
            edgeSize = SimpleBarsDB.borderSize,
        })
        ManaBar.border:SetBackdrop({
            edgeFile = borderDB,
            edgeSize = SimpleBarsDB.borderSize,
        })
        PetBar.border:SetBackdrop({
            edgeFile = borderDB,
            edgeSize = SimpleBarsDB.borderSize,
        })
        AltPower.bd:SetBackdrop({
            edgeFile = borderDB,
            edgeSize = SimpleBarsDB.borderSize,
        })
        HealthBar.border:SetWidth(healthSettings.width + SimpleBarsDB.borderInset)
        HealthBar.border:SetHeight(healthSettings.height + SimpleBarsDB.borderInset)
        ManaBar.border:SetWidth(manaSettings.width + SimpleBarsDB.borderInset)
        ManaBar.border:SetHeight(manaSettings.height + SimpleBarsDB.borderInset)
        PetBar.border:SetWidth(petSettings.width + SimpleBarsDB.borderInset)
        PetBar.border:SetHeight(petSettings.height + SimpleBarsDB.borderInset)
        AltPower.bd:SetWidth(manaSettings.width / 2 + SimpleBarsDB.borderInset)
        AltPower.bd:SetHeight(SimpleBarsDB.altFrame.height + SimpleBarsDB.borderInset)
    end

    -- Event handling for updating the status bars
    local function OnEvent(self, event)
        SB_UpdateHealthVisibility()
        SB_UpdateManaVisibility()
        SB_UpdatePetVisibility()
        SB_UpdateFade()
    end

    statusbars:RegisterEvent("PLAYER_ENTERING_WORLD")
    statusbars:RegisterEvent("VARIABLES_LOADED")
    statusbars:RegisterEvent("PLAYER_ENTER_COMBAT")
    statusbars:RegisterEvent("PLAYER_LEAVE_COMBAT")
    statusbars:RegisterEvent("PLAYER_REGEN_DISABLED")
    statusbars:RegisterEvent("PLAYER_REGEN_ENABLED")
    statusbars:SetScript("OnEvent", OnEvent)

    SLASH_SIMPLEBARS1 = "/sb"
    SlashCmdList["SIMPLEBARS"] = function(msg)
        msg = string.lower(msg)
        if msg == "" or msg == nil then
            SB_print("SimpleBars Commands:")
            SB_print("/sb config - Opens the addon options configuration")
            SB_print("/sb healthcolor - Toggle class color for health bar")
            SB_print("/sb toggle health - Show/Hide the health bar")
            SB_print("/sb toggle power - Show/Hide the mana bar")
            SB_print("/sb toggle pet - Show/Hide the pet bar")
            SB_print("/sb toggle ooc - Enables fade out of combat situations")
            SB_print("/sb ooc - Sets the fade amount for ooc fading")
            SB_print("/sb health width <value> - Set the width of the health bar")
            SB_print("/sb health height <value> - Set the height of the health bar")
            SB_print("/sb mana width <value> - Set the width of the mana bar")
            SB_print("/sb mana height <value> - Set the height of the mana bar")
            SB_print("/sb pet width <value> - Set the width of the pet bar")
            SB_print("/sb pet height <value> - Set the height of the pet bar")
        elseif msg == "config" then
            SB_ToggleOptions()
        elseif msg == "healthcolor" then
            SimpleBarsDB.useClassColorForHealth = not SimpleBarsDB.useClassColorForHealth
            SB_print("Class color for health bar: " .. (SimpleBarsDB.useClassColorForHealth and "Enabled" or "Disabled"))
            SB_UpdateHealth(HealthStatus, HealthText)
        elseif msg == "toggle health" then
            SimpleBarsDB.enableHealth = not SimpleBarsDB.enableHealth
            SB_print("Health Bar: " .. (SimpleBarsDB.enableHealth and "Enabled" or "Disabled"))
            SB_UpdateHealthVisibility()
        elseif msg == "toggle power" then
            SimpleBarsDB.enableMana = not SimpleBarsDB.enableMana
            SB_print("Mana Bar: " .. (SimpleBarsDB.enableMana and "Enabled" or "Disabled"))
            SB_UpdateManaVisibility()
        elseif msg == "toggle pet" then
            SimpleBarsDB.enablePet = not SimpleBarsDB.enablePet
            SB_print("Pet Bar: " .. (SimpleBarsDB.enablePet and "Enabled" or "Disabled"))
            SB_UpdatePetVisibility()
        elseif msg == "toggle ooc" then
            SimpleBarsDB.oocFade = not SimpleBarsDB.oocFade
            SB_print("Out of Combat fading: " .. (SimpleBarsDB.oocFade and "Enabled" or "Disabled"))
            SB_UpdateFade()
        elseif msg == "reset" then
            SimpleBarsDB = nil
            ReloadUI()
        else
            -- Split command and value manually
            local firstSpace = string.find(msg, " ")
            if firstSpace then
                local command = string.sub(msg, 1, firstSpace - 1)
                local rest = string.sub(msg, firstSpace + 1)

                if command == "health" then
                    -- Find subcommand and value
                    local secondSpace = string.find(rest, " ")
                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))

                        if subCommand == "width" and value then
                            SimpleBarsDB.healthFrame.width = value
                            SB_UpdateHealthVisibility()
                            SB_print("Health Bar width set to " .. value)
                        elseif subCommand == "height" and value then
                            SimpleBarsDB.healthFrame.height = value
                            SB_UpdateHealthVisibility()
                            SB_print("Health Bar height set to " .. value)
                        end
                    end
                elseif command == "mana" then
                    -- Find subcommand and value for mana bar
                    local secondSpace = string.find(rest, " ")
                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))

                        if subCommand == "width" and value then
                            SimpleBarsDB.manaFrame.width = value
                            ManaBar:SetWidth(value)
                            ManaBar.border:SetWidth(value + 14)
                            AltPower:SetWidth(value / 2)
                            AltPower.bd:SetWidth(value / 2 + 12)
                            SB_print("Mana Bar width set to " .. value)
                        elseif subCommand == "height" and value then
                            SimpleBarsDB.manaFrame.height = value
                            ManaBar:SetHeight(value)
                            ManaBar.border:SetHeight(value + 14)
                            _G["SimpleBars_ManaTickSpark"]:SetHeight(SimpleBarsDB.manaFrame.height)
                            SB_print("Mana Bar height set to " .. value)
                        end
                    end
                elseif command == "pet" then
                    local secondSpace = string.find(rest, " ")
                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))

                        if subCommand == "width" and value then
                            SimpleBarsDB.petFrame.width = value
                            PetBar:SetWidth(value)
                            PetBar.border:SetWidth(value + 14)
                            SB_print("Pet Bar width set to " .. value)
                        elseif subCommand == "height" and value then
                            SimpleBarsDB.petFrame.height = value
                            PetBar:SetHeight(value)
                            PetBar.border:SetHeight(value + 14)
                            SB_print("Pet Bar height set to " .. value)
                        end
                    end
                elseif command == "ooc" then
                    local secondSpace = string.find(rest, " ")

                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))
                        if subCommand == "alpha" then
                            if value and value >= 0 and value <= 1 then
                                SimpleBarsDB.oocFadeAlpha = value
                                SB_UpdateFade()
                                SB_print("Out of Combat Alpha: " .. value)
                            else
                                SB_print("Invalid value. Please provide a value between 0.0 and 1.0.")
                            end
                        end
                    end
                end
            end
        end
    end
end
