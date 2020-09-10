extends Camera2D

var playerHitShake = 5.0
var playerHitTimer = 20

var bombDropShake = 15.0
var bombDropTimer = 40

var shakeAmount
var shakeTimer = 0

func _process(delta):
	if shakeTimer > 0:
		shakeTimer -= (delta * 100)
		set_offset(Vector2(
			rand_range(-1.0, 1.0) * shakeAmount,
			rand_range(-1.0, 1.0) * shakeAmount
		))
	else:
		set_offset(Vector2.ZERO)

func player_hit():
	shakeAmount = playerHitShake
	shakeTimer = playerHitTimer

func bomb_explode():
	shakeAmount = bombDropShake
	shakeTimer = bombDropTimer
