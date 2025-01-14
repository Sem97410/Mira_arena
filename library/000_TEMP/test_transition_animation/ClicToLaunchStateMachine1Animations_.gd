extends Button

@export var state_machine_2_signal : StateMachine2SignalResource


func _on_pressed() -> void:
	state_machine_2_signal.channel.emit()
