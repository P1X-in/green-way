extends Spatial

onready var map = $"map"

onready var audio = $"/root/SimpleAudioLibrary"
onready var score_container = $"/root/Score"
#onready var switcher = $"/root/SceneSwitcher"
#onready var match_setup = $"/root/MatchSetup"
onready var ui = $"ui"

var loop = preload("res://scenes/board/logic/loop.gd").new()
var paths = preload("res://scenes/board/logic/paths.gd").new(self)
var dispatcher = preload("res://scenes/board/logic/dispatcher.gd").new(self)

var selected_tile = null
var last_hover_tile = null
var mouse_click_position = null

var tiles_available = 5
var score = 0
var loops_to_complete = 50
var latest_house = null
var latest_industrial = null

func _ready():
    self.set_up_map()
    self.set_up_board()
    
    # REFACTOR ME PLEASE
    var rand_str = str(1 + randi()%4)
    self.audio.track("game"+rand_str)
    $"ui/bottom/horizontal/vertical/msg".text = "~ Road "+rand_str+" Chill ~"
    $"ui/bottom/horizontal/vertical/submsg".text = "Tune by Komiku"
    $"ui/bottom/horizontal/vertical/AnimationPlayer".play("show")
    # THANKS
    
    self.loop.start(self)

func _input(event):
    if event.is_action_pressed("mouse_click"):
        self.mouse_click_position = event.position
    if event.is_action_released("mouse_click"):
        if self.mouse_click_position != null and event.position.distance_squared_to(self.mouse_click_position) < self.map.camera.MOUSE_MOVE_THRESHOLD:
            self.select_tile(self.map.tile_box_position)
        self.mouse_click_position = null

    if event.is_action_pressed("ui_accept"):
        self.select_tile(self.map.tile_box_position)
        self.audio.play("menu_click")
    if event.is_action_pressed("ui_cancel"):
        self.clear_road(self.map.tile_box_position)

    if event.is_action_pressed("end_turn") and self.latest_house != null:
        self.map.move_camera_to_position(self.latest_house.position)
    if event.is_action_pressed("editor_clear") and self.latest_industrial != null:
        self.map.move_camera_to_position(self.latest_industrial.position)

    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

func _physics_process(_delta):
    self.hover_tile()
    self.dispatcher.process_dispatch()
    self._update_count()

    if self.loop.loop_count >= self.loops_to_complete:
        self.loop.stopped = true
        self.map.mouse_layer.detach()
        self.score_container.score = self.score
        return self.get_tree().change_scene("res://scenes/screens/Win.tscn")

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
    self._place_random_terrain()

func set_up_board():
    return

func select_tile(position):
    if self.map.camera.camera_in_transit or self.map.camera.script_operated:
        return

    var tile = self.map.model.get_tile(position)

    if tile.has_content():
        self.audio.play("click")
    else:
        if self.tiles_available > 0:
            self.audio.play("build_road")
            self.place_road(position)

    self.selected_tile = tile
    self.update_tile_highlight(tile)


func unselect_tile():
    self.selected_tile = null


func update_tile_highlight(_tile):
    return

func end_game(_winner):
    self.map.camera.paused = true

func place_road(position):
    var tile = self.map.model.get_tile(position)

    if tile.ground.is_present():
        return

    self.map.builder.place_ground(position, self.map.templates.ROAD_STRAIGHT, 0)

    self.replace_road_tile(tile)
    self.fix_neighbouring_roads(tile)

    self.paths.refresh_all_industrial_paths()
    self.tiles_available -= 1

func fix_neighbouring_roads(tile):
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
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 0)
        1:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 0)
        2:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 0)
        3:
            self.map.builder.place_ground(tile.position, self.map.templates.ROAD_STRAIGHT, 0)
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

    #if neighbour.has_content():
    #    return value

    if neighbour.ground.is_present():
        return value

    return 0

func clear_road(position):
    var tile = self.map.model.get_tile(position)

    if tile.ground.is_present():
        tile.ground.clear()
        self.audio.play("destroy_road")
        self.fix_neighbouring_roads(tile)
        self.paths.refresh_all_industrial_paths()
        self.dispatcher.recall_trucks(tile)
        self.tiles_available += 1
    else:
        self.audio.play("click")




func _place_random_terrain():
    var tile = null
    for _i in range(20):
        tile = null

        while tile == null:
            tile = self.map.model.get_random_tile()

            if tile.terrain.is_present():
                tile = null

        self._place_random_terrain_tile(tile)

    for _i in range(80):
        tile = null

        while tile == null:
            tile = self.map.model.get_random_tile()

            if tile.terrain.is_present():
                tile = null
            elif not tile.has_neighbouring_terrain():
                tile = null

        self._place_random_terrain_tile(tile)

    for i in self.map.model.tiles.values():
        if i.is_cut_off_with_terrain():
            self._place_random_terrain_tile(i)


func _place_random_terrain_tile(tile):
    var templates = [
        self.map.templates.TERRAIN_ALPS,
        self.map.templates.TERRAIN_FOREST_1,
        self.map.templates.TERRAIN_FOREST_2,
        self.map.templates.TERRAIN_FOREST_3,
    ]
    var rotations = [0, 90, 180, 270]

    var template = templates[randi() % templates.size()]
    var rotation = rotations[randi() % rotations.size()]

    self.map.builder.place_terrain(tile.position, template, rotation)

func _update_count():
    $"ui/left/tiles/count".set_text(str(self.tiles_available))
    self._update_waiting_thrash()
    $"ui/right/score/count".set_text(str(self.score))

func _update_waiting_thrash():
    var count = 0
    var house_tiles = self.map.model.get_house_building_tiles()

    for house_tile in house_tiles:
        if house_tile.building.tile.has_thrash:
            count += 1

    $"ui/center/attention/count".set_text(str(count))
