local L		= DBM_GUI_L
local CL	= DBM_CORE_L

local RaidWarningPanel = DBM_GUI.Cat_Alerts:CreateNewPanel(L.Tab_RaidWarning, "option")

local raidwarnoptions = RaidWarningPanel:CreateArea(L.RaidWarning_Header)

local check1 = raidwarnoptions:CreateCheckButton(L.ShowWarningsInChat, true, nil, "ShowWarningsInChat")
local check2 = raidwarnoptions:CreateCheckButton(L.WarningIconLeft, true, nil, "WarningIconLeft")
local check3 = raidwarnoptions:CreateCheckButton(L.WarningIconRight, true, nil, "WarningIconRight")
local check4 = raidwarnoptions:CreateCheckButton(L.WarningIconChat, true, nil, "WarningIconChat")
local check5 = raidwarnoptions:CreateCheckButton(L.WarningAlphabetical, true, nil, "WarningAlphabetical")
local check6 = raidwarnoptions:CreateCheckButton(L.ShortTextSpellname, true, nil, "WarningShortText")

-- RaidWarn Font
local Fonts = DBM_GUI:MixinSharedMedia3("font", {
	{
		text	= DEFAULT,
		value	= "standardFont"
	},
	{
		text	= "Arial",
		value	= "Fonts\\ARIALN.TTF"
	},
	{
		text	= "Skurri",
		value	= "Fonts\\SKURRI_CYR.ttf"
	},
	{
		text	= "Morpheus",
		value	= "Fonts\\MORPHEUS_CYR.ttf"
	}
})

local FontDropDown = raidwarnoptions:CreateDropdown(L.FontType, Fonts, "DBM", "WarningFont", function(value)
	DBM.Options.WarningFont = value
	DBM:UpdateWarningOptions()
	DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
end)
local isNewDropdown = FontDropDown.mytype == "dropdown2"
FontDropDown:SetPoint("TOPLEFT", check6, "BOTTOMLEFT", isNewDropdown and 5 or 0, isNewDropdown and -15 or -10)

-- RaidWarn Font Style
local FontStyles = {
	{
		text	= L.None,
		value	= "None"
	},
	{
		text	= L.Outline,
		value	= "OUTLINE",
		flag	= true
	},
	{
		text	= L.ThickOutline,
		value	= "THICKOUTLINE",
		flag	= true
	},
	{
		text	= L.MonochromeOutline,
		value	= "MONOCHROME,OUTLINE",
		flag	= true
	},
	{
		text	= L.MonochromeThickOutline,
		value	= "MONOCHROME,THICKOUTLINE",
		flag	= true
	}
}

local FontStyleDropDown = raidwarnoptions:CreateDropdown(L.FontStyle, FontStyles, "DBM", "WarningFontStyle", function(value)
	DBM.Options.WarningFontStyle = value
	DBM:UpdateWarningOptions()
	DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
end)
FontStyleDropDown:SetPoint("TOPLEFT", FontDropDown, "BOTTOMLEFT", 0, isNewDropdown and -15 or -10)

-- RaidWarn Font Shadow
local FontShadow = raidwarnoptions:CreateCheckButton(L.FontShadow, nil, nil, "WarningFontShadow")
FontShadow:SetScript("OnClick", function()
	DBM.Options.WarningFontShadow = not DBM.Options.WarningFontShadow
	DBM:UpdateWarningOptions()
	DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
end)
FontShadow:SetPoint("LEFT", FontStyleDropDown, "RIGHT", 35, 0)

-- RaidWarn Sound
local Sounds = DBM_GUI:MixinSharedMedia3("sound", {
	{
		text	= L.NoSound,
		value	= ""
	},
	{
		text	= "RaidWarning",
		value	= 567397 -- "Sound\\interface\\RaidWarning.ogg"
	},
	{
		text	= "Classic",
		value	= 566558 -- "Sound\\Doodad\\BellTollNightElf.ogg"
	},
	{
		text	= "Ding",
		value	= 567458 -- "Sound\\interface\\AlarmClockWarning3.ogg"
	}
})

