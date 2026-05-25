local icon_util = require("prototypes.icon-util")

local overlay_convert = "__Powered_Concrete__/graphics/icons/convert.png"
local overlay_convert_powered = "__Powered_Concrete__/graphics/icons/powered-convert.png"
local overlay_powered = "__Powered_Concrete__/graphics/icons/powered.png"
local overlay_unpowered = "__Powered_Concrete__/graphics/icons/unpowered.png"

local function item_stack(name, amount)
  return {type = "item", name = name, amount = amount or 1}
end

local function item_subgroup(item_name)
  local item = data.raw["item"][item_name]
  return item and item.subgroup or "terrain"
end

local function recipe_icons_from_item(item_name, overlay)
  local item = data.raw["item"][item_name]
  if not item then
    error("Powered Concrete could not find item for recipe icon: " .. item_name)
  end
  return icon_util.with_overlay(item, overlay)
end

local function recipe(def)
  return {
    type = "recipe",
    name = def.name,
    localised_name = def.localised_name,
    order = def.order,
    subgroup = def.subgroup,
    icons = def.icons,
    ingredients = def.ingredients,
    results = def.results,
    energy_required = def.energy_required or 0.025,
    enabled = false,
    hidden = def.hidden or false,
    allow_as_intermediate = false,
    allow_decomposition = false
  }
end

-- Visible powered floor recipes. These are the only powered recipes intended to show in the crafting UI.
local recipes = {
  recipe({
    name = "powered-concrete",
    localised_name = {"recipe-name.powered-concrete"},
    order = "b[concrete]-a[powered]",
    subgroup = item_subgroup("concrete"),
    icons = recipe_icons_from_item("concrete", overlay_powered),
    ingredients = {item_stack("concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-concrete", 1)}
  }),
  recipe({
    name = "powered-hazard-concrete",
    localised_name = {"recipe-name.powered-hazard-concrete"},
    order = "b[concrete]-b[powered-hazard]",
    subgroup = item_subgroup("hazard-concrete"),
    icons = recipe_icons_from_item("hazard-concrete", overlay_powered),
    ingredients = {item_stack("hazard-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-hazard-concrete", 1)}
  }),
  recipe({
    name = "powered-refined-concrete",
    localised_name = {"recipe-name.powered-refined-concrete"},
    order = "c[refined-concrete]-a[powered]",
    subgroup = item_subgroup("refined-concrete"),
    icons = recipe_icons_from_item("refined-concrete", overlay_powered),
    ingredients = {item_stack("refined-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-refined-concrete", 1)}
  }),
  recipe({
    name = "powered-refined-hazard-concrete",
    localised_name = {"recipe-name.powered-refined-hazard-concrete"},
    order = "c[refined-concrete]-b[powered-hazard]",
    subgroup = item_subgroup("refined-hazard-concrete"),
    icons = recipe_icons_from_item("refined-hazard-concrete", overlay_powered),
    ingredients = {item_stack("refined-hazard-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-refined-hazard-concrete", 1)}
  })
}

-- Hidden compatibility / conversion recipes. These stay hidden so the crafting UI only shows
-- the actual floor tiles, not extra hazard-marking or unpowered conversion recipes.
local hidden_recipes = {
  {
    name = "unpowered-concrete",
    order = "z[hidden]-a[unpowered-plain]",
    subgroup = item_subgroup("concrete"),
    icons = recipe_icons_from_item("concrete", overlay_unpowered),
    ingredients = {item_stack("powered-concrete", 1)},
    results = {item_stack("concrete", 1), item_stack("copper-cable", 1)}
  },
  {
    name = "unpowered-hazard-concrete",
    order = "z[hidden]-b[unpowered-hazard]",
    subgroup = item_subgroup("hazard-concrete"),
    icons = recipe_icons_from_item("hazard-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-hazard-concrete", 1)},
    results = {item_stack("hazard-concrete", 1), item_stack("copper-cable", 1)}
  },
  {
    name = "unpowered-refined-concrete",
    order = "z[hidden]-c[unpowered-refined]",
    subgroup = item_subgroup("refined-concrete"),
    icons = recipe_icons_from_item("refined-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-refined-concrete", 1)},
    results = {item_stack("refined-concrete", 1), item_stack("copper-cable", 1)}
  },
  {
    name = "unpowered-refined-hazard-concrete",
    order = "z[hidden]-d[unpowered-refined-hazard]",
    subgroup = item_subgroup("refined-hazard-concrete"),
    icons = recipe_icons_from_item("refined-hazard-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-refined-hazard-concrete", 1)},
    results = {item_stack("refined-hazard-concrete", 1), item_stack("copper-cable", 1)}
  },
  {
    name = "unhazarded-concrete",
    order = "z[hidden]-e[unhazard-plain]",
    subgroup = item_subgroup("concrete"),
    icons = recipe_icons_from_item("concrete", overlay_convert),
    ingredients = {item_stack("hazard-concrete", 1)},
    results = {item_stack("concrete", 1)}
  },
  {
    name = "unhazarded-refined-concrete",
    order = "z[hidden]-f[unhazard-refined]",
    subgroup = item_subgroup("refined-concrete"),
    icons = recipe_icons_from_item("refined-concrete", overlay_convert),
    ingredients = {item_stack("refined-hazard-concrete", 1)},
    results = {item_stack("refined-concrete", 1)}
  },
  {
    name = "unhazarded-powered-concrete",
    order = "z[hidden]-g[unhazard-powered]",
    subgroup = item_subgroup("powered-concrete"),
    icons = recipe_icons_from_item("powered-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-hazard-concrete", 1)},
    results = {item_stack("powered-concrete", 1)}
  },
  {
    name = "hazarded-powered-concrete",
    order = "z[hidden]-h[hazard-powered]",
    subgroup = item_subgroup("powered-hazard-concrete"),
    icons = recipe_icons_from_item("powered-hazard-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-concrete", 1)},
    results = {item_stack("powered-hazard-concrete", 1)}
  },
  {
    name = "unhazarded-powered-refined-concrete",
    order = "z[hidden]-i[unhazard-powered-refined]",
    subgroup = item_subgroup("powered-refined-concrete"),
    icons = recipe_icons_from_item("powered-refined-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-refined-hazard-concrete", 1)},
    results = {item_stack("powered-refined-concrete", 1)}
  },
  {
    name = "hazarded-powered-refined-concrete",
    order = "z[hidden]-j[hazard-powered-refined]",
    subgroup = item_subgroup("powered-refined-hazard-concrete"),
    icons = recipe_icons_from_item("powered-refined-hazard-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-refined-concrete", 1)},
    results = {item_stack("powered-refined-hazard-concrete", 1)}
  }
}

for _, def in pairs(hidden_recipes) do
  def.hidden = true
  recipes[#recipes + 1] = recipe(def)
end

data:extend(recipes)
