extends CanvasLayer


var _parent : CharacterBody2D= null

@onready var timer_label: Label = get_node("%ClockTimeLeft")
@onready var remaining_time_timer: Timer = get_node("%RemainingTime")


var time_up : bool = false


@export var total_seconds : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


	



func _on_remaining_time_timeout() -> void:

	if total_seconds > 0:
		total_seconds -= 1
	else:
		time_up = true
		timer_label.text = "Time is out!"
		PlayerData.time_out = true
		return

	timer_label.text = str(total_seconds)

	remaining_time_timer.start(1.0)
	
