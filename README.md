# Tile Map Navigation Plugin

![Godot 4.2](https://img.shields.io/badge/Godot-v4.2.x-%23478cbf?logo=godot-engine&logoColor=white)

Godot Plugin for using Navigation2D with multiple Tile Maps and layers.

Introduces a new node `TileMapNavigationRegion2D` and a new **Bake** button in the editor that uses the physics layers in the tilemaps when baking.

## Usage

Create a `TileMapNavigationRegion2D` node and configure the navigation polygon and which tile maps to use.

![tilemapnav2d_inspector](https://github.com/suumpmolk/godot-tile-map-nav-plugin/assets/137987619/d5bc28af-13ed-4c16-9d07-12cf33d874e7)

When selecting a `TileMap` or `TileMapNavigationRegion2D` a new Bake button will appear in the canvas dock above the scene.

![dock_full](https://github.com/suumpmolk/godot-tile-map-nav-plugin/assets/137987619/eec6e136-3672-414f-ba29-1e1d9f85bf66)

If a `TileMapNavigationRegion2D` is selected, the bake button will parse the physics layers from the configured tile maps and bake the mesh using all layers.

If a `TileMap` is selected, the bake button will find all `TileMapNavigationRegion2D` from the current root scene and bake all of them if they use the selected `TileMap`.

## Example

In the example project there is a TileMap with two layers, Ground and Obstacles. The physics objects are in the second layer and because of this the regular baking does not take them into account.
With this plugin all layers will be parsed and used when baking the navigation mesh.

| Regular Bake  | Plugin Bake |
| ------------- | ------------- |
| ![regular_bake_example](https://github.com/suumpmolk/godot-tile-map-nav-plugin/assets/137987619/ad3d12c9-2aad-4494-80ae-97bbc4e4c79d)  | ![new_bake_example](https://github.com/suumpmolk/godot-tile-map-nav-plugin/assets/137987619/3bb5173b-92ff-44d3-b963-4c40799c6d16) |
