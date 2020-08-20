extends KinematicBody2D

export var GRAVITY_ACCELERATION = 3000
export var MAX_FALL_SPEED = 1000
export var JUMP_SPEED = -1000
export var RUN_ACCELERATION = 600
export var MAX_RUN_SPEED = 300
export var FRICTION = 700
export var DASH_SPEED = 800
export var DASH_DURATION = 25

enum {
	RUN,
	DASH,
	JUMP,
	CAST_FIRE,
	CAST_ICE
}

const FireBall = preload("res://src/Player/Spells/FireBall.tscn")
const IceSpike = preload("res://src/Player/Spells/IceSpike.tscn")

onready var animatedSprite = $AnimatedSprite
onready var castLeftColBox = $CastLeftCollisionShape
onready var castLeftHurtBox = $CastLeftHurtBox/CollisionShape2D
onready var castRightColBox = $CastRightCollisionShape
onready var castRightHurtBox = $CastRightHurtBox/CollisionShape2D
onready var idleLeftColBox = $IdelLeftCollisionShape
onready var idleLeftHurtBox = $IdleLeftHurtBox/CollisionShape2D
onready var idleRightColBox = $IdleRightCollisionShape
onready var idleRightHurtBox = $IdleRightHurtBox/CollisionShape2D
onready var runLeftColBox = $RunLeftCollisionShape
onready var runLeftHurtBox = $RunLeftHurtBox/CollisionShape2D
onready var runRightColBox = $RunRightCollisionShape
onready var runRightHurtBox = $RunRightHurtBox/CollisionShape2D

var state = RUN
var velocity = Vector2.ZERO
var direction_vector = Vector2.RIGHT
var dash_timer = 0
var cast_timer = 0

var hurtBoxes
var colBoxes

func _ready():
	colBoxes = [castLeftColBox, castRightColBox, idleLeftColBox, idleRightColBox, runLeftColBox, runRightColBox]
	hurtBoxes = [castLeftHurtBox, castRightHurtBox, idleLeftHurtBox, idleRightHurtBox, runLeftHurtBox, runRightHurtBox]
	idleRightColBox.disabled = false
	idleRightHurtBox.disabled = false

func _physics_process(delta):
	match state:
		RUN:
			run_state(delta)
		DASH:
			dash_state(delta)
		JUMP:
			jump_state(delta)
		CAST_FIRE:
			cast_fire_state(delta)
		CAST_ICE:
			cast_ice_state(delta)

func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		direction_vector.x = input_vector.x
		velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
		play_running_animation();
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		play_idle_animation();

	move(delta)

	if Input.is_action_just_pressed("dash"):
		dash_action()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_action()

	if Input.is_action_just_pressed("fireball"):
		cast_fire()

	if Input.is_action_just_pressed("icespike") and is_on_floor():
		cast_ice()

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

func cast_fire_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		play_idle_animation()
		state = RUN
	else:
		move(delta)

func cast_ice_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		play_idle_animation()
		state = RUN

func dash_action():
	dash_timer = DASH_DURATION
	velocity.x = direction_vector.x * DASH_SPEED
	state = DASH

func jump_action():
	state = JUMP

func cast_fire():
	velocity = Vector2.ZERO
	play_cast_animation()
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position
	fireBall.global_position.y -= fireBall.sprite_vertical_offset
	cast_timer = fireBall.CAST_DURATION
	if direction_vector.x < 0:
		fireBall.global_position.x -= fireBall.sprite_horizontal_offset
		fireBall.velocity.x = direction_vector.x * fireBall.SPEED
		fireBall.sprite.set_flip_h(true)
	else:
		fireBall.global_position.x += fireBall.sprite_horizontal_offset
	state = CAST_FIRE

func cast_ice():
	velocity = Vector2.ZERO
	play_cast_animation()
	var iceSpike = IceSpike.instance()
	get_parent().add_child(iceSpike)
	cast_timer = iceSpike.CAST_DURATION
	iceSpike.global_position = global_position
	if direction_vector.x < 0:
		iceSpike.global_position.x -= iceSpike.sprite_horizontal_offset
		iceSpike.sprite.set_flip_h(true)
	else:
		iceSpike.global_position.x += iceSpike.sprite_horizontal_offset
	state = CAST_ICE

func disable_hurt_boxes():
	for x in hurtBoxes:
		x.disabled = true

func disable_col_boxes():
	for x in colBoxes:
		x.disabled = true

func play_cast_animation():
	disable_hurt_boxes()
	disable_col_boxes()

	if direction_vector.x < 0:
		castLeftColBox.disabled = false;
		castLeftHurtBox.disabled = false;
		animatedSprite.play("CastLeft")
	else:
		castRightColBox.disabled = false;
		castRightHurtBox.disabled = false;
		animatedSprite.play("CastRight")

func play_idle_animation():
	disable_hurt_boxes()
	disable_col_boxes()

	if direction_vector.x < 0:
		idleLeftColBox.disabled = false
		idleLeftHurtBox.disabled = false
		animatedSprite.play("IdleLeft")
	else:
		idleRightColBox.disabled = false
		idleRightHurtBox.disabled = false
		animatedSprite.play("IdleRight")

func play_running_animation():
	disable_hurt_boxes()
	disable_col_boxes()

	if direction_vector.x < 0:
		runLeftColBox.disabled = false
		runLeftHurtBox.disabled = false
		animatedSprite.play("RunLeft")
	else:
		runRightColBox.disabled = false
		runRightHurtBox.disabled = false
		animatedSprite.play("RunRight")

func move(delta):
	velocity.y += GRAVITY_ACCELERATION * delta
	velocity = move_and_slide(velocity, Vector2.UP)
