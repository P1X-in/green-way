
const LOOP_TICK_DURATION = 30.0
const GARBAGE_TICK_DURATION = 10.0

var board

var loop_count = 0
var stopped = false

func start(_board):
    self.board = _board
    self.call_deferred("_loop_tick")
    self.call_deferred("_garbage_tick")

func _loop_tick():
    if self.stopped:
        return

    print("loop " + str(self.loop_count))

    var home_template = self._get_random_house_template()
    var home_tile
    var thrash_type = self._get_random_thrash_type()

    var leash_tile = null
    var industrial_distance = 10

    if self.loop_count < 4:
        leash_tile = self.board.map.model.get_tile2(20, 20)
        industrial_distance = 5

    if randi() % 2 == 1:
        home_tile = self._place_random_building(true, home_template, leash_tile, 10)
        if not home_tile:
            home_tile = self._place_random_building(false, home_template, leash_tile, 10)
    else:
        home_tile = self._place_random_building(false, home_template, leash_tile, 10)
    self._play_building_sound();

    self.board.map.model.add_house(home_tile)

    var industrial_tile = self._place_random_building(false, self.board.map.templates.BUILDING_INDUSTRY, home_tile, industrial_distance)

    home_tile.building.tile.init_thrash_bin(thrash_type)
    industrial_tile.building.tile.set_type(thrash_type)


    self.board.map.model.add_industrial(industrial_tile)

    self.board.paths.build_paths_for_industrial_building(industrial_tile)

    self.loop_count += 1

    self.board.tiles_available += 5
    yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
    self.call_deferred("_loop_tick")

func _garbage_tick():
    if self.stopped:
        return

    print("garbage tick")
    var result

    for house in self.board.map.model.get_house_building_tiles():
        result = house.building.tile.plant_thrash()
        if result:
            self.board.audio.play("garbage_dump")
            print("garbage planted")

        if house.building.tile.thrash_level > 5:
            self.board.score -= 1
            if self.board.score < 0:
                self.board.score = 0

    yield(self.board.get_tree().create_timer(self.GARBAGE_TICK_DURATION), "timeout")
    self.call_deferred("_garbage_tick")


func _play_building_sound():
    #self.board.audio.play("build_" + str(randi() % 2 ))
    pass

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
