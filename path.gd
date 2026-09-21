extends Path2D

@onready var enemy_scene = preload("res://enemy.tscn")
@onready var path_follow_scene = preload("res://enemy_path_follow.tscn")
@export var start_position : Vector2 = Vector2(0, 0)

var tick = 10

func wave(enemy_count: int, enemy_spacing: float):
	for i in enemy_count:
		spawn_enemy()
		await get_tree().create_timer(enemy_spacing).timeout

func spawn_enemy():
	var path_follow = path_follow_scene.instantiate()
	var enemy = enemy_scene.instantiate()
	enemy.position = start_position
	
	add_child(path_follow)
	path_follow.add_child(enemy)

func _on_next_wave_pressed() -> void:
	wave(3, 1)
