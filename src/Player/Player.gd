extends KinematicBody2D

export var MAX_FALL_SPEED = 500
export var JUMP_SPEED = -600
export var GRAV_ACCELERATION = 2500
export var MIN_JUMP_DURATION = 10
export var MAX_JUMP_DURATION = 25
export var HANG_TIME_DURATION = 3
#export var AIR_ACCELERATION = 600
#export var MAX_AIR_SPEED = 250
#export var RUN_ACCELERATION = 600
#export var MAX_RUN_SPEED = 300
#export var FRICTION = 800
export var HORIZONTAL_SPEED = 275
export var TELEPORT_COOLDOWN = 75

enum {
	RUN,
	TELEPORT_APPEAR,
	TELEPORT_VANISH,
	AIR_RISE,
	HANG_TIME,
	AIR_FALL,
	FREE_FALL,
	LAND,
	GET_UP,
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
# onready var runLeftColBox = $RunLeftCollisionShape
# onready var runLeftHurtBox = $RunLeftHurtBox/CollisionShape2D
# onready var runRightColBox = $RunRightCollisionShape
# onready var runRightHurtBox = $RunRightHurtBox/CollisionShape2D
onready var runColBox = $RunCollisionShape
onready var runHurtBox = $RunHurtBox/CollisionShape2D

var health = 5
var blackedOut = false
var immune = false
var immuneDuration = 75
var immuneTimer
var state = RUN
var velocity = Vector2.ZERO
var directionVector = Vector2.RIGHT
#var maxjumpduration = 40
#var minjumpduration = 25
var curJumpTimer
var jumpReleased = false
#var maxjumpspeed = 500
#var jumpacceleration = 4500
#var maxfallspeed = 650
#var fallacceleration = 2500
#var airhangtimeduration = 3
var airHangTimeTimer = 0
var teleportTimer = 0
var blinkTimer
var blinkTimerWhite = 10
var blinkTimerReg = 30
var blinkFlag = false
var castTimer = 0
var iceArrowCooldown = 125
var iceArrowTimer = 0
var iceSpikeCooldown = 100
var iceSpikeTimer = 0
var fireBallChargesMax = 3
var fireBallCharges = fireBallChargesMax
var fireBallRechargeCooldown = 125
var fireBallRechargeTimer = fireBallRechargeCooldown
var icePlatformPosition1 = Vector2(400, 575)
var icePlatformPosition2 = Vector2(600, 400)
var icePlatformPosition3 = Vector2(800, 575)

var hurtBoxes
var colBoxes

func _ready():
	colBoxes = [airColBox, castLeftColBox, castRightColBox, freeFallColBox,
				idleLeftColBox, idleRightColBox, runColBox]
	hurtBoxes = [airHurtBox, castLeftHurtBox, castRightHurtBox,
				idleLeftHurtBox, idleRightHurtBox, runHurtBox]
	idleRightColBox.disabled = false
	idleRightHurtBox.disabled = false
	get_tree().call_group("HUD", "setMaxHealth", health)
	z_index = 1

func _physics_process(delta):
	run_cool_down_timers(delta)
	match state:
		RUN:
			run_state(delta)
		AIR_RISE:
			air_rise_state(delta)
		HANG_TIME:
			hang_time_state(delta)
		AIR_FALL:
			air_fall_state(delta)
		LAND:
			land_state(delta)
		FREE_FALL:
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

func run_cool_down_timers(delta):
	if immune:
		blinkTimer -= (delta * 100)
		if blinkTimer <= 0:
			if blinkFlag:
				blinkFlag = false
				blinkTimer = blinkTimerReg
				animatedSprite.material.set_shader_param("white", false)
			else:
				blinkFlag = true
				blinkTimer = blinkTimerWhite
				animatedSprite.material.set_shader_param("white", true)

		immuneTimer -= (delta * 100)
		if immuneTimer <= 0:
			immune = false
			animatedSprite.material.set_shader_param("white", false)
	teleportTimer -= (delta * 100)
	iceArrowTimer -= (delta * 100)
	iceSpikeTimer -= (delta * 100)
	if fireBallCharges < fireBallChargesMax:
		fireBallRechargeTimer -= (delta * 100)
		if fireBallRechargeTimer <= 0:
			fireBallCharges += 1
			fireBallRechargeTimer = fireBallRechargeCooldown

func run_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		directionVector.x = input_vector.x
		#velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
		velocity = input_vector * HORIZONTAL_SPEED
		play_running_animation()
	else:
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity = input_vector
		play_idle_animation()

