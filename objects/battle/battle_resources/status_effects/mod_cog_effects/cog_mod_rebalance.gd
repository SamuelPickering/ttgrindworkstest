@tool
extends StatusEffect

var base_defense
var defgain
func apply() -> void:
	var cog: Cog = target
	#s_status_effect_added(effect: StatusEffect)
	base_defense = target.stats.defense
	defgain = ((target.stats.defense - base_defense) / base_defense) * 100
	manager.s_status_effect_added.connect(on_status_added)
	description = "This cog's defense increases when inflicted with a debuff." +"\n" + "The foreman defense is currently increased by %d%%!" % defgain

func on_status_added(status : StatusEffect) -> void:
	if status.target == target and status.quality == 1:
		manager.battle_stats[target].set('defense',manager.battle_stats[target].get('defense') * 1.20)
		defgain = ((manager.battle_stats[target].get('defense') - base_defense) / base_defense) * 100
		var hp_healed = 0
		if target.stats.hp > 0:
			hp_healed = target.stats.max_hp * 0.1
			target.stats.hp += hp_healed
		await manager.sleep(1)
		manager.battle_text(target, "+ 20% defense")
		if(hp_healed > 0):
			await manager.sleep(0.3)
			manager.battle_text(target,"+ " + str(hp_healed),Color(0, 1, 0, 1), Color(0, 1, 0, 1))
		description = "This cog's defense increases when inflicted with a debuff." +"\n" + "The foreman defense is currently increased by %d%%!" % defgain

func cleanup() -> void:
	manager.s_status_effect_added.disconnect(on_status_added)

func get_status_name() -> String:
	return "Rebalance"
func renew() -> void:
		defgain = ((manager.battle_stats[target].get('defense') - base_defense) / base_defense) * 100
		description = "This cog's defense increases when inflicted with a debuff." +"\n" + "The foreman defense is currently increased by %d%%!" % defgain
	
func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/absorbing_shield.png")
