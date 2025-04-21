extends Resource
class_name FloorVariant

## Default Item Pool
var FALLBACK_REWARD_POOL := LazyLoader.defer("res://objects/items/pools/floor_clears.tres")
## Default Cog Pool
var FALLBACK_COG_POOL := LazyLoader.defer("res://objects/cog/presets/pools/grunt_cogs.tres")
## Amount of rooms to add per difficulty (includes connectors)
const DIFFICULTY_ROOM_ADDITION := 2

const ANOMALIES_POSITIVE: Array[String] = [
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_overheal.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_record_profits.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_organic_gags.gd"
	#"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_gag_immunities.gd",

]
const ANOMALIES_NEUTRAL: Array[String] = [
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_marathon.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_reorganization.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_volatile_market.gd"
]
const ANOMALIES_NEGATIVE: Array[String] = [
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_level_up.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_cog_damage_up.gd",
	"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_bull_market.gd"
	#"res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_out_of_touch.gd", dont un comment ts anom mid 
]

const LEVEL_RANGES: Dictionary = {
	0: [1, 3],
	1: [4, 5],# was 2 - 5, im thinking 4 - 5
	2: [6, 7], #was 3 - 7 im thinking 6 - 7
	3: [8, 9], #was 5 - 7 im thinking 8 - 9
	4: [10, 11], # was 7 - 12
	5: [12, 14],
}

## Floor difficulty from 0-5
@export_range(0, 5) var floor_difficulty := 0

## The department floor resource to pull rooms from
@export var floor_type: DepartmentFloor

## The name to display upon spawning in
@export var floor_name := "Facility"

## Item is granted upon floor completion
@export var reward_pool: ItemPool

## Cog pool to use for the floor
@export var cog_pool: CogPool

## If this floor variant should take you to a scene other than game floor.
@export var override_scene: PackedScene

## Floor modification scripts to run
@export var modifiers: Array[Script]

## Optional. For if a floor variant should have a different boss set than usual.
@export var end_rooms: Array[FacilityRoom]

## Alternative version of the floor
@export var alt_floor: FloorVariant

@export var floor_icon: Texture2D


## Local vars not saved to
var anomaly_count := 0
var level_range := Vector2i(1,12)
var reward: Item
var discard_item: Item
var room_count := 13
var anomalies: Array[Script] = []
var has_power_out := false

func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		# These fallbacks may never be realized, so we need to ensure
		# their LazyLoader threads are cleaned up.
		FALLBACK_REWARD_POOL.ensure_realized()
		FALLBACK_COG_POOL.ensure_realized()

func get_anomalies() -> Array[Script]:
	var mods: Array[Script] = []
	
	# Append a random amount of anomalies to the array
	var mod_count := RandomService.randi_range_channel('floor_mods', 0, 3)
	#var mod_count := 2
	# Apply potential item anomaly boost
	if Util.get_player() and Util.get_player().stats and Util.get_player().stats.anomaly_boost != 0:
		mod_count += Util.get_player().stats.anomaly_boost
	var anomaly_files_pos: Array[String] = ANOMALIES_POSITIVE.duplicate()
	var anomaly_files_neutral: Array[String] = ANOMALIES_NEUTRAL.duplicate()
	var anomaly_files_neg: Array[String] = ANOMALIES_NEGATIVE.duplicate()

	var no_negative_anomalies := false
	if Util.get_player() and Util.get_player().no_negative_anomalies:
		no_negative_anomalies = true
		anomaly_files_neg = []

	for i in mod_count:
		var rng_val := RandomService.randf_channel('floor_mods')
		var mod_array: Array[String]
		# Positive anomalies
		if rng_val <= 0.3333: #the real 1
		#if rng_val > 0.000000001:  #the fake
			mod_array = anomaly_files_pos
			if mod_array.size() == 0:
				mod_array = RandomService.array_pick_random('floor_mods', [anomaly_files_neutral, anomaly_files_neg])
		# Neutral anomalies
		elif rng_val <= 0.6666:
			mod_array = anomaly_files_neutral
			if mod_array.size() == 0:
				mod_array = RandomService.array_pick_random('floor_mods', [anomaly_files_pos, anomaly_files_neg])
		# Negative anomalies
		else:
			if no_negative_anomalies:
				continue

			mod_array = anomaly_files_neg
			if mod_array.size() == 0:
				mod_array = RandomService.array_pick_random('floor_mods', [anomaly_files_pos, anomaly_files_neutral])

		if mod_array.size() > 0:
			var new_mod: String = RandomService.array_pick_random('floor_mods', mod_array)
			var loaded_mod: Script = Util.universal_load(new_mod)
			if not loaded_mod in modifiers:
				mods.append(loaded_mod)
			mod_array.remove_at(mod_array.find(new_mod))

	return mods
