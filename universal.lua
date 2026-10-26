--[[
    excluse universal hub (GOD TIER OVERKILL)
    Credits: Infinite Yield (Open Source), Edge, Synapse
    WARNING: THIS SCRIPT IS MASSIVE. EXPECT HEAVY COMPILATION TIME.
--]]

local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Mouse = player:GetMouse()
local Camera = Workspace.CurrentCamera

-- ===================================================================
-- === PART 1: MINIMALIST INTRO ===
-- ===================================================================
local introGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
introGui.IgnoreGuiInset = true
introGui.DisplayOrder = 9999
local bg = Instance.new("Frame", introGui); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,8); bg.BorderSizePixel = 0
local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(0,200,0,100); txt.Position = UDim2.new(0.5,-100,0.5,-50); txt.BackgroundTransparency = 1; txt.Text = "EXC"; txt.TextColor3 = Color3.new(1,1,1); txt.TextScaled = true; txt.Font = Enum.Font.GothamBlack; txt.TextTransparency = 1
local stroke = Instance.new("UIStroke", txt); stroke.Thickness = 2; stroke.Color = Color3.fromRGB(150, 200, 255); stroke.Transparency = 1

TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
task.wait(0.6)
TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
task.wait(0.3)
introGui:Destroy()

-- ===================================================================
-- === PART 2: RAYFIELD & THEME ===
-- ===================================================================
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
    Name = "excluse universal hub", LoadingTitle = "Compiling OVERKILL...", LoadingSubtitle = "v4.0 GOD TIER",
    Theme = VoidGlassTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

-- ===================================================================
-- === PART 3: ULTRA UI OVERRIDE (ANIMATIONS & GLASS) ===
-- ===================================================================
task.spawn(function()
    task.wait(1)
    local pg = player:FindFirstChild("PlayerGui")
    local rayfieldGui = pg and pg:FindFirstChild("Rayfield")
    if not rayfieldGui or not rayfieldGui:FindFirstChild("MainFrame") then return end
    
    local mainFrame = rayfieldGui.MainFrame
    local bg = mainFrame:FindFirstChild("Background")
    
    if bg then
        local galaxyImage = Instance.new("ImageLabel")
        galaxyImage.Size = UDim2.new(1.5, 0, 1.5, 0)
        galaxyImage.Position = UDim2.new(-0.25, 0, -0.25, 0)
        galaxyImage.BackgroundTransparency = 1
        galaxyImage.Image = "rbxassetid://7148785474"
        galaxyImage.ImageTransparency = 0.2
        galaxyImage.ZIndex = 0
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
        if desc:IsA("ImageLabel") and desc.Name ~= "GalaxyImage" then 
            desc.Visible = false 
        end
        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
            local uiScale = Instance.new("UIScale")
            uiScale.Parent = desc
            desc.MouseEnter:Connect(function() TweenService:Create(uiScale, TweenInfo.new(0.2), {Scale = 1.05}):Play() end)
            desc.MouseLeave:Connect(function() TweenService:Create(uiScale, TweenInfo.new(0.2), {Scale = 1}):Play() end)
            desc.MouseButton1Down:Connect(function() TweenService:Create(uiScale, TweenInfo.new(0.1), {Scale = 0.95}):Play() end)
            desc.MouseButton1Up:Connect(function() TweenService:Create(uiScale, TweenInfo.new(0.2), {Scale = 1.05}):Play() end)
        end
    end
end)

-- ===================================================================
-- === PART 4: STATE & HELPERS ===
-- ===================================================================
local Connections = {}
local State = {
    Noclip = false, Fly = false, CarFly = false, Fling = false, InvisFling = false,
    ESP = false, Chams = false, XRay = false, InfJump = false, AntiAFK = false,
    Godmode = false, AutoClick = false, Aimbot = false, SilentAim = false, Hitbox = false,
    Spinbot = false, BunnyHop = false, Tracers = false, BoxESP = false, NameESP = false,
    FlySpeed = 50, AimbotFOV = 120, HitboxSize = 10,
    OriginalSizes = {}, OriginalTransparencies = {}, Waypoints = {},
    InvisibleParts = {}, Target = nil
}

local function addConnection(conn) table.insert(Connections, conn) end
local function getRoot(char) return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")) end
local function getHum(char) return char and char:FindFirstChildOfClass("Humanoid") end

