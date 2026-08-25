class_name ResourcePool
extends Node

var wood: int = 0
var stone: int = 0

signal resources_changed(wood: int, stone: int)

func add_resource(type: ResourceNode.ResourceType, amount: int) -> void:
	match type:
		ResourceNode.ResourceType.WOOD:
			wood += amount

		ResourceNode.ResourceType.STONE:
			stone += amount

	resources_changed.emit(wood, stone)

func can_afford(definition: BuildingDefinition) -> bool:
	return wood >= definition.wood_cost \
		and stone >= definition.stone_cost


func spend_resources(definition: BuildingDefinition) -> bool:
	if not can_afford(definition):
		return false

	wood -= definition.wood_cost
	stone -= definition.stone_cost

	resources_changed.emit(wood, stone)

	return true
