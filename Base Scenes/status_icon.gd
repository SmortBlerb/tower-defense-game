extends Node
class_name StatusIcon

var texture : Texture2D
var status : Statuses.StatusEnums

func _init(t : Texture2D, s : Statuses.StatusEnums):
	texture = t
	status = s

func get_texture() -> Texture2D:
	return texture
	
func get_type() -> Statuses.StatusEnums:
	return status
