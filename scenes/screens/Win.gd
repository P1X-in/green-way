extends Spatial

onready var score_container = $"/root/Score"

func _ready():
    var score = str(self.score_container.score)
    $"Panel/vbox/hbox/score".set_text(score.pad_zeros(7))   

func _input(event):
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

    if event is InputEventMouseButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/screens/MainMenu.tscn")

    if event is InputEventJoypadButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/screens/MainMenu.tscn")

    if event is InputEventKey and event.pressed and not event.echo:
        return self.get_tree().change_scene("res://scenes/screens/MainMenu.tscn")
