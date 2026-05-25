local base_pole = data.raw["electric-pole"]["medium-electric-pole"] or data.raw["electric-pole"]["small-electric-pole"]

if not base_pole then
  error("Powered Concrete could not find a base electric pole prototype to copy.")
end

local entity = table.deepcopy(base_pole)
entity.name = "powered-tile"
entity.localised_name = {"entity-name.powered-tile"}
entity.hidden = true
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

-- Exact powered-floor behaviour: one invisible connector covers one powered tile.
-- This preserves the original "powered concrete is the wire" feel without broad grid coverage.
entity.supply_area_distance = 0.5
entity.maximum_wire_distance = 1.55
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
