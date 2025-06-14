
-- FULI HUB - v5 Refresh + Kill Rastrillo + Kill All NPCs (Nombre-independiente)

-- Asegurarse que la función addToggle ya existe en tu script base.
-- Este fragmento agrega 2 toggles nuevos a la GUI existente.

-- 🔪 Kill Rastrillo
local killRastrillo = {active = false}
addToggle("Kill Rastrillo", killRastrillo,
function()
    killRastrillo.loop = game:GetService("RunService").RenderStepped:Connect(function()
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("rastrillo") then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:TakeDamage(9999)
                end
            end
        end
    end)
end,
function()
    if killRastrillo.loop then killRastrillo.loop:Disconnect() end
end)

-- 💀 Kill All NPCs (independiente del nombre)
local killNPCs = {active = false}
addToggle("Kill NPCs (All)", killNPCs,
function()
    killNPCs.loop = game:GetService("RunService").RenderStepped:Connect(function()
        local Players = game:GetService("Players")
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and not Players:FindFirstChild(model.Name) then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:TakeDamage(9999)
                end
            end
        end
    end)
end,
function()
    if killNPCs.loop then killNPCs.loop:Disconnect() end
end)
