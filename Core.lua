SimpleBars = CreateFrame("Frame")
SimpleBars.elements = {}
SimpleBars.api = {}

local function round(input, places)
    if not places then places = 0 end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return floor(input * pow + 0.5) / pow
    end
end

SimpleBars.round = round

local defaults = {
    manaFrame = {
        width = 150,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = -220,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = {
            mana = { 0.33, 0.61, 0.78 },
            energy = { 0.85, 0.65, 0.27 },
            rage = { 0.68, 0.33, 0.33 }

        },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    healthFrame = {
        width = 150,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = -200,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = { 0.33, 0.68, 0.33 },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    petFrame = {
        width = 75,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = -150,
        yOfs = -200,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = { 0.33, 0.68, 0.33 },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    textures = {
        "Interface\\BUTTONS\\WHITE8X8",
        "Interface\\TargetingFrame\\UI-StatusBar",
        "Interface\\Tooltips\\UI-Tooltip-Background",
        "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
    },
    fonts = {
        Blank = "Interface\\AddOns\\SimpleBars\\Media\\Font\\AdbobeBlank.ttf",
        BigNoodle = "Interface\\AddOns\\SimpleBars\\Media\\Font\\BigNoodleTitling.ttf",
        Continuum = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Continuum.ttf",
        DieDieDie = "Interface\\AddOns\\SimpleBars\\Media\\Font\\DieDieDie.ttf",
        Expressway = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf",
        Homespun = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Homespun.ttf",
        Hooge = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Hooge.ttf",
        MyriadPro = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Myriad-Pro.ttf",
        PTSansNarrowBold = "Interface\\AddOns\\SimpleBars\\Media\\Font\\PT-Sans-Narrow-Bold.ttf",
        PTSansNarrowRegular = "Interface\\AddOns\\SimpleBars\\Media\\Font\\PT-Sans-Narrow-Regular.ttf",
        RobotoMono = "Interface\\AddOns\\SimpleBars\\Media\\Font\\RobotoMono.ttf"
    },
    globalFont = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf",
    oocFade = false,
    oocFadeAlpha = 0.5,
    enableHealth = true,
    enableMana = true,
    enablePet = true,
    useClassColorForHealth = true,
    mouseOverText = true,
    appearance = {
        border = {
            default = 3,
        }
    },
}

local function UpdateSettings()
	if not SimpleBarsDB then SimpleBarsDB = {} end
	for option, value in defaults do
		if SimpleBarsDB[option] == nil then
			SimpleBarsDB[option] = value
		end
	end
end

SimpleBars:RegisterEvent("VARIABLES_LOADED")
SimpleBars:RegisterEvent("PLAYER_LOGOUT")
SimpleBars:SetScript("OnEvent", function(event)
    UpdateSettings()

    for title, element in pairs(SimpleBars.elements) do
        if not SimpleBarsDB[title] then
            SimpleBarsDB[title] = element.enabled and 1 or 0
        end

        element:enable()
    end

    if event == "PLAYER_LOGOUT" then
        UpdateSettings()
    end 
end)


SimpleBars.register = function(_, element)
    SimpleBars.elements[element.title] = element
    return SimpleBars.elements[element.title]
end

function SB_print(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
end

local sbR, sbG, sbB, sbA = .4, .4, .4, 1
local bdR, bdG, bdB, bdA = 0.8, 0.8, 0.8, 1
SimpleBars.api.CreateBackdrop = SimpleBars.api.CreateBackdrop or function(frame, inset, legacy, transparent)
    if not frame then
        return
    end

    local border = inset
    if not border then
        border = 3
    end

    if transparent then
        bdA = transparent
    end

    if legacy then
        frame:SetBackdrop({
            bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
            edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\thick-border.blp",
            tile = false, tileSize = 16, edgeSize = 16,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }})
        frame:SetBackdropColor(bdR, bdG, bdB, bdA)
        frame:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
    else
        frame:SetBackdrop({
            bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
            edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\border.blp",
            tile = false, tileSize = 16, edgeSize = 16,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }})
        frame:SetBackdropColor(bdR, bdG, bdB, bdA)
        frame:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
    end

    if frame.SetHitRectInsets then
        frame:SetHitRectInsets(-border, -border, -border, -border)
    end

    if not frame.backdrop then
        frame:SetBackdrop(nil)

        local border = border - 1
        local backdrop 
        if border < 1 then
            backdrop = {
                bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
                edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\thick-border.blp",
                tile = false, tileSize = 16, edgeSize = 16,
                insets = { left = 8, right = 8, top = 8, bottom = 8 }
            }
        end
        local b = CreateFrame("Frame", nil, frame)
        b:SetPoint("TOPLEFT", frame, "TOPLEFT", -border, border)
        b:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", border, -border)

        local level = frame:GetFrameLevel()
        if level < 1 then
            b:SetFrameLevel(level)
        else
            b:SetFrameLevel(level - 1)
        end

        frame.backdrop = b
        b:SetBackdrop(backdrop)
    end

    local b = frame.backdrop
    b:SetBackdropColor(bdR, bdG, bdB, bdA)
    b:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
end

SimpleBars.api.SetButtonFont = SimpleBars.api.SetButtonFont or function(button, font, size, flags)
    if button.SetFont then
        button:SetFont(font, size, flags)
    else
        local buttonText = button:GetFontString()
        if buttonText then
            buttonText:SetFont(font, size, flags)
        else
            buttonText = button:CreateFontString(nil, "OVERLAY")
            buttonText:SetFont(font, size, flags)
            buttonText:SetPoint("CENTER", button, "CENTER")
            button:SetFontString(buttonText)
        end
    end
end

SimpleBars.api.SkinButton = SimpleBars.api.SkinButton or function(button, colorR, colorG, colorB)
    local b = getglobal(button)
    if not b then
        b = button
    end
    if not b then
        return
    end
    if not colorR or not colorG or not colorB then
        _, class = UnitClass("player")
        local color = RAID_CLASS_COLORS[class]
        colorR, colorG, colorB = color.r, color.g, color.b
    end
    SimpleBars.api.CreateBackdrop(b, nil, false)
    b:SetNormalTexture(nil)
    b:SetHighlightTexture(nil)
    b:SetPushedTexture(nil)
    b:SetDisabledTexture(nil)
    b:SetScript("OnEnter", function()
        SimpleBars.api.CreateBackdrop(b, nil, false)
        b:SetBackdropBorderColor(colorR, colorG, colorB, 1)
    end)
    b:SetScript("OnLeave", function()
        SimpleBars.api.CreateBackdrop(b, nil, false)
    end)
    SimpleBars.api.SetButtonFont(b, STANDARD_TEXT_FONT, 12, "OUTLINE")
end

SimpleBarsCustomFont = CreateFont("SimpleBarsCustomFont_Main")
SimpleBarsCustomFont:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 14, "")
SimpleBarsCustomFont:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont:SetShadowOffset(1, -1)

SimpleBarsCustomFont_Alt = CreateFont("SimpleBarsCustomFont_Alt")
SimpleBarsCustomFont_Alt:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 12, "")
SimpleBarsCustomFont_Alt:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont_Alt:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont_Alt:SetShadowOffset(1, -1)

SimpleBarsCustomFont_Pet = CreateFont("SimpleBarsCustomFont_Pet")
SimpleBarsCustomFont_Pet:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 12, "")
SimpleBarsCustomFont_Pet:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont_Pet:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont_Pet:SetShadowOffset(1, -1)

function SB_ToggleOptions()
    if SimpleBarsOptions:IsShown() then
        SimpleBarsOptions:Hide()
    else
        SimpleBarsOptions:Show()
    end
end