extends Button

# Connection with the signal
@export var animation_2_signal : Animation2SignalRessource


#Trigger that'll launch the action
func _on_pressed() -> void:
		animation_2_signal.channel.emit()
