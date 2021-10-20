
const CLASS_GROUND = "ground"
const CLASS_FRAME = "frame"
const CLASS_DECORATION = "decoration"
const CLASS_TERRAIN = "terrain"
const CLASS_BUILDING = "building"

var map

var editor = null


func _init(map_scene):
    self.map = map_scene


func place_ground(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if tile.ground.is_present():
        tile.ground.clear()

    self.place_element(position, name, rotation, 0, self.map.tiles_ground_anchor, tile.ground)

func place_frame(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if not tile.ground.is_present():
        return

    if tile.frame.is_present():
        tile.frame.clear()

    self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_frames_anchor, tile.frame)

func place_decoration(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if tile.decoration.is_present():
        tile.decoration.clear()
    if tile.terrain.is_present():
        tile.terrain.clear()
    if tile.building.is_present():
        tile.building.clear()

    self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_terrain_anchor, tile.decoration)

func place_terrain(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if tile.decoration.is_present():
        tile.decoration.clear()
    if tile.terrain.is_present():
        tile.terrain.clear()
    if tile.building.is_present():
        tile.building.clear()

    self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_terrain_anchor, tile.terrain)

func place_building(position, name, rotation):
    var tile = self.map.model.get_tile(position)

    if tile.decoration.is_present():
        tile.decoration.clear()
    if tile.terrain.is_present():
        tile.terrain.clear()
    if tile.building.is_present():
        tile.building.clear()

    self.place_element(position, name, rotation, self.map.GROUND_HEIGHT, self.map.tiles_buildings_anchor, tile.building)


func place_element(position, name, rotation, vertical_offset, anchor, tile_fragment):
    var new_tile = self.map.templates.get_template(name)
    var world_position = self.map.map_to_world(position)

    anchor.add_child(new_tile)
    world_position.y = vertical_offset
    new_tile.set_translation(world_position)
    new_tile.set_rotation(Vector3(0, deg2rad(rotation), 0))
    new_tile.current_rotation = rotation

    tile_fragment.set_tile(new_tile)

    return new_tile

func clear_tile_layer(position):
    var tile = self.map.model.get_tile(position)

    if tile.building.is_present():
        tile.building.clear()
    elif tile.terrain.is_present():
        tile.terrain.clear()
    elif tile.decoration.is_present():
        tile.decoration.clear()
    elif tile.frame.is_present():
        tile.frame.clear()
    elif tile.ground.is_present():
        tile.ground.clear()

func wipe_tile(position):
    var tile = self.map.model.get_tile(position)

    tile.wipe()

func wipe_map():
    for tile_id in self.map.model.tiles.keys():
        self.map.model.tiles[tile_id].wipe()

func fill_map_from_data(data):
    var tiles_data = data["tiles"]

    self.attach_mouse_layer()

    for tile_id in self.map.model.tiles.keys():
        if tiles_data.has(tile_id):
            self.place_tile(tile_id, tiles_data[tile_id])

func attach_mouse_layer():
    var ground_point
    var tile

    self.map.mouse_layer.initialize(self.map.model.SIZE, self.map.TILE_SIZE)
    self.map.tiles_ground_anchor.add_child(self.map.mouse_layer.mouse_layer)
    for key in self.map.mouse_layer.ground_points.keys():
        ground_point = self.map.mouse_layer.ground_points[key]
        tile = self.map.model.tiles[key]
        ground_point.bind_ground_for_mouse(self.map, tile.position)


func place_tile(tile_id, tile_data):
    var tile = self.map.model.tiles[tile_id]

    if tile_data.has("ground") and tile_data["ground"]["tile"] != null:
        self.place_ground(tile.position, tile_data["ground"]["tile"], tile_data["ground"]["rotation"])

    if tile_data.has("frame") and tile_data["frame"]["tile"] != null:
        self.place_frame(tile.position, tile_data["frame"]["tile"], tile_data["frame"]["rotation"])

    if tile_data.has("decoration") and tile_data["decoration"]["tile"] != null:
        self.place_decoration(tile.position, tile_data["decoration"]["tile"], tile_data["decoration"]["rotation"])

    if tile_data.has("terrain") and tile_data["terrain"]["tile"] != null:
        self.place_terrain(tile.position, tile_data["terrain"]["tile"], tile_data["terrain"]["rotation"])

    if tile_data.has("building") and tile_data["building"]["tile"] != null:
        self.place_building(tile.position, tile_data["building"]["tile"], tile_data["building"]["rotation"])
