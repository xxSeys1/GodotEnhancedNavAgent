# based on https://www.youtube.com/watch?v=mmvIkkKJVlQ&t=128s
extends Marker3D

const _RAYCAST_LENGHT: int = 2000

func _ready() -> void:
	GameManager._nav_target = self


func _process(_delta: float) -> void:
	var _space_state = get_world_3d().direct_space_state
	
	var _mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	var _camera: Camera3D = get_viewport().get_camera_3d()
	var _ray_origin: Vector3 = _camera.project_ray_origin(_mouse_position)
	
	var _ray_end: Vector3 = _ray_origin + _camera.project_ray_normal(_mouse_position) * _RAYCAST_LENGHT
	
	var _param: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(_ray_origin, _ray_end)
	
	var _result: Dictionary = _space_state.intersect_ray(_param)
	
	if not _result.has("position"):
		return
	
	global_position = _result["position"]
