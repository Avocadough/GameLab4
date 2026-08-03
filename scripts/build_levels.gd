extends Node

const BASE_LEVEL := preload("res://Scenes/Levels/base_level.tscn")
const GAME_WIN := preload("res://Scenes/Levels/game_win.tscn")
const GROUND_TILE_SET := preload("res://Scenes/Prefabs/ground_tile_set.tres")
const THEME := preload("res://Scenes/Prefabs/theme.tres")
const COIN := preload("res://Scenes/Prefabs/coin.tscn")
const POTION := preload("res://Scenes/Prefabs/heal_potion.tscn")
const TRAP_SAW := preload("res://Scenes/Prefabs/trap_1.tscn")
const TRAP_SPEAR := preload("res://Scenes/Prefabs/trap_2.tscn")
const MUSHROOM := preload("res://Scenes/Actors/monster_mushroom.tscn")
const SLIME := preload("res://Scenes/Actors/monster_slim.tscn")
const CLOUD_A := preload("res://Assets/BG/cloudLayer1.png")
const CLOUD_B := preload("res://Assets/BG/cloudLayerB1.png")
const MOUNTAIN_A := preload("res://Assets/BG/mountainA.png")
const MOUNTAIN_B := preload("res://Assets/BG/mountainB.png")

const LEVELS := {
	1: {
		"title": "LEVEL 1  •  ROOFTOP START",
		"hint": "Collect crystals and reach the portal.  A/D move • Space jump • X cast",
		"sky": Color("#18324f"),
		"far": CLOUD_A,
		"near": MOUNTAIN_A,
		"spawn": Vector2(128, 440),
		"door": Vector2(2240, 432),
		"platforms": [[-2, 36, 8, 3], [5, 7, 6, 1], [11, 13, 5, 1], [18, 20, 6, 1], [25, 27, 5, 1], [31, 33, 6, 1]],
		"coins": [Vector2(384, 320), Vector2(448, 320), Vector2(768, 256), Vector2(832, 256), Vector2(1216, 320), Vector2(1664, 256), Vector2(2048, 320)],
		"potions": [Vector2(1472, 408)],
		"traps": [[1, Vector2(640, 478)], [1, Vector2(1088, 478)], [2, Vector2(1856, 336)]],
		"enemies": [[0, Vector2(896, 470), 55.0], [1, Vector2(1344, 470), 65.0], [0, Vector2(1920, 470), 70.0]],
	},
	2: {
		"title": "LEVEL 2  •  WIND BRIDGES",
		"hint": "Short gaps, moving monsters, and spear traps guard the upper route.",
		"sky": Color("#21496b"),
		"far": CLOUD_B,
		"near": MOUNTAIN_B,
		"spawn": Vector2(128, 440),
		"door": Vector2(2240, 432),
		"platforms": [[-2, 7, 8, 3], [9, 16, 8, 3], [18, 25, 8, 3], [27, 36, 8, 3], [4, 6, 5, 1], [12, 14, 6, 1], [20, 22, 5, 1], [29, 31, 6, 1]],
		"coins": [Vector2(320, 256), Vector2(384, 256), Vector2(768, 320), Vector2(1280, 256), Vector2(1344, 256), Vector2(1856, 320), Vector2(2112, 384)],
		"potions": [Vector2(1536, 408)],
		"traps": [[2, Vector2(640, 400)], [1, Vector2(1088, 478)], [2, Vector2(1728, 336)], [1, Vector2(1984, 478)]],
		"enemies": [[1, Vector2(512, 470), 70.0], [0, Vector2(960, 470), 75.0], [1, Vector2(1472, 470), 80.0], [0, Vector2(2112, 470), 80.0]],
	},
	3: {
		"title": "LEVEL 3  •  CRYSTAL CAVERNS",
		"hint": "Use the high ledges to avoid the crowded cavern floor.",
		"sky": Color("#301f50"),
		"far": CLOUD_A,
		"near": MOUNTAIN_B,
		"spawn": Vector2(128, 504),
		"door": Vector2(2240, 496),
		"platforms": [[-2, 36, 9, 2], [3, 6, 7, 1], [9, 12, 6, 1], [15, 18, 5, 1], [21, 24, 6, 1], [27, 30, 5, 1], [33, 35, 7, 1]],
		"coins": [Vector2(256, 384), Vector2(576, 320), Vector2(704, 320), Vector2(1024, 256), Vector2(1472, 320), Vector2(1856, 256), Vector2(2176, 384)],
		"potions": [Vector2(1216, 472)],
		"traps": [[1, Vector2(448, 542)], [2, Vector2(832, 336)], [1, Vector2(1344, 542)], [2, Vector2(1792, 272)]],
		"enemies": [[0, Vector2(640, 534), 80.0], [1, Vector2(1088, 534), 85.0], [0, Vector2(1536, 534), 90.0], [1, Vector2(2048, 534), 90.0]],
	},
	4: {
		"title": "LEVEL 4  •  FINAL ASCENT",
		"hint": "Climb the last route and enter the crystal portal above the skyline.",
		"sky": Color("#451f4a"),
		"far": CLOUD_B,
		"near": MOUNTAIN_A,
		"spawn": Vector2(128, 504),
		"door": Vector2(2176, 112),
		"platforms": [[-2, 36, 9, 2], [4, 7, 7, 1], [10, 13, 6, 1], [16, 19, 5, 1], [22, 25, 4, 1], [28, 31, 3, 1], [33, 35, 3, 1]],
		"coins": [Vector2(320, 384), Vector2(704, 320), Vector2(1088, 256), Vector2(1472, 192), Vector2(1856, 128), Vector2(2176, 64)],
		"potions": [Vector2(1408, 152)],
		"traps": [[1, Vector2(576, 542)], [2, Vector2(896, 336)], [1, Vector2(1280, 542)], [2, Vector2(1600, 208)], [1, Vector2(1984, 542)]],
		"enemies": [[1, Vector2(448, 534), 90.0], [0, Vector2(768, 534), 95.0], [1, Vector2(1152, 534), 100.0], [0, Vector2(1664, 534), 100.0], [1, Vector2(1920, 534), 105.0]],
	},
}


