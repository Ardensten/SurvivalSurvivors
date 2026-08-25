class_name BuildingPlacement
extends Node3D

@export var camera: Camera3D
@export var worldtree: Worldtree
@export var resource_pool: ResourcePool

@export_flags_3d_physics var blocking_mask: int

var active_definition: BuildingDefinition
var ghost: Node3D
var is_valid_placement: bool = false

func _process(_delta: float) -> void:
	if ghost == null:
		return

	var mouse_position := get_viewport().get_mouse_position()

	var ray_origin := camera.project_ray_origin(mouse_position)
	var ray_direction := camera.project_ray_normal(mouse_position)
	var ray_end := ray_origin + ray_direction * 1000.0

	var query := PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_end
	)
	
	query.collision_mask = 1 << 2
	
	var result := get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		var within_build_radius := worldtree.is_position_within_build_radius(
			ghost.global_position
		)

		var area_clear := is_area_clear(ghost.global_position)

		var can_afford := resource_pool.can_afford(active_definition)

		is_valid_placement = (
			within_build_radius
			and area_clear
			and can_afford
		)

		update_ghost_visual(is_valid_placement)


func _unhandled_input(event: InputEvent) -> void:
	if ghost == null:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			cancel_placement()

	if event.is_action_pressed("ui_cancel"):
		cancel_placement()


func start_placement(definition: BuildingDefinition) -> void:
	cancel_placement()

	active_definition = definition

	if definition.scene == null:
		push_warning("Building definition has no scene: " + definition.building_name)
		return

	ghost = definition.scene.instantiate() as Node3D
	add_child(ghost)

	if ghost is CollisionObject3D:
		ghost.collision_layer = 0
		ghost.collision_mask = 0
		
	apply_ghost_visual(ghost)

	print("Started placement: ", definition.building_name)


func cancel_placement() -> void:
	active_definition = null

	if ghost:
		ghost.queue_free()
		ghost = null


func apply_ghost_visual(node: Node) -> void:
	if node is MeshInstance3D:
		var material := StandardMaterial3D.new()
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.albedo_color = Color(1.0, 1.0, 1.0, 0.5)

		node.material_override = material

	for child in node.get_children():
		apply_ghost_visual(child)


func update_ghost_visual(valid: bool) -> void:
	var color := Color(0.2, 1.0, 0.2, 0.5) if valid else Color(1.0, 0.2, 0.2, 0.5)
	set_ghost_color(ghost, color)


func set_ghost_color(node: Node, color: Color) -> void:
	if node is MeshInstance3D:
		var material := StandardMaterial3D.new()
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.albedo_color = color
		node.material_override = material

	for child in node.get_children():
		set_ghost_color(child, color)


func is_area_clear(position: Vector3) -> bool:
	var shape := BoxShape3D.new()

	shape.size = Vector3(
		active_definition.footprint.x,
		2.0,
		active_definition.footprint.y
	)

	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(Basis.IDENTITY, position)
	query.collision_mask = blocking_mask

	var results := get_world_3d().direct_space_state.intersect_shape(query)

	return results.is_empty()
