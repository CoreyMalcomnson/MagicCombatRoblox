local Promise = require(game.ReplicatedStorage.Source.Modules.Packages.Promise)
local Loader = require(game.ReplicatedStorage.Source.Modules.Packages.Loader)
local Component = require(game.ReplicatedStorage.Source.Modules.Packages.Component)

local RextFramework = {}

RextFramework._loadedModules = {}
RextFramework._loadedComponents = {}

function RextFramework:Start(modulesToLoad, modulePredicate, componentsToLoad, componentPredicate)
    return Promise.new(function(resolve, reject, onCancel)

        -- #region Load Modules
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
                print(name.." ".." awake")
                module:Start()
            end
        end
        -- #endregion

        -- #region Setup Additional Module Callbacks

        -- #endregion

        -- #region Load Components
        for _, componentFile in pairs(componentsToLoad) do 
            if not componentFile:IsA("ModuleScript") or (componentPredicate and not componentPredicate(componentFile)) then
                continue
            end

            print("Loading component " .. componentFile.Name)
            self._loadedComponents[componentFile.Name] = require(componentFile)
        end
        -- #endregion
    end)
end

return RextFramework
