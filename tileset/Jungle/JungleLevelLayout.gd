extends "res://tools/StreamingLevel/LevelLayout.gd"

const JungleLayoutBatch = preload("JungleLayoutBatchSingleTile.tscn")

const TILE_SIZE := 2

export var top_max_y := -2
export(float, -1.0, 1.0) var top_max_value := 0.0
export var end_max_y := 0

func gen(loc: Vector3) -> Spatial:
	var layout_batch = JungleLayoutBatch.instance()
	layout_batch.top_max_y = top_max_y
	layout_batch.top_max_value = top_max_value
	layout_batch.end_max_y = end_max_y
	layout_batch.translate( Vector3(loc.x*batch_size*TILE_SIZE, loc.y*batch_size*TILE_SIZE, 0) )
	layout_batch.gen( Vector3(loc.x*batch_size, loc.y*batch_size, 0), noise, cap )
	emit_signal("batch_generated", layout_batch)
	return layout_batch

