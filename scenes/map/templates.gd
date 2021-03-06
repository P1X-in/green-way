
const DUMMY_GROUND = "dummy_ground"

const ROAD_STRAIGHT = "road_straight"
const ROAD_BEND = "road_bend"
const ROAD_CROSS = "road_cross"
const ROAD_T = "road_t"

const BUILDING_HOUSE = "building_house"
const BUILDING_HOUSE_2 = "building_house2"
const BUILDING_INDUSTRY = "building_industry"

const TERRAIN_ALPS = "terrain_alps"
const TERRAIN_FOREST_1 = "terrain_forest_1"
const TERRAIN_FOREST_2 = "terrain_forest_2"
const TERRAIN_FOREST_3 = "terrain_forest_3"

const THRASH_METAL = 1
const THRASH_PLASTIC = 2
const THRASH_PAPER = 3
const THRASH_GLASS = 4

var templates = {
    self.DUMMY_GROUND : preload("res://scenes/tiles/base_ground.tscn"),

    self.ROAD_STRAIGHT : preload("res://scenes/tiles/roads/road_straight.tscn"),
    self.ROAD_BEND : preload("res://scenes/tiles/roads/road_bend.tscn"),
    self.ROAD_CROSS : preload("res://scenes/tiles/roads/road_crossroad.tscn"),
    self.ROAD_T : preload("res://scenes/tiles/roads/road_t.tscn"),

    self.BUILDING_HOUSE : preload("res://scenes/tiles/buildings/house.tscn"),
    self.BUILDING_HOUSE_2 : preload("res://scenes/tiles/buildings/house2.tscn"),
    self.BUILDING_INDUSTRY : preload("res://scenes/tiles/buildings/industry.tscn"),

    self.TERRAIN_ALPS : preload("res://scenes/tiles/terrain/alps.tscn"),
    self.TERRAIN_FOREST_1 : preload("res://scenes/tiles/terrain/forest_1.tscn"),
    self.TERRAIN_FOREST_2 : preload("res://scenes/tiles/terrain/forest_2.tscn"),
    self.TERRAIN_FOREST_3 : preload("res://scenes/tiles/terrain/forest_3.tscn"),
}


func get_template(template):
    if template == null:
        return null

    var new_tile = self.templates[template].instance()
    new_tile.template_name = template

    return new_tile
