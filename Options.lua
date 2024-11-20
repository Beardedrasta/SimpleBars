SimpleBars_colors = {}
SimpleBars_options = {}

local CLASS_COLORS = {
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, hex = "C79C6E" },
    ["MAGE"] = { r = 0.41, g = 0.80, b = 0.94, hex = "69CCF0" },
    ["ROGUE"] = { r = 1.00, g = 0.96, b = 0.41, hex = "FFF569" },
    ["DRUID"] = { r = 1.00, g = 0.49, b = 0.04, hex = "FF7D0A" },
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, hex = "ABD473" },
    ["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, hex = "0070DE" },
    ["PRIEST"] = { r = 1.00, g = 1.00, b = 1.00, hex = "FFFFFF" },
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, hex = "9482C9" },
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, hex = "F58CBA" }
}

local _, class = UnitClass("player")
local classColor = CLASS_COLORS[class]
local classColorNorm = RAID_CLASS_COLORS[class]
local _G = getfenv(0)

local reset = {
    config = function()
        local dialog = StaticPopupDialogs["SIMPLEBARS_RESET"]
        dialog.text = "Confirm that you want to reset the options to default?"
        dialog.OnAccept = function()
            SimpleBars_options = nil
            SimpleBarsDB = nil
            ReloadUI()
        end

        StaticPopup_Show("SIMPLEBARS_RESET")
    end
}

SimpleBars_defaultOpt = {
    { text = "Toggles",    default = nil, type = "header" },

    {
        text = "Enable Class Color",
        default = true,
        type = "checkbox",
        config = "useClassColorForHealth",
        func = function()
            SB_UpdateHealth(_G["SimpleBars_HealthBar"], _G["SimpleBars_HealthBarText"])
        end
    },
    {
        text = "Enable Health Display",
        default = true,
        type = "checkbox",
        config = "enableHealth",
        func = function()
            SB_UpdateHealthVisibility()
        end
    },
    {
        text = "Enable Power Display",
        default = true,
        type = "checkbox",
        config = "enableMana",
        func = function()
            SB_UpdateManaVisibility()
        end
    },
    {
        text = "Enable Pet Display",
        default = true,
        type = "checkbox",
        config = "enablePet",
        func = function()
            SB_UpdatePetVisibility()
        end
    },
    {
        text = "Enable Combat Fading",
        default = true,
        type = "checkbox",
        config = "oocFade",
        func = function()
            SB_UpdateFade()
        end
    },
    {
        text = "Enable Text Mouseover",
        default = true,
        type = "checkbox",
        config = "mouseOverText",
        func = function()
            --SB_UpdateFade()
        end
    },

    { text = "Appearance", default = nil, type = "header" },

    {
        text = "Out of Combat Alpha",
        default = "1",
        type = "text",
        config = "oocFadeAlpha",
        key = nil,
        func = function()
            SB_UpdateFade()
        end
    },
    {
        text = "Health Bar Height",
        default = "20",
        type = "text",
        config = "healthFrame",
        key = "height",
        func = function()
            SB_UpdateHealthVisibility()
        end
    },
    {
        text = "Health Bar Width",
        default = "150",
        type = "text",
        config = "healthFrame",
        key = "width",
        func = function()
            SB_UpdateHealthVisibility()
        end
    },
    {
        text = "Power Bar Height",
        default = "20",
        type = "text",
        config = "manaFrame",
        key = "height",
        func = function()
            SB_UpdateManaVisibility()
        end
    },
    {
        text = "Power Bar Width",
        default = "150",
        type = "text",
        config = "manaFrame",
        key = "width",
        func = function()
            SB_UpdateManaVisibility()
        end
    },
    {
        text = "Pet Bar Height",
        default = "20",
        type = "text",
        config = "petFrame",
        key = "height",
        func = function()
            SB_UpdatePetVisibility()
        end
    },
    {
        text = "Pet Bar Width",
        default = "75",
        type = "text",
        config = "petFrame",
        key = "width",
        func = function()
            SB_UpdatePetVisibility()
        end
    },

    { text = "Global", default = nil, type = "header" },

    {
        text = "Font Select",
        default = "",
        type = "dropdown_font",
        config = "globalFont",
        func = function()
            SB_UpdateHealthVisibility()
            SB_UpdateManaVisibility()
        end
    },
    {
        text = "Main Bars Text Size",
        default = "14",
        type = "text",
        config = "mainFontSize",
        key = nil,
        func = function()
            SB_UpdateHealthVisibility()
            SB_UpdateManaVisibility()
        end
    },
    {
        text = "Pet Bar Text Size",
        default = "12",
        type = "text",
        config = "petFontSize",
        key = nil,
        func = function()
            SB_UpdatePetVisibility()
        end
    },
    {
        text = "Border Select",
        default = "",
        type = "dropdown_border",
        config = "globalBorder",
        func = function()
            SB_UpdateBorder()
        end
    },
    {
        text = "Border Size",
        default = "14",
        type = "text",
        config = "borderSize",
        key = nil,
        func = function()
            SB_UpdateBorder()
        end
    },
    {
        text = "Border Inset",
        default = "14",
        type = "text",
        config = "borderInset",
        key = nil,
        func = function()
            SB_UpdateBorder()
        end
    },
}

