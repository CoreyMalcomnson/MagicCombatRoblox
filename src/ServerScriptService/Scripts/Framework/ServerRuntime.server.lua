-- #region Modules
local RextFramework = require(game.ReplicatedStorage.Source.Framework.RextFramework)
-- #endregion

local modulesToLoad = {
	table.unpack(game.ServerScriptService.Source.Services:GetDescendants())
}

local componentsToLoad = {
	table.unpack(game.ServerScriptService.Source.Components:GetDescendants()),
	table.unpack(game.ReplicatedStorage.Source.Components:GetDescendants())
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
