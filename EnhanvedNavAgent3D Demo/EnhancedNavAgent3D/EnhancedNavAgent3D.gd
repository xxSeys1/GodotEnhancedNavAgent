class_name EnhancedNavAgent3D extends NavigationAgent3D

## [EnhancedNavAgent3D] simplyfies navigation in Godot by providing high level functions.

## The [CharacterBody3D] used for calculating the velocity.[br][br]For example the [CharacterBody3D] of the enemy that uses this [EnhancedNavAgent3D] for navigation.
@export var _char_body: CharacterBody3D
## If [code]true[/code], calculates the velocity taking avoidance into account.[br][br]If [code]false[/code], the returned velocity is whitout doing avoidance calculations.
@export var _calc_avoidance: bool = true
## If [code]true[/code] and [code]get_tree().debug_navigation_hint[/code], displays the path the [EnhancedNavAgent3D] calculated using the inbuild debug path functionality.[br] [br]This is the same as setting [param debug_enabled] to true.
@export var _visible_navigation_display_path: bool = true

var _nav_target: Node3D
var _calculated_velocity: Vector3
var _safe_to_calculate: bool


func _ready() -> void:
	velocity_computed.connect(_on_safe_velocity_computed)
	
	if _visible_navigation_display_path and get_tree().debug_navigation_hint:
		debug_enabled = true
	
	# this is because of some weird thing where godot pushes an error when calling get_next_path_position before map synchronization
	await get_tree().process_frame
	_safe_to_calculate = true


## Sets the [param _nav_target].[br] [br]If you want to pass in a position directly, create a [Marker3D] and set its [param global_position] to the desired position and set it as the [param _nav_target].
func set_nav_target(_target: Node3D):
	_nav_target = _target
	
	if _nav_target == null:
		push_warning("Trying to set _nav_target to a <null>. This is possible but the target position will not update")
		return


## Set if the [EnhancedNavAgent3D] should calculate avoidance.
func set_calculate_safe_velocity(_calculate_avoidance) -> void:
	_calc_avoidance = _calculate_avoidance


## Returns the calculated velocity. The velocity is calculated based on the [param _char_body]s [param global_position] and the [param global_position] of the [param _nav_target].
func get_velocity_to_target() -> Vector3:
	return _calculated_velocity


func _physics_process(_delta: float) -> void:
	if not _safe_to_calculate:
		return
	
	avoidance_enabled = _calc_avoidance
	
	if not _nav_target == null:
		set_target_position(_nav_target.global_position)
	
	var _current_location: Vector3 = _char_body.global_position
	# get the next position of the calculated path
	var _next_location: Vector3 = get_next_path_position()
	# calculate the velocity vector
	var _new_velocity: Vector3 = (_next_location - _current_location).normalized()
	
	if _calc_avoidance:
		velocity = _new_velocity
	else:
		_calculated_velocity = _new_velocity


# this is the internal signal of godot that it emits when the safe velocity was computed
func _on_safe_velocity_computed(_safe_velocity: Vector3):
	if _calc_avoidance:
		_calculated_velocity = _safe_velocity
