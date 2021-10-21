
const SIZE = 40

var tile_template = preload("res://scenes/map/tile.gd")

var tiles = {}

var houses = []
var industrials = []

func _init():
    for x in range(self.SIZE):
        for y in range(self.SIZE):
            self.tiles[str(x) + "_" + str(y)] = self.tile_template.new(x, y)
    self.connect_neightbours()

func get_tile(position):
    return self.tiles[str(position.x) + "_" + str(position.y)]

func get_tile2(x, y):
    return self.tiles[str(x) + "_" + str(y)]

func get_dict():
    var tiles_dict = {}
    for i in self.tiles.keys():
        if self.tiles[i].has_content():
          tiles_dict[i] = self.tiles[i].get_dict()

    return {
        "tiles" : tiles_dict
    }

func connect_neightbours():
    var tile

    for x in range(self.SIZE):
        for y in range(self.SIZE):

            tile = self.get_tile2(x, y)

            if x > 0:
                tile.add_neighbour(tile.WEST, self.get_tile2(x-1, y))

            if x < self.SIZE - 1:
                tile.add_neighbour(tile.EAST, self.get_tile2(x+1, y))

            if y > 0:
                tile.add_neighbour(tile.NORTH, self.get_tile2(x, y-1))

            if y < self.SIZE - 1:
                tile.add_neighbour(tile.SOUTH, self.get_tile2(x, y+1))


func get_industrial_building_tiles():
    return self.industrials

func get_house_building_tiles():
    return self.houses

func add_house(house_tile):
    self.houses.append(house_tile)

func add_industrial(industrial_tile):
    self.industrials.append(industrial_tile)

func get_random_tile():
    var tiles_array = self.tiles.values()

    return tiles_array[randi() % tiles_array.size()]
