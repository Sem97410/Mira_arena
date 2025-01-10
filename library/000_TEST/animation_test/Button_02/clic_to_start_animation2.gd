extends Button

@export var animation_2_signal : Animation2SignalRessource



func _on_pressed() -> void:
		animation_2_signal.channel.emit()
