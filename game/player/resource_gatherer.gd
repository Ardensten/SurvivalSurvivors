class_name ResourceGatherer
extends Node3D

var resource_nodes_in_range: Array[ResourceNode] = []
var current_resource_node: ResourceNode = null
var gathering_progress: float = 2.0

@export var resource_pool: ResourcePool

func _process(delta: float) -> void:
	var new_resource_node := get_closest_resource_node()

	if new_resource_node != current_resource_node:
		current_resource_node = new_resource_node
		gathering_progress = 0.0

	if current_resource_node:
		gathering_progress += delta

		if gathering_progress >= current_resource_node.gathering_time:
			var resource_type := current_resource_node.resource_type
			var gathered := current_resource_node.gather()

			resource_pool.add_resource(resource_type, gathered)

			gathering_progress = 0.0

func get_closest_resource_node() -> ResourceNode:
	var closest: ResourceNode = null
	var closest_distance := INF

	for node in resource_nodes_in_range:
		var distance := global_position.distance_to(node.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest = node

	return closest


func _on_gathering_area_body_entered(body: Node3D) -> void:
	if body is ResourceNode:
		resource_nodes_in_range.append(body)


func _on_gathering_area_body_exited(body: Node3D) -> void:
	if body is ResourceNode:
		resource_nodes_in_range.erase(body)
