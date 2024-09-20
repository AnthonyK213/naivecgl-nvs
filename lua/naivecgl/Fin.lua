local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Logical_t = require("naivecgl.Logical_t")
local Object = require("naivecgl.Object")

local Fin = {}

---This function returns the edge of the given fin.
---@param fin integer A fin.
---@return integer code
---@return integer edge Owning edge.
function Fin.ask_edge(fin)
  local edge = ffi_.F.new("Naive_Edge_t[1]", Object.null)
  return ffi_.NS.Naive_Fin_ask_edge(fin, edge), edge[0]
end

--- This function returns whether the given fin goes in the same direction as its owning edge.
---@param fin integer A fin.
---@return integer code
---@return boolean is_positive Whether fin is positive or negative.
function Fin.is_positive(fin)
  local is_positive = ffi_.F.new("Naive_Logical_t[1]", Logical_t.true_)
  return ffi_.NS.Naive_Fin_is_positive(fin, is_positive), Logical_t.to_bool(is_positive[0])
end

return ffi_.U.oop.make_readonly(Fin)
