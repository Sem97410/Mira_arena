extends Button

@export var animation1_signal : Animation1SignalRessource

func _on_pressed() -> void:
	animation1_signal.channel.emit()
