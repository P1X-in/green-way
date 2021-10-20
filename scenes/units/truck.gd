extends Spatial

var type
var target = null
var path = null

var has_thrash = false

func is_truck_free():
    return target ==null

func set_type(_type):
    self.type = _type

func dispatch(destination_tile, _path):
    self.target = destination_tile
    self.path = _path
