
const EAST = "e"
const WEST = "w"
const NORTH = "n"
const SOUTH = "s"

var position = Vector2(0, 0)

var ground = preload("res://scenes/map/tile_fragment.gd").new()
var frame = preload("res://scenes/map/tile_fragment.gd").new()
var decoration = preload("res://scenes/map/tile_fragment.gd").new()
var terrain = preload("res://scenes/map/tile_fragment.gd").new()
var building = preload("res://scenes/map/tile_fragment.gd").new()

var fragments = []

var neighbours = {}

func _init(x, y):
	self.position.x = x
	self.position.y = y

	self.fragments  = [
		self.ground,
		self.frame,
		self.decoration,
		self.terrain,
		self.building,
	]

func has_content():
	for fragment in self.fragments:
		if fragment.is_present():
			return true
	return false

func get_dict():
	return {
		"ground" : self.ground.get_dict(),
		"frame" : self.frame.get_dict(),
		"decoration" : self.decoration.get_dict(),
		"terrain" : self.terrain.get_dict(),
		"building" : self.building.get_dict(),
	}

func wipe():
	self.building.clear()
	self.terrain.clear()
	self.decoration.clear()
	self.frame.clear()
	self.ground.clear()

	return false

func add_neighbour(direction, tile):
	self.neighbours[direction] = tile

func get_neighbour(direction):
	if self.neighbours.has(direction):
		return self.neighbours[direction]

	return null

func is_neighbour(tile):
	for direction in self.neighbours.keys():
		if self.neighbours[direction] == tile:
			return true
	return false

func get_direction_to_neighbour(tile):
	for direction in self.neighbours.keys():
		if self.neighbours[direction] == tile:
			return direction
	return null

func has_neighbouring_building():
	for neighbour in self.neighbours.values():
		if neighbour.building.is_present():
			return true
	return false

func has_neighbouring_terrain():
	for neighbour in self.neighbours.values():
		if neighbour.terrain.is_present():
			return true
	return false

func is_cut_off_with_terrain():
	for neighbour in self.neighbours.values():
		if not neighbour.terrain.is_present():
			return false
	return true

func has_neighbouring_home():
	for neighbour in self.neighbours.values():
		if neighbour.has_home():
			return true
	return false

func has_industrial():
	return self.building.is_present() and self.building.tile.template_name == "building_industry"

func has_home():
	return self.building.is_present() and self.building.tile.template_name in ["building_house", "building_house2"]

func cartesian_distance_to(tile):
	var x_diff = self.position.x - tile.position.x
	var y_diff = self.position.y - tile.position.y

	if x_diff < 0:
		x_diff *= -1
	if y_diff < 0:
		y_diff *= -1

	return x_diff + y_diff - 1