func _ready() -> void:
	for number in range(4, 0, -1):
		var next_scene: PackedScene = GAME_WIN if number == 4 else load("res://Scenes/Levels/level_%02d.tscn" % (number + 1))
		var result := build_level(number, next_scene)
		if result != OK:
			printerr("Failed to build level %d: %s" % [number, error_string(result)])
			get_tree().quit(result)
			return
	print("Built four Crystal Courier levels.")
	get_tree().quit()


func build_level(number: int, next_scene: PackedScene) -> Error:
	var config: Dictionary = LEVELS[number]
	var root := BASE_LEVEL.instantiate()
	root.name = "Level%02d" % number
	root.get_node("Player").position = config["spawn"]
	root.get_node("LevelFinishDoor").position = config["door"]
	root.get_node("LevelFinishDoor").next_scene = next_scene
	strip_instance_self_connections(root.get_node("LevelFinishDoor"))
	root.get_node("UserInterface/Label").text = config["title"]

	var level := root.get_node("Level")
	var backdrop := Polygon2D.new()
	backdrop.name = "Sky"
	backdrop.z_index = -20
	backdrop.color = config["sky"]
	backdrop.polygon = PackedVector2Array([Vector2(-1024, -1024), Vector2(4096, -1024), Vector2(4096, 1024), Vector2(-1024, 1024)])
	add_owned(level, backdrop, root)
	level.move_child(backdrop, 0)
	add_parallax_sprite(root.get_node("Level/Background1"), config["far"], Color(0.72, 0.82, 1.0, 0.55), root)
	add_parallax_sprite(root.get_node("Level/Background2"), config["near"], Color(0.78, 0.88, 1.0, 0.72), root)

	var ground := TileMapLayer.new()
	ground.name = "Ground"
	ground.tile_set = GROUND_TILE_SET
	ground.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_owned(level, ground, root)
	for segment in config["platforms"]:
		paint_platform(ground, segment[0], segment[1], segment[2], segment[3])

	var hint := Label.new()
	hint.name = "LevelHint"
	hint.position = Vector2(-430, 360)
	hint.size = Vector2(1080, 90)
	hint.theme = THEME
	hint.text = config["hint"]
	hint.add_theme_font_size_override("font_size", 20)
	hint.add_theme_color_override("font_color", Color("#eaf8ff"))
	hint.add_theme_constant_override("outline_size", 6)
	add_owned(root.get_node("Text"), hint, root)

	for index in config["coins"].size():
		spawn_scene(COIN, root.get_node("Coins"), config["coins"][index], "Crystal%02d" % (index + 1), root)
	for index in config["potions"].size():
		spawn_scene(POTION, root.get_node("Coins"), config["potions"][index], "HealPotion%02d" % (index + 1), root)
	for index in config["traps"].size():
		var trap_data: Array = config["traps"][index]
		var trap_scene: PackedScene = TRAP_SAW if trap_data[0] == 1 else TRAP_SPEAR
		spawn_scene(trap_scene, level, trap_data[1], "Trap%02d" % (index + 1), root)
	for index in config["enemies"].size():
		var enemy_data: Array = config["enemies"][index]
		var enemy_scene: PackedScene = MUSHROOM if enemy_data[0] == 0 else SLIME
		var enemy := spawn_scene(enemy_scene, root.get_node("Enemies"), enemy_data[1], "Monster%02d" % (index + 1), root)
		enemy.set("speed", enemy_data[2])
		enemy.set("direction", -1 if index % 2 else 1)

	var packed := PackedScene.new()
	var pack_error := packed.pack(root)
	if pack_error != OK:
		root.free()
		return pack_error
	var save_error := ResourceSaver.save(packed, "res://Scenes/Levels/level_%02d.tscn" % number)
	root.free()
	return save_error


func add_owned(parent: Node, child: Node, owner: Node) -> void:
	parent.add_child(child)
	child.owner = owner


func add_parallax_sprite(parent: Node, texture: Texture2D, tint: Color, owner: Node) -> void:
	var sprite := Sprite2D.new()
	sprite.name = "Backdrop"
	sprite.texture = texture
	sprite.centered = false
	sprite.scale = Vector2(2, 2)
	sprite.modulate = tint
	add_owned(parent, sprite, owner)


func paint_platform(layer: TileMapLayer, start_x: int, end_x: int, y: int, depth: int) -> void:
	for x in range(start_x, end_x + 1):
		layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 1), 0)
		for row in range(1, depth):
			layer.set_cell(Vector2i(x, y + row), 0, Vector2i(3, 1), 0)


func spawn_scene(scene: PackedScene, parent: Node, position: Vector2, node_name: String, owner: Node) -> Node:
	var instance := scene.instantiate()
	instance.name = node_name
	instance.position = position
	strip_instance_self_connections(instance)
	add_owned(parent, instance, owner)
	return instance


func strip_instance_self_connections(instance: Node) -> void:
	# PackedScene.pack() serializes root-to-self connections from child instances.
	# The child scene restores them itself when loaded, so keeping both duplicates them.
	for signal_info in instance.get_signal_list():
		for connection in instance.get_signal_connection_list(signal_info["name"]):
			if connection["callable"].get_object() == instance:
				instance.disconnect(signal_info["name"], connection["callable"])
