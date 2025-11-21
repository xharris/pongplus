extends Resource
class_name VfxImpactConfig

@export_group("Circle Burst", "circle_burst_")
@export var circle_burst_enabled: bool = true
@export var circle_burst_offset: Vector2 = Vector2.ZERO
@export var circle_burst_color: Color = Color.BLACK
@export var circle_burst_amount: int = 3

@export_group("Squeeze", "squeeze_")
@export var squeeze_enabled: bool = true
@export var squeeze_amount: float = 2
## TODO not sure if this is working as intended
@export var squeeze_rotation: float = deg_to_rad(0)
