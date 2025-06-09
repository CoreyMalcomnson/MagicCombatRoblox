local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Promise = require(game.ReplicatedStorage.Source.Modules.Packages.Promise)
local Trove = require(game.ReplicatedStorage.Source.Modules.Packages.Trove)

local RextFramework = {}

RextFramework._loadedModules = {}
RextFramework._loadedComponents = {}
RextFramework._troves = {}

function RextFramework:Start(modulesToLoad, modulePredicate, componentsToLoad, componentPredicate)
    return Promise.new(function(resolve, reject, onCancel)
        self:_loadModules(modulesToLoad, modulePredicate)
        self:_setupAdditionalModuleCallbacks()
        self:_loadComponents(componentsToLoad, componentPredicate)

        resolve()
    end)
end

function RextFramework:_loadModules(modulesToLoad, modulePredicate)
    for _, moduleFile in pairs(modulesToLoad) do 
        if not moduleFile:IsA("ModuleScript") or (modulePredicate and not modulePredicate(moduleFile)) then
            continue
        end

        print("Loading module " .. moduleFile.Name)
        self._loadedModules[moduleFile.Name] = require(moduleFile)
    end

    for name, module in pairs(self._loadedModules) do
        if module.Awake then
            print(name.." ".." awake")
            module:Awake()
        end
    end

    for name, module in pairs(self._loadedModules) do
        if module.Start then
            print(name.." ".." start")
            module:Start()
        end
    end
end

function RextFramework:_notifyModules(functionName, ...)
    for moduleName, module in pairs(RextFramework._loadedModules) do
        local fn = module[functionName]
        if typeof(fn) == "function" then
            local ok, err = pcall(fn, module, ...)
            if not ok then
                warn("[RextFramework] Module error in " .. moduleName .. "/" .. functionName .. ": " .. tostring(err))
            end
        end
    end
end

function RextFramework:_setupAdditionalModuleCallbacks()
    self:_setupPlayerModuleCallbacks()
    self:_setupRunModuleCallbacks()
end

function RextFramework:_setupPlayerModuleCallbacks()
    local function onPlayerCharacterAdded(player: Player, character: Model)
        RextFramework:_notifyModules("OnPlayerCharacterAdded", player, character)
    end

    local function onPlayerAdded(player: Player)
        RextFramework:_notifyModules("OnPlayerAdded", player)

        -- Init
        if player.Character then
            task.defer(onPlayerCharacterAdded, player, player.Character)
        end

        -- Listen
        RextFramework._troves[player] = Trove.new()
        RextFramework._troves[player]:Add(player.CharacterAdded:Connect(function(character: Model)
            task.defer(onPlayerCharacterAdded, player, character)
        end))
    end

    local function onPlayerRemoving(player: Player)
        RextFramework:_notifyModules("OnPlayerRemoving", player)
        
        -- Cleanup
        if RextFramework._troves[player] then
            RextFramework._troves[player]:Destroy()
            RextFramework._troves[player] = nil
        end
    end

    -- Init
    for _, player in pairs(Players:GetPlayers()) do
        task.spawn(onPlayerAdded, player)
    end

    -- Listen
    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)
end

function RextFramework:_setupRunModuleCallbacks()
    RunService.Heartbeat:Connect(function(deltaTime: number)
        RextFramework:_notifyModules("OnHeartbeat", deltaTime)
    end)

    if RunService:IsClient() then
        RunService.RenderStepped:Connect(function(deltaTime: number)
            RextFramework:_notifyModules("OnRenderStepped", deltaTime)
        end)    
    end

    RunService.Stepped:Connect(function(deltaTime: number)
        RextFramework:_notifyModules("OnStepped", deltaTime)
    end)    
end

function RextFramework:_loadComponents(componentsToLoad, componentPredicate)
    for _, componentFile in pairs(componentsToLoad) do 
        if not componentFile:IsA("ModuleScript") or (componentPredicate and not componentPredicate(componentFile)) then
            continue
        end

        print("Loading component " .. componentFile.Name)
        self._loadedComponents[componentFile.Name] = require(componentFile)
    end
end

return RextFramework
