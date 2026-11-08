extends Area2D


var inside : bool = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.current_collision_layer_changed_player.connect(try_to_walk_out)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	inside = true
	try_to_walk_out(PlayerData.current_collision_layer)

func _on_body_exited(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	inside = false



func try_to_walk_out(current_collision_layer : int) -> void:
	if !inside or current_collision_layer != 3:
		return

	PlayerData.walked_out_door = true