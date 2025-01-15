extends Button

@export var animation_signal_resource_02 : AnimationSignalResource02


func _on_pressed() -> void:
	animation_signal_resource_02.channel.emit()
