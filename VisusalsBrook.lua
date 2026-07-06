-- z0nxx Hub — Matrix Stretch, Glass Chams, Lighting & Skybox v8 (Persistent Global Session)
-- Дизайн Monochrome

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- База данных текстур неба
local skyboxes = {
    "rbxassetid://109671864865862",
    "rbxassetid://121417250612233",
    "rbxassetid://36539848",
    "rbxassetid://7371693428",
    "rbxassetid://12053823591",
    "rbxassetid://1256360176"
}

-- Инициализация или загрузка СВЕРХ-СОХРАНЕНИЯ через глобальную среду _G
if not _G.z0nxxConfig then
    _G.z0nxxConfig = {
        stretchEnabled = false,
        chamsEnabled = false,
        worldColorEnabled = false,
        skyboxEnabled = false,
        shadowsEnabled = true,
        stretchValue = 1.0,
        currentSkyIndex = 1,
        savedColor = Color3.fromRGB(255, 255, 255),
        sliderPercentage = 0,
        colorPercentage = 0
    }
end
local cfg = _G.z0nxxConfig

-- Удаляем старый GUI, если он физически остался в PlayerGui, чтобы не плодить копии
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("z0nxxUltimateGUI")
if oldGui then oldGui:Destroy() end

-- Настройка окружения в Lighting
local colorCorrection = Lighting:FindFirstChild("z0nxxColorCC")
if not colorCorrection then
    colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "z0nxxColorCC"
    colorCorrection.Parent = Lighting
end

local customSky = Lighting:FindFirstChild("z0nxxSky")
if not customSky then
    customSky = Instance.new("Sky")
    customSky.Name = "z0nxxSky"
end

local function applySkyTexture(assetId)
    customSky.SkyboxBk = assetId
    customSky.SkyboxDn = assetId
    customSky.SkyboxFt = assetId
    customSky.SkyboxLf = assetId
    customSky.SkyboxRt = assetId
    customSky.SkyboxUp = assetId
end

-- Сборка интерфейса
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "z0nxxUltimateGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 280, 0, 405)
main.Position = UDim2.new(0.5, -140, 0.5, -202)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(100, 100, 100)
mainStroke.Transparency = 0.3

-- Шапка
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -30, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "z0nxx Hub — Matrix v8"
title.TextColor3 = Color3.fromRGB(235, 235, 235)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left

-- Кнопка X (Просто прячет интерфейс, ничего не сбрасывая)
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

-- Компоненты управления
local infoLabel = Instance.new("TextLabel", main)
infoLabel.Size = UDim2.new(1, -20, 0, 32)
infoLabel.Position = UDim2.new(0, 10, 0, 44)
infoLabel.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
infoLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 14
Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 6)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(1, -20, 0, 34)
toggleBtn.Position = UDim2.new(0, 10, 0, 84)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local sliderFrame = Instance.new("Frame", main)
sliderFrame.Size = UDim2.new(1, -20, 0, 30)
sliderFrame.Position = UDim2.new(0, 10, 0, 126)
sliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)

local sliderTrack = Instance.new("Frame", sliderFrame)
sliderTrack.Size = UDim2.new(1, -20, 0, 6)
sliderTrack.Position = UDim2.new(0, 10, 0.5, -3)
sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderTrack.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderTrack)
sliderFill.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
sliderFill.BorderSizePixel = 0

local sliderBtn = Instance.new("TextButton", sliderTrack)
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderBtn.Text = ""
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

local chamsBtn = Instance.new("TextButton", main)
chamsBtn.Size = UDim2.new(1, -20, 0, 34)
chamsBtn.Position = UDim2.new(0, 10, 0, 166)
chamsBtn.Font = Enum.Font.SourceSansBold
chamsBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
chamsBtn.TextSize = 13
Instance.new("UICorner", chamsBtn).CornerRadius = UDim.new(0, 6)

local worldColorBtn = Instance.new("TextButton", main)
worldColorBtn.Size = UDim2.new(1, -20, 0, 34)
worldColorBtn.Position = UDim2.new(0, 10, 0, 208)
worldColorBtn.Font = Enum.Font.SourceSansBold
worldColorBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
worldColorBtn.TextSize = 13
Instance.new("UICorner", worldColorBtn).CornerRadius = UDim.new(0, 6)

local colorSliderFrame = Instance.new("Frame", main)
colorSliderFrame.Size = UDim2.new(1, -20, 0, 24)
colorSliderFrame.Position = UDim2.new(0, 10, 0, 248)
colorSliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Instance.new("UICorner", colorSliderFrame).CornerRadius = UDim.new(0, 6)

