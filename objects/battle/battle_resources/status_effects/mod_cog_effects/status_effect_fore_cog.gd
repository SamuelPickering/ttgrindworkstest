@tool
extends StatusEffect


const MOD_EFFECTS : Array[StatusEffect] = [ #res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_drop_immunity.tres
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_techbot.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_disguise.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_proxy_add.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_drop_immunity.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_rebalance.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_lure_immunity.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_larynx.tres"),
	preload("res://objects/battle/battle_resources/misc_movies/traffic_manager/mod_cog_green_light.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_cursed_foreman.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_damage_drift.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_troll.tres"),
]

var overchaged = preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_overcharged.tres")

func apply() -> void:
	if not MOD_EFFECTS.is_empty():
		var mod_effect: StatusEffect = (MOD_EFFECTS[Globals.fore_cog_index % 4 + 3]).duplicate()
		Globals.fore_cog_index += 1
		mod_effect.target = target
		var forecharge = overchaged.duplicate()
		forecharge.target = target
		
		#print("mod effect:")
		#print(mod_effect)
		#var saproperties = mod_effect.get_property_list()
		#if mod_effect.resource_path: print("resource path: ", mod_effect.resource_path)
		#print("target:")
		#print(target)
		manager.add_status_effect(forecharge)
		manager.add_status_effect(mod_effect)
