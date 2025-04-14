@tool
extends StatusEffect


const MOD_EFFECTS : Array[StatusEffect] = [
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_investment.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_pinpoint.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_insured.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_diverse_portfolio.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_banker.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_embezzler.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_tax_collector.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_fire_sale.tres"),
]

func apply() -> void:
	if not MOD_EFFECTS.is_empty():
		var mod_effect: StatusEffect = RandomService.array_pick_random('mod_cog_effects', MOD_EFFECTS).duplicate()
		#var mod_effect: StatusEffect = (MOD_EFFECTS.pick_random()).duplicate() #wrong
		mod_effect.target = target
		#print("mod effect:")
		#print(mod_effect)
		#var saproperties = mod_effect.get_property_list()
		#if mod_effect.resource_path: print("resource path: ", mod_effect.resource_path)
		#print("target:")
		#print(target)
		manager.add_status_effect(mod_effect)
