extends Button

@export var combo_signal : FightComboSignal


func _on_pressed() -> void:
	combo_signal.chanel.emit()
