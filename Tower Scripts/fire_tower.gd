extends Tower

func _ready() -> void:
	inflict_status = Statuses.StatusEnums.Fire
	
	shoot_area = $"Area2D"
	tower_area = $"Tower Area"
	sprite = $"Sprite2D"
	
	projectile = preload("res://Tower Scenes/flames.tscn")

func _physics_process(_delta: float) -> void:
	shoot_area.get_child(0).shape.radius = radius
	
	if !enemies_in_range.is_empty():
		look_at(enemies_in_range[0].global_position)
		if tick == fire_rate:
			shoot(enemies_in_range[0])
			tick = 0
		tick += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	enemies_in_range.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func shoot(enemy: Object):
	var inst = projectile.instantiate()
	inst.position = Vector2(0, 0)
	inst.set_status(inflict_status)
	inst.target = enemy
	add_child(inst)

func _on_tower_area_mouse_entered() -> void:
	mouse_hovering = true

func _on_tower_area_mouse_exited() -> void:
	mouse_hovering = false
