# ⚡ Powered Concrete

**Powered Concrete** adds powered versions of concrete, refined concrete, and hazard concrete so your factory floor can carry electric coverage without visible power poles everywhere.

Build cleaner. Expand faster. Keep your factory floor looking sharp.

---

## 🔌 What It Does

Powered Concrete turns your floor into a hidden power network.

Instead of placing power poles all over your factory, you can use powered concrete tiles to carry electric coverage directly through the ground. Power only exists where powered concrete has actually been placed, so the default behaviour stays exact tile-by-tile.

This 1.2.x release also keeps an optional connector-grid UPS setting for large bases and servers.

---

## ✨ 1.2.3 Polish Pass

- New cleaner overlay icons for powered, unpowered, convert, and powered-convert recipe/item states
- Documentation cleaned up so the current default is clear
- Default connector grid size is **1** for exact tile-by-tile powered floor behaviour
- Optional grid sizes such as **4** or **8** remain available for huge bases where UPS matters more than exact cell coverage
- Migration support kept for deprecated **PoweredConcreteSpaceAge 0.1.x** saves

---

## ✅ Clean Visible Floor List

The crafting UI is kept focused on the actual floor tiles you need:

- 🧱 **Stone Brick**
- 🧱 **Concrete**
- ⚠️ **Hazard Concrete**
- 🧱 **Refined Concrete**
- ⚠️ **Refined Hazard Concrete**
- ⚡ **Powered Concrete**
- ⚡ **Powered Hazard Concrete**
- ⚡ **Powered Refined Concrete**
- ⚡ **Powered Refined Hazard Concrete**

Extra conversion recipes such as **Remove Powered Concrete Hazard Markings** and similar add/remove marking recipes are hidden so the inventory stays clean.

---

## ✅ Features

- ⚡ **Powered Concrete**
- ⚡ **Powered Hazard Concrete**
- ⚡ **Powered Refined Concrete**
- ⚡ **Powered Refined Hazard Concrete**
- 🔌 Hidden floor-based electric coverage
- 🧱 Exact tile-by-tile powered floor logic by default
- 🚀 Optional big-base UPS tuning
- ⚙️ Startup setting for connector grid size
- 👁️ No visible power poles across your factory floor
- 🧪 Q / pipette support for normal, refined, and hazard variants
- 🤖 Works with normal building, mining, robot placement, and tile changes
- 🛠️ Includes `/powered-concrete-rebuild` admin command
- 🔁 Migration support from deprecated PoweredConcreteSpaceAge 0.1.x saves
- 📦 Factorio 2.0 compatible
- 🧹 No `flib` dependency

---

## ⚙️ UPS Mode

By default, the connector grid size is `1`, so powered floors keep exact tile-by-tile behaviour.

For very large bases or servers, you can raise **Powered concrete connector grid size** to `4`, `8`, or higher to reduce hidden connector count. Higher values are lighter, but power coverage becomes cell-based instead of exact per tile.

---

## 🔁 Migration From PoweredConcreteSpaceAge

Version 1.2.2+ includes migration support from the deprecated **PoweredConcreteSpaceAge 0.1.x** mod.

Matching old PCSA items, placed tiles, recipes, and hidden powered-tile poles are migrated to the main **Powered_Concrete** prototype names.

The old mod is marked incompatible so players do not accidentally load both versions together.

Optional PCSA/Krastorio reinforced powered plates are not converted because Powered Concrete does not currently define replacement prototypes for those variants.

---

## 🛠️ Rebuild Command

If the hidden powered floor system ever gets out of sync, rebuild it with:

```text
/powered-concrete-rebuild
```

This is useful after changing startup settings, testing old saves, scripted tile edits, or heavy mod changes.

---

## ⚙️ Compatibility

Built for **Factorio 2.0**.

This version updates the original concept for modern Factorio, fixes older prototype issues, removes the old dependency setup, improves hidden connector syncing, adds optional UPS-focused connector tuning, and includes migration support from the deprecated Space Age fork.

---

## 🙏 Credits

Original **Powered Concrete** mod by **JuneGame**.

This release is a **Factorio 2.0 compatibility, cleanup, packaging, migration, icon polish, and UPS optimisation pass** by **Squishy1870**.

---

## 💬 Final Note

Powered Concrete is made for players who want cleaner factory layouts without giving up practical electric coverage.

Perfect for big bases, clean bus builds, city-block layouts, and factories where you want the floor to do more than just look good.