StaticPopupDialogs["SIMPLEBARS_RESET"] = {
    button1 = CONFIRM,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
}

SimpleBarsOptions = CreateFrame("Frame", "SimpleBarsOptions", UIParent)
local opt = SimpleBarsOptions

opt:Hide()
opt:SetWidth(280)
opt:SetHeight(550)
opt:SetPoint("CENTER", 0, 0)
opt:SetFrameStrata("HIGH")
opt:SetMovable(true)
opt:EnableMouse(true)
opt:SetClampedToScreen(true)
opt:RegisterEvent("ADDON_LOADED")
opt:RegisterEvent("PLAYER_ENTERING_WORLD")
opt:SetScript("OnEvent", function()
    if arg1 == "SimpleBars" then
        opt:LoadConfig()
        opt:CreateOptionsEntries(SimpleBars_defaultOpt)


        if sbBrowserIcon and SimpleBars_options["minimapbutton"] == "0" then
            sbBrowserIcon:Hide()
        end
    end
    SimpleBars.api.CreateBackdrop(opt, nil, true, 1)
    SimpleBars.api.SkinButton(opt.close, 1, .5, .5)
    SimpleBars.api.SkinButton(opt.save)
end)

opt:SetScript("OnMouseDown", function()
    this:StartMoving()
end)

opt:SetScript("OnMouseUp", function()
    this:StopMovingOrSizing()
end)

opt:SetScript("OnShow", function()
    this:UpdateOptionsEntries()
end)

opt.vertPos = 40
table.insert(UISpecialFrames, "SimpleBarsOptions")

local _, title = GetAddOnInfo("SimpleBars")
if title then
    opt.path = "Interface\\AddOns\\SimpleBars"
    opt.version = tostring(GetAddOnMetadata("SimpleBars", "Version"))
end

opt.title = opt:CreateFontString("Status", "LOW", "GameFontNormal")
opt.title:SetFontObject(GameFontWhite)
opt.title:SetPoint("TOP", opt, "TOP", 0, -12)
opt.title:SetJustifyH("LEFT")
opt.title:SetFont(STANDARD_TEXT_FONT, 14)
opt.title:SetText("|cff" .. classColor.hex .. "SimpleBars|r Options")
opt.texture = opt:CreateTexture("SimpleBarsTitleTex", "ARTWORK", nil, 0)
opt.texture:SetTexture("Interface\\AddOns\\SimpleBars\\Media\\header.blp")
opt.texture:ClearAllPoints()
opt.texture:SetPoint("TOPLEFT", opt, "TOPLEFT", 10, -10)
opt.texture:SetPoint("TOPRIGHT", opt, "TOPRIGHT", -10, -10)
opt.texture:SetHeight(20)

opt.close = CreateFrame("Button", "SimpleBarsOptionsClose", opt)
opt.close:SetPoint("TOPRIGHT", opt, "TOPRIGHT", -4, -6)
opt.close:SetWidth(28)
opt.close:SetHeight(28)
opt.close.texture = opt.close:CreateTexture("SimpleBarsDialogCloseTex")
opt.close.texture:SetTexture("Interface\\AddOns\\SimpleBars\\Media\\close.blp")
opt.close.texture:ClearAllPoints()
opt.close.texture:SetPoint("TOPLEFT", opt.close, "TOPLEFT", 8, -8)
opt.close.texture:SetPoint("BOTTOMRIGHT", opt.close, "BOTTOMRIGHT", -8, 8)
opt.close.texture:SetVertexColor(1, .25, .25, 1)
opt.close:SetScript("OnClick", function()
    this:GetParent():Hide()
end)

opt.save = CreateFrame("Button", "SimpleBarsOptionsSave", opt)
opt.save:SetWidth(160)
opt.save:SetHeight(32)
opt.save:SetPoint("BOTTOM", 0, 10)
opt.save:SetScript("OnClick", ReloadUI)
opt.save.text = opt.save:CreateFontString("Caption", "LOW", "GameFontWhite")
opt.save.text:SetAllPoints(opt.save)
opt.save.text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
opt.save.text:SetText("Confirm & Reload")

