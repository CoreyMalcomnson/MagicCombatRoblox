local Network = require(game.ReplicatedStorage.Source.Modules.Networking.Network)

local TestService = {}

function TestService:Awake()
    print("Hello")
end

function TestService:Start()
    print("Dood")

    Network.packets.Notify.listen(function(data: { important: boolean, message: string }, player: Player?) 
        print("Message received from "..(player and player.Name or "?")..": "..(data.message or "?"))
    end)

    Network.queries.GetPlayerData.listen(function(request: { playerId: number }, player: Player?): { level: number, xp: number }  
        print("Returning data for id: "..request.playerId)
        
        return {
            level = 1,
            xp = 1
        }
    end)
end

return TestService