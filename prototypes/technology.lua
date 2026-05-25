local unlocks = {
  "hazard-concrete",
  "refined-hazard-concrete",
  "unhazarded-concrete",
  "unhazarded-refined-concrete",
  "unhazarded-powered-concrete",
  "unhazarded-powered-refined-concrete",
  "hazarded-powered-concrete",
  "hazarded-powered-refined-concrete",
  "powered-concrete",
  "powered-hazard-concrete",
  "powered-refined-concrete",
  "powered-refined-hazard-concrete",
  "unpowered-concrete",
  "unpowered-hazard-concrete",
  "unpowered-refined-concrete",
  "unpowered-refined-hazard-concrete"
}

local tech = data.raw["technology"]["concrete"]
if tech then
  tech.effects = tech.effects or {}

  local already_unlocked = {}
  for _, effect in pairs(tech.effects) do
    if effect.type == "unlock-recipe" and effect.recipe then
      already_unlocked[effect.recipe] = true
    end
  end

  for _, recipe_name in pairs(unlocks) do
    if data.raw["recipe"][recipe_name] and not already_unlocked[recipe_name] then
      table.insert(tech.effects, {type = "unlock-recipe", recipe = recipe_name})
      already_unlocked[recipe_name] = true
    end
  end
end