function opt:LoadConfig()
    if not SimpleBarsDB then
        SimpleBarsDB = {}
    end
    for id, data in pairs(SimpleBars_defaultOpt) do
        if data.config and SimpleBarsDB[data.config] == nil then
            SimpleBarsDB[data.config] = data.default
        end
    end
end

local maxHeight, maxWidth = 0, 0
local width, height = 230, 29
local maxText = 130
local configFrames = {}
function opt:CreateOptionsEntries(config)
    local count = 1
    for _, data in pairs(config) do
        if data.type then
            local frame = CreateFrame("Frame", "SimpleBarsOptions" .. count, opt)
            configFrames[data.text] = frame

            frame.caption = frame:CreateFontString("Status", "LOW", "GameFontWhite")
            frame.caption:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            frame.caption:SetPoint("LEFT", 20, 0)
            frame.caption:SetJustifyH("LEFT")
            frame.caption:SetText(data.text)
            maxText = max(maxText, frame.caption:GetStringWidth())

            if data.type == "header" then
                frame.caption:SetPoint("LEFT", 10, 0)
                frame.caption:SetTextColor(classColorNorm.r, classColorNorm.g, classColorNorm.b)
                frame.caption:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
            elseif data.type == "checkbox" then
                frame.input = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
                --frame.input:SetNormalTexture("")
                --frame.input:SetPushedTexture("")
                --frame.input:SetHighlightTexture("")
                SimpleBars.api.CreateBackdrop(frame.input, nil, true)

                frame.input:SetWidth(25)
                frame.input:SetHeight(25)
                frame.input:SetPoint("RIGHT", -20, 0)

                frame.input.config = data.config
                frame.input.func = data.func
                if SimpleBarsDB[data.config] == true then
                    frame.input:SetChecked()
                end

                frame.input:SetScript("OnClick", function()
                    SimpleBarsDB[frame.input.config] = not SimpleBarsDB[frame.input.config]
                    if SimpleBarsDB[frame.input.config] == true then
                        SimpleBarsDB[frame.input.config] = true
                    else
                        SimpleBarsDB[frame.input.config] = false
                    end
                    if this.func and type(this.func) == "function" then
                        this.func()
                    end
                    --SimpleBars:ResetAll()
                end)
            elseif data.type == "text" then
                frame.input = CreateFrame("EditBox", nil, frame)
                frame.input:SetTextColor(classColorNorm.r, classColorNorm.g, classColorNorm.b)
                frame.input:SetJustifyH("RIGHT")
                frame.input:SetTextInsets(5, 5, 5, 5)
                frame.input:SetWidth(32)
                frame.input:SetHeight(16)
                frame.input:SetPoint("RIGHT", -20, 0)
                frame.input:SetFontObject(GameFontNormal)
                frame.input:SetAutoFocus(false)
                frame.input:SetMaxLetters(3)
                frame.input.config = data.config
                frame.input.func = data.func
                frame.input.key = data.key

                if data.key then
                    frame.input:SetText(tostring(SimpleBarsDB[frame.input.config][frame.input.key]))
                else
                    frame.input:SetText(tostring(SimpleBarsDB[frame.input.config]))
                end

                frame.input:SetScript("OnEscapePressed", function(self)
                    this:ClearFocus()
                end)

                frame.input:SetScript("OnTextChanged", function(self)
                    local newValue = tonumber(this:GetText())
                    if newValue then
                        if this.key then
                            SimpleBarsDB[this.config][this.key] = newValue
                        else
                            SimpleBarsDB[this.config] = newValue
                        end
                    end
                    if this.func and type(this.func) == "function" then
                        this.func()
                    end
                end)

                frame.input:SetScript("OnEnterPressed", function()
                    this:ClearFocus()
                end)

                local b = CreateFrame("Frame", nil, frame.input)
                b:SetPoint("TOPLEFT", frame.input, "TOPLEFT", -15, 8)
                b:SetPoint("BOTTOMRIGHT", frame.input, "BOTTOMRIGHT", 7, -10)
                b:SetBackdrop({
                    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                    edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\Border\\border.blp",
                    tile = false,
                    tileSize = 16,
                    edgeSize = 16,
                    insets = { left = 8, right = 8, top = 8, bottom = 8 }
                })
                b:SetBackdropColor(0.25, 0.25, 0.25, 1)
                b:SetBackdropBorderColor(.4, .4, .4, 1)
                b:SetFrameLevel(frame.input:GetFrameLevel() - 1)
            elseif data.type == "dropdown_font" then
                frame.input = CreateFrame("Frame", "SimpleBarsFontDropdown" .. tostring(math.random(1000)), frame,
                    "UIDropDownMenuTemplate")
                frame.input:SetPoint("RIGHT", frame, "RIGHT", -115, 0)
                frame.input.config = data.config
                frame.input.func = data.func

                UIDropDownMenu_Initialize(frame.input, function(self, level)
                    local fontNames = {}
                    for fontName in pairs(SimpleBarsDB.fonts) do
                        table.insert(fontNames, fontName)
                    end
                    table.sort(fontNames)
                    for _, fontName in ipairs(fontNames) do
                        local fontPath = SimpleBarsDB.fonts[fontName]
                        local info = {}
                        info.text = fontName
                        info.value = fontPath
                        info.func = function()
                            -- Save the selected font to the database
                            SimpleBarsDB[frame.input.config] = info.value
            
                            -- Set the selected value in the dropdown
                            UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB[frame.input.config])
            
                            -- Call the provided function if it exists
                            frame.input.func()
                        end
            
                        UIDropDownMenu_AddButton(info, level)
                    end
                end)
                if SimpleBarsDB[data.config] then
                    UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB[data.config])
                else
                    UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB.fonts["Blank"]) -- Set to default value
                end
            elseif data.type == "dropdown_border" then
                frame.input = CreateFrame("Frame", "SimpleBarsBorderDropdown" .. tostring(math.random(1000)), frame,
                    "UIDropDownMenuTemplate")
                frame.input:SetPoint("RIGHT", frame, "RIGHT", -115, 0)
                frame.input.config = data.config
                frame.input.func = data.func

                UIDropDownMenu_Initialize(frame.input, function(self, level)
                    local borderNames = {}
                    for borderName in pairs(SimpleBarsDB.borders) do
                        table.insert(borderNames, borderName)
                    end
                    table.sort(borderNames)

                    for _, borderName in ipairs(borderNames) do
                        local borderPath = SimpleBarsDB.borders[borderName]
                        SB_print("Adding border:", borderName, borderPath)
            
                        if borderName and borderPath then
                            local info = {}
                            info.text = borderName
                            info.value = borderPath
                            info.func = function()
                                -- Save the selected border to the database
                                SimpleBarsDB[frame.input.config] = info.value
            
                                -- Set the selected value in the dropdown
                                UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB[frame.input.config])
            
                                -- Call the provided function if it exists
                                if frame.input.func then
                                    frame.input.func()
                                end
                            end
            
                            UIDropDownMenu_AddButton(info, level)
                        else
                            SB_print("Error: Missing border data - borderName:", borderName, " borderPath:", borderPath)
                        end
                    end
                end)
                if SimpleBarsDB[data.config] then
                    UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB[data.config])
                else
                    UIDropDownMenu_SetSelectedValue(frame.input, SimpleBarsDB.borders["Simple"]) -- Set to default value
                end
            end

            if frame.input and SimpleBars.api.emulated then
                frame.input:SetWidth(frame.input:GetWidth() / .6)
                frame.input:SetHeight(frame.input:GetHeight() / .6)
                frame.input:SetScale(.8)
                if frame.input.SetTextInsets then
                    frame.input:SetTextInsets(8, 8, 8, 8)
                end
            end
            count = count + 1
        end
    end

    width = maxText + 100
    local column, row = 1, 0
    for _, data in pairs(config) do
        if data.type then
            row = row + (data.type == "header" and row > 1 and 2 or 1)
            if row > 20 and data.type == "header" then
                column, row = column + 1, 1
            end

            maxWidth, maxHeight = max(maxWidth, column), max(maxHeight, row)

            local spacer = (column - 1) * 20
            local x, y = (column - 1) * width, -(row - 1) * height
            local frame = configFrames[data.text]
            frame:SetWidth(width)
            frame:SetHeight(height)
            frame:SetPoint("TOPLEFT", opt, "TOPLEFT", x + spacer + 10, y - 40)
        end
    end
    local spacer = (maxWidth - 1) * 20
    opt:SetWidth(maxWidth * width + spacer + 20)
    opt:SetHeight(maxHeight * height + 100)
end

function opt:UpdateOptionsEntries()
    for _, data in pairs(SimpleBars_defaultOpt) do
        if data.type and configFrames[data.text] then
            if data.type == "checkbox" then
                configFrames[data.text].input:SetChecked((SimpleBarsDB[data.config] == true and true or nil))
            elseif data.type == "text" then
                if data.key then
                    configFrames[data.text].input:SetText(tostring(SimpleBarsDB[configFrames[data.text].input.config]
                    [configFrames[data.text].input.key]))
                else
                    configFrames[data.text].input:SetText(tostring(SimpleBarsDB[configFrames[data.text].input.config]))
                end
            end
        end
    end
end
