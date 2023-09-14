extends CharacterBody3D

const _GRAVITY: float = -9.8
const _SPEED: float = 3
const _VELOCITY_LERP_WEIGHT: float = 0.85

@onready var _nav_agent: EnhancedNavAgent3D = $EnhancedNavAgent3D


func _physics_process(_delta: float) -> void:
	_nav_agent.set_nav_target(GameManager._nav_target)
	
	velocity = lerp(velocity, _nav_agent.get_velocity_to_target() * _SPEED, _VELOCITY_LERP_WEIGHT)
	
	
	if not is_on_floor():
		velocity.y = _GRAVITY
	
	move_and_slide()
