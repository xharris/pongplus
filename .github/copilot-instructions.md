# Copilot Instructions for pongplus

## Debug Logs

- Logs of the latest run are written to `logs/game.log`

## Project Overview

- **pongplus** is a Godot 4.4+ game project with modular, component-based architecture. Core gameplay logic is organized under `components/`, `entities/`, and `game/`.
- The project uses Godot's autoload feature for global event handling (`entities/event_bus.gd` as `EventBus`).
- Addons (e.g., `addons/eye_dropper/`) provide reusable shaders and tools.

## Key Architectural Patterns

- **Component System:**
  - Each gameplay element (e.g., ability, health, hitbox, node group) is a GDScript class, often with a corresponding `.tscn` scene.
  - Components are grouped by function in subfolders (e.g., `components/ability/`, `components/health/`).
- **Visitor Pattern:**
  - The `Visitor` resource (`components/visitor/visitor.gd`) enables decoupled logic injection. Use `Visitor.visit(node, visitors)` to apply logic arrays to nodes.
  - Many gameplay events (e.g., `on_start`, `on_player_take_damage`) are handled by passing arrays of `Visitor` objects.
- **Event Bus:**
  - Global signals for cross-component communication are defined in `entities/event_bus.gd` and autoloaded as `EventBus`.
  - Example: `EventBus.ball_created.connect(...)` in `Level` setup.
- **Groups:**
  - Node groups are defined in `groups.gd` and used for runtime queries (e.g., `Groups.PLAYER`, `Groups.BALL`).

## Developer Workflows

- **Main Scene:** Set in `project.godot` as `run/main_scene` (UID-based, see Godot editor for mapping).
- **Autoloads:** `EventBus` is always available globally.
- **Logging:** Use the `Logger` class (see usage in `game/game.gd`, `components/level/level.gd`).
- **Abilities & Gameplay:**
  - Abilities and gameplay events are configured via exported arrays in `Gameplay` resources (`components/gameplay.gd`).
  - Level scenes reference a `Gameplay` resource for event/ability configuration.

## Project-Specific Conventions

- **Resource-Driven:** Most configuration is done via `.tres` resources and exported arrays.
- **Scene/Script Pairing:** Each major component has both a `.gd` script and a `.tscn` scene (where applicable).
- **Shader Addons:** The `eye_dropper` shader in `addons/eye_dropper/` is used for palette swapping; see its README for usage and configuration.
- **No Automated Tests:** Testing is manual via the Godot editor.

## Integration Points

- **Addons:**
  - `addons/eye_dropper/` provides a customizable palette swap shader. See its README for details.
- **External Assets:**
  - All assets (images, shaders, resources) are referenced via Godot's `res://` pathing.

## Example Patterns

- **Visitor Usage:**
  ```gdscript
  Visitor.visit(self, gameplay.on_start)
  Visitor.visit(self, gameplay.on_player_take_damage)
  ```
- **EventBus Connection:**
  ```gdscript
  EventBus.ball_created.connect(_on_ball_created, CONNECT_DEFERRED)
  ```
- **Group Query:**
  ```gdscript
  for p in get_tree().get_nodes_in_group(Groups.PLAYER):
      p.abilities = gameplay.player_abilties.duplicate(true)
  ```

## Key Files & Directories

- `components/` — Core gameplay logic, organized by feature. Major subfolders:
  - `ability/` — Ability system. Abilities are configured as resources and referenced in arrays (e.g., `ball_abilities`, `player_abilties` in `Gameplay`).
  - `camera/` — Camera logic and visitors for camera effects. Camera nodes may export configuration for effects via visitors.
  - `character/` — Character sprites, logic, and visitors. Characters may export palettes, abilities, and visitor arrays for event handling.
  - `controller/` — Player and AI controller logic. Controllers can be configured via exported variables for input mapping and AI behavior.
  - `health/` — Health system, including health resources and visitors. Health components export health values and visitor arrays for damage/death events.
  - `hitbox/` — Hitbox logic, shapes, and visitors for collision. Hitboxes export shape/resource references and visitor arrays for collision events.
  - `level/` — Level node and setup logic. Levels export a `Gameplay` resource (see `@export var gameplay`) and an `id` string for logging/configuration.
  - `missile/` — Missile/projectile logic and visitors. Missiles export duration, movement, and visitor arrays for impact events.
  - `node_group/` — Node grouping and positioning strategies. NodeGroups export a `position_strategy` resource for layout, and manage an `items` array.
  - `palette/` — Palette/material helpers for color management. Materials and palettes are exported for use in shaders and character visuals.
  - `platform/` — Platform logic (movement, collision, etc). Platforms export movement parameters and collision settings.
  - `player_controller/` — Player input and configuration. Player controllers export input mappings and configuration resources.
  - `vfx_impact/` — Visual effects for impacts. VFX nodes export effect parameters and resource references.
  - `visitor/` — Visitor pattern base and visitor logic. Visitors are configured as resources and exported in arrays for event-driven logic injection.
- `entities/` — Game entities (player, ball, platform, etc) and the global event bus (`event_bus.gd`).
- `game/` — Main game loop, scene, and game-level visitors.
- `resources/` — Resource files for configuration (abilities, gameplay, visitors, fonts, etc).
- `addons/eye_dropper/` — Palette swap shader addon (see its README for usage and configuration).
- `groups.gd` — Node group definitions for runtime queries.
- `project.godot` — Godot project config (autoloads, main scene, rendering settings).

---

For more details, see the code in the referenced files and the `eye_dropper` README. If you are unsure about a pattern, check for similar usage in the `components/` and `entities/` folders.