	move(delta, true)

	if not is_on_floor():
		state = AIR_FALL

	if Input.is_action_just_pressed("teleport") and teleportTimer <= 0:
		teleport_action()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_action()

	if Input.is_action_just_pressed("fireball") and fireBallCharges > 0:
		cast_fire()

	if Input.is_action_just_pressed("icespike") and is_on_floor() and iceSpikeTimer <= 0:
		cast_ice_spike()

	if Input.is_action_just_pressed("icearrow") and is_on_floor() and iceArrowTimer <= 0:
		cast_ice_arrow()

	if Input.is_action_just_pressed("lightning") and is_on_floor():
		cast_lightning()

func air_rise_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		directionVector.x = input_vector.x
		#velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
		velocity.x = input_vector.x * HORIZONTAL_SPEED
		play_air_rise_animation()
	else:
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity.x = input_vector.x
		play_air_rise_animation()

	curJumpTimer += (delta * 100)
	if not jumpReleased:
		if Input.is_action_just_released("jump") or curJumpTimer >= MAX_JUMP_DURATION:
			jumpReleased = true

	if jumpReleased and curJumpTimer >= MIN_JUMP_DURATION:
		if velocity.y >= 0:
			velocity.y = 0
			airHangTimeTimer = 0
			state = HANG_TIME
		else:
			move(delta, true)
	else:
		#velocity.y -= (jumpacceleration * delta)
		#velocity.y = max(velocity.y, (-1*maxjumpspeed))
		move(delta, false)

	if Input.is_action_just_pressed("teleport") and teleportTimer <= 0:
		teleport_action()

	if Input.is_action_just_pressed("fireball") and fireBallCharges > 0:
		cast_fire()

func hang_time_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		directionVector.x = input_vector.x
		#velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
		velocity.x = input_vector.x * HORIZONTAL_SPEED
		play_air_fall_animation()
	else:
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity.x = input_vector.x
		play_air_fall_animation()

	airHangTimeTimer += (delta * 100)
	if airHangTimeTimer >= HANG_TIME_DURATION:
		state = AIR_FALL
		move(delta, true)
	else:
		move(delta, false)

	if Input.is_action_just_pressed("teleport") and teleportTimer <= 0:
		teleport_action()

	if Input.is_action_just_pressed("fireball") and fireBallCharges > 0:
		cast_fire()

func air_fall_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		directionVector.x = input_vector.x
		#velocity = velocity.move_toward(input_vector * MAX_RUN_SPEED, RUN_ACCELERATION * delta)
		velocity.x = input_vector.x * HORIZONTAL_SPEED
		play_air_fall_animation()
	else:
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity.x = input_vector.x
		play_air_fall_animation()

	if is_on_floor():
		state = LAND
		if directionVector.x < 0:
			animatedSprite.play("LandLeft")
		else:
			animatedSprite.play("LandRight")
		animatedSprite.set_frame(0)
	else:
		move(delta, true)

	if Input.is_action_just_pressed("teleport") and teleportTimer <= 0:
		teleport_action()

