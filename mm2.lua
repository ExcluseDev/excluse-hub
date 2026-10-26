--[[
    excluse hub | Murderer Mystery 2 (True Fling Physics Fix)
--]]
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
    autoEquip = false, killAura = false, killAuraDistance = 20, autoPickup = false,
    murdererEsp = false, sheriffEsp = false, gunEsp = false, coinEsp = false,
    flingEnabled = false, antiFlingEnabled = true, flingRadius = 15,
    highlights = {},
    autoCoinFarm = false, coinFarmSpeed = 0.2
}

local aimbotConnection, jumpConnection, espConnection, flingConnection, antiFlingConnection
local visitedCoins = {}

-- === HELPER: Get Roles ===
local function getRole(char)
    if not char then return "Innocent" end
    local p = Players:GetPlayerFromCharacter(char)
    if not p then return "Innocent" end
    local backpack = p:FindFirstChild("Backpack")
    if backpack then
        if backpack:FindFirstChild("Knife") then return "Murderer" end
        if backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    if char:FindFirstChild("Knife") then return "Murderer" end
    if char:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- === INSTANT ESP SYSTEM ===
espConnection = RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning then return end
    for char, h in pairs(State.highlights) do
        if not char.Parent or (char:IsA("Model") and not char:FindFirstChildOfClass("Humanoid")) then
            h:Destroy(); State.highlights[char] = nil
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local char = p.Character
            local role = getRole(char)
            local shouldHighlight, color = false, Color3.fromRGB(0, 255, 0)
            if role == "Murderer" and State.murdererEsp then shouldHighlight, color = true, Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" and State.sheriffEsp then shouldHighlight, color = true, Color3.fromRGB(0, 150, 255) end
            if shouldHighlight then
                if not State.highlights[char] then
                    local h = Instance.new("Highlight"); h.OutlineColor = Color3.fromRGB(255, 255, 255); h.FillTransparency = 0.5; h.Parent = char; State.highlights[char] = h
                end
                State.highlights[char].FillColor = color; State.highlights[char].Enabled = true
            elseif State.highlights[char] then State.highlights[char].Enabled = false end
        end
    end
    if State.gunEsp then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "Gun" and (obj:IsA("BasePart") or obj:IsA("Model")) and not State.highlights[obj] then
                local h = Instance.new("Highlight"); h.FillColor = Color3.fromRGB(255, 255, 0); h.OutlineColor = Color3.fromRGB(0, 0, 0); h.Parent = obj; State.highlights[obj] = h
            end
        end
    end
    if State.coinEsp then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "CoinContainer" and not State.highlights[v] then
                local h = Instance.new("Highlight"); h.FillColor = Color3.fromRGB(255, 215, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255); h.Parent = v; State.highlights[v] = h
            end
        end
    end
end)

-- === TRUE FLING & ANTI-FLING SYSTEM ===
flingConnection = RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning or not State.flingEnabled then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetChar = p.Character
            local dist = (targetChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist <= State.flingRadius then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-5000, 5000), 5000, math.random(-5000, 5000))
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 100000
                bv.Parent = targetChar.HumanoidRootPart
                game:GetService("Debris"):AddItem(bv, 0.2)
            end
        end
    end
end)

antiFlingConnection = RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning or not State.antiFlingEnabled then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
end)

-- === ROLE SPECIFIC PLAYER FEATURES ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local myRole = getRole(char)
                local backpack = player:FindFirstChild("Backpack")
                
                if State.autoEquip and backpack then
                    local equipped = char:FindFirstChildOfClass("Tool")
                    if myRole == "Murderer" and (not equipped or equipped.Name ~= "Knife") then
                        local knife = backpack:FindFirstChild("Knife")
                        if knife then char.Humanoid:EquipTool(knife) end
                    elseif myRole == "Sheriff" and (not equipped or equipped.Name ~= "Gun") then
                        local gun = backpack:FindFirstChild("Gun")
                        if gun then char.Humanoid:EquipTool(gun) end
                    end
                end

                if State.killAura and myRole == "Murderer" then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                            if dist <= State.killAuraDistance then
                                pcall(function() game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)) end)
                            end
                        end
                    end
                end

                if State.autoPickup then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name == "Gun" or v.Name == "Knife") and v:IsA("Model") and v:FindFirstChild("Handle") then
                            if myRole ~= "Murderer" and v.Name == "Knife" then
                                char.HumanoidRootPart.CFrame = v.Handle.CFrame
                            elseif myRole ~= "Sheriff" and v.Name == "Gun" then
                                char.HumanoidRootPart.CFrame = v.Handle.CFrame
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- === AUTO COIN FARM ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoCoinFarm then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if (v.Name == "CoinContainer" or v.Name == "Coin") and not visitedCoins[v] then
                        if v:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = CFrame.new(v.Position)
                            visitedCoins[v] = true
                            task.wait(State.coinFarmSpeed)
                        elseif v:IsA("Model") and v.PrimaryPart then
                            char.HumanoidRootPart.CFrame = CFrame.new(v.PrimaryPart.Position)
                            visitedCoins[v] = true
                            task.wait(State.coinFarmSpeed)
                        end
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- === AIMBOT / SILENT AIM ===
local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and getRole(p.Character) == "Murderer" then return p.Character end
    end
    return nil
