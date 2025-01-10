extends Button

@export var animation_04_signal : Animation4SignalRessource



func _on_pressed() -> void:
	animation_04_signal.channel.emit()
