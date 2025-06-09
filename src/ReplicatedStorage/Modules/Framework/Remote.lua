local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Source.Modules.Packages.Trove)

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()

-- Base prototype for both client & server
local Base = {}
Base.__index = Base

function Base:initialize(name, parent)
    parent = parent or ReplicatedStorage
    assert(
        not parent:FindFirstChild(name),
        "There is already a RemoteEvent named '" .. name .. "'"
    )

    self._trove = Trove.new()

    local event = Instance.new("RemoteEvent")
    event.Name = name
    event.Parent = parent
    self.Event = event
    self._trove:Add(event)

    local func = Instance.new("RemoteFunction")
    func.Name = name .. "Func"
    func.Parent = parent
    self.Function = func
    self._trove:Add(func)
end

function Base:cleanup()
    if self._trove then
        self._trove:Destroy()
        self._trove = nil
    end
end

-- Client-specific methods
local Client = {}
Client.__index = Client
setmetatable(Client, { __index = Base })

function Client:FireServer(...)
    self.Event:FireServer(...)
    return true
end

function Client:InvokeServer(...)
    return self.Function:InvokeServer(...)
end

function Client:OnClientEvent(callback)
    local conn = self.Event.OnClientEvent:Connect(callback)
    self._trove:Add(conn)
    return conn
end

function Client:OnClientInvoke(callback)
    self.Function.OnClientInvoke = callback
    return true
end

-- Server-specific methods
local Server = {}
Server.__index = Server
setmetatable(Server, { __index = Base })

function Server:FireClient(player, ...)
    self.Event:FireClient(player, ...)
    return true
end

function Server:FireAllClients(...)
    self.Event:FireAllClients(...)
    return true
end

function Server:InvokeClient(player, ...)
    return self.Function:InvokeClient(player, ...)
end

function Server:OnServerEvent(callback)
    local conn = self.Event.OnServerEvent:Connect(callback)
    self._trove:Add(conn)
    return conn
end

function Server:OnServerInvoke(callback)
    self.Function.OnServerInvoke = callback
    return true
end

-- Module exports
local RemoteModule = {}

function RemoteModule.new(name, parent)
    local inst = setmetatable({}, isClient and Client or Server)
    inst:initialize(name, parent)
    return inst
end

function RemoteModule.get(name, parent)
    parent = parent or ReplicatedStorage
    local event = parent:FindFirstChild(name)
    assert(event, "RemoteEvent '" .. name .. "' missing")
    local func = parent:FindFirstChild(name .. "Func")
    assert(func, "RemoteFunction '" .. name .. "Func' missing")

    local inst = setmetatable({ Event = event, Function = func }, isClient and Client or Server)
    inst._trove = Trove.new()
    inst._trove:Add(event)
    inst._trove:Add(func)
    return inst
end

function RemoteModule.Destroy(remote)
    if remote and remote.cleanup then
        remote:cleanup()
    end
end

return RemoteModule
