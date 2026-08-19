extends Node

signal resource_changed(
	resource_type: ResourceType,
	new_amount: int,
	delta: int
)

enum ResourceType {
	WOOD,
	STONE,
}

var _resources: Dictionary = {
	ResourceType.WOOD: 0,
	ResourceType.STONE: 0,
}


func get_amount(resource_type: ResourceType) -> int:
	return _resources.get(resource_type, 0)


func add_resource(resource_type: ResourceType, amount: int) -> void:
	assert(amount >= 0, "Cannot add a negative resource amount.")

	if amount == 0:
		return

	_resources[resource_type] = get_amount(resource_type) + amount
	resource_changed.emit(resource_type, _resources[resource_type], amount)


func remove_resource(resource_type: ResourceType, amount: int) -> bool:
	assert(amount >= 0, "Cannot remove a negative resource amount.")

	if get_amount(resource_type) < amount:
		return false

	_resources[resource_type] -= amount
	resource_changed.emit(resource_type, _resources[resource_type], -amount)

	return true


func can_afford(cost: Dictionary) -> bool:
	for resource_type: ResourceType in cost:
		var required_amount: int = cost[resource_type]

		if required_amount < 0:
			push_error("Resource costs cannot be negative.")
			return false

		if get_amount(resource_type) < required_amount:
			return false

	return true


func spend(cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false

	for resource_type: ResourceType in cost:
		var amount: int = cost[resource_type]

		if amount > 0:
			_resources[resource_type] -= amount
			resource_changed.emit(
				resource_type,
				_resources[resource_type],
				-amount
			)

	return true
