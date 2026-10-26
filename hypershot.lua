--[[
    excluse hub | Hypershot (Low-Detection Legit Mode)
    ⚠️ WARNING: Hypershot bans ALL accounts for cheating. Use at your own risk.
--]]
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- === MINIMAL INTRO ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.IgnoreGuiInset = true
local bg = Instance.new("Frame", gui); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,8)
local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(0,200,0,100); txt.Position = UDim2.new(0.5,-100,0.5,-50); txt.BackgroundTransparency = 1; txt.Text = "EXC"; txt.TextColor3 = Color3.new(1,1,1); txt.TextScaled = true; txt.Font = Enum.Font.GothamBlack; txt.TextTransparency = 1
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
task.wait(0.7)
TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
task.wait(0.3)
gui:Destroy()

-- === RAYFIELD SETUP ===
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
getgenv().excluseHubRunning = true

local VoidGlassTheme = {
    TextColor = Color3.fromRGB(255, 255, 255), Background = Color3.fromRGB(10, 10, 15),
    Topbar = Color3.fromRGB(15, 15, 25), Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(15, 15, 25), NotificationActionsBackground = Color3.fromRGB(25, 25, 40),
    TabBackground = Color3.fromRGB(15, 15, 25), TabStroke = Color3.fromRGB(60, 60, 100),
    TabBackgroundSelected = Color3.fromRGB(150, 50, 255), TabTextColor = Color3.fromRGB(180, 180, 200),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(20, 20, 30),
    ElementBackgroundHover = Color3.fromRGB(30, 30, 45), SecondaryElementBackground = Color3.fromRGB(10, 10, 15),
    ElementStroke = Color3.fromRGB(80, 80, 120), SecondaryElementStroke = Color3.fromRGB(40, 40, 60),
    SliderBackground = Color3.fromRGB(150, 50, 255), SliderProgress = Color3.fromRGB(0, 255, 255),
    SliderStroke = Color3.fromRGB(200, 100, 255), ToggleBackground = Color3.fromRGB(30, 30, 45),
    ToggleEnabled = Color3.fromRGB(0, 255, 255), ToggleDisabled = Color3.fromRGB(60, 60, 70),
    ToggleEnabledStroke = Color3.fromRGB(255, 255, 255), ToggleDisabledStroke = Color3.fromRGB(80, 80, 90),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 255, 255), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 60),
    DropdownSelected = Color3.fromRGB(150, 50, 255), DropdownUnselected = Color3.fromRGB(15, 15, 25),
    InputBackground = Color3.fromRGB(10, 10, 15), InputStroke = Color3.fromRGB(80, 80, 120),
    PlaceholderColor = Color3.fromRGB(120, 120, 140)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse hub | Hypershot (Legit)", LoadingTitle = "Loading Legit Mode...", LoadingSubtitle = "v1.0 Low-Risk",
    Theme = VoidGlassTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

-- === GALAXY UI OVERRIDE ===
task.spawn(function()
    task.wait(1)
    local rayfieldGui = player:FindFirstChild("PlayerGui") and player:FindFirstChild("PlayerGui"):FindFirstChild("Rayfield")
    if rayfieldGui and rayfieldGui:FindFirstChild("MainFrame") then
        local mainFrame = rayfieldGui.MainFrame
        local bg = mainFrame:FindFirstChild("Background")
        if bg then
            local galaxyImage = Instance.new("ImageLabel")
            galaxyImage.Size = UDim2.new(1.5, 0, 1.5, 0); galaxyImage.Position = UDim2.new(-0.25, 0, -0.25, 0)
            galaxyImage.BackgroundTransparency = 1; galaxyImage.Image = "rbxassetid://7148785474"; galaxyImage.ImageTransparency = 0.2; galaxyImage.ZIndex = 0
            galaxyImage.Parent = bg
            task.spawn(function()
                while galaxyImage.Parent do
                    TweenService:Create(galaxyImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.3, 0, -0.2, 0)}):Play()
                    task.wait(15)
                    TweenService:Create(galaxyImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.2, 0, -0.3, 0)}):Play()
                    task.wait(15)
                end
            end)
        end
        for _, desc in ipairs(mainFrame:GetDescendants()) do
            if desc:IsA("Frame") and desc.Name ~= "Background" then
                desc.BackgroundTransparency = 0.3
                if not desc:FindFirstChildOfClass("UICorner") then
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = desc
                end
            end
            if desc:IsA("ImageLabel") and desc.Name ~= "GalaxyImage" then desc.Visible = false end
        end
    end
end)

-- === STATE (LEGIT ONLY) ===
local State = {
    aimAssist = false,
    aimFOV = 60, -- Small FOV to avoid snapping to random players
    aimSmoothness = 8, -- High smoothing = slow, human-like tracking (1-20)
    aimPart = "Head",
    humanJitter = 0.05, -- Adds tiny random movement to mimic human hand shake
}

-- === HELPER: Get Target (Small FOV) ===
local function getTarget()
    local closest, dist = nil, State.aimFOV
    local cam = Workspace.CurrentCamera
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team and player.Team and p.Team == player.Team then continue end
            local part = p.Character:FindFirstChild(State.aimPart) or p.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if d < dist then
                        dist = d
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

-- === HUMANIZED AIM ASSIST (NO SNAP) ===
RunService.RenderStepped:Connect(function()
    if not State.aimAssist then return end
    local target = getTarget()
    if target then
        local cam = Workspace.CurrentCamera
        local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
        if onScreen then
            local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            local deltaX = (screenPos.X - center.X)
            local deltaY = (screenPos.Y - center.Y)

            -- Convert smoothing (1-20) to a multiplier (1.0 down to 0.05)
            local smoothMult = 1 / State.aimSmoothness
            local moveX = deltaX * smoothMult
            local moveY = deltaY * smoothMult

            -- Add human jitter
            local jitterX = (math.random() - 0.5) * State.humanJitter * 20
            local jitterY = (math.random() - 0.5) * State.humanJitter * 20

            pcall(function()
                mousemoverel(moveX + jitterX, moveY + jitterY)
            end)
        end
    end
end)

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Aim Assist")
local settingsTab = Window:CreateTab("⚙️ Settings")

mainTab:CreateSection("Humanized Aim Assist")
mainTab:CreateToggle({ Name = "Enable Aim Assist", CurrentValue = false, Callback = function(v) State.aimAssist = v end })
mainTab:CreateSlider({ Name = "Aim FOV (Keep Low)", Range = {10, 120}, Increment = 5, CurrentValue = 60, Callback = function(v) State.aimFOV = v end })
mainTab:CreateSlider({ Name = "Smoothing (1=Fast, 20=Slow/Human)", Range = {1, 20}, Increment = 1, CurrentValue = 8, Callback = function(v) State.aimSmoothness = v end })
mainTab:CreateSlider({ Name = "Human Jitter", Range = {0, 0.2}, Increment = 0.01, CurrentValue = 0.05, Callback = function(v) State.humanJitter = v end })
mainTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "UpperTorso"}, CurrentOption = "Head", Callback = function(v) State.aimPart = v end })

settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.aimAssist = false
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "Hypershot Loaded", Content = "Low-Detection Legit Mode. No rage features.", Duration = 5 })
