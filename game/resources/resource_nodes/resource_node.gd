class_name ResourceNode
extends StaticBody3D

enum ResourceType {
	WOOD,
	STONE
}

@export var resource_type: ResourceType
@export var resource_amount: int = 10
@export var gathering_time: float = 1.0

func gather() -> int:
	var gathered := resource_amount
	resource_amount = 0
	queue_free()

	return gathered
