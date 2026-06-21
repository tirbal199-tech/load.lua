-- [[ GT6 NEXT GEN UI FRAMEWORK - COMPLETE INTEGRATED EDITION ]] --
-- المطور: تيربال تيك (tirbal199-tech)
-- يدمج الهيكل الرسومي الفاخر مع المحرك المنطقي، مفاتيح الاختصار، والاتصال بـ Supabase API

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- التكوين الأساسي
local CONFIG = {
	Version = "6.0.0",
	Status = "ONLINE",
	API_URL = "https://wgabznguajgfrcfudgtc.supabase.co/functions/v1/script-config"
}

-- حالة الواجهة البرمجية (UI State)
local state = {
	currentTab = "AIMBOT",
	toggles = {
		AimAssist = false,
		AntiBan = true,
		SuperSpeed = false,
		WeatherControl = false,
		AlwaysDay = false,
		EspVisuals = false,
		PlayerTracker = false,
		AiPrediction = false,
		AdaptiveAim = false,
		AutoCollect = false,
		EnableFlight = false
	},
	sliders = {
		Sensitivity = 85,
		FOVRange = 120,
		SpeedModifier = 50,
		MenuScale = 100,
		FlySpeed = 25
	},
	visible = true
}

-- مصفوفة الألوان النيون (ثيم الصورة الفاخرة)
local Theme = {
	Background = Color3.fromRGB(12, 13, 20),
	DarkFrame = Color3.fromRGB(18, 19, 30),
	CardBg = Color3.fromRGB(25, 26, 42),
	NeonCyan = Color3.fromRGB(0, 162, 255),
	NeonPurple = Color3.fromRGB(100, 50, 255),
	NeonGreen = Color3.fromRGB(0, 255, 120),
	TextWhite = Color3.fromRGB(255, 255, 255),
	TextMuted = Color3.fromRGB(150, 150, 170)
}

-- جلب وتأكيد حماية السيرفر الخارجي
local function fetchServerConfig()
	local success, response = pcall(function() return game:HttpGet(CONFIG.API_URL, true) end)
	if success and response then
		local decodeSuccess, decoded = pcall(function() return HttpService:JSONDecode(response) end)
		if decodeSuccess then return decoded end
	end
	return nil
end
local WebConfig = fetchServerConfig()
local features = WebConfig and WebConfig.features or {aimbot = true, speed = true, weather = true, players = true, ui = true, ai = true, farm = true, fly = true}

-- إزالة أي واجهة قديمة لمنع التكرار واللاق
if game:GetService("CoreGui"):FindFirstChild("GT6_MenuGui") then game:GetService("CoreGui").GT6_MenuGui:Destroy() end

-- 1. إنشاء واجهة المستخدم الرئيسية (MAIN UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GT6_MenuGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 450)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", MainFrame) MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame) MainStroke.Color = Theme.NeonPurple MainStroke.Thickness = 1.5
MainFrame.Parent = ScreenGui

-- شريط العنوان العلوي (Header)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Theme.DarkFrame
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0.5, -100, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "GT6"
Title.TextColor3 = Theme.NeonCyan
Title.TextSize = 26
Title.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel", Header)
SubTitle.Size = UDim2.new(0, 240, 0, 15)
SubTitle.Position = UDim2.new(0.5, -120, 0, 32)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "NEXT GEN CHEAT & AI SYSTEM"
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamMedium

local StatusFrame = Instance.new("Frame", Header)
StatusFrame.Size = UDim2.new(0, 130, 0, 26)
StatusFrame.Position = UDim2.new(1, -145, 0.5, -13)
StatusFrame.BackgroundColor3 = Theme.CardBg
Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 5)

local StatusText = Instance.new("TextLabel", StatusFrame)
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "STATUS • " .. CONFIG.Status
StatusText.TextColor3 = Theme.NeonGreen
StatusText.TextSize = 11
StatusText.Font = Enum.Font.GothamBold

-- نظام السحب والتحريك الفخم بالماوس أو اللمس للهواتف
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- القائمة الجانبية (Sidebar)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 175, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundColor3 = Theme.DarkFrame
Sidebar.BorderSizePixel = 0

