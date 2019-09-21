extends "res://tools/StreamingLevel/LevelLayout.gd"

const KeysLayoutBatch = preload("KeysLayoutBatch.tscn")

const TILE_SIZE := 2

export var top_max_y := -2
export(float, -1.0, 1.0) var top_max_value := 0.0
export var end_max_y := 0

export(float, 0.1, 0.9) var drop_rate := 0.5

func gen(pos: Vector3) -> Spatial:
	var layout_batch = KeysLayoutBatch.instance()
	layout_batch.top_max_y = top_max_y
	layout_batch.top_max_value = top_max_value
	layout_batch.end_max_y = end_max_y
	layout_batch.drop_rate = drop_rate
	layout_batch.translate( Vector3(pos.x*batch_size*TILE_SIZE, pos.y*batch_size*TILE_SIZE, 0) )
	layout_batch.gen( Vector3(pos.x*batch_size, pos.y*batch_size, 0), noise, cap )
	emit_signal("batch_generated", layout_batch)
	return layout_batch