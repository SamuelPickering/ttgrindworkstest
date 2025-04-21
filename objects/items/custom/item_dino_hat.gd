extends ItemScript

var not_hit = true
var player: Player
var last_player_hp

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_battle_ended.connect(on_battle_ending)
	BattleService.s_battle_started.connect(refresh_multiscale)
	player = Util.get_player()
	player.stats.hp_changed.connect(on_toon_hp_change)
	last_player_hp = player.stats.hp

func on_action_started(action: BattleAction) -> void:
	if action is CogAttack and action.ActionTarget.SELF:
		if Util.get_player().stats.hp == Util.get_player().stats.max_hp:
			print("pre multiscale: ", action.damage)
			action.damage = action.damage * 0.50
			print("post multiscale: ", action.damage)
			action.store_boost_text("Multiscale!", Color(0.466, 0.663, 0.935))
		if not_hit:
			action.damage = action.damage * 0.8
			print("reduced first hit damage")
			action.store_boost_text("Multiscale!", Color(0.466, 0.663, 0.935))
		print("tis cog attack")
		last_player_hp = Util.get_player().stats.hp
		print(action.damage)


func on_battle_ending(manager: BattleManager) -> void:
	print("in battle ending")

func refresh_multiscale() -> void:
	last_player_hp = Util.get_player().stats.hp
	not_hit = true
	print("reseting multi,", not_hit)
	

func on_toon_hp_change(health : int) -> void:
	if health < last_player_hp:
		last_player_hp = health
		not_hit = false
		
