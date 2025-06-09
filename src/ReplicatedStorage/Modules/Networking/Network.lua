local ByteNetMax = require(game.ReplicatedStorage.Source.Modules.Packages.ByteNetMax)

return ByteNetMax.defineNamespace("MyNetwork", function()
  return {
    packets = {
      -- RemoteEvent-style
      Notify = ByteNetMax.definePacket({
        value = ByteNetMax.struct({
          message = ByteNetMax.string,
          important = ByteNetMax.bool,
        }),
      }),
    },
    queries = {
      -- RemoteFunction-style
      GetPlayerData = ByteNetMax.defineQuery({
        request = ByteNetMax.struct({ playerId = ByteNetMax.int32 }),
        response = ByteNetMax.struct({ level = ByteNetMax.uint16, xp = ByteNetMax.uint32 }),
      }),
    },
  }
end)