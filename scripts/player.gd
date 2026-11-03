extends CharacterBody2D



@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var camera : Camera2D = get_node("PlayerCamera")


@export var speed : int
@export var jump_force : int

@export var front_node : Node2D
@export var middle_node : Node2D
@export var back_node : Node2D




var gravity = ProjectSettings.get("physics/2d/default_gravity")

enum facing {
	left,
	right,
}

enum state {
	idle,
	walking,
	interacting,
	jumping,
}

var current_state : state = state.idle

func _ready():
	_swap_collision_state(true)
	camera.front_node = front_node
	camera.middle_node = middle_node
	camera.back_node = back_node
	

func _swap_collision_state(forward : bool):
	
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, false)
	set_collision_mask_value(4, false)
	
	var previous_layer : int = PlayerData.current_collision_layer
	if forward:
		PlayerData.current_collision_layer += 1
	else:
		PlayerData.current_collision_layer -= 1
	
	if PlayerData.current_collision_layer < 1:
		PlayerData.current_collision_layer = 1
	elif PlayerData.current_collision_layer > 3:
		PlayerData.current_collision_layer = 3
	
	z_index = -PlayerData.current_collision_layer
	match PlayerData.current_collision_layer:
		
		1:
			set_collision_mask_value(2, true)
		2:
			set_collision_mask_value(3, true)
		3:
			set_collision_mask_value(4, true)
	
	
	print("swapped to collision layer, ", PlayerData.current_collision_layer, " from layer, ", previous_layer)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	match current_state:
		state.idle:
			sprite.play("Idle")
		state.walking:
			pass
		state.interacting:
			pass
		state.jumping:
			pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("forward"):
		_swap_collision_state(true)
	elif event.is_action_pressed("back"):
		_swap_collision_state(false)
	
	
	
func _physics_process(delta: float) -> void:
	
	
	
	
	if !is_on_floor():
		velocity.y += gravity
		
		
	var direction : float = Input.get_axis("left", "right")
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		print("jumped")
		velocity.y = -jump_force
	
	
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	print(direction)
	velocity.x = direction * speed
	
	
	
	
	
	move_and_slide()