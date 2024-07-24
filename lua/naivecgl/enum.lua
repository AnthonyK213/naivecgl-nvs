local ffi_ = require("naivecgl.ffi_")

---@type table<string, table<string, integer>>
local enum = {}

setmetatable(enum, {
  __index = function(_, enum_class)
    return setmetatable({ __ec__ = enum_class }, {
      __index = function(o, enum_name)
        return ffi_.NS["Naive_" .. o.__ec__ .. "_" .. enum_name]
      end
    })
  end
})

return enum
