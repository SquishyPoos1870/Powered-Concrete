local base_pole = data.raw["electric-pole"]["medium-electric-pole"] or data.raw["electric-pole"]["small-electric-pole"]

if not base_pole then
  error("Powered Concrete could not find a base electric pole prototype to copy.")
end

local function startup_grid_size()
  local setting = settings and settings.startup and settings.startup["powered-concrete-connector-grid-size"]
  local value = setting and tonumber(setting.value) or 1

  if value < 1 then value = 1 end
  if value > 16 then value = 16 end

  return math.floor(value)
end

local grid_size = startup_grid_size()
local supply_radius = math.max(0.5, (grid_size / 2) + 0.25)
local wire_reach = grid_size == 1 and 1.55 or math.min(64, grid_size + 0.75)

local entity = table.deepcopy(base_pole)
entity.name = "powered-tile"
entity.localised_name = {"entity-name.powered-tile"}
entity.hidden = true
entity.hidden_in_factoriopedia = true
entity.flags = {
  "not-on-map",
  "not-blueprintable",
  "not-deconstructable",
  "not-upgradable",
  "placeable-off-grid"
}
entity.selectable_in_game = false
entity.selection_box = {{0, 0}, {0, 0}}
entity.collision_box = {{0, 0}, {0, 0}}
entity.collision_mask = {layers = {}}
entity.damaged_trigger_effect = nil
entity.dying_explosion = nil
entity.corpse = nil
entity.max_health = 1
entity.is_military_target = false
entity.allow_copy_paste = false
entity.minable = nil
entity.created_effect = nil
entity.open_sound = nil
entity.close_sound = nil

-- UPS pass: by default one invisible connector covers a small powered-concrete cell,
-- rather than creating one electric pole for every single floor tile.
entity.supply_area_distance = supply_radius
entity.maximum_wire_distance = wire_reach
entity.draw_copper_wires = false
entity.draw_circuit_wires = false
entity.pictures = {
  filename = "__core__/graphics/empty.png",
  width = 1,
  height = 1,
  direction_count = 1
}
entity.connection_points = {
  {
    wire = {copper = {0, 0}, red = {0, 0}, green = {0, 0}},
    shadow = {copper = {0, 0}, red = {0, 0}, green = {0, 0}}
  }
}
entity.radius_visualisation_picture = nil
entity.water_reflection = nil

if entity.integration_patch then entity.integration_patch = nil end
if entity.active_picture then entity.active_picture = nil end
if entity.light then entity.light = nil end

-- Kept as a real electric pole prototype so vanilla electric-network logic powers machines normally.
data:extend({entity})
