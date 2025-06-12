
-- FULI TEST ESP - Solo ESP dinámico sin GUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

RunService.RenderStepped:Connect(function()
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
