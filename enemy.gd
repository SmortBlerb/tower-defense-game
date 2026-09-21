extends Node2D

@export var max_health := 20.0
var health = max_health
var damage_amp := 1.0

var statuses = []
# None, Wet ... Hemmorhage
var status_res = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
@export var default_status_time = 120.0
var bloodflame_damage = 25.0

@onready var remote_transform = $"RemoteTransform2D"
@onready var health_text = $"RichTextLabel"

@onready var chain_radius = $"Lightning Chain Radius"

var tick = 0

@onready var animator = $"Sprite2D/AnimationPlayer"

@onready var pathwalk = $".."

@onready var icon_container = $"Control/HBoxContainer"
var status_icons = []
var bleed_icon
var fire_icon
var lightning_icon
var oil_icon
var rooted_icon
var water_icon
var bloodflame_icon
var inferno_icon
var overgrown_icon

func _ready() -> void:
	remote_transform.remote_path = "../.."
	animator.play("Walk")
	
	bleed_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Bleed Status.png"), Statuses.StatusEnums.Bleed)
	
	fire_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Fire Status.png"), Statuses.StatusEnums.Fire)
	
	lightning_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Lightning Status.png"), Statuses.StatusEnums.Electrified)
	
	oil_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Oil Status.png"), Statuses.StatusEnums.Oil)
	
	rooted_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Rooted Status.png"), Statuses.StatusEnums.Rooted)
	
	water_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Water Status.png"), Statuses.StatusEnums.Wet)
	
	bloodflame_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Bloodflame Status.png"), Statuses.StatusEnums.Bloodflame)
	
	inferno_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Inferno Status.png"), Statuses.StatusEnums.Inferno)
	
	overgrown_icon = StatusIcon.new(preload("res://Base Scenes/Status Icons/Overgrown Status.png"), Statuses.StatusEnums.Overgrown)

func _physics_process(_delta: float) -> void:
	position = remote_transform.position
	
	if health <= 0:
		queue_free()
	
	tick += 1
	update_statuses()
	update_status_icons()
	
	for i in statuses:
		i.tick()
	
	health_text.text = str(health)

func damage(amount: float, type: Status.StatusEnums = Statuses.StatusEnums.None, stagger: float = 0, time: float = default_status_time):
	health -= amount * damage_amp * status_res[type]
	if type != Statuses.StatusEnums.None:
		inflict_status(type, time)
	if stagger > 0:
		pathwalk.stagger(stagger)

func inflict_status(type: Status.StatusEnums, time: float = default_status_time):
	if statuses.is_empty():
		var add = Statuses.new(type, time)
		statuses.append(add)
		add.timeout.connect(remove_status.bind(type))
	
	var has_status = false
	for i in statuses:
		if i.get_type() == type:
			has_status = true
			i.add_time(10)
			break
	if has_status == false:
		var add = Statuses.new(type, time)
		statuses.append(add)
		add.timeout.connect(remove_status.bind(type))
	
	# Wet
	status_combo(type, Status.StatusEnums.Wet, Status.StatusEnums.Fire, Statuses.new(Statuses.StatusEnums.Wet, time))
	status_combo(type, Status.StatusEnums.Wet, Status.StatusEnums.Oil, Statuses.new(Statuses.StatusEnums.Wet, time))
	status_combo(type, Status.StatusEnums.Wet, Status.StatusEnums.Electrified, Statuses.new(Statuses.StatusEnums.ChainElec, time))
	status_combo(type, Status.StatusEnums.Wet, Status.StatusEnums.Rooted, Statuses.new(Statuses.StatusEnums.Overgrown, time))
	
	# Fire
	status_combo(type, Status.StatusEnums.Fire, Status.StatusEnums.Oil, Statuses.new(Statuses.StatusEnums.Inferno, time))
	status_combo(type, Status.StatusEnums.Fire, Status.StatusEnums.Rooted, Statuses.new(Statuses.StatusEnums.Fire, time))
	status_combo(type, Status.StatusEnums.Fire, Status.StatusEnums.Bleed, Statuses.new(Statuses.StatusEnums.Bloodflame, time))
	
	# Electrified
	status_combo(type, Status.StatusEnums.Electrified, Status.StatusEnums.Rooted, Statuses.new(Statuses.StatusEnums.Ionized, time))
	status_combo(type, Status.StatusEnums.Electrified, Status.StatusEnums.Oil, Statuses.new(Statuses.StatusEnums.Combustion, time))
	
	# Rooted
	status_combo(type, Status.StatusEnums.Rooted, Status.StatusEnums.Bleed, Statuses.new(Statuses.StatusEnums.Hemorrhage, time))


func status_combo(given_type: Status.StatusEnums, type1: Status.StatusEnums, type2: Status.StatusEnums, result: Status):
	if given_type == type1:
		for i in statuses:
			if i.get_type() == type2:
				remove_status(i.get_type())
				remove_status(given_type)
				if result != null:
					var add = result
					statuses.append(add)
					add.timeout.connect(remove_status.bind(result.get_type()))
	elif given_type == type2:
		for i in statuses:
			if i.get_type() == type1:
				remove_status(i.get_type())
				remove_status(given_type)
				if result != null:
					var add = result
					statuses.append(add)
					add.timeout.connect(remove_status.bind(result.get_type()))
					
