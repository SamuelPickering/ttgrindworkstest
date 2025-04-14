@tool
extends StatusEffect

var player: Player
var last_player_hp
var heal_multiplier = 2.5
func apply() -> void:
	var cog: Cog = target
	player  = Util.get_player()
	player.stats.hp_changed.connect(on_toon_heal)
	last_player_hp = player.stats.hp
	target.stats.is_foreman = true

func on_toon_heal(health : int) -> void:
	if(health > last_player_hp):
		print("PLAYER MUST HAS HEALED BENE")
		var hp_ratio = float(health - last_player_hp) / player.stats.max_hp
		print("hp ratio: ", hp_ratio)
		if target.stats.hp > 0:
			target.stats.hp = target.stats.hp + (max(target.stats.max_hp, target.stats.hp) * (hp_ratio * heal_multiplier))
		print(max(target.stats.max_hp, target.stats.hp) * (hp_ratio * heal_multiplier))
		print("cogs hp: ", target.stats.hp)
	else:
		print("got damaged imao by: ", health - last_player_hp)
	last_player_hp = health
	print("new last player hp: ", last_player_hp)
	

func cleanup() -> void:
	player.stats.hp_changed.disconnect(on_toon_heal)

func get_status_name() -> String:
	return "Beneficiary"

func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/green_plus.png")
