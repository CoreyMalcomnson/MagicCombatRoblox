local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local Assets = ReplicatedStorage.Assets

local Remotes = require(ReplicatedStorage.Source.Utils.Remotes)

local AnimationController = {}

AnimationController._playAnimationRemote = Remotes:GetEvent("PlayAnimation")
AnimationController._stopAnimationRemote = Remotes:GetEvent("StopAnimation")

AnimationController._loadedAnimations = {}

function AnimationController:Start()
    self:_preloadAnimations()
    self:_setupEvents()
end

function AnimationController:_preloadAnimations()
    for _, descendant in pairs(Assets.Animations:GetDescendants()) do
        if descendant:IsA("Animation") then
            ContentProvider:PreloadAsync({descendant.AnimationId}, function()
                AnimationController._loadedAnimations[descendant.Name] = descendant
            end)
        end
    end
end

function AnimationController:_setupEvents()
    AnimationController._playAnimationRemote.OnClientEvent:Connect(function(animationName)
        local animation = AnimationController._loadedAnimations[animationName]
        local character = Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildWhichIsA("Animator")

        if animator and animation then
            local track = animator:LoadAnimation(animation)
            track:Play()
        end
    end)

    AnimationController._stopAnimationRemote.OnClientEvent:Connect(function(animationName)
        local animation = AnimationController._loadedAnimations[animationName]
        local character = Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildWhichIsA("Animator")

        if animator and animation then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == animation.AnimationId then
                    track:Stop()
                end
            end
        end
    end)
end

return AnimationController