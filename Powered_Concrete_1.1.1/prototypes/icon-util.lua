local icon_util = {}

local function copy_icon(icon)
  local out = {}
  for key, value in pairs(icon) do
    if type(value) == "table" then
      local nested = {}
      for nested_key, nested_value in pairs(value) do
        nested[nested_key] = nested_value
      end
      out[key] = nested
    else
      out[key] = value
    end
  end
  return out
end

function icon_util.with_overlay(base_prototype, overlay_icon)
  local icons = {}

  if base_prototype.icons then
    for _, icon in pairs(base_prototype.icons) do
      icons[#icons + 1] = copy_icon(icon)
    end
  elseif base_prototype.icon then
    icons[#icons + 1] = {
      icon = base_prototype.icon,
      icon_size = base_prototype.icon_size or 64,
      icon_mipmaps = base_prototype.icon_mipmaps
    }
  end

  icons[#icons + 1] = {
    icon = overlay_icon,
    icon_size = 64
  }

  return icons
end

return icon_util
