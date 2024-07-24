local naivecgl_ffi = require("naivecgl_ffi")

---@type table<string, table<string, integer>>
local enum = {}

setmetatable(enum, {
  __index = function(_, enum_class)
    return setmetatable({ __ec__ = enum_class }, {
      __index = function(o, enum_name)
        return naivecgl_ffi.NS["Naive_" .. o.__ec__ .. "_" .. enum_name]
      end
    })
  end
})

return enum
