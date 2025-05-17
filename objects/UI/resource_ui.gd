extends PanelContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Update UI
	for resource in Player.resources.keys():
		find_child(resource+"Counter").text = str(Player.resources[resource])
	
