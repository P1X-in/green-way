
const LOOP_TICK_DURATION = 30.0

var board

var loop_count = 0

func start(_board):
    self.board = _board
    self.call_deferred("_loop_tick")

func _loop_tick():
    print("loop " + str(self.loop_count))

    self._place_random_building()

    self.loop_count += 1
    yield(self.board.get_tree().create_timer(self.LOOP_TICK_DURATION), "timeout")
    self.call_deferred("_loop_tick")

func _place_random_building():
    var free_tiles = self._get_free_tiles()

    if free_tiles.size() > 0:
        var rotations = [0, 90, 180, 270]
        var tile = free_tiles[randi() % free_tiles.size()]
        var rotation = rotations[randi() % rotations.size()]
        self.board.map.builder.place_building(tile.position, self.board.map.templates.BUILDING_HOUSE, rotation)
        self.board.fix_neighbouring_roads(tile)

func _get_free_tiles():
    var tiles = []

    for tile in self.board.map.model.tiles.values():
        if not tile.has_content():
            tiles.append(tile)

    return tiles
