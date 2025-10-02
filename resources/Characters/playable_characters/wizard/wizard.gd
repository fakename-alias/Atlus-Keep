extends Node3D

@export var stats: CharacterStats
@onready var card:= $Sprite3D
@onready var bar: ProgressBar = $HealthBarViewport/HealthBarUI/Bar

func _ready():
	if stats: stats.init_current_pools()
	if card and card.has_method("set_stats"):
		card.set_stats(stats)

func _process(delta: float) -> void:
	if stats:
		bar.max_value = stats.get_max_hp()
		bar.value = stats.hp
