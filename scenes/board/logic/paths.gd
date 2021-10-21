
var board

var visited_tiles = {}
var explored_tiles = {}
var tile_path = {}

func _init(board_object):
    self.board = board_object

func refresh_all_industrial_paths():
    var industrial_tiles = self.board.map.model.get_industrial_building_tiles()

    for tile in industrial_tiles:
        self.build_paths_for_industrial_building(tile)

func build_paths_for_industrial_building(building_tile):
    var source_key = self._get_key(building_tile)

    self._reset(source_key)
    self._add_path_root(source_key, building_tile)
    self._expand_from_tile(source_key, building_tile, 0)


func is_tile_reachable(source_tile, destination_tile):
    var source_key = self._get_key(source_tile)
    var destination_key = self._get_key(destination_tile)

    return self.tile_path.has(source_key) and self.tile_path[source_key].has(destination_key)

func get_path_to_tile(source_tile, destination_tile):
    var path = []
    var source_key = self._get_key(source_tile)
    var key = self._get_key(destination_tile)

    while key != null:
        path.append(key)
        key = self.tile_path[source_key][key]

    return path

func _get_key(tile):
    return str(tile.position.x) + "_" + str(tile.position.y)

func _reset(source_key):
    self.visited_tiles = {}
    self.explored_tiles = {}
    self.tile_path[source_key] = {}

func _add_path_root(source_key, root_tile):
    self.tile_path[source_key][self._get_key(root_tile)] = null

func _expand_from_tile(source_key, tile, reach_cost):
    self._mark_tile_cost(tile, reach_cost)

    var neighbour
    var neighbour_cost

    for key in tile.neighbours.keys():
        neighbour = tile.get_neighbour(key)

        if not neighbour.has_home() and not neighbour.has_industrial() and not neighbour.ground.is_present():
            continue

        neighbour_cost = self._get_tile_cost(neighbour)

        if neighbour_cost == null || neighbour_cost > reach_cost + 1:
            self._connect_path(source_key, tile, neighbour)

            if neighbour.ground.is_present() and reach_cost < 40:
                self._expand_from_tile(source_key, neighbour, reach_cost + 1)

func _mark_tile_cost(tile, cost):
    self.visited_tiles[self._get_key(tile)] = tile
    self.explored_tiles[self._get_key(tile)] = cost

func _get_tile_cost(tile):
    var key = self._get_key(tile)
    if self.explored_tiles.has(key):
        return self.explored_tiles[key]

    return null

func _connect_path(master_source_key, source_tile, destination_tile):
    var source_key = self._get_key(source_tile)
    var destination_key = self._get_key(destination_tile)

    self.tile_path[master_source_key][destination_key] = source_key

