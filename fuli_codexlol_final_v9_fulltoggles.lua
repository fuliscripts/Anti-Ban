
-- FULI HUB FINAL - FUNCIONES ESENCIALES CON TOGGLES

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("CoreGui")

-- GUI

local function addToggle(name, stateRef, onEnable, onDisable)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1,1,1)
    button.Text = "⏹️ " .. name
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        stateRef.active = not stateRef.active
        if stateRef.active then
            button.Text = "▶️ " .. name
            onEnable()
        else
            button.Text = "⏹️ " .. name
            if onDisable then onDisable() end
        end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "FuliFinal"
pcall(function()
    gui.Parent = GuiService
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)

local function addButton(name, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = name
    button.Name = "ButtonWS100"
    button.Name = "ButtonWS40"
    button.Name = "ButtonKillRake"
    button.Name = "ButtonStunAura"
    button.Name = "ButtonFullBright"
    button.Name = "ButtonESP"
    button.Parent = frame
    button.MouseButton1Click:Connect(func)
end

-- WalkSpeed 100 Toggle

local ws100State = {active = false}
addToggle("WalkSpeed 100", ws100State,
function()
    ws100 = true
end,
function()
    ws100 = false
end)

    ws100 = not ws100
    if ws100 then
        spawn(function()
            while ws100 do
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 100 end
                wait(0.2)
            end
        end)
    end
end)

-- WalkSpeed 40 Toggle

local ws40State = {active = false}
addToggle("WalkSpeed 40", ws40State,
function()
    ws40 = true
end,
function()
    ws40 = false
end)

    ws40 = not ws40
    if ws40 then
        spawn(function()
            while ws40 do
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 40 end
                wait(0.2)
            end
        end)
    end
end)

-- Kill Rake

local rakeKillingState = {active = false}
addToggle("Kill Rake", rakeKillingState,
function()
    rakeKilling = true
end,
function()
    rakeKilling = false
end)

    rakeKilling = not rakeKilling
    if rakeKilling then
        spawn(function()
            while rakeKilling do
                for _, m in pairs(Workspace:GetDescendants()) do
                    if m:IsA("Model") and m.Name:lower():find("rake") then
                        local h = m:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then
                            h:TakeDamage(9999)
                        end
                    end
                end
                wait(0.2)
            end
        end)
    end
end)

-- Stun Stick Aura

local auraEnabledState = {active = false}
addToggle("Stun Aura", auraEnabledState,
function()
    auraEnabled = true
end,
function()
    auraEnabled = false
end)

    auraEnabled = not auraEnabled
    if auraEnabled then
        spawn(function()
            while auraEnabled do
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, m in pairs(Workspace:GetDescendants()) do
                            if m:IsA("Model") and m.Name ~= LocalPlayer.Name then
                                local h = m:FindFirstChildOfClass("Humanoid")
                                local hrp2 = m:FindFirstChild("HumanoidRootPart")
                                if h and hrp2 and (hrp.Position - hrp2.Position).Magnitude < 10 then
                                    h:TakeDamage(5)
                                end
                            end
                        end
                    end
                end
                wait(0.2)
            end
        end)
    end
end)

-- FullBright

local brightState = {active = false}
addToggle("FullBright", brightState,
function()
    bright = true
end,
function()
    bright = false
end)

    bright = not bright
    if bright then
        Lighting.FogEnd = 100000
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
    else
        Lighting.FogEnd = 500
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
    end
end)

-- ESP Rake + Players (dynamic)

local espOnState = {active = false}
addToggle("ESP", espOnState,
function()
    espOn = true
end,
function()
    espOn = false
end)

    espOn = not espOn
    if espOn then
        spawn(function()
            while espOn do
                local myChar = LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                for _, model in pairs(Workspace:GetDescendants()) do
                    if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChildOfClass("Humanoid") then
                        local isPlayer = Players:FindFirstChild(model.Name)
                        local tagName = isPlayer and "👤" or model.Name:lower():find("rake") and "👹 Rake" or nil
                        if tagName and not model:FindFirstChild("ESPName") then
                            local billboard = Instance.new("BillboardGui", model)
                            billboard.Name = "ESPName"
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.Adornee = model:FindFirstChild("HumanoidRootPart")
                            billboard.AlwaysOnTop = true
                            local label = Instance.new("TextLabel", billboard)
                            label.Name = "ESPText"
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = isPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 0)
                            label.TextScaled = true
                            label.Text = "..."
                        end
                        local gui = model:FindFirstChild("ESPName")
                        if gui then
                            local label = gui:FindFirstChild("ESPText")
                            if label and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local dist = math.floor((model.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude)
                                local hp = math.floor(model:FindFirstChildOfClass("Humanoid").Health)
                                label.Text = tagName .. " | HP: " .. hp .. " | " .. dist .. "m"
                            end
                        end
                    end
                end
                wait(0.1)
            end
        end)
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "ESPName" then
                v:Destroy()
            end
        end
    end
end)
