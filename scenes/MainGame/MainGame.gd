extends Node


func _enter_tree():
	_start_init_level( $World/Level/WorldPlanet )

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Menu.visible = false
	
	loading.connect("scene_loading", self, "_on_scene_loading")
	loading.connect("scene_load_progress", self, "_on_scene_load_progress")
	loading.connect("scene_loaded", self, "_on_scene_loaded")
	
	_end_init_level( $World/Level/WorldPlanet )
	
	var ui_inventory = $Menu/MarginContainer/TabContainer/Inventory/Inventory
	$World/Player/Inventory.connect("item_added", ui_inventory, "add_item")
	ui_inventory.connect("item_equiped", $World/Player/Inventory, "equip")
	
	$Menu/MarginContainer/TabContainer/Options/Options.enable_savegame = true
	
	var game_loaded = save.load_game()
	
	print("game_loaded: ", game_loaded)
	
	if game_loaded:
		return
	
	#
	# Add default Weapon
	#
	var default_weapon := Item.new()
	default_weapon.type = "gun"
	default_weapon.properties["damage"] = 1.0
	default_weapon.properties["rate"] = 60
	$World/Player.give_item(default_weapon)
	
	#
	# Add default ammo
	# 
	var default_ammo := Item.new()
	default_ammo.type = "ammo"
	default_ammo.properties["ammo_type"] = "normal"
	$World/Player.give_item(default_ammo)
	


func _exit_tree():
	save.save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	
	if Input.is_action_just_pressed("menu"):
		$Menu.visible = !$Menu.visible
	
	if Input.is_action_just_pressed("inventory"):
		if not $Menu.visible:
			$Menu.visible = true
			$Menu/MarginContainer/TabContainer.current_tab = 1
			pass
		elif $Menu/MarginContainer/TabContainer.current_tab != 1:
			$Menu/MarginContainer/TabContainer.current_tab = 1
		else:
			$Menu.visible = false
	
	if Input.is_action_just_pressed("map"):
		if not $Menu.visible:
			$Menu.visible = true
			$Menu/MarginContainer/TabContainer.current_tab = 2
			pass
		elif $Menu/MarginContainer/TabContainer.current_tab != 2:
			$Menu/MarginContainer/TabContainer.current_tab = 2
		else:
			$Menu.visible = false
	


func set_map(map):
	
	$Menu/MarginContainer/TabContainer/Map.add_child(map)
	


func _start_init_level(scene: Node, context: Dictionary = {}):
	print("_init_level")
	scene.player = $World/Player
	scene.camera = $World/Camera
	scene.context = context


func _end_init_level(scene: Node, context: Dictionary = {}):
	for map in $Menu/MarginContainer/TabContainer/Map.get_children():
		map.queue_free()
	
	var map = scene.find_node("Map")
	print("attach map to ui: ", map)
	if map:
		scene.remove_child(map)
		$Menu/MarginContainer/TabContainer/Map.add_child(map)


func _remove_level():
	for child in $World/Level.get_children():
		$World/Level.remove_child(child)


func _on_scene_loading():
	print("on scene loading")
	$Loading.visible = true
	pass


func _on_scene_loaded(scene, context):
	print("_on_scene_loaded")
	_remove_level()
	_start_init_level(scene, context)
	$World/Level.add_child(scene)
	_end_init_level(scene, context)
	$Loading.visible = false


func _on_scene_load_progress(current_stage, stage_count):
	$Loading.set_progress(0, stage_count, current_stage)


func _on_Player_died():
	
	var level = $World/Level.get_child(0)
	
	if level and level.has_method("reset_player"):
		level.reset_player()
	
	pass # Replace with function body.