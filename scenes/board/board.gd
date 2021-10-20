extends Spatial

onready var map = $"map"

#onready var audio = $"/root/SimpleAudioLibrary"
#onready var switcher = $"/root/SceneSwitcher"
#onready var match_setup = $"/root/MatchSetup"

var selected_tile = null
var last_hover_tile = null
var mouse_click_position = null

func _ready():
    self.set_up_map()
    self.set_up_board()

func _input(event):
    if event.is_action_pressed("mouse_click"):
        self.mouse_click_position = event.position
    if event.is_action_released("mouse_click"):
        if self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD:
            self.select_tile(self.map.tile_box_position)
        self.mouse_click_position = null

func _physics_process(_delta):
    self.hover_tile()

func hover_tile():
    var tile = self.map.model.get_tile(self.map.tile_box_position)

    if tile != self.last_hover_tile:
        self.last_hover_tile = tile

        self.update_tile_highlight(tile)


func set_up_map():
    var content = {
        'tiles' : {}
    }

    self.map.loader.fill_map_from_data(content)

func set_up_board():
    #self.audio.track("soundtrack_1")
    return

func select_tile(position):
    if self.map.camera.camera_in_transit or self.map.camera.script_operated:
        return

    self.place_road(position)

    var tile = self.map.model.get_tile(position)

    self.selected_tile = tile


    self.update_tile_highlight(tile)

    if self.selected_tile != null:
        #self.audio.play("menu_click")
        pass


func unselect_tile():
    self.selected_tile = null


func update_tile_highlight(tile):
    return

func end_game(winner):
    self.map.camera.paused = true

func place_road(position):
    self.map.builder.place_ground(position, self.map.templates.ROAD_STRAIGHT, 0)

    var tile = self.map.model.get_tile(position)

    self.replace_road_tile(tile)
    for neighbour in tile.neighbours.values():
        self.replace_road_tile(neighbour)

func replace_road_tile(tile):
    if not tile.ground.is_present():
        return

    var mask = 0

    mask += self.should_connect_neighbour(tile, "n", 1)
    mask += self.should_connect_neighbour(tile, "s", 2)
    mask += self.should_connect_neighbour(tile, "e", 4)
    mask += self.should_connect_neighbour(tile, "w", 8)

    match mask:
        0:
            return
        1:
            return
        2:
            return
        3:
            return
        4:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 90)
        5:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_BEND, 180)
        6:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_BEND, 90)
        7:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_T, 180)
        8:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 90)
        9:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_BEND, 270)
        10:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_BEND, 0)
        11:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_T, 0)
        12:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 90)
        13:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_T, 270)
        14:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_T, 90)
        15:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_CROSS, 0)


func should_connect_neighbour(tile, neighbour_key, value):
    var neighbour = tile.get_neighbour(neighbour_key)

    if neighbour == null:
        return 0

    if neighbour.ground.is_present():
        return value

    return 0

