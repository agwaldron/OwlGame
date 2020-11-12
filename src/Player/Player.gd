extends KinematicBody2D

export var GRAVITY_ACCELERATION = 3000
export var MAX_FALL_SPEED = 1000
export var JUMP_SPEED = -1250
export var AIR_ACCELERATION = 600
export var MAX_AIR_SPEED = 250
export var RUN_ACCELERATION = 600
export var MAX_RUN_SPEED = 300
export var FRICTION = 700
export var TELEPORT_COOLDOWN = 35

enum {
	RUN,
	TELEPORTA,
	TELEPORTV,
	AIR,
	FREEFALL,
	GETUP,
	CAST_FIRE,
	CAST_ICE_ARROW,
	CAST_ICE_PLATFORM,
	CAST_ICE_SPIKE,
	CAST_LIGHTNING,
	PUKE
}

const FireBall = preload("res://src/Player/Spells/FireBall.tscn")
const IceBow = preload("res://src/Player/Spells/IceBow.tscn")
const IcePlatform = preload("res://src/Player/Spells/IcePlatform.tscn")
const IceSpike = preload("res://src/Player/Spells/IceSpike.tscn")
const Lightning = preload("res://src/Player/Spells/LightningBolt.tscn")
const TeleportProbe = preload("res://src/Player/Spells/TeleportProbe.tscn")

onready var animatedSprite = $AnimatedSprite
onready var airColBox = $AirCollisionShape
onready var airHurtBox = $AirHurtBox/CollisionShape2D
onready var castLeftColBox = $CastLeftCollisionShape
onready var castLeftHurtBox = $CastLeftHurtBox/CollisionShape2D
onready var castRightColBox = $CastRightCollisionShape
onready var castRightHurtBox = $CastRightHurtBox/CollisionShape2D
onready var freeFallColBox = $FreeFallCollisionShape
onready var idleLeftColBox = $IdelLeftCollisionShape
onready var idleLeftHurtBox = $IdleLeftHurtBox/CollisionShape2D
onready var idleRightColBox = $IdleRightCollisionShape
onready var idleRightHurtBox = $IdleRightHurtBox/CollisionShape2D
onready var runLeftColBox = $RunLeftCollisionShape
onready var runLeftHurtBox = $RunLeftHurtBox/CollisionShape2D
onready var runRightColBox = $RunRightCollisionShape
onready var runRightHurtBox = $RunRightHurtBox/CollisionShape2D

var health = 5
var blackedout = false
var immune = false
var immune_duration = 75
var immune_timer
var state = RUN
var velocity = Vector2.ZERO
var direction_vector = Vector2.RIGHT
var dash_timer = 0
var dash_cool_down_timer = 0
var teleporttimer = 0
var cast_timer = 0
var iceplatformpos1 = Vector2(400, 575)
var iceplatformpos2 = Vector2(600, 400)
var iceplatformpos3 = Vector2(800, 575)

var hurtBoxes
var colBoxes

func _ready():
	colBoxes = [airColBox, castLeftColBox, castRightColBox, freeFallColBox,
				idleLeftColBox, idleRightColBox, runLeftColBox, runRightColBox]
	hurtBoxes = [airHurtBox, castLeftHurtBox, castRightHurtBox, 
				idleLeftHurtBox, idleRightHurtBox, runLeftHurtBox, runRightHurtBox]
	idleRightColBox.disabled = false
	idleRightHurtBox.disabled = false

	get_tree().call_group("health_bar", "set_max", health)

func _physics_process(delta):
	dash_cool_down_timer -= (delta * 100)
	if immune:
		immune_timer -= (delta * 100)
		if immune_timer <= 0:
			immune = false

	match state:
		RUN:
			run_state(delta)
		AIR:
			air_state(delta)
		FREEFALL:
			free_fall_state(delta)
		CAST_FIRE:
			cast_fire_state(delta)
		CAST_ICE_ARROW:
			cast_ice_arrow_state(delta)
		CAST_ICE_PLATFORM:
			cast_ice_platform_state(delta)
		CAST_ICE_SPIKE:
			cast_ice_spike_state(delta)
		CAST_LIGHTNING:
			cast_lightning_state(delta)

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

	move(delta, true)

	if Input.is_action_just_pressed("teleport"):
		teleport_action()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_action()

	if Input.is_action_just_pressed("fireball"):
		cast_fire()

	if Input.is_action_just_pressed("icespike") and is_on_floor():
		cast_ice_spike()

	if Input.is_action_just_pressed("icearrow") and is_on_floor():
		cast_ice_arrow()

	if Input.is_action_just_pressed("lightning") and is_on_floor():
		cast_lightning()

