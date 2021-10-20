extends "res://scenes/tiles/tile.gd"

var truck = preload("res://scenes/units/truck.tscn").instance()
var type
var templates = load("res://scenes/map/templates.gd").new()

func is_truck_free():
	return self.truck.is_truck_free()

func set_type(_type):
	self.type = _type
	self.truck.set_type(_type)
	print(_type)
	if _type == self.templates.THRASH_METAL:
		$"Building_Industry/RootNode/Red".visible = true
		$Red.visible = true
	if _type == self.templates.THRASH_PLASTIC:
		$"Building_Industry/RootNode/Yellow".visible = true
		$Yellow.visible = true
	if _type == self.templates.THRASH_PAPER:
		$"Building_Industry/RootNode/Blue".visible = true
		$Blue.visible = true
	if _type == self.templates.THRASH_GLASS:
		$"Building_Industry/RootNode/Green".visible = true
		$Green.visible = true

func dispatch_truck(destination_tile, path, directions, return_directions):
	self.truck.dispatch(destination_tile, path, directions, return_directions)


