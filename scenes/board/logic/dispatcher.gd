
var board

func _init(_board):
    self.board = _board

func process_dispatch():
    var house_tiles = self.board.map.model.get_house_building_tiles()

    for house_tile in house_tiles:
        self._process_house(house_tile)

func recall_trucks(destroyed_road_tile):
    var key = self.board.paths._get_key(destroyed_road_tile)
    var industrial_tiles = self.board.map.model.get_industrial_building_tiles()
    var building
    var truck

    for industrial_tile in industrial_tiles:
        building = industrial_tile.building.tile
        truck = building.truck

        if not building.is_truck_free() and truck.has_key_in_path(key):
            truck.abort()

func _process_house(house_tile):
    var house = house_tile.building.tile

    if house.has_thrash and house.assigned_truck == null:
        var industrial_tile = self._find_free_truck(house_tile)

        if industrial_tile != null:
            self._dispatch(industrial_tile, house_tile)

func _find_free_truck(house_tile):
    var industrial_tiles = self.board.map.model.get_industrial_building_tiles()
    var house = house_tile.building.tile
    var building

    var matching_tiles = []

    for industrial_tile in industrial_tiles:
        building = industrial_tile.building.tile

        if building.type == house.type and building.is_truck_free():
            if self.board.paths.is_tile_reachable(industrial_tile, house_tile):
                matching_tiles.append(industrial_tile)

    if matching_tiles.size() == 0:
        return null

    if matching_tiles.size() == 1:
        return matching_tiles[0]

    var preffered_tile = matching_tiles[0]

    var best_path = self.board.paths.get_path_to_tile(preffered_tile, house_tile)
    var compared_path

    for matching_tile in matching_tiles:
        compared_path = self.board.paths.get_path_to_tile(matching_tile, house_tile)

        if compared_path.size() < best_path.size():
            preffered_tile = matching_tile
            best_path = compared_path

    return preffered_tile


func _dispatch(industrial_tile, house_tile):
    var house = house_tile.building.tile
    var industrial = industrial_tile.building.tile
    var path = self.board.paths.get_path_to_tile(industrial_tile, house_tile)
    var directions = self._convert_path_to_directions(path)

    path.invert()

    var return_directions = self._convert_path_to_directions(path)

    industrial.dispatch_truck(house_tile, path, directions, return_directions)

    house.assigned_truck = industrial.truck

    var spawn_tile = self.board.map.model.tiles[path[1]]
    self.board.map.anchor_truck(industrial.truck, spawn_tile.position)
    industrial.truck.move_to_target()

func _convert_path_to_directions(path):
    var directions = []
    for i in path.size():
        if i > 0:
            directions.append(self._get_rotation_to_tile(path[i], path[i-1]))
        elif i == 0:
            directions.append(self._get_rotation_to_tile(path[i+1], path[i]))

    directions.invert()
    return directions


func _get_rotation_to_tile(source_key, destination_key):
    var source_tile = self.board.map.model.tiles[source_key]
    var destination_tile = self.board.map.model.tiles[destination_key]
    return source_tile.get_direction_to_neighbour(destination_tile)
