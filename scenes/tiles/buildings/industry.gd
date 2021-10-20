extends "res://scenes/tiles/tile.gd"

var truck = preload("res://scenes/units/truck.tscn").instance()
var type

func is_truck_free():
    return self.truck.is_truck_free()

func set_type(_type):
    self.type = _type
    self.truck.set_type(_type)

func dispatch_truck(destination_tile, path, directions, return_directions):
    self.truck.dispatch(destination_tile, path, directions, return_directions)
