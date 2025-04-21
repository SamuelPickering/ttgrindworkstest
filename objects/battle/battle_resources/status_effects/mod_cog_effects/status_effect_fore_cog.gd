@tool
extends StatusEffect


const MOD_EFFECTS : Array[StatusEffect] = [ #res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_drop_immunity.tres
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_techbot.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_disguise.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_proxy_add.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_drop_immunity.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_rebalance.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_lure_immunity.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_troll.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_damage_drift.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_larynx.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_beneficiary.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_v15_foreman.tres"),
	preload("res://objects/battle/battle_resources/misc_movies/traffic_manager/mod_cog_green_light.tres"),
	preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_cursed_foreman.tres"),


]

var overchaged = preload("res://objects/battle/battle_resources/status_effects/mod_cog_effects/mod_cog_overcharged.tres")
const RESTRICTED_EFFECT_INDEXES := [0, 3, 5, 6, 9]  # techbot, drop_immunity, lure_immunity, troll, beneficiary for chartist pool in future
const PENTHOUSE_FOREMAN_INDEXES := [2, 6, 7, 8, 9]  # proxy+,  troll, damage_drift, larynx, beneficiary for boss pool
func apply() -> void:
	if not MOD_EFFECTS.is_empty():
		var mod_effect: StatusEffect
		if Util.final_boss:
			var available_effects = []
			for idx in PENTHOUSE_FOREMAN_INDEXES:
				available_effects.append(MOD_EFFECTS[idx])
			mod_effect = RandomService.array_pick_random('mod_cog_effects', available_effects).duplicate()
		else: mod_effect = RandomService.array_pick_random('mod_cog_effects', MOD_EFFECTS).duplicate()
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
