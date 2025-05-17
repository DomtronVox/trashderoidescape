extends Node2D

var junkpile_count = 8
var junkpile = preload("res://objects/junk_pile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn junkpiles
	for i in range(junkpile_count):
		self.spawn_junkpile()
	
	#Start rocket crash animation.
	#TODO
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	#spawn new junkpiles
	if self.find_child("JunkPiles").get_children().size() < junkpile_count:
		self.spawn_junkpile()


func spawn_junkpile():
	var junkpile_n = junkpile.instantiate()
	var angle = randi_range(0,2*PI)
	var distance = randi_range(80, 200)
	junkpile_n.position = Vector2( distance * cos(angle)  , 
								   distance * sin(angle)  )
	self.find_child("JunkPiles").add_child(junkpile_n)
	
