extends Button

@export var animation_signal_resource_04 : AnimationSignalResource04

func _on_pressed() -> void:
	animation_signal_resource_04.channel.emit()
