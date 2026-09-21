extends Tower

func _ready() -> void:
	inflict_status = Statuses.StatusEnums.Wet
	
	upgrade_left_names = ["Faster Pipes", "Mechanized Pipes", "Splash Zone", "Double Splash", "MAX"]
	upgrade_right_names = ["Long Nozzle", "Pressurized Pipes", "Oil Rigging", "Triple Nozzle", "MAX"]
	
	shoot_area = $"Area2D"
	tower_area = $"Tower Area"
	sprite = $"Sprite2D"
	
	projectile = preload("res://Tower Scenes/water_projectile.tscn")


func _physics_process(_delta: float) -> void:
	shoot_area.get_child(0).shape.radius = radius
	
	if !enemies_in_range.is_empty():
		look_at(enemies_in_range[0].global_position)
		if tick == fire_rate:
			if upgrade_right_progress == 4:
				tick = 0
				shoot(enemies_in_range[0])
				await get_tree().create_timer(0.1).timeout
				shoot(enemies_in_range[0])
				await get_tree().create_timer(0.1).timeout
				shoot(enemies_in_range[0])
			else:
				tick = 0
				shoot(enemies_in_range[0])
		tick += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	enemies_in_range.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func _on_tower_area_mouse_entered() -> void:
	mouse_hovering = true

func _on_tower_area_mouse_exited() -> void:
	mouse_hovering = false
	
func upgrade(path : int):
	if path == 0:
		if upgrade_left_progress == 0:
			fire_rate -= 5
			tick = fire_rate
			upgrade_left_progress += 1
		elif upgrade_left_progress == 1:
			fire_rate -= 5
			tick = fire_rate
			upgrade_left_progress += 1
		elif upgrade_left_progress == 2:
			pass # later
			upgrade_left_progress += 1
		elif upgrade_left_progress == 3:
			upgrade_left_progress += 1
	elif path == 1:
		if upgrade_right_progress == 0:
			radius += 5
			upgrade_right_progress += 1
		elif upgrade_right_progress == 1:
			radius += 5
			damage += 1
			upgrade_right_progress += 1
		elif upgrade_right_progress == 2:
			damage += 1
			special_active = true
			upgrade_right_progress += 1
		elif upgrade_right_progress == 3:
			upgrade_right_progress += 1
				
func special():
	if inflict_status == Statuses.StatusEnums.Wet:
		inflict_status = Statuses.StatusEnums.Oil
	else:
		inflict_status = Statuses.StatusEnums.Wet
