extends Node


signal current_collision_layer_changed_player(new_collision_layer : int) 


var time_out : bool = false

var walked_out_door : bool = false

var on_stairs_cooldown : bool = false

var current_collision_layer : int = 2:
	set(value):
		current_collision_layer = value
		current_collision_layer_changed_player.emit(value)