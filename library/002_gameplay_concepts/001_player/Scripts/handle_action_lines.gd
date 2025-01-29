extends AnimatedSprite2D

#@export var sprites : AnimatedSprite2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	launch_action_line()

func launch_action_line() -> void : 
	if Input.is_action_just_pressed("dash"): 
		self.play("Action lines")
		self.visible = true
		
		await get_tree().create_timer(0.5).timeout
		
		self.visible = false
		self.stop()
