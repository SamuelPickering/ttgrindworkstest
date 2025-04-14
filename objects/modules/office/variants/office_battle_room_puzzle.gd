extends Node3D

@export var puzzles : Array[Node3D]

func _ready() -> void:
	for node in puzzles:
		var puzzle := Globals.random_puzzle
		puzzle.grid_height = 6
		puzzle.grid_width = 6
		if puzzle is PuzzleSkullFinder:
			if puzzle.get("bombs") != null:
				print("why tf did this crash")
				puzzle.bombs = 5
			else:
				print("This bomb shit pmo")
		node.add_child(puzzle)
		node.get_node('CogButton').connect_to(puzzle)
		puzzle.lose_battle = node.get_node('BattleNode')