func air_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		direction_vector.x = input_vector.x
		velocity = velocity.move_toward(input_vector * MAX_AIR_SPEED, AIR_ACCELERATION * delta)
		play_air_animation();
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		play_air_animation();

	move(delta, true)

	if Input.is_action_just_pressed("teleport"):
		teleport_action()

	if Input.is_action_just_pressed("fireball"):
		cast_fire()

	if is_on_floor():
		state = RUN

func free_fall_state(delta):
	if is_on_floor():
		start_getting_up()
	else:
		move(delta, true)

func cast_fire_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		if is_on_floor():
			state = RUN
		else:
			state = AIR
	else:
		move(delta, true)

func ice_arrow_released():
	state = RUN

func cast_ice_arrow_state(_delta):
	if Input.is_action_just_released("icearrow"):
		get_tree().call_group("ConcentrationSpell", "spell_interrupt")
		state = RUN

func cast_ice_platform_state(delta):
	move(delta, true)

func cast_ice_spike_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		state = RUN

func cast_lightning_state(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		cast_timer = 0
		state = RUN

func teleport_action():
	play_teleport_vanish_animation()
	velocity = Vector2.ZERO
	state = TELEPORTV

func teleportProbe():
	var teleportprobe = TeleportProbe.instance()
	get_parent().add_child(teleportprobe)
	teleportprobe.global_position = global_position
	if direction_vector.x < 0:
		teleportprobe.faceLeft()

func teleport(pos):
	play_teleport_appear_animation()
	global_position = pos
	state = TELEPORTA

func teleportFinished():
	if is_on_floor():
		play_idle_animation()
		state = RUN
	else:
		play_air_animation()
		state = AIR

func jump_action():
	velocity.y = JUMP_SPEED
	state = AIR

func start_free_fall():
	immune = true
	immune_timer = immune_duration
	velocity = Vector2.ZERO
	play_free_fall_animation()
	state = FREEFALL

func start_getting_up():
	immune = true
	immune_timer = immune_duration
	velocity = Vector2.ZERO
	play_getting_up_animation()
	state = GETUP

func getUp():
	if blackedout:
		puke()
	else:
		play_idle_animation()
		immune_timer = immune_duration
		state = RUN

func cast_fire():
	velocity.x = 0
	play_cast_animation()
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position
	fireBall.global_position.y -= fireBall.sprite_vertical_offset
	cast_timer = fireBall.CAST_DURATION
	if direction_vector.x < 0:
		fireBall.global_position.x -= fireBall.sprite_horizontal_offset
		fireBall.velocity.x = direction_vector.x * fireBall.SPEED
		fireBall.animatedSprite.play("Left")
	else:
		fireBall.global_position.x += fireBall.sprite_horizontal_offset
		fireBall.animatedSprite.play("Right")
	state = CAST_FIRE

func cast_ice_arrow():
	velocity = Vector2.ZERO
	play_cast_animation()
	var iceBow = IceBow.instance()
	get_parent().add_child(iceBow)
	iceBow.global_position = global_position
	iceBow.global_position.y -= iceBow.sprite_vertical_offset
	if direction_vector.x < 0:
		iceBow.global_position.x -= iceBow.sprite_horizontal_offset
		iceBow.face_left()
	else:
		iceBow.global_position.x += iceBow.sprite_horizontal_offset
		iceBow.face_right()
	state = CAST_ICE_ARROW

func disperse_ice_platform():
	get_tree().call_group("iceplatform", "shatterPlatform")

func ice_platform_summoned():
	play_idle_animation()
	state = RUN

func cast_ice_platform():
	velocity.x = 0
	play_cast_animation()
	state = CAST_ICE_PLATFORM

	var iceplatform = IcePlatform.instance()
	get_parent().add_child(iceplatform)
	iceplatform.global_position = iceplatformpos1
	iceplatform.playercom = true

	iceplatform = IcePlatform.instance()
	get_parent().add_child(iceplatform)
	iceplatform.global_position = iceplatformpos2

	iceplatform = IcePlatform.instance()
	get_parent().add_child(iceplatform)
	iceplatform.global_position = iceplatformpos3

func cast_ice_spike():
	velocity = Vector2.ZERO
	play_cast_animation()
	var iceSpike = IceSpike.instance()
	get_parent().add_child(iceSpike)
	cast_timer = iceSpike.CAST_DURATION
	iceSpike.global_position = global_position
	if direction_vector.x < 0:
		iceSpike.global_position.x -= iceSpike.sprite_horizontal_offset
		iceSpike.animatedSprite.play("Left")
	else:
		iceSpike.global_position.x += iceSpike.sprite_horizontal_offset
		iceSpike.animatedSprite.play("Right")
		iceSpike.left = false
	state = CAST_ICE_SPIKE

func cast_lightning():
	velocity = Vector2.ZERO
	play_cast_animation()
	var lightning = Lightning.instance()
	get_parent().add_child(lightning)
	cast_timer = lightning.CAST_DURATION
	lightning.global_position = global_position
	if direction_vector.x < 0:
		lightning.global_position.x -= lightning.sprite_horizontal_offset
		lightning.animatedSprite.play("Left")
	else:
		lightning.global_position.x += lightning.sprite_horizontal_offset
		lightning.animatedSprite.play("Right")
	state = CAST_LIGHTNING

func disable_hurt_boxes():
	for x in hurtBoxes:
		x.disabled = true

func disable_col_boxes():
	for x in colBoxes:
		x.disabled = true

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

func play_teleport_vanish_animation():
	disable_hurt_boxes()
	disable_col_boxes()
	if direction_vector.x < 0:
		animatedSprite.play("TeleportVanishLeft")
	else:
		animatedSprite.play("TeleportVanishRight")
	animatedSprite.set_frame(0)

func play_teleport_appear_animation():
	if direction_vector.x < 0:
		animatedSprite.play("TeleportAppearLeft")
	else:
		animatedSprite.play("TeleportAppearRight")
	animatedSprite.set_frame(0)

func play_air_animation():
	disable_hurt_boxes()
	disable_col_boxes()

	airColBox.disabled = false
	airHurtBox.disabled = false
	if direction_vector.x < 0 and velocity.y < 0:
		animatedSprite.play("JumpLeft")
	elif direction_vector.x < 0 and velocity.y >= 0:
		animatedSprite.play("FallLeft")
	elif direction_vector.x > 0 and velocity.y < 0:
		animatedSprite.play("JumpRight")
	else:
		animatedSprite.play("FallRight")

func play_free_fall_animation():
	disable_col_boxes()
	disable_hurt_boxes()

	freeFallColBox.disabled = false
	if direction_vector.x < 0:
		animatedSprite.play("FreeFallLeft")
	else:
		animatedSprite.play("FreeFallRight")

func play_getting_up_animation():
	disable_col_boxes()
	disable_hurt_boxes()

	if direction_vector.x < 0:
		idleRightColBox.disabled = false
		animatedSprite.play("GetUpLeft")
	else:
		idleRightColBox.disabled = false
		animatedSprite.play("GetUpRight")

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

func move(delta, grav):
	if grav:
		velocity.y += GRAVITY_ACCELERATION * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	else:
		velocity.y = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	get_tree().call_group("Enemies", "updatePlayerLocation", global_position)

func blackOut():
	blackedout = true
	disable_hurt_boxes()
	if is_on_floor():
		puke()
	else:
		start_free_fall()

func puke():
	velocity = Vector2.ZERO
	state = PUKE
	if direction_vector.x < 0:
		animatedSprite.play("PukeLeft")
	else:
		animatedSprite.play("PukeRight")

func _on_HurtBox_area_entered(_area):
	if not immune:
		get_tree().call_group("ConcentrationSpell", "spell_interrupt")
		get_tree().call_group("camera", "player_hit")
		health -= 1
		get_tree().call_group("health_bar", "set_health", health)
		if health <= 0:
			call_deferred("blackOut")
		elif is_on_floor():
			call_deferred("start_getting_up")
		else:
			call_deferred("start_free_fall")

func _on_AnimatedSprite_frame_changed():
	if state == PUKE and animatedSprite.get_frame() == 4:
		get_tree().call_group("gameoverscreen", "fadeIn")

func _on_AnimatedSprite_animation_finished():
	if state == GETUP:
		getUp()
	elif state == TELEPORTV:
		teleportProbe()
	elif state == TELEPORTA:
		call_deferred("teleportFinished")
