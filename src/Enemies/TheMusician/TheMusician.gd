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

var start_tied_delay = 100
var tied_middles_played = 0
var max_tied_middles = 4
var time_between_tieds = 7
var tied_place_marker = 0

var eighths_played = 0
var max_eighths = 3
var time_between_eighths = 100

var note_timer = 0

func _ready():
	stats.health = 20
	animatedSprite.play("PlayEighth")
	state = CHOOSE
	play_next_cool_down = PLAY_FREQ
	rngen.randomize()

func _process(delta):
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
			note_timer = start_tied_delay
			state = TIED
		else:
			animatedSprite.play("PlayEighth")
			eighths_played = 0
			tied_middles_played = 0
			note_timer = time_between_eighths
			state = EIGHTH

func tied_state(delta):
	note_timer -= (delta * 100)
	if tied_place_marker == 0:
		if note_timer <= 0:
			var tiedNoteStart = TiedNoteStart.instance()
			get_parent().add_child(tiedNoteStart)
			tiedNoteStart.global_position = global_position
			tiedNoteStart.global_position.x -= tiedNoteStart.sprite_horizontal_offset
			tiedNoteStart.global_position.y -= tiedNoteStart.sprite_vertical_offset
			tiedNoteStart.velocity.x = tiedNoteStart.SPEED * -1
			tied_place_marker += 1
			note_timer = time_between_tieds
	elif tied_place_marker == 1:
		if note_timer <= 0:
			var tiedNoteMiddle = TiedNoteMiddle.instance()
			get_parent().add_child(tiedNoteMiddle)
			tiedNoteMiddle.global_position = global_position
			tiedNoteMiddle.global_position.x -= tiedNoteMiddle.sprite_horizontal_offset
			tiedNoteMiddle.global_position.y -= tiedNoteMiddle.sprite_vertical_offset
			tiedNoteMiddle.velocity.x = tiedNoteMiddle.SPEED * -1
			tied_middles_played += 1
			if tied_middles_played >= max_tied_middles:
				tied_place_marker += 1
			note_timer = time_between_tieds
	else:
		if note_timer <= 0:
			var tiedNoteEnd = TiedNoteEnd.instance()
			get_parent().add_child(tiedNoteEnd)
			tiedNoteEnd.global_position = global_position
			tiedNoteEnd.global_position.x -= tiedNoteEnd.sprite_horizontal_offset
			tiedNoteEnd.global_position.y -= tiedNoteEnd.sprite_vertical_offset
			tiedNoteEnd.velocity.x = tiedNoteEnd.SPEED * -1
			tied_place_marker = 0
			tied_middles_played = 0
			play_next_cool_down = PLAY_FREQ
			state = CHOOSE

func eighth_state(delta):
	if eighths_played < max_eighths:
		note_timer -= (delta * 100)
		if note_timer <= 0:
			var eighthNote = EighthNote.instance()
			get_parent().add_child(eighthNote)
			eighthNote.global_position = global_position
			eighthNote.global_position.x -= eighthNote.sprite_horizontal_offset
			eighthNote.global_position.y -= eighthNote.sprite_vertical_offset
			eighthNote.velocity.x = eighthNote.SPEED * -1
			eighths_played += 1
			note_timer = time_between_eighths
	else:
		play_next_cool_down = PLAY_FREQ
		eighths_played = 0
		state = CHOOSE

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
