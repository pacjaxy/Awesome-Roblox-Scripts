-- c00lgui injection script for JetRealm
-- paste into server console and it gives the GUI to the runner

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- 🔐 Admin list
local admins = {
    ["NaivePaer2"] = true,
    ["windowstester5"] = true,
    ["PacJaxy"] = true
}

-- 🧠 Find the first admin currently in the game
local player = nil
for _, p in ipairs(Players:GetPlayers()) do
    if admins[p.Name] then
        player = p
        break
    end
end

if not player then
    warn("No admin found in the server.")
    return
end



-- 🔧 Create RemoteEvents if they don't exist
local function getOrCreateEvent(name)
    local fullName = "c00l_" .. name
    local existing = ReplicatedStorage:FindFirstChild(fullName)
    if existing then return existing end
    local ev = Instance.new("RemoteEvent", ReplicatedStorage)
    ev.Name = fullName
    return ev
end

local KickEvent = getOrCreateEvent("Kick")
local KillEvent = getOrCreateEvent("Kill")
local BanEvent = getOrCreateEvent("Ban")
local InsertEvent = getOrCreateEvent("InsertModel")

-- 🖼️ Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "c00lgui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 460)
frame.Position = UDim2.new(0.5, -200, 0.5, -230)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local function createLabeledTextbox(yPos, labelText, name)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.9, 0, 0, 30)
    box.Position = UDim2.new(0.05, 0, 0, yPos + 22)
    box.PlaceholderText = labelText
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Name = name
    return box
end

local function createButton(yPos, text, event)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(function()
        local username = frame:FindFirstChild("Username")
        local assetId = frame:FindFirstChild("AssetID")
        if event == InsertEvent and assetId then
            event:FireServer(assetId.Text)
        elseif username then
            event:FireServer(username.Text)
        end
    end)
end

-- 💥 c00lkidd Mode Function
local function decalBomb()
    -- 🌌 Add sky
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://10560525674"
    sky.SkyboxDn = "rbxassetid://10560525674"
    sky.SkyboxFt = "rbxassetid://10560525674"
    sky.SkyboxLf = "rbxassetid://10560525674"
    sky.SkyboxRt = "rbxassetid://10560525674"
    sky.SkyboxUp = "rbxassetid://10560525674"
    sky.Parent = Lighting

    -- 🖼️ Add decals to all parts in all services
    for _, service in ipairs(game:GetChildren()) do
        for _, obj in ipairs(service:GetDescendants()) do
            if obj:IsA("BasePart") then
                for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                    local decal = Instance.new("Decal")
                    decal.Texture = "rbxassetid://10560525674"
                    decal.Face = face
                    decal.Parent = obj
                end
            end
        end
    end

    -- 🔊 Looping sound effect
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://129978203916047"
    sound.Volume = 1
    sound.Looped = true
    sound.Playing = true
    sound.Pitch = 0.2
    sound.Name = "c00lkiddSound"
    sound.Parent = Lighting
end

-- 🔘 GUI Elements
createLabeledTextbox(10, "Target Username", "Username")
createLabeledTextbox(70, "Model Asset ID", "AssetID")
createLabeledTextbox(130, "Kick/Ban Reason", "Reason")
createLabeledTextbox(190, "Extra Info", "Extra")

createButton(250, "Kick", KickEvent)
createButton(290, "Kill", KillEvent)
createButton(330, "Ban", BanEvent)
createButton(370, "Insert Model", InsertEvent)

-- 🧨 c00lkidd Mode Button
local c00lkiddBtn = Instance.new("TextButton", frame)
c00lkiddBtn.Size = UDim2.new(0.9, 0, 0, 30)
c00lkiddBtn.Position = UDim2.new(0.05, 0, 0, 420)
c00lkiddBtn.Text = "🔥 Activate c00lkidd Mode 🔥"
c00lkiddBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
c00lkiddBtn.TextColor3 = Color3.new(1, 1, 1)
c00lkiddBtn.Font = Enum.Font.Arcade
c00lkiddBtn.TextSize = 18
c00lkiddBtn.MouseButton1Click:Connect(decalBomb)

-- 🧠 Inject GUI into player
gui.Parent = player:WaitForChild("PlayerGui")
