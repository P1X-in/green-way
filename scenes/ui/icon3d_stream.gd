extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    var img =  $"../Icon3D/Camera".get_viewport().get_texture().get_data()
    var tex = ImageTexture.new()
    tex.create_from_image(img)
    self.texture = tex


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
