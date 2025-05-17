extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_child("UpgradeButton").gui_input.connect(self.upgrade)
	self.update_uis()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Player.valid_resources():
		find_child("UpgradeButton").disabled = false
	else:
		find_child("UpgradeButton").disabled = true

#Trigger an upgrade, if enough resources we deduct the cost and do the upgrade
func upgrade(event: InputEvent):
	if not (event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		return
	
	if Player.valid_resources():
		Player.deduct_resources()
		Player.current_upgrade += 1
		self.update_uis()
		find_child("SucceedUpgradeSound").play()
		
	else:
		find_child("FailedUpgradeSound").play()

#Update the upgrade UI with (suposedly) new info after an upgrade
func update_uis():
	
	#if we have passed the last upgrade, clean stuff up and start the end animation
	if Global.upgrades.size()-1 < Player.current_upgrade:
		queue_free()
		
		#End animation
		get_tree().get_current_scene().find_child("Rocket").fly_away = true
		
		return
	
	var upgrade_data = Global.upgrades[Player.current_upgrade]
	
	self.find_child("Description").set_text(upgrade_data["description"])
	
	var resource_text = ""
	for resource in Player.resources.keys():
		resource_text += "[img=30%%]res://assets/items/%s.png[/img]" % resource
		resource_text += " %s, " % upgrade_data[resource]
	
	self.find_child("UpgradeResources").set_text(resource_text)
	
	self.find_child("UpgradeButton").set_text(upgrade_data["button_text"])
	
	#update rocket sprite
	# TODO Kinda jank how the current upgrade rocket stage needs to have one taken off to set current rocket stage
	get_tree().get_current_scene().find_child("RocketSprite").frame = upgrade_data["rocket_stage"]-1
	
