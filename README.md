# Powered Concrete

**Powered Concrete** is a Factorio 2.0 mod that lets concrete floors carry electric coverage without visible power poles everywhere.

Build cleaner. Expand faster. Keep the factory floor sharp.

## What It Does

Powered Concrete turns selected floor tiles into a hidden electric network. Power only exists where powered concrete has actually been placed, so the default mode keeps the old exact tile-by-tile feel instead of creating one giant invisible power field.

## Current 1.2.x Highlights

- Refreshed powered / unpowered / convert overlay icons.
- Migration support from deprecated **PoweredConcreteSpaceAge 0.1.x** saves.
- Default connector grid size is **1** for exact tile-by-tile coverage.
- Optional sparse connector grid mode remains available for big factories and servers.
- Clean crafting layout with only the four powered floor recipes visible.
- Q / pipette support for normal, hazard, refined, and refined hazard powered tiles.
- `/powered-concrete-rebuild` command for rebuilding the hidden connector network.

## Visible Floor Recipes

The intended in-game floor list is:

- Stone Brick
- Concrete
- Hazard Concrete
- Refined Concrete
- Refined Hazard Concrete
- Powered Concrete
- Powered Hazard Concrete
- Powered Refined Concrete
- Powered Refined Hazard Concrete

## Features

- Powered Concrete
- Powered Hazard Concrete
- Powered Refined Concrete
- Powered Refined Hazard Concrete
- Hidden floor-based electric coverage
- Exact tile-by-tile powered floor logic by default
- Optional big-base UPS tuning through connector cells
- No visible power poles across your factory floor
- Q / pipette support for all powered tile variants
- Works with normal building, mining, robot placement, and script tile changes
- `/powered-concrete-rebuild` admin command
- Factorio 2.0 compatible
- No `flib` dependency
- Cleaner crafting layout with conversion recipes hidden
- Migration support from the deprecated PoweredConcreteSpaceAge 0.1.x mod

## UPS / Connector Mode

The startup setting **Powered concrete connector grid size** controls the hidden power network density.

- `1` = exact tile-by-tile behaviour and the default.
- `4` = optional balanced UPS mode for large-base play.
- Higher values = fewer hidden connectors and better UPS for very large bases, but power coverage becomes less exact inside each cell.

Default: `1`, which keeps exact tile-by-tile powered floor behaviour.

Example: if you manually set the value to `4`, one hidden connector can service a 4×4 powered floor cell instead of creating up to 16 hidden poles.

## Hidden Recipes

The following extra conversion-style recipes are intentionally hidden from the normal crafting UI:

- Unpowered Concrete
- Unpowered Hazard Concrete
- Unpowered Refined Concrete
- Unpowered Refined Hazard Concrete
- Remove Concrete Hazard Markings
- Remove Refined Concrete Hazard Markings
- Remove Powered Concrete Hazard Markings
- Add Powered Concrete Hazard Markings
- Remove Powered Refined Concrete Hazard Markings
- Add Powered Refined Concrete Hazard Markings

## Migration From PoweredConcreteSpaceAge

Version 1.2.2+ includes prototype migration support for the deprecated **PoweredConcreteSpaceAge 0.1.x** mod.

It migrates matching old PCSA items, tiles, recipes, and the hidden powered tile pole to the main **Powered_Concrete** prototype names. The old mod is also marked incompatible so both versions are not loaded at the same time.

Optional PCSA/Krastorio reinforced powered plates are not converted because this mod does not currently define replacement prototypes for those items or tiles.

## How It Works

When powered concrete is placed, the mod creates invisible electric connectors under powered floor cells. These connectors provide electrical coverage while keeping the surface visually clean.

The system tracks tile placement and removal from players, robots, mining, and script-based changes so the hidden power network stays synced with the actual floor.

## Admin Command

```text
/powered-concrete-rebuild
```

Rebuilds the hidden powered concrete connector network. Use this after changing the connector grid startup setting, testing old saves, or recovering from heavy scripted tile edits.

## Factorio Version

Built for **Factorio 2.0**.

## Install

Place `Powered_Concrete_1.2.3.zip` in your Factorio `mods` folder and enable **Powered Concrete** from the in-game Mods menu.

Factorio internal mod IDs cannot use spaces, so the technical mod ID is `Powered_Concrete`. The displayed mod title is **Powered Concrete**.

## Credits

Original **Powered Concrete** mod by **JuneGame**.

Factorio 2.0 compatibility, cleanup, exact-tile runtime rebuild, Q / pipette fixes, migration support, refreshed overlay icons, documentation, and release packaging by **Squishy1870**.

## License / Redistribution Notice

The original source package did not include an explicit open-source license. Treat the original work as all-rights-reserved unless the original author has provided separate permission or a license elsewhere.

This repository/package should only be published or redistributed if the original mod license or author permission allows it. Keep the original author credit intact in any shared version.
