--[[
    excluse hub | Murder Mystery 2 (Foolproof Unload Update)
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
    Name = "excluse hub | MM2", LoadingTitle = "Loading MM2...", LoadingSubtitle = "by excluse",
    Theme = GalaxyTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

local State = {
    fly = false, flySpeed = 50, infJump = false,
    aimbot = false, silentAim = false, autoShoot = false,
    esp = false, coinEsp = false, highlights = {},
    autoCoinFarm = false, coinFarmSpeed = 0.2
}

-- Variables to store connections so we can kill them on unload
local aimbotConnection
local jumpConnection

-- === HELPER: Get Roles ===
local function getRole(char)
    if not char then return "Innocent" end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        if backpack:FindFirstChild("Knife") then return "Murderer" end
        if backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    if char:FindFirstChild("Knife") then return "Murderer" end
    if char:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- === ESP SYSTEM ===
local function createESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if not State.highlights[p.Name] or not State.highlights[p.Name].Parent then
                local role = getRole(p.Character)
                local color = Color3.fromRGB(0, 255, 0)
                if role == "Murderer" then color = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then color = Color3.fromRGB(0, 150, 255) end

                local h = Instance.new("Highlight")
                h.FillColor = color
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.5
                h.Parent = p.Character
                State.highlights[p.Name] = h
            end
        end
    end
    -- Gun ESP
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Gun" and obj:IsA("BasePart") and not State.highlights[obj] then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 255, 0)
            h.Parent = obj
            State.highlights[obj] = h
        end
    end
end

-- === COIN ESP ===
local function createCoinESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "CoinContainer" and v:IsA("Model") and not State.highlights[v] then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 215, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.Parent = v
            State.highlights[v] = h
        end
    end
end

task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.esp then pcall(createESP) end
        if State.coinEsp then pcall(createCoinESP) end
        task.wait(1)
    end
end)

-- === AUTO COIN FARM ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoCoinFarm then
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "CoinContainer" and v:IsA("Model") then
                            local coinPos = v:GetModelCFrame().Position
                            char:MoveTo(coinPos)
                            task.wait(State.coinFarmSpeed)
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- === AIMBOT / SILENT AIM ===
local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if getRole(p.Character) == "Murderer" then return p.Character end
        end
    end
    return nil
end

-- Stored in a variable so we can disconnect it on unload
aimbotConnection = RunService.RenderStepped:Connect(function()
    if not getgenv().excluseHubRunning then return end
    if State.aimbot or State.silentAim then
        local target = getMurderer()
        if target then
            local targetPart = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local cam = Workspace.CurrentCamera
                if State.aimbot then cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position) end
                if State.silentAim then
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then pcall(function() mousemoverel(screenPos.X - cam.ViewportSize.X/2, screenPos.Y - cam.ViewportSize.Y/2) end) end
                end
            end
        end
    end
end)

-- === AUTO SHOOT / STAB ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoShoot then
            local murderer = getMurderer()
            if murderer then
                local myRole = getRole(player.Character)
                if myRole == "Sheriff" then
                    pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)) end)
                elseif myRole == "Murderer" then
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    local targetRoot = murderer:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot and (myRoot.Position - targetRoot.Position).Magnitude < 5 then
                        pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)) end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- === INFINITE JUMP ===
jumpConnection = UserInputService.JumpRequest:Connect(function()
    if State.infJump and getgenv().excluseHubRunning then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Combat")
local farmTab = Window:CreateTab("💰 Farm")
local visualsTab = Window:CreateTab("👁️ Visuals")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat
mainTab:CreateSection("Aimbot")
mainTab:CreateToggle({ Name = "Enable Aimbot (Locks Camera)", CurrentValue = false, Callback = function(v) State.aimbot = v end })
mainTab:CreateToggle({ Name = "Silent Aim (Executor Dependent)", CurrentValue = false, Callback = function(v) State.silentAim = v end })
mainTab:CreateToggle({ Name = "Auto Shoot / Stab", CurrentValue = false, Callback = function(v) State.autoShoot = v end })

-- Farm Tab
farmTab:CreateSection("Coin Automation")
farmTab:CreateToggle({
    Name = "Auto Collect Coins",
    CurrentValue = false,
    Callback = function(v) State.autoCoinFarm = v end,
})
farmTab:CreateSlider({
    Name = "Farm Speed (Lower = Faster)",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = 0.2,
    Callback = function(v) State.coinFarmSpeed = v end,
})
farmTab:CreateSection("Visuals")
farmTab:CreateToggle({
    Name = "Coin ESP (Highlights Coins)",
    CurrentValue = false,
    Callback = function(v)
        State.coinEsp = v
        if not v then
            for _, h in pairs(State.highlights) do
                if h and h.Parent and h.Parent.Name == "CoinContainer" then h:Destroy() end
            end
        end
    end,
})

-- Visuals
visualsTab:CreateSection("ESP")
visualsTab:CreateToggle({ Name = "Player & Gun ESP", CurrentValue = false, Callback = function(v)
    State.esp = v
    if not v then
        for _, h in pairs(State.highlights) do
            if h and h.Parent and h.Parent:IsA("Model") and h.Parent.Name ~= "CoinContainer" then h:Destroy() end
        end
    end
end })
visualsTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    local l = game:GetService("Lighting")
    if v then l.Ambient = Color3.fromRGB(200,200,200); l.OutdoorAmbient = Color3.fromRGB(200,200,200); l.Brightness = 2
    else l.Ambient = Color3.fromRGB(70,70,70); l.OutdoorAmbient = Color3.fromRGB(128,128,128); l.Brightness = 1 end
end })

-- Player
playerTab:CreateSection("Movement")
playerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end
end })
playerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = v; h.UseJumpPower = true end
end })
playerTab:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v)
    State.fly = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if v and hrp then
        local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while State.fly and getgenv().excluseHubRunning and hrp.Parent do
                local cam = Workspace.CurrentCamera; local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
                bv.Velocity = move * State.flySpeed; bg.CFrame = cam.CFrame
                task.wait()
            end
            if bg then bg:Destroy() end; if bv then bv:Destroy() end
        end)
    end
end })
playerTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.flySpeed = v end })
playerTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end })

-- Settings (THE FOOLPROOF UNLOAD)
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    -- 1. Kill the global flag so loops stop
    getgenv().excluseHubRunning = false
    
    -- 2. Turn off all state variables
    for k, v in pairs(State) do
        if type(v) == "boolean" then State[k] = false end
    end

    -- 3. Disconnect the active RenderStepped and Input connections
    if aimbotConnection then aimbotConnection:Disconnect() end
    if jumpConnection then jumpConnection:Disconnect() end

    -- 4. Clean up all ESP instances
    for _, h in pairs(State.highlights) do 
        if h and h.Parent then h:Destroy() end 
    end
    State.highlights = {}

    -- 5. Wait for the game engine to catch up and stop all loops
    task.wait(0.5)

    -- 6. Destroy the Window and force-clean the PlayerGui
    pcall(function() Window:Destroy() end)
    
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        local rGui = pg:FindFirstChild("Rayfield")
        if rGui then rGui:Destroy() end
        local rToggle = pg:FindFirstChild("RayfieldToggleScreen")
        if rToggle then rToggle:Destroy() end
    end
end })

Rayfield:Notify({ Title = "MM2 Loaded", Content = "Auto Coin Farm & Combat ready.", Duration = 5 })