local SidebarList = Instance.new("UIListLayout", Sidebar) SidebarList.SortOrder = Enum.SortOrder.LayoutOrder SidebarList.Padding = UDim.new(0, 5)
local SidebarPadding = Instance.new("UIPadding", Sidebar) SidebarPadding.PaddingTop = UDim.new(0, 8) SidebarPadding.PaddingLeft = UDim.new(0, 8) SidebarPadding.PaddingRight = UDim.new(0, 8)

-- مساحة عرض المحتوى (Content Area)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -185, 1, -100)
ContentArea.Position = UDim2.new(0, 180, 0, 55)
ContentArea.BackgroundTransparency = 1

-- شريط المعلومات السفلي (Footer)
local Footer = Instance.new("Frame", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 45)
Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.BackgroundColor3 = Theme.DarkFrame
Footer.BorderSizePixel = 0

local FPS_LBL = Instance.new("TextLabel", Footer)
FPS_LBL.Size = UDim2.new(0, 120, 1, 0)
FPS_LBL.Position = UDim2.new(0, 15, 0, 0)
FPS_LBL.BackgroundTransparency = 1
FPS_LBL.Text = "FPS: 计算中..."
FPS_LBL.TextColor3 = Theme.TextMuted
FPS_LBL.TextSize = 12
FPS_LBL.Font = Enum.Font.Code
FPS_LBL.TextXAlignment = Enum.TextXAlignment.Left

local SaveBtn = Instance.new("TextButton", Footer)
SaveBtn.Size = UDim2.new(0, 115, 0, 30)
SaveBtn.Position = UDim2.new(1, -250, 0.5, -15)
SaveBtn.BackgroundColor3 = Theme.CardBg
SaveBtn.Text = "SAVE CONFIG"
SaveBtn.TextColor3 = Theme.TextWhite
SaveBtn.TextSize = 11
SaveBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 5)

local InjectBtn = Instance.new("TextButton", Footer)
InjectBtn.Size = UDim2.new(0, 115, 0, 30)
InjectBtn.Position = UDim2.new(1, -125, 0.5, -15)
InjectBtn.BackgroundColor3 = Theme.NeonPurple
InjectBtn.Text = "INJECT GT6"
InjectBtn.TextColor3 = Theme.TextWhite
InjectBtn.TextSize = 11
InjectBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", InjectBtn).CornerRadius = UDim.new(0, 5)

-- 2. دوال إنشاء عناصر التحكم الفرعية المتقدمة
local function CreateTabButton(title, icon, order, isEnabled)
	local Btn = Instance.new("TextButton", Sidebar)
	Btn.Size = UDim2.new(1, 0, 0, 36)
	Btn.BackgroundColor3 = Theme.Background
	Btn.Text = "      " .. title .. (isEnabled and "" or " 🔒")
	Btn.TextColor3 = isEnabled and Theme.TextWhite or Color3.fromRGB(110, 65, 70)
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 11
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
	Btn.LayoutOrder = order
	
	local IconLabel = Instance.new("TextLabel", Btn)
	IconLabel.Size = UDim2.new(0, 25, 1, 0)
	IconLabel.Position = UDim2.new(0, 6, 0, 0)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text = icon
	IconLabel.TextSize = 14
	IconLabel.TextColor3 = isEnabled and Theme.TextWhite or Color3.fromRGB(110, 65, 70)
	
	return Btn
end

