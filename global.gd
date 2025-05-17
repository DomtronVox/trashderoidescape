extends Node

var cruft: Array[Resource] = []
var cursor_state = false
var animate_cursor = false

var dig_sound = AudioStreamPlayer.new()
var next_dig = Timer.new()

var upgrades = []

func _ready() -> void:
	#setup mouse cursor stuff
	Input.set_custom_mouse_cursor(load("res://assets/items/shovel/shovel.png"), Input.CursorShape.CURSOR_IBEAM, Vector2(20,70) )
	Input.set_custom_mouse_cursor(load("res://assets/items/shovel/shovel-move.png"), Input.CursorShape.CURSOR_POINTING_HAND, Vector2(20,70))
	
	#setup sound for digging
	self.dig_sound.set_stream(load("res://sound/sfx100v2_footstep_02 - digging sound.ogg"))
	self.add_child(self.dig_sound)
	
	#setup timer for sound and cursor animation
	self.next_dig.set_wait_time(1)
	self.next_dig.connect("timeout", self.dig)
	self.next_dig.set_autostart(true)
	self.next_dig.set_paused(true)
	self.add_child(self.next_dig)
	
	#load cruft images into our array
	var dir = DirAccess.open("res://assets/cruft/")
	if dir:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			#we only look at the import files, because when exported, .png and such are moved.
			if not dir.current_is_dir() and file_name.ends_with(".import"):
				#load in the import file so we can get the real asset path
				var conf = ConfigFile.new()
				conf.load("res://assets/cruft/"+file_name)
				
				cruft.append(ResourceLoader.load(conf.get_value("remap", "path")))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
	#Load and process upgrade data
	var upgrade_data = ConfigFile.new()
	var err = upgrade_data.load("res://data/upgrades.ini")

	## If the file didn't load, exit
	if err != OK:
		printerr("Major error loading upgrades.ini file. Quitting! errcode: " + str(err) )
		get_tree().quit()
	
	for section in upgrade_data.get_sections():
		upgrades.append({
			"description" : upgrade_data.get_value(section, "description"),
			"fasteners"   : upgrade_data.get_value(section, "fasteners"),
			"copper"      : upgrade_data.get_value(section, "copper"),
			"steel"       : upgrade_data.get_value(section, "steel"),
			"rocket_stage" : upgrade_data.get_value(section, "rocket_stage"),
			"button_text"  : upgrade_data.get_value(section, "button_text"),
		})


func _process(_delta: float):
	if self.animate_cursor:
		#Input.set_custom_mouse_cursor(cursor_ani.get_frame_texture(cursor_ani.get_current_frame()), Input.CursorShape.CURSOR_POINTING_HAND, Vector2(20,70))
		
		#self.next_dig.set_paused(false)
		pass
	else:
		#self.next_dig.set_paused(true)
		pass
		
func dig():
	if self.cursor_state:
		self.cursor_state = false
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_IBEAM)
	else:
		self.cursor_state = true
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
		self.dig_sound.play()
	
	
