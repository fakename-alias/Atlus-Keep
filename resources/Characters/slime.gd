extends Node3D

@export var stats: CharacterStats
@onready var card:= $Sprite3D

func _ready():
	if stats: stats.init_current_pools()
	if card and card.has_method("set_stats"):
		card.set_stats(stats)