	if Input.is_action_just_pressed("fireball") and fireBallCharges > 0:
		cast_fire()

func land_state(delta):
	#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_vector.x * HORIZONTAL_SPEED
	move(delta, false)

func free_fall_state(delta):
	if is_on_floor():
		start_getting_up()
	else:
		move(delta, true)

func cast_fire_state(delta):
	castTimer -= (delta * 100)
	if castTimer <= 0:
		castTimer = 0
		if is_on_floor():
			state = RUN
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
	castTimer -= (delta * 100)
	if castTimer <= 0:
		castTimer = 0
		state = RUN

func cast_lightning_state(delta):
	castTimer -= (delta * 100)
	if castTimer <= 0:
		castTimer = 0
		state = RUN

func teleport_action():
	play_teleport_vanish_animation()
	velocity = Vector2.ZERO
	state = TELEPORT_VANISH

func teleport_probe():
	var teleportProbe = TeleportProbe.instance()
	get_parent().add_child(teleportProbe)
	teleportProbe.global_position = global_position
	if directionVector.x < 0:
		teleportProbe.faceLeft()

func teleport_move(pos):
	global_position = pos
	get_tree().call_group("Enemies", "update_player_location", global_position)

func teleport_appear(pos):
	play_teleport_appear_animation()
	global_position = pos
	state = TELEPORT_APPEAR

func teleport_finished():
	teleportTimer = TELEPORT_COOLDOWN
	if is_on_floor():
		play_idle_animation()
		state = RUN
	else:
		play_air_fall_animation()
		airHangTimeTimer = 0
		state = HANG_TIME

func jump_action():
	play_air_rise_animation()
	jumpReleased = false
	curJumpTimer = 0
	velocity.y = JUMP_SPEED
	state = AIR_RISE

func start_free_fall():
	immune = true
	immuneTimer = immuneDuration
	velocity = Vector2.ZERO
	play_free_fall_animation()
	state = FREE_FALL

func start_getting_up():
	immune = true
	immuneTimer = immuneDuration
	velocity = Vector2.ZERO
	play_getting_up_animation()
	state = GET_UP

func get_up():
	if blackedOut:
		puke()
	else:
		play_idle_animation()
		immuneTimer = immuneDuration
		state = RUN

func cast_fire():
	if is_on_floor():
		velocity.x = 0
		play_cast_animation()
		state = CAST_FIRE
	fireBallCharges -= 1
	var fireBall = FireBall.instance()
	get_parent().add_child(fireBall)
	fireBall.global_position = global_position
	fireBall.global_position.y -= fireBall.spriteVerticalOffset
	castTimer = fireBall.CAST_DURATION
	if directionVector.x < 0:
		fireBall.global_position.x -= fireBall.spriteHorizontalOffset
		fireBall.velocity.x = directionVector.x * fireBall.SPEED
		fireBall.animatedSprite.play("Left")
	else:
		fireBall.global_position.x += fireBall.spriteHorizontalOffset
		fireBall.animatedSprite.play("Right")

func cast_ice_arrow():
	velocity = Vector2.ZERO
	iceArrowTimer = iceArrowCooldown
	play_cast_animation()
	var iceBow = IceBow.instance()
	get_parent().add_child(iceBow)
	iceBow.global_position = global_position
	iceBow.global_position.y -= iceBow.spriteVerticalOffset
	if directionVector.x < 0:
		iceBow.global_position.x -= iceBow.spriteHorizontalOffset
		iceBow.face_left()
	else:
		iceBow.global_position.x += iceBow.spriteHorizontalOffset
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

	var icePlatform = IcePlatform.instance()
	get_parent().add_child(icePlatform)
	icePlatform.global_position = icePlatformPosition1
	icePlatform.playerCom = true

	icePlatform = IcePlatform.instance()
	get_parent().add_child(icePlatform)
	icePlatform.global_position = icePlatformPosition2

