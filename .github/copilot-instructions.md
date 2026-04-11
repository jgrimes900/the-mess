# AI Coding Guidelines for "The Mess" Godot Project

## Architecture Overview
- **3D Game Engine**: Godot 4.6 with C# support, Jolt Physics, Forward Plus rendering
- **Main Components**: 
  - Entities (`entities/`): Player, weapons, collectibles, enemies (e.g., `Player.gd` as CharacterBody3D)
  - Maps (`maps/`): Scene files (.tscn) with static geometry, triggers, prefabs
  - Assets: Models, textures, sounds organized by type
  - Addons: RL agents (`godot_rl_agents`), MCP AI control (`gdai-mcp-plugin-godot`)
- **Data Flow**: Signals for entity communication (e.g., `collected` in `Shar_Coin.gd`), autoloads for global state (Player, GDAIMCPRuntime)
- **RL Integration**: `Sync` node connects Godot scenes to Python training scripts via TCP (port 11008)

## Key Patterns & Conventions
- **Entity Scripts**: Extend Node3D/CharacterBody3D, use `@export` for configurable vars, `@onready` for node refs
- **Collision Handling**: Custom physics queries for complex interactions (e.g., coin bouncing in `Shar_Coin.gd`)
- **Signals**: Connect via `connect()` with `bind()` for params (e.g., `collected.emit(index)`)
- **Prefabs**: Reusable scenes in `prefabs/`, instantiated in maps
- **Input**: WASD movement, space jump, mouse fire, esc pause (defined in `project.godot`)

## Developer Workflows
- **Build/Run**: Use Godot editor (`godot` command) or export presets for Linux builds (excludes `addons/`, `wiki/`)
- **RL Training**: Add `Sync` node to scenes, set `control_mode` to TRAINING, run Python env (e.g., stable_baselines3) connecting to port 11008
- **Debugging**: Check output logs via MCP plugin, use Godot's debugger for breakpoints
- **Version Control**: Git plugin autoloaded, commit .tscn/.gd changes frequently

## Integration Points
- **Python RL**: Scripts in `py/` use stable_baselines3, communicate via TCP with `Sync` node
- **MCP AI Control**: `gdai-mcp-plugin-godot` addon enables AI scene/node manipulation
- **C# Scripts**: For performance-critical code, compile via .csproj files

## Examples
- **Adding Entity**: Create script in `entities/`, attach to Node3D, use `get_node("/root/Player")` for global refs
- **Signal Usage**: `signal collected(a: int)` in coin, connect to player currency handler
- **Physics Query**: `get_world_3d().direct_space_state.intersect_ray()` for custom collision (see `Shar_Coin.gd` monster mode)