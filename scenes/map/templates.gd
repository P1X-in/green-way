
const DUMMY_GROUND = "dummy_ground"

var templates = {
    self.DUMMY_GROUND : preload("res://scenes/tiles/base_ground.tscn"),
}


func get_template(template):
    if template == null:
        return null

    var new_tile = self.templates[template].instance()
    new_tile.template_name = template

    return new_tile