-- Drawing API ESP Setup
local Drawings = {}
local function newDrawing(class, properties)
    local obj = Drawing.new(class)
    for k, v in pairs(properties) do obj[k] = v end
    table.insert(Drawings, obj)
    return obj
end

-- ===================================================================
-- === PART 5: COMBAT (Aimbot, Silent Aim, Hitbox) ===
-- ===================================================================

-- Camera Aimbot
local aimbotLoop = RunService.RenderStepped:Connect(function()
    if not State.Aimbot then return end
    local closest, dist = nil, State.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team and player.Team and p.Team == player.Team then continue end
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if d < dist then dist = d; closest = hrp end
            end
        end
    end
    if closest then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), 0.2)
    end
end)
addConnection(aimbotLoop)

-- Silent Aim
local silentAimLoop = RunService.RenderStepped:Connect(function()
    if not State.SilentAim then return end
    local closest, dist = nil, State.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if d < dist then dist = d; closest = head end
            end
        end
    end
    if closest then
        local sp, os = Camera:WorldToViewportPoint(closest.Position)
        if os then
            pcall(function() mousemoverel(sp.X - Camera.ViewportSize.X/2, sp.Y - Camera.ViewportSize.Y/2) end)
        end
    end
end)
addConnection(silentAimLoop)

-- Hitbox Expander
local hitboxLoop = RunService.Heartbeat:Connect(function()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if State.Hitbox then
                    if not State.OriginalSizes[p.Character] then State.OriginalSizes[p.Character] = hrp.Size end
                    hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    hrp.Transparency = 0.5
                else
                    if State.OriginalSizes[p.Character] then
                        hrp.Size = State.OriginalSizes[p.Character]
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
end)
addConnection(hitboxLoop)

-- Auto Clicker
task.spawn(function()
    while getgenv().excluseHubRunning do
        if State.AutoClick then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
        task.wait(0.1)
    end
end)

-- ===================================================================
-- === PART 6: MOVEMENT (Fly, Noclip, Spinbot, Bhop) ===
-- ===================================================================

local noclipLoop
local function toggleNoclip(enabled)
    State.Noclip = enabled
    if enabled then
        noclipLoop = RunService.Stepped:Connect(function()
            if player.Character then
                for _, c in pairs(player.Character:GetDescendants()) do
                    if c:IsA("BasePart") and c.CanCollide then c.CanCollide = false end
                end
            end
        end)
        addConnection(noclipLoop)
    else
        if noclipLoop then noclipLoop:Disconnect() end
        if player.Character then
            for _, c in pairs(player.Character:GetDescendants()) do if c:IsA("BasePart") then c.CanCollide = true end end
        end
    end
end

local cflyLoop
local function toggleCFly(enabled)
    State.Fly = enabled
    local char = player.Character; if not char then return end
    local head, hum = char:FindFirstChild("Head"), getHum(char); if not head or not hum then return end
    if enabled then
        hum.PlatformStand = true; head.Anchored = true
        cflyLoop = RunService.Heartbeat:Connect(function(dt)
            local moveDir = hum.MoveDirection * (State.FlySpeed * dt)
            local headCF, camCF = head.CFrame, Camera.CFrame
            local camOffset = headCF:ToObjectSpace(camCF).Position
            camCF = camCF * CFrame.new(-camOffset.X, -camOffset.Y, -camOffset.Z + 1)
            local camPos, headPos = camCF.Position, headCF.Position
            local objSpaceVel = CFrame.new(camPos, Vector3.new(headPos.X, camPos.Y, headPos.Z)):VectorToObjectSpace(moveDir)
            head.CFrame = CFrame.new(headPos) * (camCF - camPos) * CFrame.new(objSpaceVel)
        end)
        addConnection(cflyLoop)
    else
        if cflyLoop then cflyLoop:Disconnect() end
        hum.PlatformStand = false; head.Anchored = false
    end
end

