extends Node2D

var fly_away = false

func _ready():
	find_child("FireExaust").set_autoplay("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fly_away:
		find_child("FireExaust").set_visible(true)
		#TODO ramp this up instead of linearly speeding up
		self.position.y -= (400 - self.position.y) * delta  
		#self.position.y -= (self.position.y / (1+  * (1-self.position.y)) ) * delta
		#self.position.y -=  -pow(self.position.y, 2) * delta
		
		#Stop following the rocket after it launches for a bit
		if self.position.y >= -400:
			var camera = self.get_parent().find_child("Camera")
			camera.position = Vector2(self.position)
			
		if self.position.y <= -1000:
			queue_free()
