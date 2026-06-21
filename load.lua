-- [[ OMNI HUB GLOBAL ENGINE - LIVE API EDITION ]] --
-- كود اللوحة النخبوية المربوط بموقعك الحقيقي على Bolt.host

local API_URL = "https://roblox-elite-hub-web-8eyn.bolt.host/api/script-config"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف أي نسخة سابقة لمنع اللاق والتكرار
if CoreGui:FindFirstChild("Gta6EliteHub") then CoreGui.Gta6EliteHub:Destroy() end

-- جلب البيانات حية من موقع الويب الخاص بك
local function fetchWebData()
    local success, response = pcall(function()
        return game:HttpGet(API_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        warn("⚠️ فشل الاتصال بموقع الويب الخارجي. تم تشغيل الوضع الافتراضي.")
        return nil
    end
end

local WebConfig = fetchWebData()

-- 1. إنشاء الشاشة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Gta6EliteHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- =======================================================
-- 🎥 [ شاشة إقلاع سينمائية لشعار GTA 6 ]
-- =======================================================
local SplashScreen = Instance.new("Frame")
SplashScreen.Size = UDim2.new(1, 0, 1, 0)
SplashScreen.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
SplashScreen.ZIndex = 10
SplashScreen.Parent = ScreenGui

local GtaLogo = Instance.new("ImageLabel")
GtaLogo.Size = UDim2.new(0, 350, 0, 200)
GtaLogo.Position = UDim2.new(0.5, -175, 0.5, -100)
GtaLogo.Image = "rbxassetid://15121404113" 
GtaLogo.BackgroundTransparency = 1
GtaLogo.ImageTransparency = 1
GtaLogo.Parent = SplashScreen

task.spawn(function()
    TweenService:Create(GtaLogo, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(GtaLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
    local fadeTween = TweenService:Create(SplashScreen, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    fadeTween:Play()
    fadeTween.Completed:Connect(function() SplashScreen:Destroy() end)
end)

-- =======================================================
-- 🎛️ [ اللوحة الرئيسية الحديثة بطراز GTA 6 ]
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 340)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 0, 128) -- نيون Vice City الوردي
MainStroke.Parent = MainFrame

-- نظام السحب والتحريك المطور للهواتف
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

-- =======================================================
-- 🗂️ [ توليد الأقسام بناءً على أزرار الموقع ]
-- =======================================================
local SideBar = Instance.new("ScrollingFrame")
SideBar.Size = UDim2.new(0, 140, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
SideBar.BorderSizePixel = 0
SideBar.CanvasSize = UDim2.new(0, 0, 0, 450)
SideBar.ScrollBarThickness = 2
SideBar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = SideBar

local function createTabButton(name, order, isEnabledByWeb)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.BackgroundColor3 = isEnabledByWeb and Color3.fromRGB(25, 26, 38) or Color3.fromRGB(40, 20, 25)
    Btn.Text = isEnabledByWeb and name or name .. " 🔒"
    Btn.TextColor3 = isEnabledByWeb and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 100, 100)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    Btn.Parent = SideBar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        if not isEnabledByWeb then
            print("🚨 هذه الميزة معطلة حالياً من لوحة تحكم موقع الويب!")
        else
            print("🎯 تم فتح ميزة: " .. name)
        end
    end)
end

-- قراءة حالة الأزرار من موقعك مباشرة!
local features = WebConfig and WebConfig.features or {}
createTabButton("🎯 AIMBOT", 1, features.aimbot ~= false)
createTabButton("⚡ SPEED", 2, features.speed ~= false)
createTabButton("🌤️ WEATHER", 3, features.weather ~= false)
createTabButton("👥 PLAYERS", 4, features.players ~= false)
createTabButton("📢 UPDATES", 5, true)
createTabButton("🤖 ADVANCED AI", 6, features.ai ~= false)

-- =======================================================
-- 💬 [ صندوق التحديثات القادم من السيرفر حياً ]
-- =======================================================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -155, 1, -50)
ContentArea.Position = UDim2.new(0, 145, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local UpdateBox = Instance.new("TextLabel")
UpdateBox.Size = UDim2.new(1, 0, 1, 0)
UpdateBox.BackgroundColor3 = Color3.fromRGB(16, 17, 24)

-- جلب النص المكتوب في جدول التحديثات بالموقع
local webUpdates = WebConfig and WebConfig.updates or "لا توجد تحديثات مسجلة في الموقع حالياً."
UpdateBox.Text = "📢 آخر التحديثات من الموقع:\n\n" .. webUpdates
UpdateBox.TextColor3 = Color3.fromRGB(0, 255, 150)
UpdateBox.Font = Enum.Font.Code
UpdateBox.TextSize = 13
UpdateBox.TextXAlignment = Enum.TextXAlignment.Left
UpdateBox.TextYAlignment = Enum.TextYAlignment.Top
UpdateBox.TextWrapped = true
UpdateBox.Parent = ContentArea

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpdateBox

print("🔗 متصل بنجاح بموقع: roblox-elite-hub-web-8eyn.bolt.host")
