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

local function startup_grid_size()
  local setting = settings and settings.startup and settings.startup["powered-concrete-connector-grid-size"]
  local value = setting and tonumber(setting.value) or 1

  if value < 1 then value = 1 end
  if value > 16 then value = 16 end

  return math.floor(value)
end

local GRID_SIZE = startup_grid_size()

local function init_storage()
  storage.powered_concrete = storage.powered_concrete or {}
  storage.powered_concrete.cells = storage.powered_concrete.cells or {}

  -- Pre-1.2.0 used storage.powered_concrete.nodes for one connector per tile.
  -- Keep old saves clean after migration without carrying the heavy table forward.
  storage.powered_concrete.nodes = nil
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

local function cell_xy_for_tile(x, y)
  return math.floor(x / GRID_SIZE), math.floor(y / GRID_SIZE)
end

local function cell_key(cell_x, cell_y)
  return cell_x .. ":" .. cell_y
end

local function cell_area(cell_x, cell_y)
  local left_top_x = cell_x * GRID_SIZE
  local left_top_y = cell_y * GRID_SIZE

  return {
    {left_top_x, left_top_y},
    {left_top_x + GRID_SIZE, left_top_y + GRID_SIZE}
  }
end

local function connector_position(cell_x, cell_y)
  local offset = GRID_SIZE / 2
  return {cell_x * GRID_SIZE + offset, cell_y * GRID_SIZE + offset}
end

local function get_surface_cells(surface_index)
  init_storage()

  local cells = storage.powered_concrete.cells[surface_index]
  if not cells then
    cells = {}
    storage.powered_concrete.cells[surface_index] = cells
  end

  return cells
end

local function destroy_connector(entity)
  if entity and entity.valid then
    entity.destroy({raise_destroy = false})
  end
end

local function cell_has_powered_tile(surface, cell_x, cell_y)
  return surface.count_tiles_filtered{
    area = cell_area(cell_x, cell_y),
    name = POWERED_TILE_NAMES,
    limit = 1
  } > 0
end

local function ensure_cell_connector(surface, cell_x, cell_y, force)
  local cells = get_surface_cells(surface.index)
  local key = cell_key(cell_x, cell_y)
  local existing = cells[key]

  if existing and existing.valid then
    return existing
  end

  local connector = surface.create_entity{
    name = CONNECTOR_NAME,
    position = connector_position(cell_x, cell_y),
    force = force or fallback_force(),
    raise_built = false
  }

  if connector and connector.valid then
    connector.destructible = false
    connector.minable = false
    connector.operable = false
    cells[key] = connector
    return connector
  end

  cells[key] = nil
  return nil
end

local function remove_cell_connector(surface, cell_x, cell_y)
  local cells = get_surface_cells(surface.index)
  local key = cell_key(cell_x, cell_y)

  destroy_connector(cells[key])
  cells[key] = nil
end

local function sync_cell(surface, cell_x, cell_y, force)
  if cell_has_powered_tile(surface, cell_x, cell_y) then
    ensure_cell_connector(surface, cell_x, cell_y, force)
  else
    remove_cell_connector(surface, cell_x, cell_y)
  end
end

local function collect_changed_cells(tiles)
  local changed = {}

  for _, tile in pairs(tiles or {}) do
    if tile.position then
      local tile_x, tile_y = tile_xy(tile.position)
      local cell_x, cell_y = cell_xy_for_tile(tile_x, tile_y)
      changed[cell_key(cell_x, cell_y)] = {x = cell_x, y = cell_y}
    end
  end

  return changed
end

local function on_tiles_changed(event)
  local surface = game.get_surface(event.surface_index)
  if not surface then return end

  local force = force_from_event(event)
  local changed_cells = collect_changed_cells(event.tiles)

  for _, cell in pairs(changed_cells) do
    sync_cell(surface, cell.x, cell.y, force)
  end
end

local function destroy_all_connectors(surface)
  for _, entity in pairs(surface.find_entities_filtered{name = CONNECTOR_NAME}) do
    destroy_connector(entity)
  end

  storage.powered_concrete.cells[surface.index] = {}
end

local function rebuild_surface(surface)
  destroy_all_connectors(surface)

  local force = fallback_force()
  local rebuilt_cells = {}

  for _, tile in pairs(surface.find_tiles_filtered{name = POWERED_TILE_NAMES}) do
    local tile_x, tile_y = tile_xy(tile.position)
    local cell_x, cell_y = cell_xy_for_tile(tile_x, tile_y)
    local key = cell_key(cell_x, cell_y)

    if not rebuilt_cells[key] then
      ensure_cell_connector(surface, cell_x, cell_y, force)
      rebuilt_cells[key] = true
    end
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
  storage.powered_concrete.cells[event.surface_index] = nil
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
