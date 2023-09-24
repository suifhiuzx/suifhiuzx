-- Script to highlight all players

-- Get all players in the game
local players = game.Players:GetPlayers()

-- Iterate over all players and highlight them
for _, player in pairs(players) do
    local character = player.Character or player.CharacterAdded:Wait()

    -- Create a new Highlight instance
    local highlight = Instance.new("Highlight")

    -- Parent the Highlight instance to the player's character
    highlight.Parent = character

    -- Set the Adornee property of the Highlight instance to the player's character
    highlight.Adornee = character

    -- Set the Enabled property of the Highlight instance to true
    highlight.Enabled = true
end
