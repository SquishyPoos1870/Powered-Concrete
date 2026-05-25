local icon_util = require("prototypes.icon-util")
local powered_overlay = "__Powered_Concrete__/graphics/icons/powered.png"

local function make_powered_item(base_name, new_name, result_tile, order)
  local base = data.raw["item"][base_name]
  if not base then
    error("Powered Concrete could not find base item: " .. base_name)
  end

  local item = table.deepcopy(base)
  item.name = new_name
  item.localised_name = {"item-name." .. new_name}
  item.order = order

  -- Keep powered floor items in the same crafting/floor area as the vanilla concrete items.
  -- This avoids a noisy extra subgroup and keeps the visible UI list clean.
  item.subgroup = base.subgroup

  item.icons = icon_util.with_overlay(base, powered_overlay)
  item.icon = nil
  item.icon_size = nil
  item.icon_mipmaps = nil
  item.place_as_tile = table.deepcopy(base.place_as_tile)
  item.place_as_tile.result = result_tile

  return item
end

data:extend({
  make_powered_item("concrete", "powered-concrete", "powered-concrete", "b[concrete]-a[powered]"),
  make_powered_item("hazard-concrete", "powered-hazard-concrete", "powered-hazard-concrete-left", "b[concrete]-b[powered-hazard]"),
  make_powered_item("refined-concrete", "powered-refined-concrete", "powered-refined-concrete", "c[refined-concrete]-a[powered]"),
  make_powered_item("refined-hazard-concrete", "powered-refined-hazard-concrete", "powered-refined-hazard-concrete-left", "c[refined-concrete]-b[powered-hazard]")
})
