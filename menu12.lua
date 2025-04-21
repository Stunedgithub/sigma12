local player = game.Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Harrisons Hub (BETA)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local Tab = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = Tab:AddSection({
    Name = "LocalPlayer"
})

OrionLib:MakeNotification({
    Name = "Welcome!",
    Content = "Welcome to Harrihub!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

Tab:AddButton({
    Name = "High Speed",
    Callback = function()
        player.Character.Humanoid.WalkSpeed = 500
    end
})

Tab:AddButton({
    Name = "High Jumppower",
    Callback = function()
        player.Character.Humanoid.JumpPower = 100
    end
})

Tab:AddButton({
    Name = "Low Gravity",
    Callback = function()
        game.Workspace.Gravity = 10
    end
})

-- Silent Aim Implementation
local silentAimActive = false
local function silentAim()
    local target = nil
    local closestDistance = math.huge

    -- Loop through all other players to find the closest one to aim at
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (enemy.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                target = enemy
            end
        end
    end

    -- Aim at the target (silent aim)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local headPosition = target.Character.Head.Position
        game:GetService("TweenService"):Create(player.Character.HumanoidRootPart, TweenInfo.new(0.1), {CFrame = CFrame.new(headPosition)}):Play()
    end
end

Tab:AddButton({
    Name = "Toggle Silent Aim",
    Callback = function()
        silentAimActive = not silentAimActive
        if silentAimActive then
            -- This will call silent aim continuously when activated.
            while silentAimActive do
                wait(0.1)
                silentAim()
            end
        end
    end
})

-- ESP Implementation
local espActive = false
local function createESP(targetPlayer)
    -- Create ESP for each player
    if targetPlayer and targetPlayer.Character then
        local esp = Instance.new("BillboardGui")
        esp.Adornee = targetPlayer.Character.Head
        esp.Size = UDim2.new(0, 100, 0, 50)
        esp.StudsOffset = Vector3.new(0, 2, 0)
        esp.Parent = targetPlayer.Character.Head

        local label = Instance.new("TextLabel")
        label.Text = targetPlayer.Name
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.new(1, 0, 0)
        label.BackgroundTransparency = 1
        label.Parent = esp
    end
end

local function toggleESP()
    if espActive then
        -- Remove ESP for all players
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local esp = enemy.Character.Head:FindFirstChildOfClass("BillboardGui")
                if esp then
                    esp:Destroy()
                end
            end
        end
    else
        -- Add ESP for all players
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player then
                createESP(enemy)
            end
        end
    end
end

Tab:AddButton({
    Name = "Toggle ESP",
    Callback = function()
        espActive = not espActive
        toggleESP()
    end
})

-- Add ESP for all players on player join
game.Players.PlayerAdded:Connect(function(newPlayer)
    if espActive and newPlayer ~= player then
        createESP(newPlayer)
    end
end)

game.Players.PlayerRemoving:Connect(function(remPlayer)
    if remPlayer ~= player and remPlayer.Character and remPlayer.Character:FindFirstChild("Head") then
        -- Clean up ESP when player leaves
        local esp = remPlayer.Character.Head:FindFirstChildOfClass("BillboardGui")
        if esp then
            esp:Destroy()
        end
    end
end)
