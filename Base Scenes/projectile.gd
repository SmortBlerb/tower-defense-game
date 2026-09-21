extends Node2D

@export var speed := 30.0
@export var inflict_status = Status.StatusEnums.Wet
var splash = false
var damage = 1

func _physics_process(_delta: float) -> void:
	position += transform.x * speed

func set_status(type: Status.StatusEnums):
	inflict_status = type
	
func set_damage(dmg: int):
	damage = dmg
	
func splash_active():
	splash = true
	
func _on_body_entered(body: Node2D) -> void:
	body.damage(damage, inflict_status)
	if splash == true:
		pass # need to make splash thing
	queue_free()
