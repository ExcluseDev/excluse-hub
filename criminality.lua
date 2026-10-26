--[[
    excluse hub | Criminality
--]]
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
getgenv().excluseHubRunning = true

local GalaxyTheme = {
    TextColor = Color3.fromRGB(240, 245, 255), Background = Color3.fromRGB(10, 12, 18),
    Topbar = Color3.fromRGB(15, 18, 28), Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(20, 25, 35), NotificationActionsBackground = Color3.fromRGB(30, 35, 45),
    TabBackground = Color3.fromRGB(15, 18, 28), TabStroke = Color3.fromRGB(40, 45, 60),
    TabBackgroundSelected = Color3.fromRGB(60, 100, 180), TabTextColor = Color3.fromRGB(150, 160, 180),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(18, 22, 32),
    ElementBackgroundHover = Color3.fromRGB(28, 35, 50), SecondaryElementBackground = Color3.fromRGB(15, 18, 28),
    ElementStroke = Color3.fromRGB(45, 55, 75), SecondaryElementStroke = Color3.fromRGB(35, 45, 60),
    SliderBackground = Color3.fromRGB(60, 100, 180), SliderProgress = Color3.fromRGB(180, 220, 255),
    SliderStroke = Color3.fromRGB(100, 150, 220), ToggleBackground = Color3.fromRGB(30, 35, 50),
    ToggleEnabled = Color3.fromRGB(80, 150, 255), ToggleDisabled = Color3.fromRGB(60, 60, 70),
    ToggleEnabledStroke = Color3.fromRGB(150, 200, 255), ToggleDisabledStroke = Color3.fromRGB(80, 80, 90),
    ToggleEnabledOuterStroke = Color3.fromRGB(120, 160, 220), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 60),
    DropdownSelected = Color3.fromRGB(60, 100, 180), DropdownUnselected = Color3.fromRGB(18, 22, 32),
    InputBackground = Color3.fromRGB(15, 18, 28), InputStroke = Color3.fromRGB(50, 60, 80),
    PlaceholderColor = Color3.fromRGB(120, 130, 150)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse hub | Criminality", LoadingTitle = "Loading Criminality...", LoadingSubtitle = "by excluse",
    Theme = GalaxyTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

local State = {
    aimbot = false, aimbotSmooth = 0.15, aimbotFOV = 120,
    silentAim = false,
    espPlayers = false, espTracers = false,
    fly = false, flySpeed = 50,
    infJump = false,
    fullbright = false,
    highlights = {}
}

local aimbotConnection, espConnection, jumpConnection

-- === HELPER: Get Target (Nearest Player) ===
local function getTarget()
    local closest, dist = nil, State.aimbotFOV
    local cam = Workspace.CurrentCamera
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
                local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if d < dist then
                    dist = d
                    closest = p.Character
                end
            end
        end
    end
    return closest
end

-- === AIMBOT & SILENT AIM ===
aimbotConnection = RunService.RenderStepped:Connect(function()
    if not getgenv().excluseHubRunning then return end
    if State.aimbot or State.silentAim then
        local target = getTarget()
        if target then
            local targetPart = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local cam = Workspace.CurrentCamera
                if State.aimbot then
                    cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPart.Position), State.aimbotSmooth)
                end
                if State.silentAim then
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        pcall(function()
                            mousemoverel(screenPos.X - cam.ViewportSize.X/2, screenPos.Y - cam.ViewportSize.Y/2)
                        end)
                    end
                end
            end
        end
    end
end)

-- === ESP SYSTEM ===
espConnection = RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning then return end
    for char, h in pairs(State.highlights) do
        if not char.Parent or not char:FindFirstChild("Humanoid") then
            h:Destroy()
            State.highlights[char] = nil
        end
    end

    if State.espPlayers then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and not State.highlights[p.Character] then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(255, 50, 50)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.5
                h.Parent = p.Character
                State.highlights[p.Character] = h
            end
        end
    end
end)

-- === FLY SYSTEM ===
local function toggleFly(enabled)
    State.fly = enabled
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while State.fly and getgenv().excluseHubRunning and hrp.Parent do
                local cam = Workspace.CurrentCamera
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
                bv.Velocity = move * State.flySpeed
                bg.CFrame = cam.CFrame
                task.wait()
            end
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    else
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

-- === INFINITE JUMP ===
jumpConnection = UserInputService.JumpRequest:Connect(function()
    if State.infJump and getgenv().excluseHubRunning then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- === FULLBRIGHT ===
local function setFullbright(enabled)
    State.fullbright = enabled
    local l = game:GetService("Lighting")
    if enabled then
        l.Ambient = Color3.fromRGB(200,200,200)
        l.OutdoorAmbient = Color3.fromRGB(200,200,200)
        l.Brightness = 2
    else
        l.Ambient = Color3.fromRGB(70,70,70)
        l.OutdoorAmbient = Color3.fromRGB(128,128,128)
        l.Brightness = 1
    end
end

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Main")
local playerTab = Window:CreateTab("🏃 Player")
local visualsTab = Window:CreateTab("👁️ Visuals")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Main Tab
mainTab:CreateSection("Aimbot")
mainTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = false, Callback = function(v) State.aimbot = v end })
mainTab:CreateSlider({ Name = "Aimbot Smoothness", Range = {0.05, 1}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) State.aimbotSmooth = v end })
mainTab:CreateSlider({ Name = "Aimbot FOV", Range = {30, 360}, Increment = 10, Suffix = "°", CurrentValue = 120, Callback = function(v) State.aimbotFOV = v end })
mainTab:CreateToggle({ Name = "Enable Silent Aim", CurrentValue = false, Callback = function(v) State.silentAim = v end })

-- Player Tab
playerTab:CreateSection("Movement")
playerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
playerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v; h.UseJumpPower = true end
end })
playerTab:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v) toggleFly(v) end })
playerTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.flySpeed = v end })
playerTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end })

-- Visuals Tab
visualsTab:CreateSection("ESP")
visualsTab:CreateToggle({ Name = "Player ESP", CurrentValue = false, Callback = function(v) State.espPlayers = v end })
visualsTab:CreateSection("Environment")
visualsTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v) setFullbright(v) end })

-- Settings Tab
settingsTab:CreateSection("Script Management")
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.aimbot = false; State.silentAim = false; State.espPlayers = false; State.infJump = false
    toggleFly(false)
    if aimbotConnection then aimbotConnection:Disconnect() end
    if espConnection then espConnection:Disconnect() end
    if jumpConnection then jumpConnection:Disconnect() end
    for _, h in pairs(State.highlights) do if h and h.Parent then h:Destroy() end end
    State.highlights = {}
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        local rGui = pg:FindFirstChild("Rayfield"); if rGui then rGui:Destroy() end
        local rToggle = pg:FindFirstChild("RayfieldToggleScreen"); if rToggle then rToggle:Destroy() end
    end
end })

Rayfield:Notify({ Title = "Criminality Loaded", Content = "Aimbot & ESP ready.", Duration = 5 })
