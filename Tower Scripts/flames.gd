extends Area2D

# Remember: Redo flames to match pixel scaling
@export var lifespan := 60
@export var inflict_status = Status.StatusEnums.Fire
@export var target : Node

func _physics_process(_delta: float) -> void:
	lifespan -= 1
	if lifespan <= 0:
		queue_free()
	
	for e in get_overlapping_bodies():
		if lifespan % 30 == 0:
			e.damage(2, inflict_status)

func set_status(type: Status.StatusEnums):
	inflict_status = type
