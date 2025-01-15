extends Button
@export var animation_signal_resource_03 : AnimationSignalResource03

func _on_pressed() -> void:
	animation_signal_resource_03.channel.emit()
