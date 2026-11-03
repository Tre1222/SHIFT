extends Camera2D


var shake_intensity : float = 0.0
var shake_decay : float = 15.0
var rng = RandomNumberGenerator.new()


# Given by player.gd
var front_node : Node2D
var middle_node : Node2D
var back_node : Node2D


func _ready() -> void:
	rng.randomize()
	PlayerData.current_collision_layer_changed_player.connect(handle_layer_shift)
	
func _process(delta: float) -> void:
	if shake_intensity > 0:
		var offset_x : float= rng.randf_range(-shake_intensity, shake_intensity)
		var offset_y : float= rng.randf_range(-shake_intensity, shake_intensity)
		
		self.offset = Vector2(offset_x, offset_y)
		
		shake_intensity = move_toward(shake_intensity, 0.0, shake_decay * delta)
	else:
		self.offset = Vector2.ZERO

func start_shake(intensity: float, decay_rate: float = 15.0) -> void:
	shake_intensity = intensity
	shake_decay = decay_rate

func handle_layer_shift(new_layer : int) -> void:
	
	start_shake(8.0, 18.0)
	
	var tween : Tween = create_tween().set_parallel(true)
	
	var active_color : Color = Color(1.0,1.0,1.0,1.0)
	var faded_back : Color = Color(0.4, 0.4, 0.5, 0.5)
	var faded_front : Color = Color(1.0,1.0,1.0,0.15)
	
	if front_node == null or  middle_node == null or  back_node == null:
		return
	match new_layer:
		1: #Forward
			tween.tween_property(self, "zoom", Vector2(3.64,3.44),0.3).set_trans(Tween.TRANS_QUAD)
			

			
			#Adjust layers
			tween.tween_property(front_node, "modulate", active_color, 0.3)
			tween.tween_property(middle_node, "modulate", faded_back, 0.3)
			tween.tween_property(back_node, "modulate", faded_back * 0.5, 0.3)
		2: #Middle
			tween.tween_property(self, "zoom", Vector2(3.34,3.34),0.3).set_trans(Tween.TRANS_QUAD)

			#Adjust layers
			tween.tween_property(front_node, "modulate", faded_front, 0.3)
			tween.tween_property(middle_node, "modulate", active_color, 0.3)
			tween.tween_property(back_node, "modulate", faded_back, 0.3)
		3: #back
			tween.tween_property(self, "zoom", Vector2(3.04,3.24),0.3).set_trans(Tween.TRANS_QUAD)

			#Adjust layers
			tween.tween_property(front_node, "modulate", faded_front * 0.5, 0.3)
			tween.tween_property(middle_node, "modulate", faded_front, 0.3)
			tween.tween_property(back_node, "modulate", active_color, 0.3)
	tween.play()


func _on_timer_timeout() -> void:
	handle_layer_shift(PlayerData.current_collision_layer)
