extends Button
@export var animation_signal_resource_01 : AnimationSignalResource01



func _on_pressed() -> void:
	animation_signal_resource_01.channel.emit()