func search_status(type: Status.StatusEnums):
	if statuses.is_empty():
			return -1
	for i in statuses.size():
		if statuses[i].get_type() == type:
			return i
	return -1
	
func search_icons(icon : StatusIcon):
	if icon_container.get_child_count() == 0:
		return -1
	for i in icon_container.get_child_count():
		if icon_container.get_child(i).texture == icon.get_texture():
			return i
	return -1

func remove_status(type: Statuses.StatusEnums):
	statuses.remove_at(search_status(type))
	for icon in status_icons:
		if icon.get_type() == type:
			icon_container.get_child(search_icons(icon)).queue_free()
			status_icons.erase(icon)
	if type == Statuses.StatusEnums.Ionized:
		damage_amp = 1.0

func update_statuses():
	if search_status(Statuses.StatusEnums.Combustion) >= 0:
		damage(20.0 * status_res[Statuses.StatusEnums.Combustion])
		remove_status(Statuses.StatusEnums.Combustion)
	if search_status(Statuses.StatusEnums.Hemorrhage) >= 0:
		damage((max_health / 5) * status_res[Statuses.StatusEnums.Hemorrhage], Statuses.StatusEnums.None, 5)
		remove_status(Statuses.StatusEnums.Hemorrhage)
	if search_status(Statuses.StatusEnums.ChainElec) >= 0:
		damage(5.0 * status_res[Statuses.StatusEnums.Electrified], Statuses.StatusEnums.None, 5)
		for e in chain_radius.get_overlapping_bodies():
			if e != self && e.search_status(Statuses.StatusEnums.Wet) >= 0:
				e.damage(0, Statuses.StatusEnums.Electrified)
		remove_status(Statuses.StatusEnums.ChainElec)

	if tick == 20:
		if search_status(Statuses.StatusEnums.Oil) >= 0:
			pathwalk.slow(0.8)
		if search_status(Statuses.StatusEnums.Rooted) >= 0:
			damage(1.0 * status_res[Statuses.StatusEnums.Rooted])
			pathwalk.slow(0.5)
		if search_status(Statuses.StatusEnums.Electrified) >= 0:
			damage(1.0 * status_res[Statuses.StatusEnums.Electrified], Statuses.StatusEnums.None, 5)
		if search_status(Statuses.StatusEnums.Bleed) >= 0:
			damage(2.0 * status_res[Statuses.StatusEnums.Bleed])
		if search_status(Statuses.StatusEnums.Fire) >= 0:
			damage(3.0 * status_res[Statuses.StatusEnums.Fire])
		if search_status(Statuses.StatusEnums.Overgrown) >= 0:
			damage(5.0 * status_res[Statuses.StatusEnums.Overgrown])
			pathwalk.slow(0.25)
		if search_status(Statuses.StatusEnums.Inferno) >= 0:
			damage(10.0 * status_res[Statuses.StatusEnums.Inferno])
		if search_status(Statuses.StatusEnums.Bloodflame) >= 0:
			damage(bloodflame_damage * status_res[Statuses.StatusEnums.Bloodflame])
			bloodflame_damage -= 2.0
			if bloodflame_damage <= 5:
				bloodflame_damage = 5
		if search_status(Statuses.StatusEnums.Ionized) >= 0:
			pathwalk.slow(1.2)
			damage_amp = 1.5
		tick = 0

func update_status_icons():
	if search_status(Statuses.StatusEnums.Bleed) >= 0 && search_icons(bleed_icon) == -1:
		add_status_icon(bleed_icon)
	if search_status(Statuses.StatusEnums.Fire) >= 0 && search_icons(fire_icon) == -1:
		add_status_icon(fire_icon)
	if search_status(Statuses.StatusEnums.Electrified) >= 0 && search_icons(lightning_icon) == -1:
		add_status_icon(lightning_icon)
	if search_status(Statuses.StatusEnums.Oil) >= 0 && search_icons(oil_icon) == -1:
		add_status_icon(oil_icon)
	if search_status(Statuses.StatusEnums.Rooted) >= 0 && search_icons(rooted_icon) == -1:
		add_status_icon(rooted_icon)
	if search_status(Statuses.StatusEnums.Wet) >= 0 && search_icons(water_icon) == -1:
		add_status_icon(water_icon)
	if search_status(Statuses.StatusEnums.Bloodflame) >= 0 && search_icons(bloodflame_icon) == -1:
		add_status_icon(bloodflame_icon)
	if search_status(Statuses.StatusEnums.Inferno) >= 0 && search_icons(inferno_icon) == -1:
		add_status_icon(inferno_icon)
	if search_status(Statuses.StatusEnums.Overgrown) >= 0 && search_icons(overgrown_icon) == -1:
		add_status_icon(overgrown_icon)
	
func add_status_icon(icon : StatusIcon):
	var add = TextureRect.new()
	add.texture = icon.get_texture()
	add.stretch_mode = 3
	status_icons.append(icon)
	icon_container.add_child(add)
