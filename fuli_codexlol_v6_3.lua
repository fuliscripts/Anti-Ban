-- FULI HUB - v6.2 Final (ESP dinámico, , stamina fix)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FuliCodexV6"
pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 430)
frame.Position = UDim2.new(0, 10, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 4)

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

-- FullBright
local fullbright = {active = false}
addToggle("FullBright", fullbright,
    function()
        fullbright.loop = RunService.RenderStepped:Connect(function()
            Lighting.FogEnd = 1e9
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
        end)
    end,
    function()
        if fullbright.loop then fullbright.loop:Disconnect() end
    end
)

-- WalkSpeed 40
local speed100 = {active = false}
addToggle("WalkSpeed 40", speed100,
    function()
        speed100.loop = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then hum.WalkSpeed = 40 end
            end
        end)
    end,
    function()
        if speed100.loop then speed100.loop:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
)

-- 
local 
addToggle("", speed50,
    function()
        -- eliminado = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then hum.WalkSpeed = 50 end
            end
        end)
    end,
    function()
        if -- eliminado then -- eliminado:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
)

-- Infinite Stamina
local stamina = {active = false}
addToggle("Infinite Stamina", stamina,
    function()
        stamina.loop = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("NumberValue") and v.Name:lower():find("stamina") then
                    v.Value = 999
                elseif v:IsA("Script") and v.Name:lower():find("stamina") then
                    v.Disabled = true
                end
            end
        end)
    end,
    function()
        if stamina.loop then stamina.loop:Disconnect() end
    end
)

-- StunStick Aura
local aura = {active = false}
addToggle("StunStick Aura", aura,
    function()
        aura.loop = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            for _, m in pairs(Workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name ~= LocalPlayer.Name then
                    local h = m:FindFirstChildOfClass("Humanoid")
                    local hrp2 = m:FindFirstChild("HumanoidRootPart")
                    if h and hrp2 and (hrp.Position - hrp2.Position).Magnitude < 10 then
                        h:TakeDamage(5)
                    end
                end
            end
        end)
    end,
    function()
        if aura.loop then aura.loop:Disconnect() end
    end
)

-- Kill Rake
local killRake = {active = false}
addToggle("Kill Rake (loop)", killRake,
    function()
        killRake.loop = RunService.RenderStepped:Connect(function()
            for _, m in pairs(Workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name:lower():find("rake") then
                    local h = m:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        h:TakeDamage(9999)
                    end
                end
            end
        end)
    end,
    function()
        if killRake.loop then killRake.loop:Disconnect() end
    end
)

-- ESP dinámico
local esp = {active = false}
addToggle("ESP (Rake + Players)", esp,
    function()
        esp.loop = RunService.RenderStepped:Connect(function()
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
            for _, model in pairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChildOfClass("Humanoid") then
                    local isPlayer = Players:FindFirstChild(model.Name)
                    local tagName = isPlayer and "👤" or model.Name:lower():find("rake") and "👹 Rake" or nil

                    local existing = model:FindFirstChild("ESPName")
                    if not existing and tagName then
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
                    end

                    local gui = model:FindFirstChild("ESPName")
                    if gui then
                        local label = gui:FindFirstChild("ESPText")
                        if label then
                            local dist = math.floor((model.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude)
                            local hp = math.floor(model:FindFirstChildOfClass("Humanoid").Health)
                            label.Text = tagName .. " | HP: " .. hp .. " | " .. dist .. "m"
                        end
                    end
                end
            end
        end)
    end,
    function()
        if esp.loop then esp.loop:Disconnect() end
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "ESPName" then
                v:Destroy()
            end
        end
    end
)
