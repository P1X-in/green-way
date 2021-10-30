extends Spatial

var board

var type
var target = null
var path = []
var directions = []
var return_directions = []

var has_thrash = false
var current_path_index = 0
var end_condition = 2

var base = null

onready var animations = $"animations"
onready var audio = $"/root/SimpleAudioLibrary"

onready var sound_bites = {
    "dog_0" : $"dog1",
    "dog_1" : $"dog2",
    "dog_2" : $"dog3",
    "dog_3" : $"dog4",
    "dog_4" : $"dog5",
    "dog_5" : $"dog6",
    "dog_6" : $"dog7",
    "dog_7" : $"dog8",
    "garbage_0" : $"garbage1",
    "garbage_1" : $"garbage2",
    "garbage_2" : $"garbage3",
    "garbage_3" : $"garbage4",
    "garbage_4" : $"garbage5",
    "garbage_5" : $"garbage6",
    "garbage_6" : $"garbage7",
    "garbage_7" : $"garbage8",
    "garbage_8" : $"garbage9",
    "garbage_9" : $"garbage10",
}

var templates = load("res://scenes/map/templates.gd").new()

#func _ready():
#    self.move_to_target()

func is_truck_free():
    return target == null


func set_type(_type):
    self.type = _type
    if _type == self.templates.THRASH_METAL:
        $"mesh_anchor/GarbageTrack_Red".visible = true
    if _type == self.templates.THRASH_PLASTIC:
        $"mesh_anchor/GarbageTrack_Yellow".visible = true
    if _type == self.templates.THRASH_PAPER:
        $"mesh_anchor/GarbageTrack_Blue".visible = true
    if _type == self.templates.THRASH_GLASS:
        $"mesh_anchor/GarbageTrack_Green".visible = true

func dispatch(destination_tile, _path, _directions, _return_directions, _board):
    self.target = destination_tile
    self.path = _path
    self.directions = _directions
    self.return_directions = _return_directions
    self.current_path_index = 0
    self.end_condition = 2
    self.board = _board

func has_key_in_path(key):
    for step in self.path:
        if step == key:
            return true
    return false

func abort():
    if self.has_thrash:
        self.target.building.tile.has_thrash = true

    self.animations.stop()
    $"mesh_anchor".set_translation(Vector3(0, 0, 0))
    self.target.building.tile.assigned_truck = null
    self.has_thrash = false
    self.get_parent().remove_child(self)
    self.target = null

    if self.base != null:
        self.base.return_truck()


func move_to_target():
    self._animate_initial_path_segment()


var unit_rotations = {
    "s" : 180,
    "n" : 0,
    "e" : 270,
    "w" : 90,
}
var unit_translations = {
    "n" : Vector3(0, 0, -8),
    "s" : Vector3(0, 0, 8),
    "e" : Vector3(8, 0, 0),
    "w" : Vector3(-8, 0, 0),
}

func _animate_initial_path_segment():
    var direction = self.directions[self.current_path_index]
    self._move_in_direction(direction)

func _animate_next_path_segment():
    if self.target == null:
        return

    var direction = self.directions[self.current_path_index]
    $"mesh_anchor".set_translation(Vector3(0, 0, 0))
    self.set_translation(self.get_translation() + self.unit_translations[direction])
    self.current_path_index += 1
    direction = self.directions[self.current_path_index]
    self._move_in_direction(direction)

func _move_in_direction(direction):
    self._rotate_unit_to_direction(direction)
    if self.current_path_index < self.directions.size() - self.end_condition:
        self.animations.play("move")
        #self.sfx_effect("move")
    else:
        self.call_deferred("_end_of_path_reached")

func _rotate_unit_to_direction(direction):
    if not self.unit_rotations.has(direction):
        return

    var rotation = self.unit_rotations[direction]
    self.set_rotation(Vector3(0, deg2rad(rotation), 0))

func _end_of_path_reached():
    if not self.has_thrash:
        self.end_condition = 1
        self.animations.play("pickup")
        self._play_garbage_sound()
    else:
        self._come_back()


func _come_back():
    if not self.has_thrash:
        self.target.building.tile.has_thrash = false
        self.target.building.tile.empty_thrash()
        self.has_thrash = true

        self.directions = self.return_directions
        self.current_path_index = 1

        self.move_to_target()
    else:
        self.target.building.tile.assigned_truck = null
        self.has_thrash = false
        self.get_parent().remove_child(self)
        self.target = null

        if self.base != null:
            self.base.return_truck()

func _play_garbage_sound():
    var sample = ""
    if randi() % 3 == 0:
        sample = "dog_" + str(randi() % 8)
    else:
        sample = "garbage_"+ str(randi() % 10)

    self.sound_bites[sample].play()