local colorTrack = Instance.new("Frame", colorSliderFrame)
colorTrack.Size = UDim2.new(1, -20, 0, 6)
colorTrack.Position = UDim2.new(0, 10, 0.5, -3)
colorTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
colorTrack.BorderSizePixel = 0

local colorSliderBtn = Instance.new("TextButton", colorTrack)
colorSliderBtn.Size = UDim2.new(0, 12, 0, 12)
colorSliderBtn.Text = ""
Instance.new("UICorner", colorSliderBtn).CornerRadius = UDim.new(1, 0)

local shadowsBtn = Instance.new("TextButton", main)
shadowsBtn.Size = UDim2.new(1, -20, 0, 34)
shadowsBtn.Position = UDim2.new(0, 10, 0, 278)
shadowsBtn.Font = Enum.Font.SourceSansBold
shadowsBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
shadowsBtn.TextSize = 13
Instance.new("UICorner", shadowsBtn).CornerRadius = UDim.new(0, 6)

local skyBtn = Instance.new("TextButton", main)
skyBtn.Size = UDim2.new(1, -20, 0, 34)
skyBtn.Position = UDim2.new(0, 10, 0, 318)
skyBtn.Font = Enum.Font.SourceSansBold
skyBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
skyBtn.TextSize = 13
Instance.new("UICorner", skyBtn).CornerRadius = UDim.new(0, 6)

local subText = Instance.new("TextLabel", main)
subText.Size = UDim2.new(1, -20, 0, 20)
subText.Position = UDim2.new(0, 10, 0, 362)
subText.BackgroundTransparency = 1
subText.Text = "Global Memory Save | Press RightShift to Toggle"
subText.TextColor3 = Color3.fromRGB(130, 130, 130)
subText.Font = Enum.Font.SourceSans
subText.TextSize = 12

-- Драг и хоткей (RightShift)
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = main.Position end end)
header.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputBegan:Connect(function(input, processed) if not processed and input.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible end end)

-- ФУНКЦИОНАЛ ОБНОВЛЕНИЯ ИНТЕРФЕЙСА НА ОСНОВЕ СОХРАНЕНИЯ
local function syncVisuals()
    -- Растяг камеры
    if cfg.stretchEnabled then
        toggleBtn.Text = "DISABLE STRETCH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
        infoLabel.Text = string.format("Stretch: Active (%.2fx)", cfg.stretchValue)
    else
        toggleBtn.Text = "ENABLE STRETCH"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        infoLabel.Text = string.format("Stretch: Disabled (%.2fx)", cfg.stretchValue)
    end
    sliderBtn.Position = UDim2.new(cfg.sliderPercentage, -7, 0.5, -7)
    sliderFill.Size = UDim2.new(cfg.sliderPercentage, 0, 1, 0)

    -- Стекло хамс
    if cfg.chamsEnabled then
        chamsBtn.Text = "RAINBOW GLASS CHAMS: ON"
        chamsBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
    else
        chamsBtn.Text = "RAINBOW GLASS CHAMS: OFF"
        chamsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end

    -- Цвет мира
    if cfg.worldColorEnabled then
        worldColorBtn.Text = "WORLD COLOR FILTER: ON"
        worldColorBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
        colorCorrection.Enabled = true
        colorCorrection.TintColor = cfg.savedColor
    else
        worldColorBtn.Text = "WORLD COLOR FILTER: OFF"
        worldColorBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        colorCorrection.Enabled = false
    end
    colorSliderBtn.Position = UDim2.new(cfg.colorPercentage, -6, 0.5, -6)
    colorSliderBtn.BackgroundColor3 = cfg.savedColor

    -- Тени
    Lighting.GlobalShadows = cfg.shadowsEnabled
    if cfg.shadowsEnabled then
        shadowsBtn.Text = "GLOBAL SHADOWS: ON"
        shadowsBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
    else
        shadowsBtn.Text = "GLOBAL SHADOWS: OFF"
        shadowsBtn.BackgroundColor3 = Color3.fromRGB(110, 40, 40)
    end

    -- Небо
    if cfg.skyboxEnabled then
        customSky.Parent = Lighting
        skyBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 40)
        skyBtn.Text = string.format("SKYBOX: ON (%d/%d)", cfg.currentSkyIndex, #skyboxes)
    else
        customSky.Parent = nil
        skyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        skyBtn.Text = string.format("CUSTOM SKYBOX: OFF (%d/%d)", cfg.currentSkyIndex, #skyboxes)
    end
    applySkyTexture(skyboxes[cfg.currentSkyIndex])
end

-- ЛОГИКА ПОЛЗУНКОВ
local sliderDragging = false
local function updateSlider(input)
    local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
    local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
    cfg.sliderPercentage = percentage
    cfg.stretchValue = 1.0 + (percentage * 0.20)
    syncVisuals()
end
sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliderDragging = true end end)
UserInputService.InputChanged:Connect(function(input) if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliderDragging = false end end)

local colorDragging = false
local function updateColorSlider(input)
    local relativeX = input.Position.X - colorTrack.AbsolutePosition.X
    local percentage = math.clamp(relativeX / colorTrack.AbsoluteSize.X, 0, 1)
    cfg.colorPercentage = percentage
    cfg.savedColor = Color3.fromHSV(percentage, 0.75, 1)
    syncVisuals()
end
colorSliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then colorDragging = true end end)
UserInputService.InputChanged:Connect(function(input) if colorDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateColorSlider(input) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then colorDragging = false end end)