end

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
local flingTab = Window:CreateTab("🌀 Fling")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat
mainTab:CreateSection("Aimbot")
mainTab:CreateToggle({ Name = "Enable Aimbot (Locks Camera)", CurrentValue = false, Callback = function(v) State.aimbot = v end })
mainTab:CreateToggle({ Name = "Silent Aim (Executor Dependent)", CurrentValue = false, Callback = function(v) State.silentAim = v end })
mainTab:CreateToggle({ Name = "Auto Shoot / Stab", CurrentValue = false, Callback = function(v) State.autoShoot = v end })

mainTab:CreateSection("Role Specific Features")
mainTab:CreateToggle({ Name = "Auto-Equip Knife / Gun", CurrentValue = false, Callback = function(v) State.autoEquip = v end })
mainTab:CreateToggle({ Name = "Murderer Kill Aura (Long Stab)", CurrentValue = false, Callback = function(v) State.killAura = v end })
mainTab:CreateSlider({ Name = "Kill Aura Distance", Range = {5, 50}, Increment = 1, CurrentValue = 20, Callback = function(v) State.killAuraDistance = v end })
mainTab:CreateToggle({ Name = "Auto-Pickup Dropped Items", CurrentValue = false, Callback = function(v) State.autoPickup = v end })

mainTab:CreateSection("Teleports")
mainTab:CreateButton({
    Name = "📍 Teleport to Murderer",
    Callback = function()
        local murderer = getMurderer()
        if murderer and murderer:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = murderer.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to Murderer!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Teleport", Content = "Murderer not found!", Duration = 2 })
        end
    end,
})

-- Farm Tab
farmTab:CreateSection("Coin Automation")
farmTab:CreateToggle({ Name = "Auto Collect Coins", CurrentValue = false, Callback = function(v) State.autoCoinFarm = v end })
farmTab:CreateSlider({ Name = "Farm Speed (Lower = Faster)", Range = {0.05, 1}, Increment = 0.05, Suffix = "s", CurrentValue = 0.2, Callback = function(v) State.coinFarmSpeed = v end })
farmTab:CreateButton({ Name = "🔄 Reset Visited Coins", Callback = function() visitedCoins = {} end })
farmTab:CreateSection("Visuals")
farmTab:CreateToggle({ Name = "Coin ESP (Highlights Coins)", CurrentValue = false, Callback = function(v) 
    State.coinEsp = v 
    if not v then for obj, h in pairs(State.highlights) do if obj.Name == "CoinContainer" or obj.Name == "Coin" then h:Destroy(); State.highlights[obj] = nil end end end
end })

-- Visuals
visualsTab:CreateSection("Instant Role ESP")
visualsTab:CreateToggle({ Name = "Murderer ESP (Red)", CurrentValue = false, Callback = function(v) State.murdererEsp = v end })
visualsTab:CreateToggle({ Name = "Sheriff ESP (Blue)", CurrentValue = false, Callback = function(v) State.sheriffEsp = v end })
visualsTab:CreateSection("Item ESP")
visualsTab:CreateToggle({ Name = "Dropped Gun ESP (Yellow)", CurrentValue = false, Callback = function(v) 
    State.gunEsp = v 
    if not v then for obj, h in pairs(State.highlights) do if obj.Name == "Gun" then h:Destroy(); State.highlights[obj] = nil end end end
end })
visualsTab:CreateSection("Environment")
visualsTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    local l = game:GetService("Lighting")
    if v then l.Ambient = Color3.fromRGB(200,200,200); l.OutdoorAmbient = Color3.fromRGB(200,200,200); l.Brightness = 2
    else l.Ambient = Color3.fromRGB(70,70,70); l.OutdoorAmbient = Color3.fromRGB(128,128,128); l.Brightness = 1 end
end })

-- Fling Tab
flingTab:CreateSection("Fling Settings")
flingTab:CreateToggle({ Name = "Enable Touch Fling", CurrentValue = false, Callback = function(v) State.flingEnabled = v end })
flingTab:CreateSlider({ Name = "Fling Radius", Range = {5, 30}, Increment = 1, CurrentValue = 15, Callback = function(v) State.flingRadius = v end })
flingTab:CreateSection("Protection")
flingTab:CreateToggle({ Name = "Anti-Fling (Self Protection)", CurrentValue = true, Callback = function(v) State.antiFlingEnabled = v end })

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

-- Settings (FOOLPROOF UNLOAD)
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    for k, v in pairs(State) do if type(v) == "boolean" then State[k] = false end end
    if aimbotConnection then aimbotConnection:Disconnect() end
    if jumpConnection then jumpConnection:Disconnect() end
    if espConnection then espConnection:Disconnect() end
    if flingConnection then flingConnection:Disconnect() end
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    for _, h in pairs(State.highlights) do if h and h.Parent then h:Destroy() end end
    State.highlights = {}
    task.wait(0.5)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        local rGui = pg:FindFirstChild("Rayfield"); if rGui then rGui:Destroy() end
        local rToggle = pg:FindFirstChild("RayfieldToggleScreen"); if rToggle then rToggle:Destroy() end
    end
end })

Rayfield:Notify({ Title = "MM2 Loaded", Content = "True Touch Fling & Anti-Fling ready.", Duration = 5 })
