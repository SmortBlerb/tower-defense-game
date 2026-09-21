extends PathFollow2D

@export var max_speed := 1.0
var speed := max_speed
var tick = 0
var status_end = 0

func _physics_process(_delta: float) -> void:
	progress += speed
	if progress_ratio == 1.0:
		queue_free()
	if speed != max_speed:
		tick += 1
		if tick == status_end:
			speed = max_speed

func stagger(time: float):
	status_end = time
	tick = 0
	speed = 0

func slow(speed_frac: float):
	status_end = 15
	tick = 0
	speed = max_speed * speed_frac
