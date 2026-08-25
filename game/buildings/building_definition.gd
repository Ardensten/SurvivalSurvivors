class_name BuildingDefinition
extends Resource

@export var building_name: String
@export var icon: Texture2D
@export var scene: PackedScene

@export_group("Cost")
@export var wood_cost: int = 0
@export var stone_cost: int = 0

@export_group("Construction")
@export var construction_time: float = 1.0

@export_group("Placement")
@export var footprint: Vector2 = Vector2.ONE
