extends Control

onready var animations = $"animations"


func start_bar():
    self.animations.play("tick")
    
func update_avr(value):
    $"center/attention/average".set_text(str(value) + "%")
