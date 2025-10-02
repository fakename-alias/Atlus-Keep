extends Control

class_name HealthBar

@export var target_3d: Node3D
@export var stats: CharacterStats
@export var pixel_offset: Vector2 = Vector2(0, -40) #nudge box upwards

@onready var bar: ProgressBar = %Bar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats:
		bar.max_value = stats.get_max_hp()
		bar.value = stats.get_current_hp()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stats:
		bar.max_value = stats.get_max_hp()
		bar.value = stats.get_current_hp()
	if target_3d:
		var camera:= get_viewport().get_camera_3d()
		if camera:
			global_position = camera.unproject_position(target_3d.global_transform.origin) + pixel_offset
