local function copy_tile(base_name, new_name, result_item, layer_offset, next_direction, transition_tile)
  local base = data.raw["tile"][base_name]
  if not base then
    error("Powered Concrete could not find base tile: " .. base_name)
  end

  local tile = table.deepcopy(base)
  tile.name = new_name
  tile.localised_name = {"tile-name." .. new_name}

  if tile.minable then
    tile.minable = table.deepcopy(tile.minable)
    tile.minable.result = result_item
  end

  -- Make the pipette tool (Q) return the correct powered item for every
  -- powered tile variant. This matters most for hazard concrete because it
  -- has left/right tile directions but only one inventory item.
  tile.placeable_by = {item = result_item, count = 1}

  tile.layer = (base.layer or 0) + layer_offset
  tile.next_direction = next_direction
  tile.transition_merges_with_tile = transition_tile

  return tile
end

local powered_concrete = copy_tile("concrete", "powered-concrete", "powered-concrete", 3, nil, nil)
local powered_hazard_left = copy_tile("hazard-concrete-left", "powered-hazard-concrete-left", "powered-hazard-concrete", 4, "powered-hazard-concrete-right", "powered-concrete")
local powered_hazard_right = copy_tile("hazard-concrete-right", "powered-hazard-concrete-right", "powered-hazard-concrete", 4, "powered-hazard-concrete-left", "powered-concrete")

local powered_refined = copy_tile("refined-concrete", "powered-refined-concrete", "powered-refined-concrete", 3, nil, nil)
local powered_refined_hazard_left = copy_tile("refined-hazard-concrete-left", "powered-refined-hazard-concrete-left", "powered-refined-hazard-concrete", 4, "powered-refined-hazard-concrete-right", "powered-refined-concrete")
local powered_refined_hazard_right = copy_tile("refined-hazard-concrete-right", "powered-refined-hazard-concrete-right", "powered-refined-hazard-concrete", 4, "powered-refined-hazard-concrete-left", "powered-refined-concrete")

data:extend({
  powered_concrete,
  powered_hazard_left,
  powered_hazard_right,
  powered_refined,
  powered_refined_hazard_left,
  powered_refined_hazard_right
})
