
var board

func _init(_board):
    self.board = _board

func process_dispatch():
    var house_tiles = self.board.map.model.get_house_building_tiles()

    for house_tile in house_tiles:
        self._process_house(house_tile)

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


func _dispatch(industrial_tile, house_tile):
    var house = house_tile.building.tile
    var industrial = industrial_tile.building.tile
    var path = self.board.paths.get_path_to_tile(industrial_tile, house_tile)

    industrial.dispatch_truck(house_tile, path)

    house.assigned_truck = industrial.truck
    print("truck dispatched")