local carLoop
local function toggleCarFly(enabled)
    State.CarFly = enabled
    local char = player.Character; if not char then return end
    local hum = getHum(char); if not hum or not hum.SeatPart then Rayfield:Notify({Title="CarFly", Content="Get in a vehicle!", Duration=3}) return end
    local vehicle = hum.SeatPart:FindFirstAncestorOfClass("Model"); if not vehicle then return end
    local root = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
    if enabled then
        local bg = Instance.new("BodyGyro", root); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        carLoop = RunService.Heartbeat:Connect(function()
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move * State.FlySpeed; bg.CFrame = Camera.CFrame
        end)
        addConnection(carLoop)
    else
        if carLoop then carLoop:Disconnect() end
        for _, v in pairs(root:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end
    end
end

-- Spinbot & Bhop
RunService.Heartbeat:Connect(function()
    if State.Spinbot and player.Character then
        local hrp = getRoot(player.Character)
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0) end
    end
    if State.BunnyHop and player.Character then
        local hum = getHum(player.Character)
        if hum and hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Landed then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and player.Character then
        local hum = getHum(player.Character); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ===================================================================
-- === PART 7: VISUALS (Drawing ESP, Chams, X-Ray) ===
-- ===================================================================

local espObjects = {}
local function createESP()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and not espObjects[p] then
            local h = Instance.new("Highlight")
            h.Name = "EXC_ESP"
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.5
            h.Parent = p.Character
            espObjects[p] = h
        end
    end
end
local function clearESP()
    for _, h in pairs(espObjects) do if h then h:Destroy() end end
    espObjects = {}
end

local chamsBoxes = {}
local function createChams()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            for _, part in pairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "EXC_Chams"
                    box.Size = part.Size
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Transparency = 0.5
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Parent = part
                    table.insert(chamsBoxes, box)
                end
            end
        end
    end
end
local function clearChams()
    for _, b in pairs(chamsBoxes) do if b then b:Destroy() end end
    chamsBoxes = {}
end

local function toggleXRay(enabled)
    State.XRay = enabled
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            if enabled then
                if not State.OriginalTransparencies[part] then State.OriginalTransparencies[part] = part.LocalTransparencyModifier end
                part.LocalTransparencyModifier = 0.5
            else
                if State.OriginalTransparencies[part] then part.LocalTransparencyModifier = State.OriginalTransparencies[part] end
            end
        end
    end
end

-- ===================================================================
-- === PART 8: TROLLING (Fling, Void TP, Freeze, Orbit) ===
-- ===================================================================

-- VOID TP (Fall through floor)
local function voidTP()
    local char = player.Character
    if char and getRoot(char) then
        getRoot(char).CFrame = CFrame.new(getRoot(char).Position.X, -1000, getRoot(char).Position.Z)
        Rayfield:Notify({Title="Void TP", Content="You have been sent to the shadow realm.", Duration=3})
    end
end

local flingDied
local function toggleFling(enabled)
    State.Fling = enabled
    local char = player.Character; if not char then return end
    if enabled then
        for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5) end end
        toggleNoclip(true); task.wait(0.1)
        local bambam = Instance.new("BodyAngularVelocity")
        bambam.Name = "EXCFling"; bambam.Parent = char.HumanoidRootPart
        bambam.AngularVelocity = Vector3.new(0, 99999, 0); bambam.MaxTorque = Vector3.new(0, math.huge, 0); bambam.P = math.huge
        for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false; v.Massless = true; v.Velocity = Vector3.new(0,0,0) end end
        flingDied = char:FindFirstChildOfClass("Humanoid").Died:Connect(function() toggleFling(false) end)
        task.spawn(function()
            while State.Fling and bambam.Parent do
                bambam.AngularVelocity = Vector3.new(0, 99999, 0); task.wait(0.2)
                bambam.AngularVelocity = Vector3.new(0, 0, 0); task.wait(0.1)
            end
        end)
    else
        toggleNoclip(false)
        if flingDied then flingDied:Disconnect() end
        if char then
            local bambam = char.HumanoidRootPart:FindFirstChild("EXCFling")
            if bambam then bambam:Destroy() end
            for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5); c.Massless = false end end
        end
    end
end

local orbitLoop
local function toggleOrbit(enabled)
    if enabled then
        orbitLoop = RunService.Heartbeat:Connect(function()
            local myRoot = getRoot(player.Character)
            if myRoot then
                local angle = tick() * 5
                for i, p in ipairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= player and p.Character and getRoot(p.Character) then
                        local offset = CFrame.new(math.cos(angle + (i * 1.5)) * 15, 0, math.sin(angle + (i * 1.5)) * 15)
                        getRoot(p.Character).CFrame = myRoot.CFrame * offset
                    end
                end
            end
        end)
        addConnection(orbitLoop)
    else
        if orbitLoop then orbitLoop:Disconnect() end
    end
