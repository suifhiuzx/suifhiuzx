-- Function to create a name tag for a player
local function createNameTag(player)
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "NameTag"
    nameTag.AlwaysOnTop = true
    nameTag.Size = UDim2.new(0, 100, 0, 30)
    nameTag.StudsOffset = Vector3.new(0, 2, 0) -- Adjust the offset if needed

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = nameTag
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 20
    nameLabel.TextColor3 = Color3.new(1, 1, 1) -- Default text color
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Text outline color
    nameLabel.TextStrokeTransparency = 0.5

    nameTag.Parent = player.CharacterHead -- Attach the name tag to the player's head

    -- Function to highlight a player's name tag
    function player:HighlightNameTag()
        nameLabel.TextColor3 = Color3.new(1, 0, 0) -- Highlighted text color (red)
    end

    -- Function to unhighlight a player's name tag
    function player:UnhighlightNameTag()
        nameLabel.TextColor3 = Color3.new(1, 1, 1) -- Default text color
    end

    return nameTag
end

-- Function to set up name tags for all players
local function setupNameTags()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        createNameTag(player)
    end
end

-- Event handler to set up name tags when a player joins the game
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createNameTag(player)
    end)
end)

-- Set up name tags for existing players when the script runs
setupNameTags()
-- Function to create a camera target for a player's head
local function createCameraTarget(player)
    local cameraTarget = Instance.new("Attachment")
    cameraTarget.Name = "CameraTarget"
    cameraTarget.Parent = player.Character.Head

    return cameraTarget
end

-- Function to set up camera targets for all players
local function setupCameraTargets()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        createCameraTarget(player)
    end
end

-- Event handler to set up camera targets when a player joins the game
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createCameraTarget(player)
    end)
end)

-- Set up camera targets for existing players when the script runs
setupCameraTargets()

-- Function to update the camera's CFrame to look at a specific target
local function updateCameraToTarget(target)
    local camera = game.Workspace.CurrentCamera
    local cameraCFrame = CFrame.new(camera.CFrame.p, target.Position)
    camera.CFrame = cameraCFrame
end

-- Function to lock the camera onto a player's head
local function lockCameraToHead(player)
    local target = player.Character:FindFirstChild("CameraTarget")
    if target then
        updateCameraToTarget(target)
    end
end

-- Function to unlock the camera
local function unlockCamera()
    local camera = game.Workspace.CurrentCamera
    local originalCFrame = camera.CFrame.p
    camera.CFrame = CFrame.new(originalCFrame, originalCFrame + camera.CFrame.LookVector * 10) -- Adjust the distance
end

-- Event handler to lock the camera onto a player's head when the mouse is clicked
game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local player = game.Players.LocalPlayer
        lockCameraToHead(player)
    end
end)

-- Event handler to unlock the camera when the mouse is released
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        unlockCamera()
    end
end)
-- Define the player and character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define variables for controlling floating
local isFloating = false
local floatingHeight = 10 -- Adjust the height at which the character floats

-- Function to enable floating
local function startFloating()
    if not isFloating then
        isFloating = true

        -- Disable character's gravity
        character:FindFirstChild("Humanoid").RootPart.Anchored = true

        -- Adjust character's position to make it float
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.x, floatingHeight, humanoidRootPart.Position.z)
        end
    end
end

-- Function to disable floating
local function stopFloating()
    if isFloating then
        isFloating = false

        -- Re-enable character's gravity
        character:FindFirstChild("Humanoid").RootPart.Anchored = false
    end
end

-- Listen for the spacebar key press to toggle floating
local userInputService = game:GetService("UserInputService")
local isSpacePressed = false

userInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.Space then
        isSpacePressed = true
        if isFloating then
            stopFloating()
        else
            startFloating()
        end
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        isSpacePressed = false
    end
end)

-- Continuously update the floating position when the character is floating
while true do
    if isFloating and character:FindFirstChild("HumanoidRootPart") then
        character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(character:FindFirstChild("HumanoidRootPart").Position.x, floatingHeight, character:FindFirstChild("HumanoidRootPart").Position.z)
    end
    wait(0.1)
end
-- Define the player and character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to find the closest player
local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge -- Start with a very large distance

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (character:FindFirstChild("HumanoidRootPart").Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end

    return closestPlayer
end

-- Function to make the character face the closest player
local function faceClosestPlayer()
    local closestPlayer = findClosestPlayer()

    if closestPlayer then
        local direction = (closestPlayer.Character:FindFirstChild("HumanoidRootPart").Position - character:FindFirstChild("HumanoidRootPart").Position).unit
        local lookRotation = CFrame.new(Vector3.new(), direction)
        character:SetPrimaryPartCFrame(lookRotation)
    end
end

-- Continuously update character's orientation to face the closest player
while true do
    faceClosestPlayer()
    wait(0.1) -- Adjust the update frequency as needed
end
-- Define the player and character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the bobbing parameters
local bobbingAmplitude = 1 -- Adjust the amplitude of the bobbing
local bobbingFrequency = 2 -- Adjust the frequency of the bobbing (how fast it happens)

-- Function to handle character bobbing
local function handleBobbing()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end

    while true do
        wait(1 / bobbingFrequency)
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, bobbingAmplitude, 0)
        wait(1 / bobbingFrequency)
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -bobbingAmplitude, 0)
    end
end

-- Function to handle object collisions
local function handleObjectCollision(otherPart)
    local characterPart = character:FindFirstChild("HumanoidRootPart")
    if characterPart and otherPart.Parent and otherPart.Parent:IsA("Model") and otherPart.Parent:FindFirstChild("Humanoid") then
        -- Check if the collision was with a player's character
        handleBobbing() -- Start the bobbing animation
    end
end

-- Connect the collision event
character:WaitForChild("Head").Touched:Connect(handleObjectCollision)
-- Define the player and character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define flight parameters
local flightDuration = 2.5 -- Duration of flight in seconds
local flySpeed = 25 -- Flying speed (adjust as needed)
local flyKey = Enum.KeyCode.Space -- Key to activate flight (spacebar)

-- Variable to track if the player is currently flying
local isFlying = false

-- Function to handle character flying
local function handleFlying()
    if isFlying then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid:Move(Vector3.new(0, flySpeed, 0), false)
        end
    end
end

-- Function to start flight
local function startFlight()
    if not isFlying then
        isFlying = true

        -- Disable character's gravity
        character:FindFirstChild("Humanoid").RootPart.Anchored = true

        -- Enable flight control
        character:FindFirstChild("Humanoid").Freefall:Fire(false)

        -- Start flying
        handleFlying()

        -- Disable flight after a certain duration
        wait(flightDuration)
        stopFlight()
    end
end

-- Function to stop flight
local function stopFlight()
    isFlying = false

    -- Re-enable character's gravity
    character:FindFirstChild("Humanoid").RootPart.Anchored = false

    -- Disable flight control
    character:FindFirstChild("Humanoid").Freefall:Fire(true)
end

-- Listen for the fly key press to toggle flight
local userInputService = game:GetService("UserInputService")
local isFlyKeyPressed = false

userInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == flyKey and character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").Health > 0 then
        isFlyKeyPressed = true
        startFlight()
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == flyKey then
        isFlyKeyPressed = false
        stopFlight()
    end
end)

-- Continuously update flying while the player is holding the fly key
while true do
    if isFlyKeyPressed then
        handleFlying()
    end
    wait(0.1)
end
