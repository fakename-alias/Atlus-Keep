extends Node3D

@export var stats: CharacterStats
@onready var card:= $Sprite3D
@onready var bar: ProgressBar = $HealthBarViewport/HealthBarUI/Bar

func _ready():
	if stats: stats.init_current_pools()
	
	if bar: 
		stats.hp_changed.connect(_on_hp_changed)
		_on_hp_changed(stats.get_hp(), stats.get_max_hp())
	if card and card.has_method("set_stats"):
		card.set_stats(stats)

func _process(delta: float) -> void:
	if stats:
		bar.max_value = stats.get_max_hp()
		bar.value = stats.hp

func _on_hp_changed(current: int, max_value: int) -> void:
	if bar:
		bar.min_value = 0
		bar.max_value = max_value
		bar.value = current