-- РАБОЧИЙ ЦИКЛ ЭФФЕКТОВ
local function applyStretch()
    Camera = Workspace.CurrentCamera
    if cfg.stretchEnabled and Camera then
        local cf = Camera.CFrame
        local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
        Camera.CFrame = CFrame.new(x, y, z, r00 * cfg.stretchValue, r01, r02, r10 * cfg.stretchValue, r11, r12, r20 * cfg.stretchValue, r21, r22)
    end
end

-- Перепривязываем рендер-степ (безопасно, без дублей)
pcall(function() RunService:UnbindFromRenderStep("z0nxxMatrixStretch") end)
RunService:BindToRenderStep("z0nxxMatrixStretch", Enum.RenderPriority.Camera.Value + 1, applyStretch)

-- Радужный Chams поток
task.spawn(function()
    while true do
        if cfg.chamsEnabled and LocalPlayer.Character then
            local hue = (tick() % 5) / 5
            local rainbowColor = Color3.fromHSV(hue, 0.7, 1)
            for _, item in ipairs(LocalPlayer.Character:GetDescendants()) do
                if item:IsA("BasePart") and item.Name ~= "HumanoidRootPart" then
                    item.Color = rainbowColor
                    if item.Material ~= Enum.Material.Glass then
                        item.Material = Enum.Material.Glass
                        item.Transparency = 0.5
                    end
                end
            end
        end
        task.wait()
    end
end)

-- Авто-наложение стекла при возрождении
LocalPlayer.CharacterAdded:Connect(function(char)
    if cfg.chamsEnabled then
        task.wait(0.2)
        for _, item in ipairs(char:GetDescendants()) do
            if item:IsA("BasePart") and item.Name ~= "HumanoidRootPart" then
                item.Material = Enum.Material.Glass
                item.Transparency = 0.5
            elseif item:IsA("CharacterMesh") or item:IsA("ShirtGraphic") or item:IsA("Clothing") then
                item:Destroy() 
            end
        end
    end
end)

-- НАЖАТИЯ НА КНОПКИ
toggleBtn.MouseButton1Click:Connect(function() cfg.stretchEnabled = not cfg.stretchEnabled syncVisuals() end)
worldColorBtn.MouseButton1Click:Connect(function() cfg.worldColorEnabled = not cfg.worldColorEnabled syncVisuals() end)
shadowsBtn.MouseButton1Click:Connect(function() cfg.shadowsEnabled = not cfg.shadowsEnabled syncVisuals() end)

chamsBtn.MouseButton1Click:Connect(function()
    cfg.chamsEnabled = not cfg.chamsEnabled
    syncVisuals()
    if not cfg.chamsEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

skyBtn.MouseButton1Click:Connect(function()
    if not cfg.skyboxEnabled then
        cfg.skyboxEnabled = true
    else
        cfg.currentSkyIndex = cfg.currentSkyIndex + 1
        if cfg.currentSkyIndex > #skyboxes then
            cfg.skyboxEnabled = false
            cfg.currentSkyIndex = 1
        end
    end
    syncVisuals()
end)

-- Синхронизируем все настройки при старте
syncVisuals()

-- Плавное появление интерфейса
main.Position = UDim2.new(0.5, -140, 1.5, 0)
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -140, 0.5, -202)}):Play()
