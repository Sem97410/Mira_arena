extends Button
@export var idle_animation_signal : IdleAnimationSignalResource


func _on_pressed() -> void:
	idle_animation_signal.channel.emit()
