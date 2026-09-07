
# Recycling API

A ComputerCraft Lua API for retrieving item counts and item limits from a remote recycling server over `ecnet2`.

## Quick Note!
The entire api is logged and I can see exactly who makes every request. If you abuse this I will have no problem removing your api key and blacklisting you from creating a new one!

## Overview

The API consists of two parts:

-   **Server API** — exposes routes for querying item information.
    
-   **Client wrapper** — provides simple Lua functions for connecting to the server and calling those routes.
    

Communication is handled using `ecnet2`, with requests serialized using `textutils.serialize`.

----------

# Client API

The client wrapper is returned as the `recyclingAPI` module.

```lua
local recyclingAPI = require("recyclingAPI")

```

## Setup

Before making API requests, set the API key:

```lua
recyclingAPI.setKey("YOUR_API_KEY")

```

The API key is required for all requests.

----------

## `recyclingAPI.run()`

Starts the API connection and the `ecnet2` daemon.

```lua
recyclingAPI.run()

```

This function:

1.  Connects to the recycling API server.
    
2.  Waits for the server greeting.
    
3.  Starts the `ecnet2` daemon.
    

This function is blocking and should be used with parallel.

----------

## `recyclingAPI.setKey(key)`

Sets the API key used for subsequent requests.

### Parameters

`key` string, API authentication key,  **required** 






### Example

```lua
recyclingAPI.setKey("abc123")

```

The key is stored in:

```lua
recyclingAPI.key

```

----------

## `recyclingAPI.getItem(item)`

Retrieves information about a specific item.

### Parameters

Parameter

Type

Required

Description

`item` string Item identifier. **required**


### Example

```lua
local result = recyclingAPI.getItem("minecraft:diamond")

```

### Response

A successful response may look like:

```lua
{
    ok = true,
    data = {
        count = 42,
        limit = 64,
        low = 10
    }
}

```

Possible fields:


`count` number Current item count.





`limit` number Maximum amount before items are disposed of.

`low` number Recycling will attempt to autocraft this item until it reaches this value.





An item that does not exist will return:

```lua
{
    ok = false,
    error = "item does not exist"
}

```

----------

## `recyclingAPI.getItemCountAll()`

Retrieves the current count for every known item.

### Example

```lua
local result = recyclingAPI.getItemCountAll()

```

### Response

```lua
{
    ok = true,
    data = {
        ["minecraft:diamond"] = 42,
        ["minecraft:iron_ingot"] = 87,
        ["minecraft:gold_ingot"] = 23
    }
}

```

The `data` table maps item identifiers to their current counts.

----------

## `recyclingAPI.getMaxAll()`

Retrieves configuration/limit information for every known item.

### Example

```lua
local result = recyclingAPI.getMaxAll()

```

### Response

```lua
{
    ok = true,
    data = {
        ["minecraft:diamond"] = {
            limit = 64,
            low = 10
        },
        ["minecraft:iron_ingot"] = {
            limit = 128,
            low = 20
        }
    }
}

```

The exact contents depend on recycling's configuration

----------

# Server API Routes

The server exposes the following routes through the `recyclingAPI` protocol.


Requests use the following general structure:

```lua
{
    key = "YOUR_API_KEY",
    route = "routeName",
    data = {}
}

```

----------

## `getItem`

Returns information about one item.

### Request

```lua
{
    key = "YOUR_API_KEY",
    route = "getItem",
    data = {
        item = "minecraft:diamond"
    }
}

```

### Schema

```lua
item = {
    required = true,
    type = "string"
}

```

### Response

```lua
{
    ok = true,
    data = {
        count = 42,
        limit = 64,
        low = 10
    }
}

```

----------

## `getMaxAll`

Returns item configuration data for all items.

### Request

```lua
{
    key = "YOUR_API_KEY",
    route = "getMaxAll"
}

```

### Schema

No parameters are required.

```lua
schema = {}

```

### Response

```lua
{
    ok = true,
    data = {
        ["minecraft:diamond"] = {
            limit = 64,
            low = 10
        }
    }
}

```

----------

## `getItemCountAll`

Returns the current count of all known items.

### Request

```lua
{
    key = "YOUR_API_KEY",
    route = "getItemCountAll"
}

```

### Schema

No parameters are required.

```lua
schema = {}

```

### Response

```lua
{
    ok = true,
    data = {
        ["minecraft:diamond"] = 42,
        ["minecraft:iron_ingot"] = 87
    }
}

```

----------

# Data Refresh

The server automatically refreshes its cached data when the last update was more than **30 seconds** ago.

The refresh check is performed before handling:

-   `getItem`
    
-   `getMaxAll`
    
-   `getItemCountAll`
    

Conceptually:

```lua
if os.epoch() - lastUpdate > 30000 then
    generateData()
end

```

----------
# Communication

The client uses the `ecnet2` protocol named:

```text
recyclingAPI

```

The server address is configured in the wrapper:

```lua
local server = "sgthMgJucho-JkvoUMyfyEWPUvMSxfzXlw9c0kB8yTk="

```

The client connects using:

```lua
ping:connect(server, "back")

```

----------

# Error Handling

The wrapper requires an API key before making requests.

If no key has been configured, the request fails with:

```text
Set api key with .setKey(key)

```


----------

