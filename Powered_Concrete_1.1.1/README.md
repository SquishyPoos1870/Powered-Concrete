# Powered Concrete

**Powered Concrete** is a Factorio 2.0 mod that lets concrete floors carry electric coverage without visible power poles everywhere.

This release keeps the crafting menu clean by showing only the real floor tiles players actually need: vanilla floor tiles plus the powered concrete variants. Extra conversion recipes like hazard-marking and unpowered-return recipes are kept hidden so they do not clutter the inventory/crafting UI.

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
- Exact tile-by-tile powered floor logic
- Power only exists where powered concrete has actually been placed
- No grid-based power zones
- No visible power poles across your factory floor
- Q / pipette support for normal, refined, and hazard variants
- Works with normal building, mining, robot placement, and script tile changes
- `/powered-concrete-rebuild` admin command
- Factorio 2.0 compatible
- No `flib` dependency
- Cleaner crafting layout with conversion recipes hidden

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

## How It Works

When powered concrete is placed, the mod creates hidden electric connectors under the powered tiles. These connectors provide electrical coverage while keeping the surface visually clean.

The system tracks tile placement and removal from players, robots, mining, and script-based changes so the hidden power network stays synced with the actual floor.

## Admin Command

```text
/powered-concrete-rebuild
```

Rebuilds the hidden powered concrete connector nodes. This is useful if an old save, another mod, or a script change causes the hidden power network to get out of sync.

## Factorio Version

Built for **Factorio 2.0**.

## Install

Place `Powered_Concrete_1.1.1.zip` in your Factorio `mods` folder and enable **Powered Concrete** from the in-game Mods menu.

Factorio internal mod IDs cannot use spaces, so the technical mod ID is `Powered_Concrete`. The displayed mod title is **Powered Concrete**.

## Credits

Original **Powered Concrete** mod by **JuneGame**.

This release is a **Factorio 2.0 compatibility, cleanup, and packaging pass** by **Squishy1870**.

## License / Redistribution Notice

The original source package did not include an explicit open-source license. Treat the original work as all-rights-reserved unless the original author has provided separate permission or a license elsewhere.

This repository/package should only be published or redistributed if the original mod license or author permission allows it. Keep the original author credit intact in any shared version.
