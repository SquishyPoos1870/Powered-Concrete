local POWERED_TILES = {
  ["powered-concrete"] = true,

  -- All powered concrete variants remain exact tile-by-tile powered floor tiles.
  ["powered-hazard-concrete-left"] = true,
  ["powered-hazard-concrete-right"] = true,
  ["powered-refined-concrete"] = true,
  ["powered-refined-hazard-concrete-left"] = true,
  ["powered-refined-hazard-concrete-right"] = true
}

local POWERED_TILE_NAMES = {
  "powered-concrete",
  "powered-hazard-concrete-left",
  "powered-hazard-concrete-right",
  "powered-refined-concrete",
  "powered-refined-hazard-concrete-left",
  "powered-refined-hazard-concrete-right"
}

local CONNECTOR_NAME = "powered-tile"

local PUBLIC_RECIPES = {
  "powered-concrete",
  "powered-hazard-concrete",
  "powered-refined-concrete",
  "powered-refined-hazard-concrete"
}

local HIDDEN_RECIPES = {
  "unpowered-concrete",
  "unpowered-hazard-concrete",
  "unpowered-refined-concrete",
  "unpowered-refined-hazard-concrete",
  "unhazarded-concrete",
  "unhazarded-refined-concrete",
  "unhazarded-powered-concrete",
  "hazarded-powered-concrete",
  "unhazarded-powered-refined-concrete",
  "hazarded-powered-refined-concrete"
}

local function init_storage()
  storage.powered_concrete = storage.powered_concrete or {}
  storage.powered_concrete.nodes = storage.powered_concrete.nodes or {}
end

local function fallback_force()
  return game.forces.player or game.forces.neutral
end

local function force_from_event(event)
  if event.player_index then
    local player = game.get_player(event.player_index)
    if player and player.valid then
      return player.force
    end
  end

  if event.robot and event.robot.valid then
    return event.robot.force
  end

  return fallback_force()
end

local function tile_xy(position)
  return math.floor(position.x or position[1]), math.floor(position.y or position[2])
end

local function tile_key(x, y)
  return x .. ":" .. y
end

local function connector_position(x, y)
  -- TilePosition values identify the tile. Offset by half a tile so the hidden pole sits on the tile centre.
  return {x + 0.5, y + 0.5}
end

local function get_surface_nodes(surface_index)
  init_storage()
  local nodes = storage.powered_concrete.nodes[surface_index]
  if not nodes then
    nodes = {}
    storage.powered_concrete.nodes[surface_index] = nodes
  end
  return nodes
end

local function destroy_node(node)
  if node and node.valid then
    node.destroy({raise_destroy = false})
  end
end

local function find_existing_node(surface, x, y)
  local position = connector_position(x, y)
  local found = surface.find_entities_filtered{
    name = CONNECTOR_NAME,
    position = position,
    radius = 0.25,
    limit = 1
  }
  return found[1]
end

local function ensure_node(surface, x, y, force)
  local nodes = get_surface_nodes(surface.index)
  local key = tile_key(x, y)
  local existing = nodes[key]

  if existing and existing.valid then
    return existing
  end

  existing = find_existing_node(surface, x, y)
  if existing and existing.valid then
    nodes[key] = existing
    return existing
  end

  local node = surface.create_entity{
    name = CONNECTOR_NAME,
    position = connector_position(x, y),
    force = force or fallback_force(),
    raise_built = false
  }

  if node and node.valid then
    node.destructible = false
    node.minable = false
    node.operable = false
    nodes[key] = node
    return node
  end

  nodes[key] = nil
  return nil
end

local function remove_node(surface, x, y)
  local nodes = get_surface_nodes(surface.index)
  local key = tile_key(x, y)

  destroy_node(nodes[key])
  nodes[key] = nil

  -- Clean up any stray connector that may exist from older versions or manual script changes.
  local stray = find_existing_node(surface, x, y)
  destroy_node(stray)
end

local function is_powered_tile(surface, x, y)
  local tile = surface.get_tile(x, y)
  return tile and POWERED_TILES[tile.name] or false
end

local function sync_tile(surface, x, y, force)
  if is_powered_tile(surface, x, y) then
    ensure_node(surface, x, y, force)
  else
    remove_node(surface, x, y)
  end
end

local function collect_changed_tiles(tiles)
  local changed = {}

  for _, tile in pairs(tiles or {}) do
    if tile.position then
      local x, y = tile_xy(tile.position)
      changed[tile_key(x, y)] = {x = x, y = y}
    end
  end

  return changed
end

local function on_tiles_changed(event)
  local surface = game.get_surface(event.surface_index)
  if not surface then return end

  local force = force_from_event(event)
  local changed_tiles = collect_changed_tiles(event.tiles)

  for _, tile in pairs(changed_tiles) do
    sync_tile(surface, tile.x, tile.y, force)
  end
end

local function destroy_all_nodes(surface)
  for _, entity in pairs(surface.find_entities_filtered{name = CONNECTOR_NAME}) do
    destroy_node(entity)
  end
  storage.powered_concrete.nodes[surface.index] = {}
end

local function rebuild_surface(surface)
  destroy_all_nodes(surface)

  local force = fallback_force()
  for _, tile in pairs(surface.find_tiles_filtered{name = POWERED_TILE_NAMES}) do
    local x, y = tile_xy(tile.position)
    ensure_node(surface, x, y, force)
  end
end

local function rebuild_all_surfaces()
  init_storage()
  for _, surface in pairs(game.surfaces) do
    rebuild_surface(surface)
  end
end

local function sync_recipe_states()
  for _, force in pairs(game.forces) do
    local concrete_tech = force.technologies and force.technologies["concrete"]
    local concrete_unlocked = concrete_tech and concrete_tech.researched or false

    for _, recipe_name in pairs(PUBLIC_RECIPES) do
      local force_recipe = force.recipes[recipe_name]
      if force_recipe then
        force_recipe.enabled = concrete_unlocked
      end
    end

    -- Keep old conversion / hazard-marking recipes out of the player crafting UI after upgrades.
    for _, recipe_name in pairs(HIDDEN_RECIPES) do
      local force_recipe = force.recipes[recipe_name]
      if force_recipe then
        force_recipe.enabled = false
      end
    end
  end
end

local function on_surface_removed(event)
  init_storage()
  storage.powered_concrete.nodes[event.surface_index] = nil
end

script.on_init(function()
  rebuild_all_surfaces()
  sync_recipe_states()
end)

script.on_configuration_changed(function()
  rebuild_all_surfaces()
  sync_recipe_states()
end)

script.on_event(defines.events.on_player_built_tile, on_tiles_changed)
script.on_event(defines.events.on_robot_built_tile, on_tiles_changed)
script.on_event(defines.events.on_player_mined_tile, on_tiles_changed)
script.on_event(defines.events.on_robot_mined_tile, on_tiles_changed)
script.on_event(defines.events.script_raised_set_tiles, on_tiles_changed)

script.on_event(defines.events.on_research_finished, function(event)
  if event.research and event.research.valid and event.research.name == "concrete" then
    sync_recipe_states()
  end
end)

if defines.events.on_surface_deleted then
  script.on_event(defines.events.on_surface_deleted, on_surface_removed)
end

commands.add_command("powered-concrete-rebuild", {"command-help.powered-concrete-rebuild"}, function(command)
  local player = command.player_index and game.get_player(command.player_index)
  if player and not player.admin then
    player.print({"message.powered-concrete-admin-only"})
    return
  end

  rebuild_all_surfaces()

  if player then
    player.print({"message.powered-concrete-rebuilt"})
  end
end)
