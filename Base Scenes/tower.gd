extends Node2D

@export var radius := 100.0
@export var fire_rate := 40
var tick = fire_rate

var enemies_in_range := []
var target

@onready var shoot_area
@onready var sprite

@onready var projectile = preload("res://Base Scenes/projectile.tscn")
@export var inflict_status = Status.StatusEnums.Wet
var damage = 1

@onready var tower_area
var mouse_hovering : bool = false
signal select
var upgrade_left_progress = 0
var upgrade_right_progress = 0
var upgrade_left_names = ["???", "???", "???", "???", "MAX"]
var upgrade_right_names = ["???", "???", "???", "???", "MAX"]
var special_active = false

func _process(_delta: float) -> void:
	if mouse_hovering && Input.is_action_just_pressed("mouse_press"):
		select.emit()

func shoot(enemy: Object):
	var inst = projectile.instantiate()
	inst.position = Vector2(0, 0)
	inst.set_status(inflict_status)
	inst.set_damage(damage)
	inst.look_at(enemy.position * -1)
	add_child(inst)

func upgrade(_path : int):
	pass # Here to prevent errors

func special():
	pass # Same as above
