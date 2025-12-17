extends Node2D
class_name Controller

## normal vector of direction to move (ie. joystick movement)
var move_direction: Vector2

signal up
signal down
signal left
signal right
## charging up attack
signal charge_attack
## release attack
signal release_attack
