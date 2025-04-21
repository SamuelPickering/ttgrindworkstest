extends FloorModifier

var loadout : GagLoadout


func modify_floor() -> void:
	var player := Util.get_player()
	
	if not player:
		return
	
	# Save a copy of the base gag loadout
	loadout = player.stats.character.gag_loadout.duplicate()
	print("in reorg: loadout: ")
	print(loadout.loadout)
	print(loadout.loadout[0].track_name)
	RandomService.array_shuffle_channel('anomaly_reorg',player.stats.character.gag_loadout.loadout)
	var gag_list = player.stats.character.gag_loadout.loadout
		# Find indexes of "Trap" and "Lure"
	var trap_index := -1
	var lure_index := -1

	for i in range(gag_list.size()):
		if gag_list[i].track_name == "Trap":
			trap_index = i
			print(i)
		elif gag_list[i].track_name == "Lure":
			lure_index = i
			print("in rorg lure index: ", i)

	# If both exist and Trap is after Lure, swap them
	if trap_index != -1 and lure_index != -1 and trap_index > lure_index:
		var temp = gag_list[trap_index]
		gag_list[trap_index] = gag_list[lure_index]
		gag_list[lure_index] = temp

# Save the adjusted list back into the loadout


# Debug prints
	print("Shuffled Loadout:")
	for gag in gag_list:
		print(gag.track_name)
	

func clean_up() -> void:
	if not loadout:
		return
	# Restore previous loadout
	var player := Util.get_player()
	player.stats.character.gag_loadout = loadout

func get_mod_name() -> String:
	return "Reorganization"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Reorganization.png")

func get_description() -> String:
	return "Gag tracks are randomly shuffled"
