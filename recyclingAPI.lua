local recyclingAPI = {}
local connection = nil
local ecnet2 = require "ecnet2"
local random = require "ccryptolib.random"
local expect = require("cc.expect").expect
random.initWithTiming()
local modem = peripheral.find("modem",function(named,wrapped)
  return wrapped.isWireless()
end)
ecnet2.open(peripheral.getName(modem))


local id = ecnet2.Identity("/.ecnet2")


local ping = id:Protocol {

    name = "recyclingAPI",
    serialize = textutils.serialize,
    deserialize = textutils.unserialize,
}


local server = "sgthMgJucho-JkvoUMyfyEWPUvMSxfzXlw9c0kB8yTk="

local function connect()
  connection = ping:connect(server, "back")

    -- Wait for the greeting.
    connection:receive()
end

function recyclingAPI.run()
  parallel.waitForAll(connect,ecnet2.daemon)
end

function recyclingAPI.setKey(key)
  recyclingAPI.key = key
end

function recyclingAPI.getItemCountAll()
  assert(recyclingAPI.key,"Set api key with .setKey(key)")
  connection:send({
      key = recyclingAPI.key,
      route = "getItemCountAll",
      data = {}
    })
  return select(2,connection:receive())
end

function recyclingAPI.getMaxAll()
  assert(recyclingAPI.key,"Set api key with .setKey(key)")
  connection:send({
      key = recyclingAPI.key,
      route = "getMaxAll",
      data = {}
    })
  return select(2,connection:receive())
end


function recyclingAPI.getItem(item)
  assert(recyclingAPI.key,"Set api key with .setKey(key)")
  expect(1,item,"string")
  recyclingAPI:send({
    key = connection.key,
    route = "getItem",
    data = {
      item=item
    }
  })
  return select(2,connection:receive())
end

return recyclingAPI
