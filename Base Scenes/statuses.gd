extends Node
class_name Statuses

var status
var time

signal timeout 

enum StatusEnums {
	None,
	Wet,
	Fire,
	Oil,
	Electrified,
	ChainElec,
	Rooted,
	Bleed,
	Inferno,
	Combustion,
	Overgrown,
	Bloodflame,
	Ionized,
	Hemorrhage
}	

func _init(type: Status.StatusEnums = Status.StatusEnums.None, t_time: float = 5.0) -> void:
	status = type
	time = t_time

func tick():
	time -= 1
	if time <= 0:
		timeout.emit()

func get_type():
	return status

func add_time(amount: float):
	time += amount
