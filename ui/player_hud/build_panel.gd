class_name BuildPanel
extends PanelContainer

@export var building_entry_scene: PackedScene
@export var building_definitions: Array[BuildingDefinition]

@onready var building_list: VBoxContainer = $MarginContainer/VBoxContainer/BuildingList

var resource_pool: ResourcePool
var building_placement: BuildingPlacement


func setup(pool: ResourcePool, placement: BuildingPlacement) -> void:
	resource_pool = pool
	building_placement = placement
	populate_building_list()


func populate_building_list() -> void:
	for child in building_list.get_children():
		child.queue_free()

	for definition in building_definitions:
		var entry := building_entry_scene.instantiate() as BuildingEntry
		building_list.add_child(entry)
		entry.setup(definition, resource_pool, building_placement)
