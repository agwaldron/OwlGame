extends AnimatedSprite

func cast(facingLeft):
	if facingLeft:
		play("CastLeft")
	else:
		play("CastRight")

func fall(facingLeft):
	if facingLeft:
		play("FallLeft")
	else:
		play("FallRight")

func free_fall(facingLeft):
	if facingLeft:
		play("FreeFallLeft")
	else:
		play("FreeFallRight")

func get_up(facingLeft):
	if facingLeft:
		play("GetUpLeft")
	else:
		play("GetUpRight")

func idle(facingLeft):
	if facingLeft:
		play("IdleLeft")
	else:
		play("IdleRight")

func immune_flash(whiteOut):
	if whiteOut:
		material.set_shader_param("white", true)
	else:
		material.set_shader_param("white", false)

func jump(facingLeft):
	if facingLeft:
		play("JumpLeft")
	else:
		play("JumpRight")

func land(facingLeft):
	if facingLeft:
		play("LandLeft")
	else:
		play("LandRight")

func puke(facingLeft):
	if facingLeft:
		play("PukeLeft")
	else:
		play("PukeRight")

func run(facingLeft):
	if facingLeft:
		play("RunLeft")
	else:
		play("RunRight")

func teleport_appear(facingLeft):
	if facingLeft:
		play("TeleportAppearLeft")
	else:
		play("TeleportAppearRight")

func teleport_vanish(facingLeft):
	if facingLeft:
		play("TeleportVanishLeft")
	else:
		play("TeleportVanishRight")
