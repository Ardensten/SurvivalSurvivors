extends VBoxContainer

@onready var wood_label: Label = $WoodLabel
@onready var stone_label: Label = $StoneLabel


func setup(resource_pool: ResourcePool) -> void:
	resource_pool.resources_changed.connect(_on_resources_changed)
	_on_resources_changed(resource_pool.wood, resource_pool.stone)


func _on_resources_changed(wood: int, stone: int) -> void:
	wood_label.text = "🪵 %d" % wood
	stone_label.text = "🪨 %d" % stone