func get_green_light_anomaly() -> Array[Script]:
	var mods: Array[Script] = []
	var new_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_green_light.gd" 
	var loaded_mod: Script = Util.universal_load(new_mod)
	mods.append(loaded_mod)
	return mods

func get_gag_immunity_anomaly() -> Array[Script]:
	var mods: Array[Script] = []
	var new_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_gag_immunities.gd" 
	var loaded_mod: Script = Util.universal_load(new_mod)
	mods.append(loaded_mod)
	return mods
func get_reorg_anomaly() -> Array[Script]:
	var mods: Array[Script] = []
	var new_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_reorganization.gd" 
	var loaded_mod: Script = Util.universal_load(new_mod)
	mods.append(loaded_mod)
	return mods
func get_no_anomaly() -> Array[Script]:
	var mods: Array[Script] = []
	return mods

func all_negative_anomalies() -> Array[Script]:
	var mods: Array[Script] = []
	for anomaly in ANOMALIES_NEGATIVE:
		var loaded_mod: Script = Util.universal_load(anomaly)
		mods.append(loaded_mod)
	var green_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_green_light.gd" 
	var loaded_green_mod: Script = Util.universal_load(green_mod)
	mods.append(loaded_green_mod)
	var immunity_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_gag_immunities.gd" 
	var loaded_immunity_mod: Script = Util.universal_load(immunity_mod)
	mods.append(loaded_immunity_mod)
	
	return mods
func all_positive_anomalies() -> Array[Script]:
	var mods: Array[Script] = []
	for anomaly in ANOMALIES_POSITIVE :
		var loaded_mod: Script = Util.universal_load(anomaly)
		mods.append(loaded_mod)
	var organic_mod: String = "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_organic_gags.gd" 
	var loaded_organic_mod: Script = Util.universal_load(organic_mod)
	mods.append(loaded_organic_mod) # adding it again so its easier
	return mods
func randomize_details() -> void:
	clear()
	
	anomalies = get_anomalies()
	anomaly_count = anomalies.size()

	for anomaly: Script in anomalies:
		modifiers.append(anomaly)
	
	floor_difficulty = Util.floor_number + 1
	level_range.x = LEVEL_RANGES[floor_difficulty][0]
	level_range.y = LEVEL_RANGES[floor_difficulty][1]
	
	# Add onto the room count for the difficulty
	room_count += DIFFICULTY_ROOM_ADDITION * floor_difficulty
	if floor_difficulty == 3: room_count = room_count * 1.2
	if room_count % 2 == 0:
		room_count += 1

	
	# Get the default Cog Pool if none specified
	if not cog_pool:
		cog_pool = FALLBACK_COG_POOL.load()

func randomize_item() -> void:
	if not reward_pool:
		reward_pool = FALLBACK_REWARD_POOL.load()
	reward = ItemService.get_random_item(reward_pool,true)
	if not reward.evergreen:
		discard_item = reward
	
	# Handle rerolls
	if not reward.s_reroll.is_connected(reward_rerolled):
		reward.s_reroll.connect(reward_rerolled)
	
	var model := reward.model.instantiate()
	model.hide()
	Util.add_child(model)
	if model.has_method("setup"):
		model.setup(reward)
	model.queue_free()

func reward_rerolled() -> void:
	randomize_item()

func clear() -> void:
	for i in range(anomalies.size() - 1, -1, -1):
		if modifiers.size() > i:
			modifiers.remove_at(i)
	anomalies.clear()

func scripted_details(anomaly_array) -> void:
	clear()
	anomalies = anomaly_array
	anomaly_count = anomaly_array.size()
	for anomaly: Script in anomaly_array:
		modifiers.append(anomaly)
	
	floor_difficulty = Util.floor_number + 1
	level_range.x = LEVEL_RANGES[floor_difficulty][0]
	level_range.y = LEVEL_RANGES[floor_difficulty][1]
	
	# Add onto the room count for the difficulty
	room_count += DIFFICULTY_ROOM_ADDITION * floor_difficulty
	if floor_difficulty == 3: room_count = room_count * 1.2
	if room_count % 2 == 0:
		room_count += 1
	print("FLOOR 3 MMMARAAAARTON")
	
	# Get the default Cog Pool if none specified
	if not cog_pool:
		cog_pool = FALLBACK_COG_POOL.load()
