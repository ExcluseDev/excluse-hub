--[[
    excluse universal loader (Ultra-Lightweight Fix)
--]]

-- 1. FIX FOR XENO COREGUI CRASH
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local resetBindable = game:GetService("CoreGui").RobloxGui:FindFirstChild("ResetButton")
        if resetBindable then resetBindable:Destroy() end
    end
end)

local player = game:GetService("Players").LocalPlayer
local PlaceId = game.PlaceId
local TeleportService = game:GetService("TeleportService")

-- 2. DATABASE
local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" },
    ["142823291"] = { Name = "Murder Mystery 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/mm2.lua" },
    ["4588604953"] = { Name = "Criminality", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/criminality.lua" },
    ["1537690962"] = { Name = "Bee Swarm Simulator", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bss.lua" },
    ["112731528776884"] = { Name = "Knife Duels", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/knifeduels.lua" },
    ["114234929420007"] = { Name = "BloxStrike", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bloxstrike.lua" },
    ["122446657157717"] = { Name = "Sniper Arena", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/sniperarena.lua" },
    ["17516596118"] = { Name = "Hypershot", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/hypershot.lua" },
    ["90568084448279"] = { Name = "One Tap", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/onetap.lua" },
    ["13772394625"] = { Name = "Blade Ball", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bladeball.lua" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

-- Smart DQR Detection
local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end
local isDQR = (PlaceId == 77649408247578) or (game.GameId == 9931749389) or (string.find(string.lower(GameName), "dungeon quest")) or (string.find(string.lower(GameName), "level"))

local targetUrl = nil
local targetName = ""

if Scripts[tostring(PlaceId)] then
    targetUrl = Scripts[tostring(PlaceId)].URL
    targetName = Scripts[tostring(PlaceId)].Name
elseif isDQR then
    targetUrl = Scripts["77649408247578"].URL
    targetName = "Dungeon Quest Reborn"
end

-- 3. RAW GUI (No Rayfield to prevent double-load crash)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EXC_Loader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(150, 50, 255)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Text = "excluse loader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 40)
Info.Position = UDim2.new(0, 10, 0, 50)
Info.BackgroundTransparency = 1
Info.Text = "Detected: " .. GameName
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 14
Info.TextWrapped = true
Info.Parent = Frame

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, -40, 0, 40)
Btn.Position = UDim2.new(0, 20, 0, 100)
Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 16
Btn.Text = "Launch Script"
Btn.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -40, 0, 30)
CloseBtn.Position = UDim2.new(0, 20, 0, 155)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 14
CloseBtn.Text = "Cancel"
CloseBtn.Parent = Frame

-- 4. EXECUTION LOGIC (With huge wait time for Xeno memory flush)
local function execute(url)
    Frame:Destroy() -- Delete the loader GUI immediately
    task.wait(2) -- CRITICAL: Give Xeno 2 full seconds to flush the memory before loading the next UI
    
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    
    if not ok then
        print("[EXC Loader] Error loading script: " .. tostring(err))
    end
end

if targetUrl then
    Btn.Text = "Launch " .. targetName
    Btn.MouseButton1Click:Connect(function() execute(targetUrl) end)
else
    Btn.Text = "Launch Universal Hub"
    Btn.MouseButton1Click:Connect(function() execute(UNIVERSAL_URL) end)
end

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
