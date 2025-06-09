local Network = require(game.ReplicatedStorage.Source.Modules.Networking.Network)

local TestController = {}

function TestController:Awake()
    print("Hello")
end

function TestController:Start()
    print("Dood")

    local data = Network.queries.GetPlayerData.invoke({ playerId = game.Players.LocalPlayer.UserId })
    print(data.level, data.xp)
end

return TestController