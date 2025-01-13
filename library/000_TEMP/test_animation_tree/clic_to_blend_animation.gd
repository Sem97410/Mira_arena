extends Button

@export var blend_animation_signal : BlendAnimationSignal


func _on_pressed() -> void:
	blend_animation_signal.channel.emit()
