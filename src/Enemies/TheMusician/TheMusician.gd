extends KinematicBody2D

export var PLAY_FREQ = 200

enum{
	CHOOSE,
	TIED,
	EIGHTH
}

const EighthNote = preload("res://src/Enemies/TheMusician/Notes/EighthNote.tscn")
const TiedNoteStart = preload("res://src/Enemies/TheMusician/Notes/TiedNoteStart.tscn")
const TiedNoteMiddle = preload("res://src/Enemies/TheMusician/Notes/TiedNoteMiddle.tscn")
const TiedNoteEnd = preload("res://src/Enemies/TheMusician/Notes/TiedNoteEnd.tscn")

onready var stats = $EnemyStats
onready var animatedSprite = $AnimatedSprite

var state
var play_next_cool_down
var rngen = RandomNumberGenerator.new()

var hitFlashDuration = 8
var hitFlashTimer = 0
var hitFlashFlag = false
var startTiedDelay = 100
var tiedMiddlesPlayed = 0
var maxTiedMiddles = 5
var timeBetweenTieds = 7
var tiedPlaceMarker = 0
var eighthsPlayed = 0
var maxEighths = 5
var timeBetweenEighths = 125
var noteTimer = 0

func _ready():
	stats.health = 20
	animatedSprite.play("PlayEighth")
	state = CHOOSE
	play_next_cool_down = PLAY_FREQ
	rngen.randomize()

func _process(delta):
	if hitFlashFlag:
		hit_flash_countdown(delta)
	match state:
		CHOOSE:
			choose_note(delta)
		TIED:
			tied_state(delta)
		EIGHTH:
			eighth_state(delta)

func choose_note(delta):
	play_next_cool_down -= (delta * 100)
	if play_next_cool_down <= 0:
		var rand_num = rngen.randi_range(0, 1)
		if rand_num == 0:
			animatedSprite.play("PlayTied")
			noteTimer = startTiedDelay
			state = TIED
		else:
			animatedSprite.play("PlayEighth")
			eighthsPlayed = 0
			tiedMiddlesPlayed = 0
			noteTimer = timeBetweenEighths
			state = EIGHTH

func tied_state(delta):
	noteTimer -= (delta * 100)
	if tiedPlaceMarker == 0:
		if noteTimer <= 0:
			var tiedNoteStart = TiedNoteStart.instance()
			get_parent().add_child(tiedNoteStart)
			tiedNoteStart.global_position = global_position
			tiedNoteStart.global_position.x -= tiedNoteStart.spriteHorizontalOffset
			tiedNoteStart.global_position.y -= tiedNoteStart.spriteVerticalOffset
			tiedNoteStart.velocity.x = tiedNoteStart.SPEED * -1
			tiedPlaceMarker += 1
			noteTimer = timeBetweenTieds
	elif tiedPlaceMarker == 1:
		if noteTimer <= 0:
			var tiedNoteMiddle = TiedNoteMiddle.instance()
			get_parent().add_child(tiedNoteMiddle)
			tiedNoteMiddle.global_position = global_position
			tiedNoteMiddle.global_position.x -= tiedNoteMiddle.spriteHorizontalOffset
			tiedNoteMiddle.global_position.y -= tiedNoteMiddle.spriteVerticalOffset
			tiedNoteMiddle.velocity.x = tiedNoteMiddle.SPEED * -1
			tiedMiddlesPlayed += 1
			if tiedMiddlesPlayed >= maxTiedMiddles:
				tiedPlaceMarker += 1
			noteTimer = timeBetweenTieds
	else:
		if noteTimer <= 0:
			var tiedNoteEnd = TiedNoteEnd.instance()
			get_parent().add_child(tiedNoteEnd)
			tiedNoteEnd.global_position = global_position
			tiedNoteEnd.global_position.x -= tiedNoteEnd.spriteHorizontalOffset
			tiedNoteEnd.global_position.y -= tiedNoteEnd.spriteVerticalOffset
			tiedNoteEnd.velocity.x = tiedNoteEnd.SPEED * -1
			tiedPlaceMarker = 0
			tiedMiddlesPlayed = 0
			play_next_cool_down = PLAY_FREQ
			state = CHOOSE

func eighth_state(delta):
	if eighthsPlayed < maxEighths:
		noteTimer -= (delta * 100)
		if noteTimer <= 0:
			var eighthNote = EighthNote.instance()
			get_parent().add_child(eighthNote)
			eighthNote.global_position.x = global_position.x - eighthNote.spriteHorizontalOffset
			eighthNote.global_position.y = rand_range(eighthNote.maxHeight, eighthNote.minHeight)
			eighthNote.velocity = Vector2(eighthNote.HORIZONTAL_SPEED, eighthNote.VERTICAL_SPEED)
			eighthsPlayed += 1
			noteTimer = timeBetweenEighths
	else:
		play_next_cool_down = PLAY_FREQ
		eighthsPlayed = 0
		state = CHOOSE

func hit_flash_countdown(delta):
	if hitFlashTimer <= 0:
		hitFlashFlag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitFlashTimer -= delta * 100

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			hitFlashTimer = hitFlashDuration
			hitFlashFlag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
