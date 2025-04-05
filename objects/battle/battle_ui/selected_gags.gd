extends HBoxContainer

## References to the selected gag panels
var panels: Array[TextureRect] = []
var paneleffects = {
	0 : 0.5,
	2 : 1.2
}

## The base gag panel
@onready var gag_panel := $SelectedGag
@onready var battle_ui : BattleUI = get_parent()
@onready var manager: BattleManager = NodeGlobals.get_ancestor_of_type(self, BattleManager)

var current_gags: Array[ToonAttack] = []

## Signals the gag index to cancel
signal s_gag_canceled(index : int)


## Find the proper amount of gag panels to have on startup
func _ready():
	# Add the first gag panel to the array
	panels.append(gag_panel)
	
	# Amount of panels is based on Player turns (-1)
	var panels_to_make: int = Util.get_player().stats.turns - 1
	
	# Append the panels
	for i in panels_to_make:
		var panel = gag_panel.duplicate()
		add_child(panel)
		panels.append(panel)
	
	# X Button configuration
	for panel in panels:
		panel.get_node('GagIcon').mouse_entered.connect(hover_slot.bind(panels.find(panel)))
		panel.get_node('GagIcon').mouse_exited.connect(stop_hover)
		panel.get_node('GeneralButton').disabled = true
		panel.get_node('GeneralButton').hide()
		panel.get_node('GeneralButton').pressed.connect(cancel_gag.bind(panels.find(panel)))

func append_gag(gag: ToonAttack) -> void:
	# Add the icon to the gag panels
	for panel in panels:
		var icon: TextureRect = panel.get_node('GagIcon')
		if not icon.texture:
			icon.texture = gag.icon
			break
	
	# Enable/Disable x buttons
	for panel in panels:
		panel.get_node('GeneralButton').disabled = not panel.get_node('GagIcon').texture
		panel.get_node('GeneralButton').visible = not panel.get_node('GeneralButton').disabled

## Reset all panels
func on_round_start(_gag_order: Array[ToonAttack]) -> void:
	for panel in panels:
		panel.get_node('GagIcon').texture = null
		panel.get_node('GeneralButton').disabled = true
		panel.get_node('GeneralButton').hide()

func cancel_gag(index: int):
	s_gag_canceled.emit(index)
	

func refresh_gags(gags: Array[ToonAttack]):
	current_gags = gags
	for i in panels.size():
		var panel = panels[i]
		if i < gags.size():
			panel.get_node('GagIcon').texture = gags[i].icon
			panel.get_node('GeneralButton').disabled = false
		else:
			panel.get_node('GagIcon').texture = null
			panel.get_node('GeneralButton').disabled = true
		panel.get_node('GeneralButton').visible = not panel.get_node('GeneralButton').disabled

func hover_slot(idx: int) -> void:
	if (not current_gags) or current_gags.size() - 1 < idx:
		if not paneleffects.has(idx):
			return
	#manager.s_gag_modified.connect(color_panels) #idk man %5
	var atk_string: String = ""
	if paneleffects.has(idx):
		if paneleffects[idx] > 1:
			atk_string += "Gag damage on this turn is boosted by " + str(paneleffects[idx] * 100) + "%"
		else: atk_string += "Gag damage on this turn is reduced by " + str(paneleffects[idx] * 100) + "%"
	if  not ((not current_gags) or current_gags.size() - 1 < idx):
		var gag: ToonAttack = current_gags[idx]
		var has_main_target: bool = gag.main_target != null
		if paneleffects.has(idx):
			atk_string += "\n"
		for cog in manager.cogs:
			if cog in gag.targets:
				atk_string += "X" if ((not has_main_target) or (has_main_target and cog == gag.main_target)) else "x"
			else:
				atk_string += "-"
			if manager.cogs.find(cog) < manager.cogs.size() - 1:
				atk_string += " "
	HoverManager.hover(atk_string, 20, 0.0125)
	
func reset_panel_effects(dict: Dictionary) -> void:
	paneleffects = dict
	color_panels()
func color_panels() -> void: # idk man %5
	for idx in paneleffects.keys():
		if paneleffects[idx] < 1:
			panels[idx].self_modulate = Color(0.5, 0.2, 0.2, 1)
		else: panels[idx].self_modulate = Color(0.2, 0.5, 0.2, 1)
func stop_hover() -> void:
	HoverManager.stop_hover()
