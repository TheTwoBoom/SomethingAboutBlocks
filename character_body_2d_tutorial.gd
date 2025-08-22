extends CharacterBody2D

var GRAVITY = 0
@export var speed = 400 # How fast the player will move (pixels/sec).
@onready var sprite = %CharacterSprite2D
@onready var start_text = %StartTextLabel
@onready var points_text = %PointsTextLabel
@onready var rootNode = get_node("/root/Tutorial/")
var screen_size # Size of the game window.
var points = 0
var type = "BlockGap2D"
var started = false
var next_texture = 0

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float):
	velocity = Vector2.ZERO
	velocity.y += delta * GRAVITY
	move_and_slide()
	if !started:
		return
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed
	else:
		velocity.x = 0

func _process(delta: float):	
	if position.y >= screen_size.y + 100:
		position.y = -100

func gap_handler(area: Area2D, areatype: String):
	if areatype != type or area.filled:
		return
	match areatype:
		"BlockGap2D":
			points+= 1
		"CircleGap2D":
			points+= 2
		"HexGap2D":
			points+= 3
	#area.queue_free()
	update_points()
	reset_player(next_texture)
	next_texture = generate_texture()
	fill_gap(area, areatype)

func reset_player(nextTexture: int):
	GRAVITY = 0
	position.y = -50

func generate_texture():
	var texture_index = randi_range(0, 2)
	match texture_index:
		0:
			if rootNode.gapArray[0] <= 1:
				generate_texture()
				return
			rootNode.gapArray[0] -= 1
		1:
			if rootNode.gapArray[1] <= 1:
				generate_texture()
				return
			rootNode.gapArray[1] -= 1
		2:
			if rootNode.gapArray[2] <= 1:
				generate_texture()
				return
			rootNode.gapArray[2] -= 1
	return texture_index

func fill_gap(area: Area2D, areatype: String):
	area.filled = true
	var areasprite
	for child in area.get_children():
		if child is Sprite2D:
			areasprite = child
			break
	match areatype:
		"BlockGap2D":
			areasprite.texture = load('res://block_gap_filled.svg')
		"CircleGap2D":
			areasprite.texture = load('res://circle_gap_filled.svg')
		"HexGap2D":
			areasprite.texture = load('res://hex_gap_filled.svg')
	rootNode.check_rows()

func update_points():
	print(points)
	points_text.text = "Points: " + str(points)

func _on_block_gap_2d_body_entered(body: Node2D) -> void:
	gap_handler(body, "BlockGap2D")

func _on_circle_gap_2d_body_entered(body: Node2D) -> void:
	gap_handler(body, "CircleGap2D")

func _on_hex_gap_2d_body_entered(body: Node2D) -> void:
	gap_handler(body, "HexGap2D")
