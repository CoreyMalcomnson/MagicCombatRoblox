local Remote = require(game.ReplicatedStorage.Source.Modules.Framework.Remote)

local TestService = {}

TestService.NotifyRemote = Remote.new("Notify")
TestService.GetPlayerDataRemote = Remote.new("GetPlayerData")

function TestService:Awake()
    print("Hello")

    TestService.NotifyRemote:OnServerEvent(function(player, message)

    end)
end

function TestService:Start()
    print("Dood")

    TestService.NotifyRemote:OnServerEvent(function(player)
        print(player.Name.." Notified server")
    end)

    TestService.GetPlayerDataRemote:OnServerInvoke(function(player)
        return {level = 1, exp = 1}
    end)
end

-- function TestService:OnPlayerAdded(player: Player)
--     print("Player joined: "..player.Name)
-- end

-- function TestService:OnPlayerCharacterAdded(player: Player, character: Model)
--     print("Player joined: "..player.Name)
--     print("Player character join. "..character:GetFullName())
-- end

-- function TestService:OnPlayerRemoving(player: Player)
--     print("Player leaving: "..player.Name)
-- end

-- function TestService:OnHeartbeat(deltaTime: number)
--     print("a "..deltaTime)
-- end

-- function TestService:OnStepped(deltaTime: number)
--     print("b "..deltaTime)
-- end

-- function TestService:OnRenderStepped(deltaTime: number)
--     print("c "..deltaTime)
-- end

return TestService