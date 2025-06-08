-- #region Modules
local RextFramework = require(game.ReplicatedStorage.Source.Modules.Framework.RextFramework)
-- #endregion

local modulesToLoad = {
	table.unpack(game.ServerScriptService.Source.Modules.Services:GetDescendants())
}

local componentsToLoad = {
	table.unpack(game.ServerScriptService.Source.Modules:FindFirstChild("Components"):GetDescendants()),
	table.unpack(game.ReplicatedStorage.Source.Modules:FindFirstChild("Components"):GetDescendants())
}

RextFramework:Start(
	modulesToLoad,
	function(moduleFile)  
		return moduleFile.Name:match("Service$")
	end,
	componentsToLoad,
	nil
)
-- #endregion
