extends Button

@export var exitToScene : PackedScene
@export var restart_game := false

func _on_pressed() -> void:
	if restart_game:
		GameManager.restart()
	elif exitToScene != null:
		SceneTransition.load_scene(exitToScene)
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
