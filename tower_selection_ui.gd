extends HBoxContainer

@onready var tower_holder = $"../../Towers"
var selected_tower = null

@onready var upgrade_left_path = $"Upgrade Path 1"
@onready var upgrade_right_path = $"Upgrade Path 2"
@onready var special = $"CenterContainer/Special"

func _physics_process(_delta: float) -> void:
	for tower in tower_holder.get_children():
		if !tower.is_connected("select", temp):
			tower.select.connect(temp.bind(tower))
			
	if selected_tower == null:
		hide()
	else:
		show()
		upgrade_left_path.text = selected_tower.upgrade_left_names[selected_tower.upgrade_left_progress]
		upgrade_right_path.text = selected_tower.upgrade_right_names[selected_tower.upgrade_right_progress]
		if selected_tower.special_active:
			special.show()
		else:
			special.hide()
		
func temp(tower : Object):
	if selected_tower != tower:
		selected_tower = tower
	else:
		selected_tower = null

func _on_button_pressed() -> void:
	if selected_tower != null:
		selected_tower.queue_free()

func _on_upgrade_path_1_pressed() -> void:
	selected_tower.upgrade(0)

func _on_upgrade_path_2_pressed() -> void:
	selected_tower.upgrade(1)

func _on_special_pressed() -> void:
	selected_tower.special()
