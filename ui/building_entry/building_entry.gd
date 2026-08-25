class_name BuildingEntry
extends Button

@onready var name_label: Label = $HBoxContainer/NameLabel
@onready var cost_label: Label = $HBoxContainer/CostLabel

var definition: BuildingDefinition
var resource_pool: ResourcePool
var building_placement: BuildingPlacement
var is_dragging: bool = false
var drag_start_position: Vector2
const DRAG_THRESHOLD := 8.0

func setup(building_definition: BuildingDefinition, pool: ResourcePool, placement: BuildingPlacement) -> void:
	definition = building_definition
	resource_pool = pool
	building_placement = placement

	name_label.text = definition.building_name
	cost_label.text = "%d wood / %d stone" % [
		definition.wood_cost,
		definition.stone_cost
	]

	resource_pool.resources_changed.connect(_on_resources_changed)

	update_affordability()


func _on_resources_changed(_wood: int, _stone: int) -> void:
	update_affordability()


func update_affordability() -> void:
	disabled = not resource_pool.can_afford(definition)

	if disabled:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color.WHITE
		

func _gui_input(event: InputEvent) -> void:
	if disabled:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start_position = event.position
			else:
				if is_dragging:
					building_placement.place_blueprint()
				is_dragging = false

	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if not is_dragging:
				var drag_distance = event.position.distance_to(drag_start_position)

				if drag_distance >= DRAG_THRESHOLD:
					is_dragging = true
					building_placement.start_placement(definition)
