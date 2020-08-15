extends KinematicBody2D

export var GRAVITY_ACCELERATION = 3000
export var MAX_FALL_SPEED = 1000
export var JUMP_SPEED = -1000
export var RUN_ACCELERATION = 600
export var MAX_RUN_SPEED = 300
export var FRICTION = 700
export var DASH_SPEED = 800
export var DASH_DURATION = 25
export var CAST_DURATION = 20

enum {
	RUN,
	DASH,
	JUMP,
	CAST
}

const UP = Vector2(0, -1)
const FireBall = preload("res://src/Player/FireBall.tscn")

var state = RUN
var velocity = Vector2.ZERO
var direction_vector = Vector2.RIGHT
var dash_timer = 0
var cast_timer = 0

func _physics_process(delta):
	match state:
		RUN:
			run_state(delta)
		DASH:
			dash_state(delta)
		JUMP:
			jump_state(delta)
		CAST:
			cast_state(delta)

func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		direction_vector.x = input_vector.x
		velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move(delta)

	if Input.is_action_just_pressed("dash"):
		dash_action()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_action()

	if Input.is_action_just_pressed("cast"):
		cast_action()

func dash_state(delta):
	dash_timer -= (delta * 100)
	if dash_timer <= 0:
		dash_timer = 0
		velocity.x = velocity.x * 0.35
		state = RUN
	else:
		move(delta)

func jump_state(delta):
	velocity.y = JUMP_SPEED
	state = RUN

func cast_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		state = RUN
	else:
		move(delta)

func dash_action():
	dash_timer = DASH_DURATION
	velocity.x = direction_vector.x * DASH_SPEED
	state = DASH

func jump_action():
	state = JUMP

func cast_action():
	velocity = Vector2.ZERO
	cast_timer = CAST_DURATION
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position
	fireBall.global_position.y -= 30
	if direction_vector.x < 0:
		fireBall.velocity.x = direction_vector.x * fireBall.SPEED
		fireBall.sprite.set_flip_h(true)
	state = CAST

func move(delta):
	velocity.y += GRAVITY_ACCELERATION * delta
	velocity = move_and_slide(velocity, UP)