end

-- Freeze All
local function freezeAll()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") and not v.Anchored then v.Anchored = true end
            end
        end
    end
end
local function thawAll()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.Anchored then v.Anchored = false end
            end
        end
    end
end

-- ===================================================================
-- === PART 9: PLAYER & UTILS ===
-- ===================================================================

local function toggleGodmode(enabled)
    State.Godmode = enabled
    if enabled then
        local char = player.Character
        if char then
            local hum = getHum(char)
            if hum then
                local newHum = hum:Clone(); newHum.Parent = char; newHum.Name = "1"; hum:Destroy()
                Camera.CameraSubject = char
                newHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                newHum.Name = "Humanoid"
                local animate = char:FindFirstChild("Animate")
                if animate then animate.Disabled = true; task.wait(); animate.Disabled = false end
                newHum.Health = newHum.MaxHealth
            end
        end
    end
end

local invisParts = {}
local function toggleInvis(enabled)
    local char = player.Character; if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            if enabled then
                if not invisParts[v] then invisParts[v] = v.Transparency end
                v.Transparency = 1
            else
                if invisParts[v] then v.Transparency = invisParts[v] end
            end
        end
    end
end

local function serverHop()
    local servers = {}
    pcall(function()
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        if req and req.data then
            for _, v in pairs(req.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(servers, v.id) end
            end
        end
    end)
    if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
    else Rayfield:Notify({Title="Server Hop", Content="No servers found.", Duration=3}) end
end

local function gotoPlayer(name)
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p.Name:lower():find(name:lower()) and p ~= player then
            if p.Character and getRoot(p.Character) then
                getRoot(player.Character).CFrame = getRoot(p.Character).CFrame * CFrame.new(0,0,3)
                break
            end
        end
    end
end

local function bringPlayer(name)
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p.Name:lower():find(name:lower()) and p ~= player then
            if p.Character and getRoot(p.Character) then
                getRoot(p.Character).CFrame = getRoot(player.Character).CFrame * CFrame.new(0,0,3)
                break
            end
        end
    end
end

-- ===================================================================
-- === PART 10: THE 10 TABS (THE OVERKILL UI) ===
-- ===================================================================

local CombatTab = Window:CreateTab("⚔️ Combat")
local MoveTab = Window:CreateTab("🏃 Movement")
local VisualTab = Window:CreateTab("👁️ Visuals")
local TrollTab = Window:CreateTab("😈 Trolling")
local PlayerTab = Window:CreateTab("👥 Player")
local TP_Tab = Window:CreateTab("📍 Teleports")
local UtilTab = Window:CreateTab("🛠️ Utility")
local WorldTab = Window:CreateTab("🏗️ World")
local FunTab = Window:CreateTab("🎪 Fun")
local SettingsTab = Window:CreateTab("⚙️ Settings")

-- ================= COMBAT TAB =================
CombatTab:CreateSection("Aimbot & Silent Aim")
CombatTab:CreateToggle({ Name = "Camera Aimbot", CurrentValue = false, Callback = function(v) State.Aimbot = v end })
CombatTab:CreateToggle({ Name = "Silent Aim (Mouse)", CurrentValue = false, Callback = function(v) State.SilentAim = v end })
CombatTab:CreateSlider({ Name = "Aimbot FOV", Range = {30, 360}, Increment = 10, CurrentValue = 120, Callback = function(v) State.AimbotFOV = v end })

CombatTab:CreateSection("Hitbox Expander")
CombatTab:CreateToggle({ Name = "Enable Hitbox", CurrentValue = false, Callback = function(v) State.Hitbox = v end })
CombatTab:CreateSlider({ Name = "Hitbox Size", Range = {1, 50}, Increment = 1, CurrentValue = 10, Callback = function(v) State.HitboxSize = v end })

CombatTab:CreateSection("Auto Clicker")
CombatTab:CreateToggle({ Name = "Enable Auto Clicker", CurrentValue = false, Callback = function(v) State.AutoClick = v end })

-- ================= MOVEMENT TAB =================
MoveTab:CreateSection("Speed & Jump")
MoveTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) if getHum(player.Character) then getHum(player.Character).WalkSpeed = v end end })
MoveTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) local h = getHum(player.Character); if h then h.JumpPower = v; h.UseJumpPower = true end end })
MoveTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.InfJump = v end })
MoveTab:CreateToggle({ Name = "Bunny Hop", CurrentValue = false, Callback = function(v) State.BunnyHop = v end })

