extends Spatial

onready var audio = $"/root/SimpleAudioLibrary"

func _ready():
	self.audio.track("menu")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

	if event is InputEventMouseButton and event.pressed:
		return self.get_tree().change_scene("res://scenes/screens/HowTo.tscn")

	if event is InputEventJoypadButton and event.pressed:
		return self.get_tree().change_scene("res://scenes/screens/HowTo.tscn")

	if event is InputEventKey:
		return self.get_tree().change_scene("res://scenesscreens//HowTo.tscn")
