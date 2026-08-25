class_name Worldtree
extends StaticBody3D

@export var build_radius: float = 15.0

func is_position_within_build_radius(position: Vector3) -> bool:
	var flat_position := Vector2(position.x, position.z)
	var flat_tree_position := Vector2(global_position.x, global_position.z)

	return flat_tree_position.distance_to(flat_position) <= build_radius
	
