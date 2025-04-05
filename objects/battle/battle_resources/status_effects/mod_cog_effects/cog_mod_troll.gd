
@tool
extends StatusEffect

#const Add_Proxy_Attack := preload("res://objects/battle/battle_resources/cog_attacks/resources/proxy+.tres") # or whatever I rename it 
#var Add_Proxy_Attack := preload("res://objects/battle/battle_resources/cog_attacks/resources/proxy_attack.tres")
#var Add_Proxy_Attack := preload("res://objects/battle/battle_resources/cog_attacks/resources/proxy_attack.tres")	
var troll_dazzle = preload("res://objects/battle/battle_resources/cog_attacks/resources/troll_dazzle.tres")

var cog: Cog

func apply() -> void:
	cog = target
	print("TS PMO")
	manager.s_round_started.connect(on_round_start)

func on_round_start(array : Array) -> void:
	print("on round start")
	for i in range(array.size()):
		print(i)
		print("iteration")
		var action = array[i]
		print(action.targets)
		if action is ToonAttack:
			if cog in action.targets:
					print(" in troll")
					print(cog)
					print(action.targets)
					print("pre actions:")
					print(manager.round_actions)
					var troll_attack: = troll_dazzle.duplicate()
					troll_attack.user = cog
					troll_attack.targets.append(cog)
					print("troll attack:")
					print(troll_attack)
					manager.inject_battle_action(troll_attack, i)
					print("After")
					print(manager.round_actions)
					break
				
	

func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/troll.png") #change the icon color red

func get_status_name() -> String:
	return "Troll Foreman"
