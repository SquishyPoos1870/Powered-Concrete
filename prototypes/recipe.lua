local icon_util = require("prototypes.icon-util")

local overlay_convert = "__Powered_Concrete__/graphics/icons/convert.png"
local overlay_convert_powered = "__Powered_Concrete__/graphics/icons/powered-convert.png"
local overlay_powered = "__Powered_Concrete__/graphics/icons/powered.png"
local overlay_unpowered = "__Powered_Concrete__/graphics/icons/unpowered.png"

local function item_stack(name, amount)
  return {type = "item", name = name, amount = amount or 1}
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
    energy_required = 0.025,
    enabled = false,
    allow_as_intermediate = false,
    allow_decomposition = false
  }
end

local function patch_existing_recipe(name, fields)
  local existing = data.raw["recipe"][name]
  if existing then
    for key, value in pairs(fields) do
      existing[key] = value
    end
  else
    data:extend({recipe(fields)})
  end
end

-- Patch vanilla hazard conversion recipes instead of redefining duplicate recipe prototypes.
patch_existing_recipe("hazard-concrete", {
  name = "hazard-concrete",
  order = "b[concrete]-a[converted]-b[hazard]",
  subgroup = "powered-concrete-convert",
  icons = recipe_icons_from_item("hazard-concrete", overlay_convert),
  ingredients = {item_stack("concrete", 1)},
  results = {item_stack("hazard-concrete", 1)},
  energy_required = 0.025,
  enabled = false,
  allow_as_intermediate = false,
  allow_decomposition = false
})

patch_existing_recipe("refined-hazard-concrete", {
  name = "refined-hazard-concrete",
  order = "b[concrete]-a[converted]-d[refined-hazard]",
  subgroup = "powered-concrete-convert",
  icons = recipe_icons_from_item("refined-hazard-concrete", overlay_convert),
  ingredients = {item_stack("refined-concrete", 1)},
  results = {item_stack("refined-hazard-concrete", 1)},
  energy_required = 0.025,
  enabled = false,
  allow_as_intermediate = false,
  allow_decomposition = false
})

data:extend({
  recipe({
    name = "unhazarded-concrete",
    order = "b[concrete]-a[converted]-a[plain]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("concrete", overlay_convert),
    ingredients = {item_stack("hazard-concrete", 1)},
    results = {item_stack("concrete", 1)}
  }),
  recipe({
    name = "unhazarded-refined-concrete",
    order = "b[concrete]-a[converted]-c[refined]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("refined-concrete", overlay_convert),
    ingredients = {item_stack("refined-hazard-concrete", 1)},
    results = {item_stack("refined-concrete", 1)}
  }),
  recipe({
    name = "unhazarded-powered-concrete",
    order = "b[concrete]-a[converted]-e[powered-plain]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("powered-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-hazard-concrete", 1)},
    results = {item_stack("powered-concrete", 1)}
  }),
  recipe({
    name = "hazarded-powered-concrete",
    order = "b[concrete]-a[converted]-f[powered-hazard]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("powered-hazard-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-concrete", 1)},
    results = {item_stack("powered-hazard-concrete", 1)}
  }),
  recipe({
    name = "unhazarded-powered-refined-concrete",
    order = "b[concrete]-a[converted]-g[powered-refined]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("powered-refined-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-refined-hazard-concrete", 1)},
    results = {item_stack("powered-refined-concrete", 1)}
  }),
  recipe({
    name = "hazarded-powered-refined-concrete",
    order = "b[concrete]-a[converted]-h[powered-refined-hazard]",
    subgroup = "powered-concrete-convert",
    icons = recipe_icons_from_item("powered-refined-hazard-concrete", overlay_convert_powered),
    ingredients = {item_stack("powered-refined-concrete", 1)},
    results = {item_stack("powered-refined-hazard-concrete", 1)}
  }),

  recipe({
    name = "powered-concrete",
    localised_name = {"recipe-name.powered-concrete"},
    order = "b[concrete]-b[powered]-a[plain]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("concrete", overlay_powered),
    ingredients = {item_stack("concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-concrete", 1)}
  }),
  recipe({
    name = "powered-hazard-concrete",
    localised_name = {"recipe-name.powered-hazard-concrete"},
    order = "b[concrete]-b[powered]-b[hazard]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("hazard-concrete", overlay_powered),
    ingredients = {item_stack("hazard-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-hazard-concrete", 1)}
  }),
  recipe({
    name = "powered-refined-concrete",
    localised_name = {"recipe-name.powered-refined-concrete"},
    order = "b[concrete]-b[powered]-c[refined]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("refined-concrete", overlay_powered),
    ingredients = {item_stack("refined-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-refined-concrete", 1)}
  }),
  recipe({
    name = "powered-refined-hazard-concrete",
    localised_name = {"recipe-name.powered-refined-hazard-concrete"},
    order = "b[concrete]-b[powered]-d[refined-hazard]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("refined-hazard-concrete", overlay_powered),
    ingredients = {item_stack("refined-hazard-concrete", 1), item_stack("copper-cable", 1)},
    results = {item_stack("powered-refined-hazard-concrete", 1)}
  }),

  recipe({
    name = "unpowered-concrete",
    order = "b[concrete]-c[unpowered]-a[plain]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("concrete", overlay_unpowered),
    ingredients = {item_stack("powered-concrete", 1)},
    results = {item_stack("concrete", 1), item_stack("copper-cable", 1)}
  }),
  recipe({
    name = "unpowered-hazard-concrete",
    order = "b[concrete]-c[unpowered]-b[hazard]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("hazard-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-hazard-concrete", 1)},
    results = {item_stack("hazard-concrete", 1), item_stack("copper-cable", 1)}
  }),
  recipe({
    name = "unpowered-refined-concrete",
    order = "b[concrete]-c[unpowered]-c[refined]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("refined-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-refined-concrete", 1)},
    results = {item_stack("refined-concrete", 1), item_stack("copper-cable", 1)}
  }),
  recipe({
    name = "unpowered-refined-hazard-concrete",
    order = "b[concrete]-c[unpowered]-d[refined-hazard]",
    subgroup = "powered-concrete-power",
    icons = recipe_icons_from_item("refined-hazard-concrete", overlay_unpowered),
    ingredients = {item_stack("powered-refined-hazard-concrete", 1)},
    results = {item_stack("refined-hazard-concrete", 1), item_stack("copper-cable", 1)}
  })
})
