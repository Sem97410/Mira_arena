extends Button

@export var animation_3_signal : Animation3SignalRessource



func _on_pressed() -> void:
	animation_3_signal.channel.emit()
