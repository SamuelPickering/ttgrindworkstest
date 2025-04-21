extends ItemScript

const DMG_BONUS := 1.3

var turns_used = 0
var activate_turn = 7

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_battle_started.connect(refresh_turns)
	BattleService.s_round_ended.connect(on_round_ended)

func on_action_started(action: BattleAction) -> void:
	if action is ToonAttack:
		turns_used += 1
		if turns_used % activate_turn == 0:
			if action.targets.size() == 1:
				var bonus_dmg: int 
				bonus_dmg =  int(action.targets[0].stats.hp * 0.1)
				action.damage += bonus_dmg
			else:
				if action.main_target != null:
						action.main_target.stats.hp -= int(action.main_target.stats.hp * 0.1)
			action.store_boost_text("Strange Energy!", Color(0.4, 1.0, 0.7))  # Alien green

func refresh_turns() -> void:
	turns_used = 0
	
func on_round_ended(manager: BattleManager) -> void:
	var turns_remaining_in_cycle = activate_turn - (turns_used % activate_turn)
	var activation_turn_next_round = turns_remaining_in_cycle - 1     
	if turns_remaining_in_cycle <= Util.get_player().stats.max_turns:
		var dict = {}
		dict[activation_turn_next_round] = "Base damage on the main target increased by 10% of target's hp"
		manager.battle_ui.s_item_effect.emit(dict)
