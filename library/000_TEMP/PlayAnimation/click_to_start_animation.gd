extends Button

@export var play_animation_signal : PlayAnimationSignalResource


func _on_pressed() -> void:
	play_animation_signal.channel.emit()
