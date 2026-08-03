extends Node


func _ready() -> void:
	var levels := [
		"res://Scenes/Levels/level_01.tscn",
		"res://Scenes/Levels/level_02.tscn",
		"res://Scenes/Levels/level_03.tscn",
		"res://Scenes/Levels/level_04.tscn",
	]
	var next_scenes := [
		"res://Scenes/Levels/level_02.tscn",
		"res://Scenes/Levels/level_03.tscn",
		"res://Scenes/Levels/level_04.tscn",
		"res://Scenes/Levels/game_win.tscn",
	]
	for index in levels.size():
		var path: String = levels[index]
		assert(ResourceLoader.exists(path), "Missing %s" % path)
		var scene: PackedScene = load(path)
		var root := scene.instantiate()
		assert(root.has_node("Level/Ground"), "%s has no TileMapLayer" % path)
		var ground: TileMapLayer = root.get_node("Level/Ground")
		assert(ground.get_used_cells().size() > 20, "%s has too few tiles" % path)
		assert(ground.tile_set.get_physics_layers_count() > 0, "%s has no tile collision layer" % path)
		assert(root.get_node("LevelFinishDoor").next_scene.resource_path == next_scenes[index], "%s has the wrong exit" % path)
		root.free()
	var menu := (load("res://Scenes/Levels/menu.tscn") as PackedScene).instantiate()
	assert(menu.has_node("UI/btnExit"), "Menu has no Exit button")
	menu.free()
	for path in ["res://Scenes/Levels/game_over.tscn", "res://Scenes/Levels/game_win.tscn"]:
		var end_screen := (load(path) as PackedScene).instantiate()
		assert(end_screen.get_node("btnPlay").restart_game, "%s cannot restart the game" % path)
		end_screen.free()
	assert(ResourceLoader.exists("res://Assets/Sound/crystal_route.wav"))
	assert(ResourceLoader.exists("res://Assets/Spritesheet/crystal_bolt.svg"))
	print("PROJECT_VALIDATION_OK: menu + four levels + TileMap collision + assets")
	get_tree().quit()
