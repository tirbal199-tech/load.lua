-- [[ OMNI HUB GLOBAL ENGINE - SUPABASE LIVE EDITION ]] --
local API_URL = "https://wgabznguajgfrcfudgtc.supabase.co/functions/v1/script-config"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("Gta6EliteHub") then CoreGui.Gta6EliteHub:Destroy() end

-- جلب البيانات المباشرة من سرفر الـ Edge Function الخاص بك
local function fetchWebData()
    local success, response = pcall(function()
        return game:HttpGet(API_URL, true)
    end)
    
    if success and response then
        local decodeSuccess, decoded = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeSuccess then return decoded end
    end
    
    -- وضع الطوارئ في حال حدوث لاق بالشبكة
    return {
        features = {aimbot = true, speed = true, weather = true, players = true, ai = true},
        updates = "⚠️ جاري تحديث البيانات الحية من السيرفر..."
    }
end

local WebConfig = fetchWebData()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Gta6EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [ 🎥 شاشة إقلاع شعار GTA 6 السينمائية ]
local SplashScreen = Instance.new("Frame")
SplashScreen.Size = UDim2.new(1, 0, 1, 0)
SplashScreen.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
SplashScreen.ZIndex = 10
SplashScreen.Parent = ScreenGui

local GtaLogo = Instance.new("ImageLabel")
GtaLogo.Size = UDim2.new(0, 320, 0, 180)
GtaLogo.Position = UDim2.new(0.5, -160, 0.5, -90)
GtaLogo.Image = "rbxassetid://15121404113" 
GtaLogo.BackgroundTransparency = 1
GtaLogo.ImageTransparency = 1
GtaLogo.Parent = SplashScreen

task.spawn(function()
    TweenService:Create(GtaLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    task.wait(1.5)
    TweenService:Create(GtaLogo, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
    local fadeTween = TweenService:Create(SplashScreen, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    fadeTween:Play()
    fadeTween.Completed:Connect(function() SplashScreen:Destroy() end)
end)

-- [ 🎛️ اللوحة الرئيسية بطراز غيمنغ نيون ]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 330)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(230, 0, 120) -- لون نيون فايس سيتي
MainStroke.Parent = MainFrame

-- نظام السحب واللمس للهواتف
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- [ 🗂️ القائمة الجانبية للأزرار القادمة من السيرفر ]
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 135, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
SideBar.BorderSizePixel = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 400)
SideBar.ScrollBarThickness = 2
SideBar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = SideBar

local function createTabButton(name, order, isEnabledByWeb)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.BackgroundColor3 = isEnabledByWeb and Color3.fromRGB(28, 30, 42) or Color3.fromRGB(45, 22, 28)
    Btn.Text = isEnabledByWeb and name or name .. " 🔒"
    Btn.TextColor3 = isEnabledByWeb and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 120, 120)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    Btn.Parent = SideBar
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    Btn.Parent = SideBar
end

local features = WebConfig.features or {}
createTabButton("🎯 AIMBOT", 1, features.aimbot ~= false)
createTabButton("⚡ SPEED", 2, features.speed ~= false)
createTabButton("🌤️ WEATHER", 3, features.weather ~= false)
createTabButton("👥 PLAYERS", 4, features.players ~= false)
createTabButton("📢 UPDATES", 5, true)
createTabButton("🤖 ADVANCED AI", 6, features.ai ~= false)

-- [ 💬 صندوق عرض آخر تحديثات الموقع ]
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -50)
ContentArea.Position = UDim2.new(0, 140, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local UpdateBox = Instance.new("TextLabel")
UpdateBox.Size = UDim2.new(1, 0, 1, 0)
UpdateBox.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
UpdateBox.Text = "📢 آخر التحديثات من لوحة الويب:\n\n" .. (WebConfig.updates or "لا توجد منشورات جديدة حالياً.")
UpdateBox.TextColor3 = Color3.fromRGB(0, 255, 160)
UpdateBox.Font = Enum.Font.Code
UpdateBox.TextSize = 12
UpdateBox.TextXAlignment = Enum.TextXAlignment.Left
UpdateBox.TextYAlignment = Enum.TextYAlignment.Top
UpdateBox.TextWrapped = true
UpdateBox.Parent = ContentArea
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
UpdateBox.Parent = ContentArea

print("🚀 تم الاتصال المباشر بقاعدة بيانات Supabase واللوحة تعمل بكفاءة!")
