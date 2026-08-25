extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerHUD/ResourceDisplay.setup($Player/ResourcePool)
	$PlayerHUD/BuildPanel.setup($Player/ResourcePool, $BuildingPlacement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart_scene"):
		SceneManager.restart_scene()

	if Input.is_action_just_pressed("load_scene"):
		SceneManager.load_scene("res://main/main.tscn")

	if Input.is_action_just_pressed("quit"):
		SceneManager.quit_game()
