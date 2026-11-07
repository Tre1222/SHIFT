extends Area2D



var inside : bool = false
@onready var cooldown_timer : Timer = get_node("Cooldown")

var player : Node2D = null

@export var sister_stairs : Area2D

func _input(event: InputEvent) -> void:
	if !inside or PlayerData.on_stairs_cooldown or PlayerData.current_collision_layer != 3:
		return
	
	if event.is_action_pressed("interact"):
		if player == null:
			return	
		PlayerData.on_stairs_cooldown = true
		cooldown_timer.start()
		player.global_position = sister_stairs.global_position

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	
	player = body
	
	inside = true

func _on_body_exited(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	
	
	inside = false


func _on_cooldown_timeout() -> void:
	PlayerData.on_stairs_cooldown = false
