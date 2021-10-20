
const LOOP_TICK_DURATION = 30.0

var board

var loop_count = 0

func start(_board):
    self.board = _board
    self.call_deferred("_loop_tick")

func _loop_tick():
    print("loop " + str(self.loop_count))

    if randi() % 2 == 1:
        var result = self._place_random_building(true, self.board.map.templates.BUILDING_HOUSE)
        if not result:
            self._place_random_building(false, self.board.map.templates.BUILDING_HOUSE)
    else:
        self._place_random_building(false, self.board.map.templates.BUILDING_HOUSE)

    self._place_random_building(false, self.board.map.templates.BUILDING_INDUSTRY)

    self.loop_count += 1
    yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
    self.call_deferred("_loop_tick")


func _place_random_building(with_neighbour, template):
    var free_tiles = self._get_free_tiles(with_neighbour)

    if free_tiles.size() > 0:
        var rotations = [0, 90, 180, 270]
        var tile = free_tiles[randi() % free_tiles.size()]
        var rotation = rotations[randi() % rotations.size()]
        self.board.map.builder.place_building(tile.position, template, rotation)
        self.board.fix_neighbouring_roads(tile)
        return true
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
