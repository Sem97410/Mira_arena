extends Button

@export var state_machine_1_signal : StateMachine1SignalResource


func _on_pressed() -> void:
	state_machine_1_signal.channel.emit()