local function CreateToggle(parent, title, desc, configKey)
	local Container = Instance.new("Frame", parent)
	Container.Name = "Toggle_" .. configKey
	Container.Size = UDim2.new(1, -15, 0, 50)
	Container.BackgroundColor3 = Theme.DarkFrame
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

	local TitleLabel = Instance.new("TextLabel", Container)
	TitleLabel.Size = UDim2.new(0, 200, 0, 20)
	TitleLabel.Position = UDim2.new(0, 15, 0, 6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Theme.TextWhite
	TitleLabel.TextSize = 13
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local DescLabel = Instance.new("TextLabel", Container)
	DescLabel.Size = UDim2.new(0, 300, 0, 15)
	DescLabel.Position = UDim2.new(0, 15, 0, 26)
	DescLabel.BackgroundTransparency = 1
	DescLabel.Text = desc
	DescLabel.TextColor3 = Theme.TextMuted
	DescLabel.TextSize = 10
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local ToggleBtn = Instance.new("TextButton", Container)
	ToggleBtn.Name = "ToggleBtn"
	ToggleBtn.Size = UDim2.new(0, 46, 0, 24)
	ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	ToggleBtn.Text = ""
	Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
	
	local TglIndicator = Instance.new("Frame", ToggleBtn)
	TglIndicator.Name = "TglIndicator"
	TglIndicator.Size = UDim2.new(0, 18, 0, 18)
	TglIndicator.Position = UDim2.new(0, 3, 0.5, -9)
	TglIndicator.BackgroundColor3 = Color3.fromRGB(120, 120, 140)
	Instance.new("UICorner", TglIndicator).CornerRadius = UDim.new(0, 9)
	
	-- المحرك الفعلي للزر التفاعلي والأنيميشن
	ToggleBtn.MouseButton1Click:Connect(function()
		state.toggles[configKey] = not state.toggles[configKey]
		local active = state.toggles[configKey]
		TweenService:Create(ToggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = active and Theme.NeonPurple or Color3.fromRGB(40, 40, 60)}):Play()
		TweenService:Create(TglIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = active and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = active and Theme.TextWhite or Color3.fromRGB(120, 120, 140)}):Play()
		print("⚙️ " .. title .. " Changed to: " .. tostring(active))
	end)
end

