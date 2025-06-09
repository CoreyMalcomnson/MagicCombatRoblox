local Network = require(game.ReplicatedStorage.Source.Modules.Networking.Network)

local TestController = {}

function TestController:Awake()
    print("Hello")
end

function TestController:Start()
    print("Dood")

    local data = Network.queries.GetPlayerData.invoke({ playerId = game.Players.LocalPlayer.UserId })
    print(data.level, data.xp)

    Network.packets.Notify.send({ imporant = false, message = "Hello" })
end

-- function TestController:OnPlayerAdded(player: Player)
--     print("Player joined: "..player.Name)
-- end

-- function TestController:OnPlayerCharacterAdded(player: Player, character: Model)
--     print("Player joined: "..player.Name)
--     print("Player character join. "..character:GetFullName())
-- end

-- function TestController:OnPlayerRemoving(player: Player)
--     print("Player leaving: "..player.Name)
-- end

-- function TestController:OnHeartbeat(deltaTime: number)
--     print("a "..deltaTime)
-- end

-- function TestController:OnStepped(deltaTime: number)
--     print("b "..deltaTime)
-- end

-- function TestController:OnRenderStepped(deltaTime: number)
--     print("c "..deltaTime)
-- end

return TestController