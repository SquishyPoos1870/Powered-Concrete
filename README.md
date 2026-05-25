# Powered Concrete

**Powered Concrete** is a Factorio 2.0 mod that lets concrete, refined concrete, and hazard concrete carry electric coverage through the floor.

It keeps the factory floor clean by using hidden electric connectors under powered tiles, so you can build neat late-game factory layouts without placing visible power poles everywhere.

## Features

- Powered Concrete
- Powered Refined Concrete
- Powered Hazard Concrete
- Powered Refined Hazard Concrete
- Exact tile-by-tile power coverage
- No grid-based power zones
- No visible power poles on the floor
- Q / pipette support for all powered concrete variants
- Factorio 2.0 compatibility fixes
- No `flib` dependency
- Cleaner runtime syncing for better UPS behaviour than the older tick-heavy setup

## How It Works

When powered concrete is placed, the mod creates hidden electric connectors under the powered tiles. These connectors provide electrical coverage while keeping the surface clean.

The system tracks tile placement and removal from players, robots, mining, and script-based changes so the hidden power network stays synced with the actual floor.

This version uses exact tile logic. Power exists only where powered concrete actually exists, instead of using broad grid zones.

## UPS / Big Base Notes

Powered Concrete does not run a constant per-tick update loop during normal gameplay. It reacts to tile changes, stores hidden connector references, and deduplicates changed tile positions before syncing.

Exact tile-by-tile power is naturally heavier than a grid-based approximation in huge paved bases, because each powered tile needs its own hidden connector. This release keeps exact behaviour because it feels better and is more honest to the tile placement.

For very large bases, use powered concrete where it matters most instead of paving the entire map with powered tiles.

## Admin Command

```text
/powered-concrete-rebuild
```

Rebuilds the hidden powered concrete connector nodes. This is useful if an old save, another mod, or a script change causes the hidden power network to get out of sync.

## Factorio Version

Built for **Factorio 2.0**.

## Install

Place `Powered_Concrete_1.0.9.zip` in your Factorio `mods` folder and enable **Powered Concrete** from the in-game Mods menu.

Factorio internal mod IDs cannot use spaces, so the technical mod ID is `Powered_Concrete`. The displayed mod title is **Powered Concrete**.

## Credits

Original mod, concept, base implementation, icons, and artwork by **JuneGame**.

Factorio 2.0 compatibility, cleanup, exact-tile runtime pass, Q / pipette fixes, documentation, and release packaging by **Squishy1870**.

## License / Redistribution Notice

The original source package did not include an explicit open-source license. Treat the original work as all-rights-reserved unless the original author has provided separate permission or a license elsewhere.

This repository/package should only be published or redistributed if the original mod license or author permission allows it. Keep the original author credit intact in any shared version.