	icePlatform = IcePlatform.instance()
	get_parent().add_child(icePlatform)
	icePlatform.global_position = icePlatformPosition3

func cast_ice_spike():
	velocity = Vector2.ZERO
	iceSpikeTimer = iceSpikeCooldown
	play_cast_animation()
	var iceSpike = IceSpike.instance()
	get_parent().add_child(iceSpike)
	castTimer = iceSpike.CAST_DURATION
	iceSpike.global_position = global_position
	if directionVector.x < 0:
		iceSpike.global_position.x -= iceSpike.spriteHorizontalOffset
		iceSpike.animatedSprite.play("Left")
	else:
		iceSpike.global_position.x += iceSpike.spriteHorizontalOffset
		iceSpike.animatedSprite.play("Right")
		iceSpike.left = false
	state = CAST_ICE_SPIKE

func cast_lightning():
	velocity = Vector2.ZERO
	play_cast_animation()
	var lightning = Lightning.instance()
	get_parent().add_child(lightning)
	castTimer = lightning.CAST_DURATION
	lightning.global_position = global_position
	if directionVector.x < 0:
		lightning.global_position.x -= lightning.spriteHorizontalOffset
		lightning.animatedSprite.play("Left")
	else:
		lightning.global_position.x += lightning.spriteHorizontalOffset
		lightning.animatedSprite.play("Right")
	state = CAST_LIGHTNING

func disable_col_boxes():
	for x in colBoxes:
		x.disabled = true

func disable_hurt_boxes():
	for x in hurtBoxes:
		x.disabled = true

func play_idle_animation():
	disable_hurt_boxes()
	disable_col_boxes()
	if directionVector.x < 0:
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
	runColBox.disabled = false
	runHurtBox.disabled = false
	if directionVector.x < 0:
		animatedSprite.play("RunLeft")
	else:
		animatedSprite.play("RunRight")

func play_teleport_vanish_animation():
	disable_hurt_boxes()
	disable_col_boxes()
	if directionVector.x < 0:
		animatedSprite.play("TeleportVanishLeft")
	else:
		animatedSprite.play("TeleportVanishRight")
	animatedSprite.set_frame(0)

func play_teleport_appear_animation():
	if directionVector.x < 0:
		animatedSprite.play("TeleportAppearLeft")
	else:
		animatedSprite.play("TeleportAppearRight")
	animatedSprite.set_frame(0)

func play_air_rise_animation():
	disable_col_boxes()
	disable_hurt_boxes()
	airColBox.disabled = false
	airHurtBox.disabled = false
	if directionVector.x < 0:
		animatedSprite.play("JumpLeft")
	else:
		animatedSprite.play("JumpRight")

func play_air_fall_animation():
	disable_col_boxes()
	disable_hurt_boxes()
	airColBox.disabled = false
	airHurtBox.disabled = false
	if directionVector.x < 0:
		animatedSprite.play("FallLeft")
	else:
		animatedSprite.play("FallRight")

func play_free_fall_animation():
	disable_col_boxes()
	disable_hurt_boxes()
	freeFallColBox.disabled = false
	if directionVector.x < 0:
		animatedSprite.play("FreeFallLeft")
	else:
		animatedSprite.play("FreeFallRight")

func play_getting_up_animation():
	disable_col_boxes()
	disable_hurt_boxes()
	if directionVector.x < 0:
		idleRightColBox.disabled = false
		animatedSprite.play("GetUpLeft")
	else:
		idleRightColBox.disabled = false
		animatedSprite.play("GetUpRight")

func play_cast_animation():
	disable_hurt_boxes()
	disable_col_boxes()
	if directionVector.x < 0:
		castLeftColBox.disabled = false;
		castLeftHurtBox.disabled = false;
		animatedSprite.play("CastLeft")
	else:
		castRightColBox.disabled = false;
		castRightHurtBox.disabled = false;
		animatedSprite.play("CastRight")

func move(delta, grav):
	if grav:
		velocity.y += GRAV_ACCELERATION * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	velocity = move_and_slide(velocity, Vector2.UP)
	get_tree().call_group("Enemies", "update_player_location", global_position)

func black_out():
	blackedOut = true
	disable_hurt_boxes()
	if is_on_floor():
		puke()
	else:
		start_free_fall()

func puke():
	velocity = Vector2.ZERO
	state = PUKE
	if directionVector.x < 0:
		animatedSprite.play("PukeLeft")
	else:
		animatedSprite.play("PukeRight")

func _on_HurtBox_area_entered(_area):
	if not immune:
		get_tree().call_group("ConcentrationSpell", "spell_interrupt")
		get_tree().call_group("camera", "player_hit")
		health -= 1
		get_tree().call_group("HUD", "setHealth", health)
		if health <= 0:
			call_deferred("black_out")
		else:
			blinkFlag = true
			blinkTimer = blinkTimerWhite
			animatedSprite.material.set_shader_param("white", true)
			if is_on_floor():
				call_deferred("start_getting_up")
			else:
				call_deferred("start_free_fall")

func _on_AnimatedSprite_frame_changed():
	if state == PUKE and animatedSprite.get_frame() == 4:
		get_tree().call_group("HUD", "gameOver")

func _on_AnimatedSprite_animation_finished():
	if state == LAND:
		state = RUN
	elif state == GET_UP:
		get_up()
	elif state == TELEPORT_VANISH:
		teleport_probe()
	elif state == TELEPORT_APPEAR:
		call_deferred("teleport_finished")
