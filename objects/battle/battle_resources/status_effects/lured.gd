@tool
extends StatusEffect
class_name StatusLured

enum LureType {
	STUN,
	DAMAGE_DOWN
}

@export var lure_type := LureType.STUN
@export var knockback_effect := 10
@export var damage_nerf := 0.5

func apply() -> void:
	var cog: Cog = target
	cog.lured = true
	cog.get_node('Body').position.z = Globals.SUIT_LURE_DISTANCE
	if lure_type == LureType.STUN:
		manager.skip_turn(cog)
		cog.stunned = true
	else:
		print("in lured.gd: damage nerf:")
		print(damage_nerf)
		var stats : BattleStats = manager.battle_stats[cog]
		stats.damage *= damage_nerf
	
	description = "Knockback Damage: %d" % knockback_effect
	if lure_type == LureType.DAMAGE_DOWN: description += "\ndamage nerf: 50% Damage Down"

func expire() -> void:
	if target.lured:
		var walk_tween := create_walk_tween()
		await walk_tween.finished
		walk_tween.kill()
	target.lured = false
	if lure_type == LureType.DAMAGE_DOWN:
		manager.battle_stats[target].damage *= (1 / damage_nerf)
	else:
		print("manager.bellow: " )
		if manager.bellow and target.stunned:
			target.stunned = false
			print(" in lured gd  41 BELLLOW?!!!!!!!!!")
			var attack = manager.get_cog_attack(target)
			manager.append_action(attack)
			return
		if target.stunned:
			target.stunned = false
			manager.unskip_turn(target)
			print("in lured, ARE U TELLING ME THIS DOESN'T RUN?")
			await manager.run_actions()
			print("in lured, bruh there aint no way")
		print("idk bro")
		

func ts_pmo() -> void:
	var walk_tween := create_walk_tween()
	await walk_tween.finished
	walk_tween.kill()
func create_walk_tween() -> Tween:
	var cog: Cog = target
	var battle_node = manager.battle_node
	
	var walk_tween = manager.create_tween()
	walk_tween.tween_callback(cog.set_animation.bind('walk'))
	walk_tween.tween_callback(battle_node.focus_character.bind(cog))
	walk_tween.tween_property(cog.get_node('Body'), 'position:z', 0.0, 0.5)
	walk_tween.tween_callback(cog.set_animation.bind('neutral'))
	
	return walk_tween

func get_effect_string() -> String:
	match lure_type:
		LureType.STUN: return 'Stun'
		_: return "Damage Down"

func get_status_name() -> String:
	return "Lured"
