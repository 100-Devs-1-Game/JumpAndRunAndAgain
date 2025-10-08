class_name InfiniteScrollingLevel
extends Node2D

@export var player: Player

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var prev_tile_map_layer: TileMapLayer
var next_tile_map_layer: TileMapLayer
var tile_map_offset: float

func _ready() -> void:
	# Create previous and next tile map layers
	var tile_map_rect: Rect2i = tile_map_layer.get_used_rect()
	var scaled_tile_size: float = tile_map_layer.tile_set.tile_size.x * tile_map_layer.scale.x
	tile_map_offset = tile_map_rect.size.x * scaled_tile_size
	## Previous tile map layer
	prev_tile_map_layer = tile_map_layer.duplicate()
	add_child(prev_tile_map_layer)
	prev_tile_map_layer.position.x -= tile_map_rect.size.x * scaled_tile_size
	## Next tile map layer
	next_tile_map_layer = tile_map_layer.duplicate()
	add_child(next_tile_map_layer)
	next_tile_map_layer.position.x += tile_map_offset

func _process(_delta: float) -> void:
	# Jump player when reaching start or end of level
	if player.position.x > next_tile_map_layer.position.x:
		player.position.x -= tile_map_offset
	elif player.position.x < prev_tile_map_layer.position.x + tile_map_offset:
		player.position.x += tile_map_offset
