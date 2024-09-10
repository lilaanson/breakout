extends CharacterBody2D



func _physics_process(delta: float) -> void:
	position.x=get_viewport().get_mouse_position().x
