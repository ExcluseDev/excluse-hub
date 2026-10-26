--[[ excluse hub | Dungeon Quest Reborn ]]--
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer
getgenv().excluseHubRunning = true

local GalaxyTheme = {
    TextColor = Color3.fromRGB(230, 220, 255), Background = Color3.fromRGB(12, 8, 25),
    Topbar = Color3.fromRGB(20, 12, 40), Shadow = Color3.fromRGB(5, 2, 10),
    NotificationBackground = Color3.fromRGB(25, 15, 45), NotificationActionsBackground = Color3.fromRGB(35, 20, 60),
    TabBackground = Color3.fromRGB(30, 18, 55), TabStroke = Color3.fromRGB(60, 40, 100),
    TabBackgroundSelected = Color3.fromRGB(180, 50, 255), TabTextColor = Color3.fromRGB(180, 160, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(25, 15, 45),
    ElementBackgroundHover = Color3.fromRGB(40, 25, 70), SecondaryElementBackground = Color3.fromRGB(20, 10, 35),
    ElementStroke = Color3.fromRGB(80, 50, 130), SecondaryElementStroke = Color3.fromRGB(50, 30, 90),
    SliderBackground = Color3.fromRGB(180, 50, 255), SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(200, 100, 255), ToggleBackground = Color3.fromRGB(30, 20, 50),
    ToggleEnabled = Color3.fromRGB(0, 200, 255), ToggleDisabled = Color3.fromRGB(80, 70, 90),
    ToggleEnabledStroke = Color3.fromRGB(0, 220, 255), ToggleDisabledStroke = Color3.fromRGB(100, 90, 110),
    ToggleEnabledOuterStroke = Color3.fromRGB(255, 100, 200), ToggleDisabledOuterStroke = Color3.fromRGB(70, 60, 80),
    DropdownSelected = Color3.fromRGB(180, 50, 255), DropdownUnselected = Color3.fromRGB(25, 15, 45),
    InputBackground = Color3.fromRGB(20, 10, 35), InputStroke = Color3.fromRGB(80, 50, 130),
    PlaceholderColor = Color3.fromRGB(150, 130, 180)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse hub | DQR", LoadingTitle = "Loading DQR...", LoadingSubtitle = "by excluse",
    Theme = GalaxyTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

local State = { autoFarm = false, autoAtk = false, autoSkill = false, fly = false, flySpeed = 50 }

local function getEnemies()
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= player.Character then
            table.insert(list, obj)
        end
    end
    return list
end

local main = Window:CreateTab("⚔️ Main")
main:CreateToggle({ Name = "Auto Farm (Teleport)", Callback = function(v)
    State.autoFarm = v
    if v then
        task.spawn(function()
            while State.autoFarm and getgenv().excluseHubRunning do
                local closest, dist = nil, math.huge
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, e in ipairs(getEnemies()) do
                        local ehrp = e:FindFirstChild("HumanoidRootPart")
                        if ehrp then
                            local d = (ehrp.Position - hrp.Position).Magnitude
                            if d < dist then dist = d; closest = e end
                        end
                    end
                    if closest and dist > 5 then hrp.CFrame = closest.HumanoidRootPart.CFrame * CFrame.new(0,0,5) end
                end
                task.wait(0.5)
            end
        end)
    end
end })

main:CreateToggle({ Name = "Auto Attack", Callback = function(v)
    State.autoAtk = v
    if v then
        task.spawn(function()
            while State.autoAtk and getgenv().excluseHubRunning do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0,0))
                task.wait(0.1)
            end
        end)
    end
end })

main:CreateToggle({ Name = "Auto Skill (Q/E)", Callback = function(v)
    State.autoSkill = v
    if v then
        task.spawn(function()
            while State.autoSkill and getgenv().excluseHubRunning do
                local virt = game:GetService("VirtualInputManager")
                virt:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                virt:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                task.wait(0.1)
                virt:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                virt:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(1)
            end
        end)
    end
end })

local pTab = Window:CreateTab("🏃 Player")
pTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Callback = function(v) 
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end 
end })

pTab:CreateToggle({ Name = "Fly", Callback = function(v)
    State.fly = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if v and hrp then
        local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while State.fly and getgenv().excluseHubRunning and hrp.Parent do
                local cam = workspace.CurrentCamera; local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                bv.Velocity = move * State.flySpeed; bg.CFrame = cam.CFrame
                task.wait()
            end
            if bg then bg:Destroy() end; if bv then bv:Destroy() end
        end)
    end
end })

local settings = Window:CreateTab("⚙️ Settings")
settings:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.autoFarm = false; State.autoAtk = false; State.autoSkill = false; State.fly = false
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "DQR Loaded", Content = "Auto Farm & Combat ready.", Duration = 5 })