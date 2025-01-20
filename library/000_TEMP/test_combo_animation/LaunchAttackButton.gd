extends Button

@export var combo_signal : FightComboSignal
@export var transition_signal : ManageAnimationSignal


func _on_pressed() -> void:
	combo_signal.chanel.emit()
	transition_signal.chanel.emit()
