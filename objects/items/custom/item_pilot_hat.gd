extends ItemScript

const DMG_BONUS := 1.5

var turns_used = 0
var activate_turn = 5
var damage_multiplied = false
var dmg_sum := 0.0

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(refresh_turns)
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_action_finished.connect(on_action_finished)
	BattleService.s_round_ended.connect(on_round_ended)
	

func on_action_started(action: BattleAction) -> void:
	if action is ToonAttack:
		turns_used += 1
		if turns_used % activate_turn == 0:
			action.damage = action.damage * DMG_BONUS
			action.store_boost_text("Pilot Boost!", Color(0.466, 0.663, 0.935))
			damage_multiplied = true

func refresh_turns() -> void:
	turns_used = 0
	print("refreshing pilot hat turns")

func on_action_finished(action: BattleAction) -> void:
	if damage_multiplied:
		print(action.action_name, " last action had its damage multiplied")
		damage_multiplied = false

func on_round_ended(manager: BattleManager) -> void:
	var turns_remaining_in_cycle = activate_turn - (turns_used % activate_turn)
	var activation_turn_next_round = turns_remaining_in_cycle - 1     
	if turns_remaining_in_cycle <= Util.get_player().stats.max_turns:
		var dict = {}
		dict[activation_turn_next_round] = DMG_BONUS
		manager.battle_ui.s_damage_drifted.emit(dict)
		print(activation_turn_next_round)
	print(activation_turn_next_round)
