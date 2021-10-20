
var map

func _init(map_scene):
    self.map = map_scene

func save_map_file(_filename):
    #MapManager.save_map_to_file(filename, self.map.model.get_dict())
    return

func load_map_file(_filename):
    #var content = MapManager.get_map_data(filename)
    #if content.empty():
    #    return

    #self.fill_map_from_data(content)
    return

func fill_map_from_data(content):
    self.map.builder.wipe_map()
    self.map.builder.fill_map_from_data(content)
