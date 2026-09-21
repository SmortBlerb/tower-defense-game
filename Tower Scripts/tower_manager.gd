extends GridContainer

var selected = null

var water_tower = preload("res://Tower Scenes/water_tower.tscn")
var fire_tower = preload("res://Tower Scenes/fire_tower.tscn")
var electric_tower = preload("res://Tower Scenes/electric_tower.tscn")
var root_tower = preload("res://Tower Scenes/root_tower.tscn")
var bleed_tower = preload("res://Tower Scenes/bleed_tower.tscn")

@onready var button1 = $"Button"
@onready var button2 = $"Button2"
@onready var button3 = $"Button3"
@onready var button4 = $"Button4"
@onready var button5 = $"Button5"

@onready var tower_holder = $"../../Towers"

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_press") && selected != null && !buttons_hovered():
		var instance = selected.instantiate()
		instance.position = get_global_mouse_position()
		tower_holder.add_child(instance)
		reset_button()
		selected = null

func buttons_hovered() -> bool:
	if !button1.is_hovered() && !button2.is_hovered() && !button3.is_hovered() && !button4.is_hovered() && !button5.is_hovered():
		return false
	else:
		return true

func reset_button(exclude : Object = null):
	if exclude == null:
		button1.set_pressed_no_signal(false)
		button2.set_pressed_no_signal(false)
		button3.set_pressed_no_signal(false)
		button4.set_pressed_no_signal(false)
		button5.set_pressed_no_signal(false)
	else:
		button1.set_pressed_no_signal(false)
		button2.set_pressed_no_signal(false)
		button3.set_pressed_no_signal(false)
		button4.set_pressed_no_signal(false)
		button5.set_pressed_no_signal(false)
		exclude.set_pressed_no_signal(true)

func _on_button_pressed() -> void:
	selected = water_tower
	reset_button(button1)

func _on_button_2_pressed() -> void:
	selected = fire_tower
	reset_button(button2)

func _on_button_3_pressed() -> void:
	selected = electric_tower
	reset_button(button3)

func _on_button_4_pressed() -> void:
	selected = root_tower
	reset_button(button4)

func _on_button_5_pressed() -> void:
	selected = bleed_tower
	reset_button(button5)