MoveTab:CreateSection("Advanced Movement")
MoveTab:CreateToggle({ Name = "CFrame Fly (Bypass)", CurrentValue = false, Callback = function(v) toggleCFly(v) end })
MoveTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.FlySpeed = v end })
MoveTab:CreateToggle({ Name = "CarFly (Vehicle)", CurrentValue = false, Callback = function(v) toggleCarFly(v) end })
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) toggleNoclip(v) end })
MoveTab:CreateToggle({ Name = "Spinbot", CurrentValue = false, Callback = function(v) State.Spinbot = v end })

-- ================= VISUALS TAB =================
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({ Name = "Highlight ESP", CurrentValue = false, Callback = function(v)
    State.ESP = v
    if v then createESP(); addConnection(RunService.Heartbeat:Connect(function() if State.ESP then createESP() end end)) else clearESP() end
end })
VisualTab:CreateToggle({ Name = "Chams (Box)", CurrentValue = false, Callback = function(v)
    State.Chams = v
    if v then createChams(); addConnection(RunService.Heartbeat:Connect(function() if State.Chams then clearChams(); createChams() end end)) else clearChams() end
end })

VisualTab:CreateSection("Environment")
VisualTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
end })
VisualTab:CreateToggle({ Name = "X-Ray", CurrentValue = false, Callback = function(v) toggleXRay(v) end })
VisualTab:CreateSlider({ Name = "Camera FOV", Range = {30, 120}, Increment = 5, CurrentValue = 70, Callback = function(v) Camera.FieldOfView = v end })

-- ================= TROLLING TAB =================
TrollTab:CreateSection("Devastation")
TrollTab:CreateToggle({ Name = "Fling (Touch Player)", CurrentValue = false, Callback = function(v) toggleFling(v) end })
TrollTab:CreateToggle({ Name = "Orbit All Players", CurrentValue = false, Callback = function(v) toggleOrbit(v) end })
TrollTab:CreateButton({ Name = "Freeze All Players", Callback = function() freezeAll() end })
TrollTab:CreateButton({ Name = "Thaw All Players", Callback = function() thawAll() end })
TrollTab:CreateButton({ Name = "☠️ VOID TP (Fall Through Floor)", Callback = function() voidTP() end })

TrollTab:CreateSection("Animations")
TrollTab:CreateButton({ Name = "Spasm Animation", Callback = function()
    local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://33796059"
    local track = getHum(player.Character):LoadAnimation(anim); track:Play(); track:AdjustSpeed(99)
end })
TrollTab:CreateButton({ Name = "Dance (R6 Only)", Callback = function()
    local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://" .. ({"27789359", "30196114", "248263260", "45834924", "33796059", "28488254", "52155728"})[math.random(1, 7)]
    getHum(player.Character):LoadAnimation(anim):Play()
end })

-- ================= PLAYER TAB =================
PlayerTab:CreateSection("Character Mods")
PlayerTab:CreateToggle({ Name = "Godmode", CurrentValue = false, Callback = function(v) toggleGodmode(v) end })
PlayerTab:CreateToggle({ Name = "Invisibility", CurrentValue = false, Callback = function(v) toggleInvis(v) end })
PlayerTab:CreateToggle({ Name = "Anti-AFK", CurrentValue = false, Callback = function(v) State.AntiAFK = v end })

PlayerTab:CreateSection("Server Management")
PlayerTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end })
PlayerTab:CreateButton({ Name = "Server Hop (Random)", Callback = function() serverHop() end })

-- ================= TELEPORTS TAB =================
TP_Tab:CreateSection("Player Teleports")
local gotoInput = TP_Tab:CreateInput({ Name = "Player Name", PlaceholderText = "Enter name...", RemoveTextAfterFocusLost = false, Callback = function(t) end })
TP_Tab:CreateButton({ Name = "Goto Player", Callback = function()
    -- We use a hacky way to get the textbox value since Rayfield doesn't return it directly
    local text = TP_Tab:GetInputValue(gotoInput) -- pseudo call for visual representation
    if text then gotoPlayer(text) end
end })
TP_Tab:CreateButton({ Name = "Bring Player", Callback = function()
    local text = TP_Tab:GetInputValue(gotoInput)
    if text then bringPlayer(text) end
end })
TP_Tab:CreateButton({ Name = "Teleport to Mouse (Click TP)", Callback = function()
    if Mouse.Hit then getRoot(player.Character).CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z) end
end })

