
const LOOP_TICK_DURATION = 30.0

var board

var loop_count = 0

func start(_board):
    self.board = _board
    self.call_deferred("_loop_tick")

func _loop_tick():
    print("loop " + str(self.loop_count))

    var home_tile
    if randi() % 2 == 1:
        home_tile = self._place_random_building(true, self.board.map.templates.BUILDING_HOUSE)
        if not home_tile:
            home_tile = self._place_random_building(false, self.board.map.templates.BUILDING_HOUSE)
    else:
        home_tile = self._place_random_building(false, self.board.map.templates.BUILDING_HOUSE)

    var new_building_tile = self._place_random_building(false, self.board.map.templates.BUILDING_INDUSTRY, home_tile, self.loop_count * 5 + 5)

    self.board.paths.build_paths_for_industrial_building(new_building_tile)

    self.loop_count += 1
    yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
    self.call_deferred("_loop_tick")


func _place_random_building(with_neighbour, template, source_tile=null, distance=999):
    var free_tiles = self._get_free_tiles(with_neighbour)

    if source_tile != null:
        free_tiles = self._filter_by_distance(source_tile, free_tiles, distance)

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

func _filter_by_distance(source_tile, tiles, distance):
    var filtered_tiles = []
    for tile in tiles:
        if tile.cartesian_distance_to(source_tile) <= distance:
            filtered_tiles.append(tile)
    return filtered_tiles
