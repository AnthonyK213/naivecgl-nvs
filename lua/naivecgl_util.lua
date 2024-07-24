local naivecgl_ffi = require("naivecgl_ffi")

local naivecgl_util = {}

---
---@param code integer
---@return boolean
function naivecgl_util.is_ok(code)
  return naivecgl_ffi.NS.Naive_Code_ok == code
end

---try-catch-finally.
---@param try_block function
---@return { catch: fun(catch_block: fun(ex: string)):{ finally: fun(finally_block: function) }, finally: fun(finally_block: function) }
function naivecgl_util.try(try_block)
  local status, err = true, nil

  if type(try_block) == "function" then
    status, err = xpcall(try_block, debug.traceback)
  end

  ---Finally.
  ---@param finally_block function
  ---@param catch_block_declared boolean
  local finally = function(finally_block, catch_block_declared)
    if type(finally_block) == "function" then
      finally_block()
    end

    if not catch_block_declared and not status then
      error(err)
    end
  end

  ---Catch.
  ---@param catch_block fun(ex: string)
  ---@return { finally: fun(finally_block: function) }
  local catch = function(catch_block)
    local catch_block_declared = type(catch_block) == "function"

    if not status and catch_block_declared then
      local ex = err or "Unknown error"
      catch_block(ex)
    end

    return {
      finally = function(finally_block)
        finally(finally_block, catch_block_declared)
      end
    }
  end

  return {
    catch = catch,
    finally = function(finally_block)
      finally(finally_block, false)
    end
  }
end

---
---@generic T
---@param code integer
---@param ... T
---@return T
function naivecgl_util.unwrap(code, ...)
  if not naivecgl_util.is_ok(code) then
    error(code)
  end
  return ...
end

return naivecgl_util
