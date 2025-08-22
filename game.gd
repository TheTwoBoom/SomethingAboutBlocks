extends Node2D
@onready var block_gap = %BlockGap2D
@onready var circle_gap = %CircleGap2D
@onready var hex_gap = %HexGap2D
@onready var player = %CharacterBody2D
var gapArray = [0, 0, 0]

func _ready():
	fill_gameboard()

func _process(delta: float):
	if !gap_check():
		fill_gameboard()

func check_rows():
	var rows := {}
	var cols := {}
	var patterns := []  # Hier kannst du Muster definieren, z.B. [[0,1,0],[1,1,1],[0,1,0]]

	# Alle Gaps in Zeilen und Spalten einsortieren
	for child in get_children():
		if child is Area2D and "filled" in child:
			var y := int(child.position.y)
			var x := int(child.position.x)

			if not rows.has(y):
				rows[y] = []
			rows[y].append(child)

			if not cols.has(x):
				cols[x] = []
			cols[x].append(child)

	# Jede Zeile prüfen
	for y in rows.keys():
		var line = rows[y]
		var full := true
		var type_count := {}
		for gap in line:
			if not gap.filled:
				full = false
			else:
				if not type_count.has(gap.type):
					type_count[gap.type] = 0
				type_count[gap.type] += 1

		if full:
			# Punkte für volle Zeile
			player.points += 10
			for gap in line:
				remove_gap_with_effect(gap)
			
			# Bonus prüfen: 3 gleiche Blöcke in der Reihe
			for type in type_count.keys():
				if type_count[type] >= 3:
					player.points += 5  # Bonuspunkte
					print("Bonus für 3 gleiche Blöcke vom Typ ", type)

	# Jede Spalte prüfen (optional, falls du auch vertikal Muster willst)
	for x in cols.keys():
		var col = cols[x]
		var full := true
		for gap in col:
			if not gap.filled:
				full = false
				break
		if full:
			player.points += 10
			for gap in col:
				remove_gap_with_effect(gap)

	# Musterprüfung (optional)
	for pattern in patterns:
		# Logik zum Überprüfen vordefinierter Muster auf dem Spielfeld
		pass

func gap_check():
	for child in get_children():
		if child is Area2D and "filled" in child:
			return true
	return false

func fill_gameboard():
	for y in range(10):
		for x in range(8):
			var clone
			match randi_range(0, 2):
				0:
					clone = block_gap.duplicate()
					gapArray[0] += 1
				1:
					clone = circle_gap.duplicate()
					gapArray[1] += 1
				2:
					clone = hex_gap.duplicate()
					gapArray[2] += 1
			clone.position.x = 64*x+700
			clone.position.y = 64*y+200 + 128
			add_child(clone)
			move_child(clone, 0)

func remove_gap_with_effect(gap: Node2D):
	var tween := create_tween()
	tween.tween_property(gap, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(gap, "modulate:a", 0.0, 0.3)
	tween.tween_callback(Callable(gap, "queue_free"))
