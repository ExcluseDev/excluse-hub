--[[
    excluse hub | Bee Swarm Simulator (Superior Macro)
--]]
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
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
    Name = "excluse hub | BSS", LoadingTitle = "Loading BSS...", LoadingSubtitle = "by excluse",
    Theme = GalaxyTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

local State = {
    fly = false, flySpeed = 50, infJump = false,
    autoFarm = false, autoConvert = false, autoDig = false, autoSprinkler = false,
    autoToken = false, autoMobs = false, autoQuest = false,
    farmField = "None", mobKillRadius = 50
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

-- === HELPER: Get Field CFrame ===
local function getFieldCFrame(fieldName)
    local fields = Workspace:FindFirstChild("Fields")
    if fields then
        local field = fields:FindFirstChild(fieldName)
        if field and field:FindFirstChild("Center") then
            return field.Center.CFrame
        end
    end
    return nil
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

-- === AUTO FARM SYSTEM ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoFarm and State.farmField ~= "None" then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local fieldCFrame = getFieldCFrame(State.farmField)
                if fieldCFrame then
                    char.HumanoidRootPart.CFrame = fieldCFrame * CFrame.new(math.random(-20, 20), 5, math.random(-20, 20))
                end
            end)
        end
        task.wait(1) 
    end
end)

-- === AUTO CONVERT (HIVE) ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoConvert then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hive = Workspace:FindFirstChild("Hive")
                if hive and hive:FindFirstChild("Convert") then
                    char.HumanoidRootPart.CFrame = hive.Convert.CFrame * CFrame.new(0, 5, 0)
                end
            end)
        end
        task.wait(5) 
    end
end)

-- === AUTO DIG ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoDig then
            pcall(function()
                local char = player.Character
                if not char then return end
                local digTool = char:FindFirstChild("Dig") or char:FindFirstChild("Shovel")
                if digTool and digTool:IsA("Tool") then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
                    task.wait(0.5)
                end
            end)
        end
        task.wait(1)
    end
end)

-- === AUTO SPRINKLER ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoSprinkler then
            pcall(function()
                local char = player.Character
                if not char then return end
                local sprinkler = char:FindFirstChild("Sprinkler")
                if sprinkler and sprinkler:IsA("Tool") then
                    char.Humanoid:EquipTool(sprinkler)
                    task.wait(0.5)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0,0))
                end
            end)
        end
        task.wait(3)
    end
end)

-- === AUTO TOKEN COLLECTION ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoToken then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if (v.Name == "Token" or v.Name == "HoneyToken") and v:IsA("BasePart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(v.Position)
                        task.wait(0.1)
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- === AUTO MOB KILLER ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoMobs then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= player.Name then
                        local hrp = v:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                            if dist <= State.mobKillRadius then
                                char.HumanoidRootPart.CFrame = CFrame.new(hrp.Position)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(2)
    end
end)

-- === AUTO QUEST FULFILLMENT ===
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.autoQuest then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v.Name == "NPC" or v.Name == "QuestGiver" then
                        if v:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            task.wait(1) 
                        end
                    end
                end
            end)
        end
        task.wait(10) 
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
local questTab = Window:CreateTab("📜 Quests")
local visualsTab = Window:CreateTab("👁️ Visuals")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat
mainTab:CreateSection("Combat")
mainTab:CreateToggle({ Name = "Auto Kill Mobs", CurrentValue = false, Callback = function(v) State.autoMobs = v end })
mainTab:CreateSlider({ Name = "Mob Kill Radius", Range = {10, 100}, Increment = 5, CurrentValue = 50, Callback = function(v) State.mobKillRadius = v end })

-- Farm Tab
farmTab:CreateSection("Auto Farm")
farmTab:CreateDropdown({
    Name = "Select Field",
    Options = {"None", "Dandelion", "Mushroom", "Blue Flower", "Clover", "Bamboo", "Pineapple", "Strawberry", "Cactus"},
    CurrentOption = "None",
    Callback = function(v) State.farmField = v end,
})
farmTab:CreateToggle({ Name = "Enable Auto Farm", CurrentValue = false, Callback = function(v) State.autoFarm = v end })
farmTab:CreateSection("Auto Convert & Dig")
farmTab:CreateToggle({ Name = "Auto Convert at Hive", CurrentValue = false, Callback = function(v) State.autoConvert = v end })
farmTab:CreateToggle({ Name = "Auto Dig", CurrentValue = false, Callback = function(v) State.autoDig = v end })
farmTab:CreateToggle({ Name = "Auto Sprinkler", CurrentValue = false, Callback = function(v) State.autoSprinkler = v end })
farmTab:CreateSection("Collection")
farmTab:CreateToggle({ Name = "Auto Collect Tokens", CurrentValue = false, Callback = function(v) State.autoToken = v end })

-- Quest Tab
questTab:CreateSection("Auto Quest")
questTab:CreateToggle({ Name = "Auto Fulfill Quests (NPC TP)", CurrentValue = false, Callback = function(v) State.autoQuest = v end })
questTab:CreateLabel("Note: This will teleport you to NPCs. It may need manual quest claiming.")

-- Visuals
visualsTab:CreateSection("ESP")
visualsTab:CreateToggle({ Name = "Coin ESP (Gold)", CurrentValue = false, Callback = function(v) State.coinEsp = v end })
visualsTab:CreateToggle({ Name = "Dropped Gun ESP (Yellow)", CurrentValue = false, Callback = function(v) State.gunEsp = v end })
visualsTab:CreateSection("Environment")
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
playerTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infJump = v end })

-- Settings (FOOLPROOF UNLOAD)
settingsTab:CreateSection("Server Management")
settingsTab:CreateButton({ 
    Name = "🔄 Rejoin Server", 
    Callback = function()
        Rayfield:Notify({ Title = "Rejoining", Content = "Rejoining the same server...", Duration = 3 })
        task.wait(0.5)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end)
    end 
})

settingsTab:CreateSection("Script Management")
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

Rayfield:Notify({ Title = "BSS Loaded", Content = "Superior Macro features ready.", Duration = 5 })
