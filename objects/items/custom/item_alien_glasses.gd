extends ItemScript

const DMG_BONUS := 1.3

var attack_count := 0

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_battle_started.connect(refresh_turns)

func on_action_started(action: BattleAction) -> void:
	if action is ToonAttack:
		attack_count += 1
		if attack_count % 2 == 0:
			if action.targets.size() == 1:
				var bonus_dmg: int 
				bonus_dmg =  int(action.targets[0].stats.hp * 0.1)
				action.damage += bonus_dmg
			else:
				if action.main_target != null:
						action.main_target.stats.hp -= int(action.main_target.stats.hp * 0.1)
			action.store_boost_text("Strange Energy!", Color(0.4, 1.0, 0.7))  # Alien green

func refresh_turns() -> void:
	attack_count = 0
	print("refressing turns")
