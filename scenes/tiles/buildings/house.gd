extends "res://scenes/tiles/tile.gd"

var has_thrash = true
var assigned_truck = null
var thrash_level = 0

var type

const THRASH_METAL = 1
const THRASH_PLASTIC = 2
const THRASH_PAPER = 3
const THRASH_GLASS = 4


func init_thrash_bin(type):
	self.type = type
	if type == self.THRASH_METAL:
		$SM_TrashBin_Red.visible = true
	if type == self.THRASH_PLASTIC:
		$SM_TrashBin_Yellow.visible = true
	if type == self.THRASH_PAPER:
		$SM_TrashBin_Blue.visible = true
	if type == self.THRASH_GLASS:
		$SM_TrashBin_Green.visible = true


func plant_thrash():
	self.has_thrash = true
	self.thrash_level += 1

	if self.thrash_level > 0:
		if self.type == self.THRASH_METAL:
			$SM_TrashBin_Red.visible = true
		if self.type == self.THRASH_PLASTIC:
			$SM_TrashBin_Yellow.visible = true
		if self.type == self.THRASH_PAPER:
			$SM_TrashBin_Blue.visible = true
		if self.type == self.THRASH_GLASS:
			$SM_TrashBin_Green.visible = true
	
	if self.thrash_level > 1:
		if self.type == self.THRASH_METAL:
			$"SM_TrashBin_Red/RootNode/SM_Bin_Red/SM_Trash_Red".visible = true
		if self.type == self.THRASH_PLASTIC:
			$"SM_TrashBin_Yellow/RootNode/SM_Bin_Yellow/SM_Trash_Yellow".visible = true
		if self.type == self.THRASH_PAPER:
			$"SM_TrashBin_Blue/RootNode/SM_Bin_Blue/SM_Trash_Blue".visible = true
		if self.type == self.THRASH_GLASS:
			$"SM_TrashBin_Green/RootNode/SM_Bin_Green/SM_Trash_Green".visible = true

	if self.thrash_level > 2:
		$Exclamation.visible = true

func empty_thrash():
	self.has_thrash = false
	self.thrash_level = 0
	$Exclamation.visible = false
	$"SM_TrashBin_Blue/RootNode/SM_Bin_Blue/SM_Trash_Blue".visible = false
	$"SM_TrashBin_Yellow/RootNode/SM_Bin_Yellow/SM_Trash_Yellow".visible = false
	$"SM_TrashBin_Blue/RootNode/SM_Bin_Blue/SM_Trash_Blue".visible = false
	$"SM_TrashBin_Green/RootNode/SM_Bin_Green/SM_Trash_Green".visible = false
	$SM_TrashBin_Red.visible = false
	$SM_TrashBin_Yellow.visible = false
	$SM_TrashBin_Green.visible = false
	$SM_TrashBin_Blue.visible = false
