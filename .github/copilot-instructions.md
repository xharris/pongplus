# Copilot Instructions for pongplus

## Rules

- Avoid modifying a node's process mode

## Debug & Logging

- **ALWAYS** check `logs/game.log` first when debugging - file logging is enabled via `project.godot`.
- Use the `Logger` class (`logs.gd`) for all logging. Create instances with `Logger.new(id, level, prefix)`.
- Set global log level via `Logger.global_level = Logger.Level.DEBUG/INFO/WARN/ERROR`.
- Components typically have `var _log = Logger.new("component_name")` for instance-level logging.
- Logs that are repeated, print this instead: `...`
- When adding logs to troubleshoot, `DEBUG` level is preferred

## Project Overview

- **pongplus** is a Godot 4.4+ game project with modular, component-based architecture.
- Core gameplay logic is organized under `components/`, `entities/`, and `game/`.
- **Autoloads:** Only `EventBus` (`entities/event_bus.gd`) is globally available - use it for cross-component signaling.
- Addons (e.g., `addons/eye_dropper/`) provide reusable shaders and tools.

## Writing/Reading logs

- `...` means the previous line was repeated in the logs
- When adding logs using `log.debug`, the logger level must be set to `DEBUG`, for example: `var _log = Logger.new("player", Logger.Level.DEBUG)`

## Key Architectural Patterns

### Component System

- Each gameplay element is a GDScript class (often with a `.tscn` scene).
- Components are grouped by function (e.g., `components/ability/`, `components/health/`).
- Most components implement `accept(v: Visitor)` for visitor pattern integration.

### Visitor Pattern (Critical)

- **Core class:** `Visitor` resource (`components/visitor/visitor.gd`).
- **Usage:** `Visitor.visit(node, visitors)` or `await Visitor.visit(node, visitors)` for async operations.
- Visitors are configured as `.tres` resources and exported in arrays (e.g., `gameplay.on_start: Array[Visitor]`).
- Many gameplay events use visitor arrays:
  - `Gameplay.on_start` - level initialization
  - `Gameplay.on_player_take_damage` - player damage events
  - `Ability.on_ready`, `Ability.on_me_hit_player`, etc. - ability triggers
- **Pattern:** Components implement `accept(v: Visitor)` and check visitor type:
  ```gdscript
  func accept(v: Visitor):
      if v is PlayerVisitor:
          v.visit_player(self)
      elif v is CameraVisitor:
          camera.accept(v)  # delegate to child
  ```

### Event Bus (Global Communication)

- **File:** `entities/event_bus.gd` (autoloaded as `EventBus`).
- Defines global signals like `ball_created(ball)`, `ball_destroyed(ball)`, `player_health_current_changed(player, amount)`.
- Components connect to signals in `_ready()`:
  ```gdscript
  EventBus.ball_created.connect(_on_ball_created, CONNECT_DEFERRED)
  ```

### Node Groups (Runtime Queries)

- **File:** `groups.gd` - defines constants for all groups (e.g., `Groups.PLAYER`, `Groups.BALL`).
- Query with `get_tree().get_nodes_in_group(Groups.PLAYER)`.
- Nodes add themselves to groups in `_ready()`: `add_to_group(Groups.GAME)`.

### Constants & Enums

- `constants.gd` - gameplay constants (e.g., `ATTACK_HITBOX_ACTIVE_DURATION`).
- `hitboxes.gd` - hitbox type constants (e.g., `Hitboxes.PLAYER`, `Hitboxes.BALL`).
- Use these instead of hardcoded strings/values.

## Developer Workflows

### Running & Testing

- **Main Scene:** Set in `project.godot` as `run/main_scene` (UID-based).
- **Testing:** Manual testing via Godot editor (F5 to run). No automated test framework.
- **Debugging:** Check `logs/game.log` first. Enable DEBUG logging: `Logger.global_level = Logger.Level.DEBUG`.

### Gameplay Configuration

- **Gameplay Resource:** Levels reference a `Gameplay` resource (`.tres`) that defines:
  - `player_abilties: Array[Ability]` - abilities for players
  - `on_start`, `on_player_take_damage`, `on_exit: Array[Visitor]` - event handlers
- **Level Setup:** In `level.gd`, gameplay is applied via:
  ```gdscript
  Visitor.visit.call_deferred(self, gameplay.on_start)
  for p in get_tree().get_nodes_in_group(Groups.PLAYER):
      p.abilities = gameplay.player_abilties.duplicate(true)
  ```

### Ability System

- **Static helpers:** `Ability.visit_abilities(abilities, node, name)` processes ability visitor arrays.
- **Ability hooks:** `on_ready`, `on_me_hit_player`, `on_me_hit_player_platform` (see `ability.gd` constants).
- **Override flag:** Set `ability.overrides = true` to stop processing subsequent abilities in the array.

## Project-Specific Conventions

- **Resource-Driven:** Configuration uses `.tres` resources with exported arrays (not code-based configs).
- **Scene/Script Pairing:** Components typically have both `.gd` script and `.tscn` scene.
- **Visitor Propagation:** Components delegate visitors to children via `accept()`:
  ```gdscript
  func accept(v: Visitor):
      if v is PlayerVisitor:
          v.visit_player(self)
      elif v is CameraVisitor:
          camera.accept(v)  # delegate to child component
  ```
- **Deferred Connections:** Use `CONNECT_DEFERRED` for EventBus signals to avoid timing issues.
- **No Automated Tests:** Testing is manual via Godot editor.

## Integration Points

- **Addons:**
  - `addons/eye_dropper/` provides palette swap shader for character colorization. See its README for usage.
- **Utility Helpers:**
  - `Util.get_ancestor(node, cls)` - finds ancestor of specific class
  - `Util.find_child(parent, cls)` - finds child of specific class
  - `Util.find_first_child_in_group(parent, group)` - finds first child in group
  - `Util.diminishing(value, rate)` - calculates diminishing returns [0, 1]
- **Signals:**
  - Components often emit `accepted_visitor(v: Visitor)` signal for visitor propagation up to parent nodes.
  - Controllers emit directional signals: `up`, `down`, `left`, `right`, `charge_attack`, `release_attack`.

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
- **Logger Instance:**
  ```gdscript
  var _log = Logger.new("component_name")
  _log.debug("message")
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
