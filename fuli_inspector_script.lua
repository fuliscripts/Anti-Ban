
local function printChildren(instance, depth)
    depth = depth or 0
    local prefix = string.rep("  ", depth)
    for _, child in ipairs(instance:GetChildren()) do
        print(prefix .. "- " .. child.Name .. " [" .. child.ClassName .. "]")
        printChildren(child, depth + 1)
    end
end

print("🔍 Workspace:")
printChildren(workspace)

print("\n📦 ReplicatedStorage:")
printChildren(game:GetService("ReplicatedStorage"))

print("\n👥 Players:")
printChildren(game:GetService("Players"))

print("\n🧠 StarterGui:")
printChildren(game:GetService("StarterGui"))

print("\n🎮 StarterPack:")
printChildren(game:GetService("StarterPack"))

print("\n📜 StarterPlayer:")
printChildren(game:GetService("StarterPlayer"))

print("\n🎁 Lighting:")
printChildren(game:GetService("Lighting"))

print("\n📊 Inspecting your Character (if loaded):")
local plr = game:GetService("Players").LocalPlayer
if plr and plr.Character then
    printChildren(plr.Character)
else
    print("Character not loaded yet.")
end
