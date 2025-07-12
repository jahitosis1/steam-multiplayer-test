extends CharacterBody2D

@onready var camera_2d: Camera2D = $Camera2D

const SPEED = 300.0

func _enter_tree() -> void:
	prints("Player Name", name)
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	camera_2d.enabled = is_multiplayer_authority()

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
