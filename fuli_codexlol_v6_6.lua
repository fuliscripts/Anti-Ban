
-- FULI HUB - v6.5 (based on v5_refresh) - GUI + WalkSpeed 40 + ESP Rake/Players

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("CoreGui")

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "FuliV65"
pcall(function()
    gui.Parent = GuiService
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)

local function addButton(name, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = name
    button.Parent = frame
    button.MouseButton1Click:Connect(func)
end

-- WalkSpeed 40
addButton("WalkSpeed 100", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 100 end
end)

addButton("WalkSpeed 40", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 40 end
end)

-- FullBright
addButton("FullBright", function()
    Lighting.FogEnd = 100000
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
end)

-- Kill Rake (loop)
local rakeKilling = false
addButton("Toggle Kill Rake", function()
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

-- StunStick Aura (safe version)
local auraEnabled = false
addButton("Toggle Stun Aura", function()
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

-- ESP Rake + Players (dynamic)
local espOn = false
addButton("Toggle ESP Rake + Players", function()
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
