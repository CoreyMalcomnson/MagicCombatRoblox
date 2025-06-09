local Remote = require(game.ReplicatedStorage.Source.Modules.Framework.Remote)

local TestController = {}

TestController.NotifyRemote = Remote.get("Notify")
TestController.GetPlayerDataRemote = Remote.get("GetPlayerData")

function TestController:Awake()
    print("Hello")
end

function TestController:Start()
    print("Dood")

    TestController.NotifyRemote:FireServer()
    local data = TestController.GetPlayerDataRemote:InvokeServer()
    print(data)
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