local RaidWarnSoundDropDown = raidwarnoptions:CreateDropdown(L.RaidWarnSound, Sounds, "DBM", "RaidWarningSound", function(value)
	DBM.Options.RaidWarningSound = value
end)
RaidWarnSoundDropDown:SetPoint("TOPLEFT", FontStyleDropDown, "BOTTOMLEFT", 0, isNewDropdown and -15 or -10)

-- RaidWarn Font Size
local fontSizeSlider = raidwarnoptions:CreateSlider(L.FontSize, 8, 60, 1, 200)
fontSizeSlider:SetPoint("TOPLEFT", RaidWarnSoundDropDown, "BOTTOMLEFT", isNewDropdown and 5 or 20, -20)
fontSizeSlider:SetValue(DBM.Options.WarningFontSize)
fontSizeSlider:HookScript("OnValueChanged", function(self)
	DBM.Options.WarningFontSize = self:GetValue()
	DBM:UpdateWarningOptions()
	DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
end)

-- RaidWarn Duration
local durationSlider = raidwarnoptions:CreateSlider(L.Warn_Duration, 1, 10, 0.5, 200)
durationSlider:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -30)
durationSlider:SetValue(DBM.Options.WarningDuration2)
durationSlider:HookScript("OnValueChanged", function(self)
	DBM.Options.WarningDuration2 = self:GetValue()
	DBM:UpdateWarningOptions()
	DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
end)

local movemebutton = raidwarnoptions:CreateButton(L.MoveMe, 100, 16)
movemebutton:SetPoint("TOPRIGHT", raidwarnoptions.frame, "TOPRIGHT", -2, -4)
movemebutton:SetNormalFontObject(GameFontNormalSmall)
movemebutton:SetHighlightFontObject(GameFontNormalSmall)
movemebutton:SetScript("OnClick", function()
	DBM:MoveWarning()
end)

local resetbutton = raidwarnoptions:CreateButton(L.SpecWarn_ResetMe, 120, 16)
resetbutton:SetPoint("BOTTOMRIGHT", raidwarnoptions.frame, "BOTTOMRIGHT", -2, 4)
resetbutton:SetNormalFontObject(GameFontNormalSmall)
resetbutton:SetHighlightFontObject(GameFontNormalSmall)
resetbutton:SetScript("OnClick", function()
	-- Set Options
	DBM.Options.ShowWarningsInChat = DBM.DefaultOptions.ShowWarningsInChat
	DBM.Options.WarningIconLeft = DBM.DefaultOptions.WarningIconLeft
	DBM.Options.WarningIconRight = DBM.DefaultOptions.WarningIconRight
	DBM.Options.WarningIconChat = DBM.DefaultOptions.WarningIconChat
	DBM.Options.WarningAlphabetical = DBM.DefaultOptions.WarningAlphabetical
	DBM.Options.WarningShortText = DBM.DefaultOptions.WarningShortText
	DBM.Options.WarningFont = DBM.DefaultOptions.WarningFont
	DBM.Options.FontStyles = DBM.DefaultOptions.FontStyles
	DBM.Options.WarningFontSize = DBM.DefaultOptions.WarningFontSize
	DBM.Options.WarningDuration2 = DBM.DefaultOptions.WarningDuration2
	DBM.Options.WarningFontShadow = DBM.DefaultOptions.WarningFontShadow
	DBM.Options.RaidWarningSound = DBM.DefaultOptions.RaidWarningSound
	DBM.Options.WarningPoint = DBM.DefaultOptions.WarningPoint
	DBM.Options.WarningX = DBM.DefaultOptions.WarningX
	DBM.Options.WarningY = DBM.DefaultOptions.WarningY
	-- Set UI visuals
	check1:SetChecked(DBM.Options.ShowWarningsInChat)
	check2:SetChecked(DBM.Options.WarningIconLeft)
	check3:SetChecked(DBM.Options.WarningIconRight)
	check4:SetChecked(DBM.Options.WarningIconChat)
	check5:SetChecked(DBM.Options.WarningAlphabetical)
	check6:SetChecked(DBM.Options.WarningShortText)
	FontDropDown:SetSelectedValue(DBM.Options.WarningFont)
	FontStyleDropDown:SetSelectedValue(DBM.Options.FontStyles)
	fontSizeSlider:SetValue(DBM.DefaultOptions.WarningFontSize)
	durationSlider:SetValue(DBM.DefaultOptions.WarningDuration2)
	FontShadow:SetChecked(DBM.Options.WarningFontShadow)
	RaidWarnSoundDropDown:SetSelectedValue(DBM.Options.RaidWarningSound)
	DBM:UpdateWarningOptions()
end)

