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
        'tiles' : {
            "18_18" : {
                "ground": {
                    "rotation" : 0,
                    "tile" : "road_straight"
                }
            }
        }
    }

    self.map.loader.fill_map_from_data(content)

func set_up_board():
    #self.audio.track("soundtrack_1")
    return

func select_tile(position):
    if self.map.camera.camera_in_transit or self.map.camera.script_operated:
        return

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
