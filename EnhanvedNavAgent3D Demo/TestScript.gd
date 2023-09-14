extends CharacterBody3D

@export var _nav_agent: EnhancedNavAgent3D

const _GRAVITY: float = -9.8

func _physics_process(delta: float) -> void:
	_nav_agent.set_nav_target(GameManager.get_player())
	
	velocity = _nav_agent.get_velocity_to_target() * _GRAVITY
	
	move_and_slide()
