extends Tower

func _ready() -> void:
	inflict_status = Statuses.StatusEnums.Rooted
	
	shoot_area = $"Area2D"
	tower_area = $"Tower Area"
	sprite = $"Sprite2D"


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
	
func shoot(_enemy: Object):
	for enemy in enemies_in_range:
		enemy.damage(damage, inflict_status)

func _on_tower_area_mouse_entered() -> void:
	mouse_hovering = true

func _on_tower_area_mouse_exited() -> void:
	mouse_hovering = false
