local macro = {}

setmetatable(macro, {
  __index = {
    Object = {
      null = 0,
    },
    Logical = {
      true_ = 1,
      false_ = 0,
    }
  }
})

return macro