local function CreateSlider(parent, title, minVal, maxVal, default, suffix, configKey)
	local Container = Instance.new("Frame", parent)
	Container.Name = "Slider_" .. configKey
	Container.Size = UDim2.new(1, -15, 0, 52)
	Container.BackgroundColor3 = Theme.DarkFrame
	Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
	
	local TitleLabel = Instance.new("TextLabel", Container)
	TitleLabel.Size = UDim2.new(0, 200, 0, 20)
	TitleLabel.Position = UDim2.new(0, 15, 0, 5)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Theme.TextWhite
	TitleLabel.TextSize = 13
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local ValueLabel = Instance.new("TextLabel", Container)
	ValueLabel.Name = "ValueLabel"
	ValueLabel.Size = UDim2.new(0, 60, 0, 20)
	ValueLabel.Position = UDim2.new(1, -75, 0, 5)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = tostring(default) .. suffix
	ValueLabel.TextColor3 = Theme.NeonCyan
	ValueLabel.TextSize = 13
	ValueLabel.Font = Enum.Font.Code
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	
	local BarBg = Instance.new("Frame", Container)
	BarBg.Name = "BarBg"
	BarBg.Size = UDim2.new(1, -30, 0, 5)
	BarBg.Position = UDim2.new(0, 15, 0, 34)
	BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	Instance.new("UICorner", BarBg).CornerRadius = UDim.new(0, 3)
	
	local BarFill = Instance.new("Frame", BarBg)
	BarFill.Name = "BarFill"
	BarFill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
	BarFill.BackgroundColor3 = Theme.NeonCyan
	Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 3)
	
	local Handle = Instance.new("TextButton", BarBg)
	Handle.Name = "Handle"
	Handle.Size = UDim2.new(0, 12, 0, 12)
	Handle.Position = UDim2.new((default - minVal) / (maxVal - minVal), -6, 0.5, -6)
	Handle.BackgroundColor3 = Theme.TextWhite
	Handle.Text = ""
	Instance.new("UICorner", Handle).CornerRadius = UDim.new(0, 6)
	
	-- المحرك المنطقي لحساب حركة السلايدر بدقة وسلاسة
	local dragging = false
	Handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	
	RunService.RenderStepped:Connect(function()
		if dragging then
			local mousePos = UserInputService:GetMouseLocation()
			local relativeX = (mousePos.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X
			relativeX = math.clamp(relativeX, 0, 1)
			
			local calculatedValue = math.floor(minVal + ((maxVal - minVal) * relativeX) + 0.5)
			state.sliders[configKey] = calculatedValue
			ValueLabel.Text = tostring(calculatedValue) .. suffix
			BarFill.Size = UDim2.new(relativeX, 0, 1, 0)
			Handle.Position = UDim2.new(relativeX, -6, 0.5, -6)
		end
	end)
end

-- 3. بناء وإدراج التبويبات الفخمة والربط
local ContentMap = {}
local TabsButtons = {}

local function CreateTabContentFrame(name)
	local Frame = Instance.new("ScrollingFrame", ContentArea)
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.ScrollBarThickness = 3
	Frame.ScrollBarImageColor3 = Theme.NeonPurple
	Frame.Visible = false
	Frame.CanvasSize = UDim2.new(0, 0, 0, 500)
	
	local Layout = Instance.new("UIListLayout", Frame) Layout.SortOrder = Enum.SortOrder.LayoutOrder Layout.Padding = UDim.new(0, 8)
	local Padding = Instance.new("UIPadding", Frame) Padding.PaddingTop = UDim.new(0, 5) Padding.PaddingLeft = UDim.new(0, 5)
	
	ContentMap[name] = Frame
	return Frame
end

-- تبويب 1: AIMBOT
local AimFrame = CreateTabContentFrame("AIMBOT")
local AimBtn = CreateTabButton("AIMBOT", "🎯", 1, features.aimbot ~= false)
TabsButtons["AIMBOT"] = AimBtn

-- كروت الواجهة العلوية الفاخرة المدمجة (Feature Cards)
local CardsFrame = Instance.new("Frame", AimFrame) CardsFrame.Size = UDim2.new(1, -15, 0, 75) CardsFrame.BackgroundTransparency = 1
local Grid = Instance.new("UIGridLayout", CardsFrame) Grid.CellSize = UDim2.new(0, 120, 0, 70) Grid.CellPadding = UDim2.new(0, 8, 0, 0)
local function CreateCard(icon, title, desc)
	local Card = Instance.new("Frame", CardsFrame) Card.BackgroundColor3 = Theme.DarkFrame Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
	local I = Instance.new("TextLabel", Card) I.Text = icon I.TextSize = 18 I.Size = UDim2.new(1,0,0,25) I.BackgroundTransparency = 1
	local T = Instance.new("TextLabel", Card) T.Text = title T.TextColor3 = Theme.TextWhite T.Font = Enum.Font.GothamBold T.TextSize = 11 T.Size = UDim2.new(1,0,0,20) T.Position = UDim2.new(0,0,0,25) T.BackgroundTransparency = 1
	local D = Instance.new("TextLabel", Card) D.Text = desc D.TextColor3 = Theme.TextMuted T.Font = Enum.Font.Gotham T.TextSize = 8 D.Size = UDim2.new(1,0,0,15) D.Position = UDim2.new(0,0,0,45) D.BackgroundTransparency = 1
end
CreateCard("🎯", "SMART AIM", "Precision AI")
CreateCard("🧠", "PREDICTIVE", "Vector Path")
CreateCard("🔒", "AUTO LOCK", "Fast Lock")
CreateCard("🛡️", "ANTI BAN", "Secure Core")

CreateToggle(AimFrame, "AIM ASSIST", "Advanced Core targeting intelligence", "AimAssist")
CreateSlider(AimFrame, "SENSITIVITY", 0, 100, state.sliders.Sensitivity, "%", "Sensitivity")
CreateSlider(AimFrame, "FOV RANGE", 10, 180, state.sliders.FOVRange, "°", "FOVRange")

-- تبويب 2: SPEED
local SpeedFrame = CreateTabContentFrame("SPEED")
local SpeedBtn = CreateTabButton("SPEED", "⚡", 2, features.speed ~= false) TabsButtons["SPEED"] = SpeedBtn
CreateToggle(SpeedFrame, "SUPER SPEED", "Unlocks maximum human acceleration multiplier", "SuperSpeed")
CreateSlider(SpeedFrame, "SPEED MODIFIER", 16, 250, state.sliders.SpeedModifier, " km/h", "SpeedModifier")

-- تبويب 3: WEATHER
local WeatherFrame = CreateTabContentFrame("WEATHER")
local WeatherBtn = CreateTabButton("WEATHER", "🌤️", 3, features.weather ~= false) TabsButtons["WEATHER"] = WeatherBtn
CreateToggle(WeatherFrame, "WEATHER CONTROL", "Inject custom local cloud system", "WeatherControl")
CreateToggle(WeatherFrame, "ALWAYS DAY", "Freezes global sky lighting into daylight", "AlwaysDay")

-- تبويب 4: PLAYERS
local PlayersFrame = CreateTabContentFrame("PLAYERS")
local PlayersBtn = CreateTabButton("PLAYERS", "👥", 4, features.players ~= false) TabsButtons["PLAYERS"] = PlayersBtn
CreateToggle(PlayersFrame, "ESP VISUALIZATION", "Draws bounding boxes over online hostiles", "EspVisuals")
CreateToggle(PlayersFrame, "PLAYER TRACKER", "Active radar triangulation of target routes", "PlayerTracker")

-- تبويب 5: UI CONFIG
local UIFrame = CreateTabContentFrame("UI CONFIG")
local UIBtn = CreateTabButton("UI CONFIG", "⚙️", 5, features.ui ~= false) TabsButtons["UI CONFIG"] = UIBtn
CreateSlider(UIFrame, "MENU SCALE", 50, 150, state.sliders.MenuScale, "%", "MenuScale")

-- تبويب 6: UPDATES
local UpdatesFrame = CreateTabContentFrame("UPDATES")
local UpdatesBtn = CreateTabButton("UPDATES", "📢", 6, true) TabsButtons["UPDATES"] = UpdatesBtn
local UpBox = Instance.new("Frame", UpdatesFrame) UpBox.Size = UDim2.new(1, -15, 0, 150) UpBox.BackgroundColor3 = Theme.DarkFrame Instance.new("UICorner", UpBox).CornerRadius = UDim.new(0, 6)
local UpText = Instance.new("TextLabel", UpBox) UpText.Size = UDim2.new(1, -20, 1, -20) UpText.Position = UDim2.new(0, 10, 0, 10) UpText.BackgroundTransparency = 1 UpText.TextColor3 = Theme.NeonGreen UpText.Font = Enum.Font.Code UpText.TextSize = 12 UpText.TextXAlignment = Enum.TextXAlignment.Left UpText.TextYAlignment = Enum.TextYAlignment.Top UpText.TextWrapped = true
UpText.Text = "Checking connection...\n" .. CONFIG.API_URL .. "\n\n> " .. (WebConfig and WebConfig.updates or "Version " .. CONFIG.Version .. " fully active.")

-- تبويب 7: ADVANCED AI
local AIFrame = CreateTabContentFrame("ADVANCED AI")
local AIBtn = CreateTabButton("ADVANCED AI", "🧠", 7, features.ai ~= false) TabsButtons["ADVANCED AI"] = AIBtn
CreateToggle(AIFrame, "AI PREDICTION", "Calculates bullet travel latency dynamically", "AiPrediction")
CreateToggle(AIFrame, "ADAPTIVE AIM", "Neural network learning target escape routes", "AdaptiveAim")

-- تبويب 8: AUTO FARM
local FarmFrame = CreateTabContentFrame("AUTO FARM")
local FarmBtn = CreateTabButton("AUTO FARM", "🌱", 8, features.farm ~= false) TabsButtons["AUTO FARM"] = FarmBtn
CreateToggle(FarmFrame, "AUTO COLLECT", "Instantly teleport world items into storage", "AutoCollect")

-- تبويب 9: FLY
local FlyFrame = CreateTabContentFrame("FLY")
local FlyBtn = CreateTabButton("FLY", "✈️", 9, features.fly ~= false) TabsButtons["FLY"] = FlyBtn
CreateToggle(FlyFrame, "ENABLE FLIGHT", "Bypasses gravity vectors allowing complete flight", "EnableFlight")
CreateSlider(FlyFrame, "FLY SPEED", 10, 150, state.sliders.FlySpeed, " Max", "FlySpeed")

-- نظام التنقل الفعلي بين الصفحات والتبويبات السلس
local function SwitchTab(tabName)
	for name, frame in pairs(ContentMap) do frame.Visible = false end
	for name, btn in pairs(TabsButtons) do btn.BackgroundColor3 = Theme.Background btn.TextColor3 = Theme.TextWhite end
	
	if ContentMap[tabName] then
		ContentMap[tabName].Visible = true
		TabsButtons[tabName].BackgroundColor3 = Theme.CardBg
		TabsButtons[tabName].TextColor3 = Theme.NeonCyan
		state.currentTab = tabName
	end
end

for name, btn in pairs(TabsButtons) do
	bt
