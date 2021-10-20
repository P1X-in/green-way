
const LOOP_TICK_DURATION = 30.0
const GARBAGE_TICK_DURATION = 10.0

var board

var loop_count = 0

func start(_board):
	self.board = _board
	self.call_deferred("_loop_tick")
	self.call_deferred("_garbage_tick")

func _loop_tick():
	print("loop " + str(self.loop_count))

	var home_template = self._get_random_house_template()
	var home_tile
	var thrash_type = self._get_random_thrash_type()
	if randi() % 2 == 1:
		home_tile = self._place_random_building(true, home_template)
		if not home_tile:
			home_tile = self._place_random_building(false, home_template)
	else:
		home_tile = self._place_random_building(false, home_template)
	self._play_building_sound();

    self.board.map.model.add_house(home_tile)

    var industrial_tile = self._place_random_building(false, self.board.map.templates.BUILDING_INDUSTRY, home_tile, self.loop_count * 5 + 5)

	home_tile.building.tile.init_thrash_bin(thrash_type)
	industrial_tile.building.tile.type = thrash_type

    self.board.map.model.add_industrial(industrial_tile)

	self.board.paths.build_paths_for_industrial_building(industrial_tile)

	self.loop_count += 1
	yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
	self.call_deferred("_loop_tick")

func _garbage_tick():
	print("garbage tick")

	for house in self.board.map.model.get_house_building_tiles():
		if randi() % 3 == 0:
			house.building.tile.plant_thrash()
			self.board.audio.play("garbage_dump")
			print("garbage planted")

	yield(self.board.get_tree().create_timer(self.GARBAGE_TICK_DURATION), "timeout")
	self.call_deferred("_garbage_tick")


func _play_building_sound():
	self.board.audio.play("build_" + str(randi() % 2 ))

func _place_random_building(with_neighbour, template, source_tile=null, distance=999):
	var free_tiles = self._get_free_tiles(with_neighbour)

	if source_tile != null:
		free_tiles = self._filter_by_max_distance(source_tile, free_tiles, distance)
		free_tiles = self._filter_by_min_distance(source_tile, free_tiles, 2)

	if free_tiles.size() > 0:
		var rotations = [0, 90, 180, 270]
		var tile = free_tiles[randi() % free_tiles.size()]
		var rotation = rotations[randi() % rotations.size()]
		self.board.map.builder.place_building(tile.position, template, rotation)
		self.board.fix_neighbouring_roads(tile)
		return tile
	return false

func _get_free_tiles(with_neighbours):
	var tiles = []

	for tile in self.board.map.model.tiles.values():
		if tile.has_content():
			continue

		if with_neighbours and not tile.has_neighbouring_home():
			continue

		tiles.append(tile)

	return tiles

func _filter_by_max_distance(source_tile, tiles, distance):
	var filtered_tiles = []
	for tile in tiles:
		if tile.cartesian_distance_to(source_tile) <= distance:
			filtered_tiles.append(tile)
	return filtered_tiles

func _filter_by_min_distance(source_tile, tiles, distance):
	var filtered_tiles = []
	for tile in tiles:
		if tile.cartesian_distance_to(source_tile) >= distance:
			filtered_tiles.append(tile)
	return filtered_tiles

func _get_random_house_template():
	var templates = [
		self.board.map.templates.BUILDING_HOUSE,
		self.board.map.templates.BUILDING_HOUSE_2,
	]

	return templates[randi() % templates.size()]

func _get_random_thrash_type():
	var types = [
		self.board.map.templates.THRASH_METAL,
		self.board.map.templates.THRASH_PLASTIC,
		self.board.map.templates.THRASH_PAPER,
		self.board.map.templates.THRASH_GLASS,
	]

	return types[randi() % types.size()]
