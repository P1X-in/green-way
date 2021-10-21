extends Spatial

func _input(event):
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

    if event is InputEventMouseButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")

    if event is InputEventJoypadButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")

    if event is InputEventKey:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")
