extends ItemScript

const DMG_BONUS := 0.02

var dmg_sum := 0.0
var toon_actions = 0
var round_number = 0

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_action_finished.connect(on_action_finished)
	BattleService.s_battle_started.connect(refresh_dmg)
	BattleService.s_battle_ended.connect(on_battle_ending)

func on_action_started(action: BattleAction) -> void:
	if action is ToonAttack and not is_equal_approx(dmg_sum, 0.0):
		action.store_boost_text("Soar Boost!", Color(0.466, 0.663, 0.935))


func refresh_dmg() -> void:
	dmg_sum = 0.0
	round_number = 0

func on_battle_ending(manager: BattleManager) -> void:
	manager.battle_stats[Util.get_player()].damage -= dmg_sum
	dmg_sum = 0.0
	round_number = 0

func on_action_finished(action: BattleAction) -> void:
	if action is ToonAttack:
		toon_actions += 1
		if(dmg_sum < 0.16):
			BattleService.ongoing_battle.battle_stats[Util.get_player()].damage += DMG_BONUS
			dmg_sum += DMG_BONUS
		print_damage()

func print_damage() -> void:
	print('Soar: New damage value: %s' % BattleService.ongoing_battle.battle_stats[Util.get_player()].damage)