--Raid Warning Colors
local raidwarncolors = RaidWarningPanel:CreateArea(L.RaidWarnColors)

local color1 = raidwarncolors:CreateColorSelect(L.RaidWarnColor_1, function(_, r, g, b)
	DBM.Options.WarningColors[1].r = r
	DBM.Options.WarningColors[1].g = g
	DBM.Options.WarningColors[1].b = b
end, function(self)
	self:SetColorRGB(DBM.DefaultOptions.WarningColors[1].r, DBM.DefaultOptions.WarningColors[1].g, DBM.DefaultOptions.WarningColors[1].b, true)
end)
local color2 = raidwarncolors:CreateColorSelect(L.RaidWarnColor_2, function(_, r, g, b)
	DBM.Options.WarningColors[2].r = r
	DBM.Options.WarningColors[2].g = g
	DBM.Options.WarningColors[2].b = b
end, function(self)
	self:SetColorRGB(DBM.DefaultOptions.WarningColors[2].r, DBM.DefaultOptions.WarningColors[2].g, DBM.DefaultOptions.WarningColors[2].b, true)
end)
local color3 = raidwarncolors:CreateColorSelect(L.RaidWarnColor_3, function(_, r, g, b)
	DBM.Options.WarningColors[3].r = r
	DBM.Options.WarningColors[3].g = g
	DBM.Options.WarningColors[3].b = b
end, function(self)
	self:SetColorRGB(DBM.DefaultOptions.WarningColors[3].r, DBM.DefaultOptions.WarningColors[3].g, DBM.DefaultOptions.WarningColors[3].b, true)
end)
local color4 = raidwarncolors:CreateColorSelect(L.RaidWarnColor_4, function(_, r, g, b)
	DBM.Options.WarningColors[4].r = r
	DBM.Options.WarningColors[4].g = g
	DBM.Options.WarningColors[4].b = b
end, function(self)
	self:SetColorRGB(DBM.DefaultOptions.WarningColors[4].r, DBM.DefaultOptions.WarningColors[4].g, DBM.DefaultOptions.WarningColors[4].b, true)
end)

color2.myheight = 0
color3.myheight = 0
color4.myheight = 0

color1:SetPoint("TOPLEFT", 20, -10)
color2:SetPoint("TOPLEFT", color1, "TOPRIGHT", 20, 0)
color3:SetPoint("TOPLEFT", color2, "TOPRIGHT", 20, 0)
color4:SetPoint("TOPLEFT", color3, "TOPRIGHT", 20, 0)

color1:SetColorRGB(DBM.Options.WarningColors[1].r, DBM.Options.WarningColors[1].g, DBM.Options.WarningColors[1].b)
color2:SetColorRGB(DBM.Options.WarningColors[2].r, DBM.Options.WarningColors[2].g, DBM.Options.WarningColors[2].b)
color3:SetColorRGB(DBM.Options.WarningColors[3].r, DBM.Options.WarningColors[3].g, DBM.Options.WarningColors[3].b)
color4:SetColorRGB(DBM.Options.WarningColors[4].r, DBM.Options.WarningColors[4].g, DBM.Options.WarningColors[4].b)

local infotext = raidwarncolors:CreateText(L.InfoRaidWarning, nil, false, GameFontNormalSmall)
infotext:SetPoint("BOTTOMLEFT", raidwarncolors.frame, "BOTTOMLEFT", 10, 10)
