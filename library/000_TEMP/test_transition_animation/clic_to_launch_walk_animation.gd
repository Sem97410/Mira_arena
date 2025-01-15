extends Button
@export var walk_animation_signal : WalkAnimationSignalResource



func _on_pressed() -> void:
	walk_animation_signal.channel.emit()
