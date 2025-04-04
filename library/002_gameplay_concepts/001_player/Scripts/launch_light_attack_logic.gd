extends Node
class_name LightAttackAnimationScript

@export_multiline var Summary: String

@export var animation_tree: AnimationTree
@export var mira_game_master: MiraGameMaster
@export var index_animation_script: FightAnimationIndex

@onready var base_state_machine = animation_tree["parameters/MiraAnimations/playback"]

func _ready() -> void:
	mira_game_master.player_use_light_attack.connect(launch_light_attack)

func launch_light_attack() -> void:
	var current_index = index_animation_script.request_combo()
	var target_state = "Combo" + str(current_index) + "BlendTree"
	print("🎯 Lance animation :", target_state)
	base_state_machine.travel(target_state)

func on_animation_combo_end() -> void:
	print("🎬 Fin d’animation détectée (call_func)")
	index_animation_script.confirm_combo_done()
