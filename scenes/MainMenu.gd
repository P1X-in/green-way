extends Spatial

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")

    if event is InputEventJoypadButton and event.pressed:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")

    if event is InputEventKey:
        return self.get_tree().change_scene("res://scenes/board/board.tscn")
