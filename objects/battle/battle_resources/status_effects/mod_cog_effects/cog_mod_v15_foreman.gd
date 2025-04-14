@tool
extends StatusEffect




func apply() -> void:
	var cog: Cog = target
	print("Appied v15 Foreman")
	# add sound immunity
	

func on_death() -> void:
	print("running on line 14 in v15_foreman")
	manager.create_v1_5_skele_cog(target)
	




func get_status_name() -> String:
	return "Foreman v1.5"

func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/virtual_cog.png")