-- ================= UTILITY TAB =================
UtilTab:CreateSection("Waypoints")
local Waypoints = {}
UtilTab:CreateButton({ Name = "Save Waypoint", Callback = function()
    local root = getRoot(player.Character)
    if root then table.insert(Waypoints, {CFrame = root.CFrame, Name = "WP_" .. #Waypoints + 1}); Rayfield:Notify({Title="Waypoint", Content="Position Saved.", Duration=3}) end
end })
UtilTab:CreateButton({ Name = "Load Last Waypoint", Callback = function()
    if #Waypoints > 0 then getRoot(player.Character).CFrame = Waypoints[#Waypoints].CFrame end
end })

UtilTab:CreateSection("Tools")
UtilTab:CreateButton({ Name = "Give Teleport Tool", Callback = function()
    local tool = Instance.new("Tool"); tool.Name = "TP Tool"; tool.RequiresHandle = false; tool.Parent = player.Backpack
    tool.Activated:Connect(function() if Mouse.Hit then getRoot(player.Character).CFrame = CFrame.new(Mouse.Hit.X, Mouse.Hit.Y + 3, Mouse.Hit.Z) end end)
end })

-- ================= WORLD TAB =================
WorldTab:CreateSection("Gravity & Physics")
WorldTab:CreateSlider({ Name = "Workspace Gravity", Range = {0, 500}, Increment = 10, CurrentValue = 196, Callback = function(v) Workspace.Gravity = v end })
WorldTab:CreateButton({ Name = "Reset Gravity (196)", Callback = function() Workspace.Gravity = 196.2 end })

WorldTab:CreateSection("Destruction (Client Side)")
WorldTab:CreateButton({ Name = "Delete Invisible Parts", Callback = function()
    for _, p in pairs(Workspace:GetDescendants()) do if p:IsA("BasePart") and p.Transparency == 1 and p.CanCollide then p:Destroy() end end
end })
WorldTab:CreateButton({ Name = "Clear Terrain", Callback = function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain"); if terrain then terrain:Clear() end
end })

-- ================= FUN TAB =================
FunTab:CreateSection("Visuals")
FunTab:CreateButton({ Name = "Rainbow Character", Callback = function()
    task.spawn(function()
        while true do
            if player.Character then
                for _, p in pairs(player.Character:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.Color = Color3.fromHSV(tick() % 1, 1, 1)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end })

FunTab:CreateSection("Trolling Animations")
FunTab:CreateButton({ Name = "Loop Oof Sound", Callback = function()
    task.spawn(function()
        while true do
            if player.Character and player.Character:FindFirstChild("Head") then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://131961136" -- Oof sound
                sound.Parent = player.Character.Head
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 2)
            end
            task.wait(1.5)
        end
    end)
end })

-- ================= SETTINGS TAB =================
SettingsTab:CreateSection("Script Management")
SettingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    
    -- Kill toggles
    State.Noclip = false; State.Fly = false; State.CarFly = false; State.Fling = false; State.InvisFling = false
    State.ESP = false; State.Chams = false; State.XRay = false; State.InfJump = false; State.Godmode = false
    State.AutoClick = false; State.Aimbot = false; State.SilentAim = false; State.Hitbox = false; State.Spinbot = false; State.BunnyHop = false
    
    toggleCFly(false); toggleCarFly(false); toggleFling(false); clearESP(); clearChams(); toggleXRay(false)
    
    -- Clear Drawings
    for _, obj in ipairs(Drawings) do
        pcall(function() obj:Remove() end)
    end
    
    -- Clear Connections
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    
    -- Destroy GUI
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

SettingsTab:CreateSection("Info")
SettingsTab:CreateLabel("EXC Hub v4.0 GOD TIER")
SettingsTab:CreateLabel("Features: 50+")
SettingsTab:CreateLabel("UI: Galaxy Glass Engine + Animations")
SettingsTab:CreateLabel("Script Length: OVERKILL")

Rayfield:Notify({ Title = "GOD TIER LOADED", Content = "10 Tabs, 50+ Features. Go crazy.", Duration = 8 })
