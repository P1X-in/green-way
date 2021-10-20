extends Spatial

export var template_name = ""

export var unit_vertical_offset = 0

var current_rotation = 0

func get_dict():
	var rotation = self.get_rotation_degrees()

	return {
		"tile" : self.template_name,
		"rotation" : rotation.y,
	}
