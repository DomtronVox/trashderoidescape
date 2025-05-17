extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("toggled", self.music_toggle)
	self.set_pressed(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func music_toggle(toggled_on):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
