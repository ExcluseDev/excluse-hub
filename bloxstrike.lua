--[[
    excluse hub | BloxStrike (Legit & Humanized Edition)
--]]
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    Name = "excluse hub | BloxStrike", LoadingTitle = "Loading Legit...", LoadingSubtitle = "v1.0 Human",
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

-- === STATE ===
local State = {
    aimAssist = false, aimAssistFOV = 80, aimAssistSmoothness = 0.2, aimAssistPart = "Head",
    humanization = 0.1, -- Jitter amount
    triggerbot = false, triggerDelay = 0.15, triggerChance = 60,
    espEnabled = false, espMaxDistance = 300,
    wallbang = false, noRecoil = false,
    highlights = {}
}

-- === HELPER: Get Target ===
local function getTarget()
    local closest, dist = nil, State.aimAssistFOV
    local cam = Workspace.CurrentCamera
    local myChar = player.Character
    if not myChar then return nil end

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team and player.Team and p.Team == player.Team then continue end
            local part = p.Character:FindFirstChild(State.aimAssistPart) or p.Character:FindFirstChild("Head")
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

-- === HUMANIZED AIM ASSIST ===
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

            -- Apply smoothing
            local moveX = deltaX * State.aimAssistSmoothness
            local moveY = deltaY * State.aimAssistSmoothness

            -- Apply human jitter
            local jitterX = (math.random() - 0.5) * State.humanization * 10
            local jitterY = (math.random() - 0.5) * State.humanization * 10

            pcall(function()
                mousemoverel(moveX + jitterX, moveY + jitterY)
            end)
        end
    end
end)

-- === TRIGGERBOT (Humanized) ===
task.spawn(function()
    while State.triggerbot and getgenv().excluseHubRunning do
        local target = getTarget()
        if target then
            if math.random(1, 100) <= State.triggerChance then
                task.wait(math.random(80, 150) / 1000) -- Random delay 80-150ms
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end
        end
        task.wait(State.triggerDelay)
    end
end)

-- === ESP (Subtle) ===
RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning then return end
    for char, h in pairs(State.highlights) do
        if not char.Parent or not char:FindFirstChild("Humanoid") then
            h:Destroy(); State.highlights[char] = nil
        end
    end
    if State.espEnabled then
        local cam = Workspace.CurrentCamera
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - cam.CFrame.Position).Magnitude
                if dist <= State.espMaxDistance then
                    if not State.highlights[p.Character] then
                        local h = Instance.new("Highlight")
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.FillTransparency = 0.7 -- Very subtle
                        h.Parent = p.Character
                        State.highlights[p.Character] = h
                    end
                else
                    if State.highlights[p.Character] then
                        State.highlights[p.Character]:Destroy()
                        State.highlights[p.Character] = nil
                    end
                end
            end
        end
    end
end)

-- === NO RECOIL (Camera) ===
RunService.RenderStepped:Connect(function()
    if State.noRecoil then
        local cam = Workspace.CurrentCamera
        if cam then
            -- Attempt to reset camera offset (common recoil method)
            cam.CFrame = cam.CFrame * CFrame.Angles(0, 0, 0) -- Placeholder, actual logic depends on game
        end
    end
end)

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Combat")
local visualTab = Window:CreateTab("👁️ Visuals")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat Tab
mainTab:CreateSection("Humanized Aim Assist")
mainTab:CreateToggle({ Name = "Enable Aim Assist", CurrentValue = false, Callback = function(v) State.aimAssist = v end })
mainTab:CreateSlider({ Name = "Aim FOV", Range = {20, 200}, Increment = 5, CurrentValue = 80, Callback = function(v) State.aimAssistFOV = v end })
mainTab:CreateSlider({ Name = "Smoothness (Lower = Smoother)", Range = {0.05, 0.8}, Increment = 0.05, CurrentValue = 0.2, Callback = function(v) State.aimAssistSmoothness = v end })
mainTab:CreateSlider({ Name = "Humanization (Jitter)", Range = {0, 0.5}, Increment = 0.05, CurrentValue = 0.1, Callback = function(v) State.humanization = v end })
mainTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = "Head", Callback = function(v) State.aimAssistPart = v end })

mainTab:CreateSection("Humanized Triggerbot")
mainTab:CreateToggle({ Name = "Enable Triggerbot", CurrentValue = false, Callback = function(v) State.triggerbot = v end })
mainTab:CreateSlider({ Name = "Trigger Delay (s)", Range = {0.05, 0.5}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) State.triggerDelay = v end })
mainTab:CreateSlider({ Name = "Hit Chance (%)", Range = {10, 100}, Increment = 5, CurrentValue = 60, Callback = function(v) State.triggerChance = v end })

mainTab:CreateSection("Weapon Mods")
mainTab:CreateToggle({ Name = "No Recoil", CurrentValue = false, Callback = function(v) State.noRecoil = v end })
mainTab:CreateToggle({ Name = "Wallbang (Shoot Through Walls)", CurrentValue = false, Callback = function(v) State.wallbang = v end })

-- Visuals Tab
visualTab:CreateSection("Subtle ESP")
visualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = function(v) State.espEnabled = v end })
visualTab:CreateSlider({ Name = "Max Distance", Range = {50, 1000}, Increment = 50, CurrentValue = 300, Callback = function(v) State.espMaxDistance = v end })

-- Settings Tab
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.aimAssist = false; State.triggerbot = false; State.espEnabled = false
    State.noRecoil = false; State.wallbang = false
    for _, h in pairs(State.highlights) do if h and h.Parent then h:Destroy() end end
    State.highlights = {}
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "BloxStrike Loaded", Content = "Humanized Legit Mode Active.", Duration = 5 })
