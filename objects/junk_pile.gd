extends Area2D

var cruft_count=5
var clear_progress = 0

var cleaning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#we are going to add cruft sprites to the pile
	var gfx_container = self.find_child("CruftGFXContainer")
	var picked = []
	
	#create cruft gfx
	for i in range(cruft_count):
		var sprite = Sprite2D.new()
		#randomly pick a cruft image
		sprite.set_texture(Global.cruft[ randi_range(0, Global.cruft.size()-1) ])
		
		#place sprites inside the junkpile collision triangle
		while true:
			var vec = sprite.position + Vector2( randi_range(5,20) * [-1,1][randi_range(0,1)] , 
												 randi_range(5,20) * [-1,1][randi_range(0,1)] )
			#trying to make sure we don't have too much overlap
			if not vec in picked:
				sprite.position = vec
				picked.append(vec)
				break 
		
		#add sprite to our junkpile
		gfx_container.add_child(sprite)


# Called when events happen
func _input_event(_rid, event, _si):
	
	if event.is_action_pressed("cleaning"):
		self.cleaning = true
		Global.animate_cursor = true
		Global.next_dig.set_paused(false)
	elif event.is_action_released("cleaning"):
		self.cleaning = false
		Global.animate_cursor = false
		Global.next_dig.set_paused(true)
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_IBEAM)

func _mouse_enter():
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_IBEAM)

func _mouse_exit():
	self.cleaning = false
	Global.animate_cursor = false
	Global.next_dig.set_paused(true)
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if self.cleaning:	
		self.clear_progress += delta * Player.clearing_speed
		
		var difference = cruft_count - self.find_child("CruftGFXContainer").get_children().size() 
		var increment = 100/floor(cruft_count)
		
		if clear_progress >= 100+increment:
			Player.award_resource()
			Player.award_resource()
			Player.award_resource()
			
			self._mouse_exit()
			queue_free()
		
		elif clear_progress > increment+difference*increment :
			var cruft = self.find_child("CruftGFXContainer").get_children()
			cruft[randi_range(0, cruft.size()-1)].queue_free()
			
			Player.award_resource()
			
