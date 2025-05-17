extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.find_child("PlayButton").connect("pressed", self.play_game)
	self.find_child("StoryButton").connect("pressed", self.story)
	self.find_child("CreditsButton").connect("pressed", self.credits)
	self.find_child("QuitButton").connect("pressed", self.quit_game)

func play_game():
	get_tree().change_scene_to_file("res://world.tscn")

func story():
	var box1 = find_child("StoryBox")
	var box2 = find_child("CreditBox")
	box1.visible = not box1.visible
	box2.visible = false

func credits():
	var box1 = find_child("CreditBox")
	var box2 = find_child("StoryBox")
	box1.visible = not box1.visible
	box2.visible = false

func quit_game():
	get_tree().quit()
