extends KinematicBody2D

export var GRAVITY_ACCELERATION = 3000
export var MAX_FALL_SPEED = 1000
export var JUMP_SPEED = -1000
export var RUN_ACCELERATION = 300
export var MAX_RUN_SPEED = 300
export var FRICTION = 500

enum {
	RUN,
	DASH,
	JUMP
}

const UP = Vector2(0, -1)

var state = RUN
var velocity = Vector2.ZERO
var dash_vector = Vector2.ZERO

func _physics_process(delta):
	match state:
		RUN:
			run_state(delta)
		DASH:
			dash_state(delta)
		JUMP:
			jump_state(delta)

func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity.y += GRAVITY_ACCELERATION * delta
	move()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = JUMP

	if Input.is_action_just_pressed("dash"):
		state = DASH

func dash_state(delta):
	state = RUN

func jump_state(delta):
	velocity.y = JUMP_SPEED
	state = RUN

func move():
	velocity = move_and_slide(velocity, UP)
