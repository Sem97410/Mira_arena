extends Button

@export var pause_animation_signal : PauseAnimationSignalResource



func _on_pressed() -> void:
	pause_animation_signal.channel.emit()
