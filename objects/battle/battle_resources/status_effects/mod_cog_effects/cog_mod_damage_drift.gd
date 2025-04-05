@tool
extends StatusEffect
var debuff_turn_index = 0
var buff_turn_index = 0
signal s_gag_modified(indexes: Array)  # New signal
var effectdict = {}

func apply() -> void:
	var cog: Cog = target
	var playerturns = Util.get_player().stats.turns
	print(playerturns)
	debuff_turn_index = randi_range(0, playerturns - 1)
	buff_turn_index = randi_range(0, playerturns - 1)
	print(debuff_turn_index, " sec ", buff_turn_index)
	print("APPLIED DAMAGE DRIFT")
	effectdict[debuff_turn_index] = 0.5
	effectdict[buff_turn_index] = 1.2
	print("ui sledected gags? line 15")
	
	manager.s_gags_chosen.connect(on_gags_chosen)


func on_gags_chosen(actions: Array[ToonAttack]) -> void:
	print("line 20 on damage drift")
	if(actions.size() -1 >= debuff_turn_index):
		print("pre nerf: ", actions[debuff_turn_index].damage,"damage on", actions[debuff_turn_index].action_name)
		actions[debuff_turn_index].damage *= 0.5
		print("After, ", actions[debuff_turn_index].damage)
	if(actions.size() -1 >= buff_turn_index):
		print("pre buff: ", actions[buff_turn_index].damage,"damage on", actions[buff_turn_index].action_name)
		actions[buff_turn_index].damage *= 1.2
		print("After, ", actions[buff_turn_index].damage)
	s_gag_modified.emit([debuff_turn_index, buff_turn_index])

func renew() -> void:
	var playerturns = Util.get_player().stats.turns
	debuff_turn_index = randi_range(0, playerturns - 1)
	buff_turn_index = randi_range(0, playerturns - 1)
	
func cleanup() -> void:
	manager.s_gags_chosen.disconnect(on_gags_chosen)

func get_status_name() -> String:
	return "Damage Drift"

func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/pinpoint_accuracy.png")
