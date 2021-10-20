extends Spatial

var type
var target = null
var path = []
var directions = []
var return_directions = []

var has_thrash = false
var current_path_index = 0

onready var animations = $"animations"
onready var audio = $"/root/SimpleAudioLibrary"

#func _ready():
#    self.move_to_target()

func is_truck_free():
	return target == null

func set_type(_type):
	self.type = _type

func dispatch(destination_tile, _path, _directions, _return_directions):
	self.target = destination_tile
	self.path = _path
	self.directions = _directions
	self.return_directions = _return_directions
	self.current_path_index = 1

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
	if self.current_path_index < self.directions.size() - 2:
		self.animations.play("move")
		#self.sfx_effect("move")
	else:
		self.call_deferred("_come_back")

func _rotate_unit_to_direction(direction):
	if not self.unit_rotations.has(direction):
		return

	var rotation = self.unit_rotations[direction]
	self.set_rotation(Vector3(0, deg2rad(rotation), 0))

func _come_back():
	if not self.has_thrash:
		self.target.building.tile.has_thrash = false
		self.target.building.tile.empty_thrash()
		self._play_dog_sound()
		self.has_thrash = true

		self.directions = self.return_directions
		self.current_path_index = 1

		self.move_to_target()
	else:
		self.target.building.tile.assigned_truck = null
		self.has_thrash = false
		self.get_parent().remove_child(self)
		self.target = null
		
func _play_dog_sound():
	self.audio.play("dog_"+ str(randi() % 8 ))
