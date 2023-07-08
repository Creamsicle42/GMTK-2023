class_name ManaSpark extends Node2D

const ATTRACT_FORCE := 1024.0
const MAX_SPEED := 640.0
const INIT_MAX_SPEED := 1000.0
const INIT_MIN_SPEED := 50.0
const FRICTION := 128.0
const STALL_FRICTION := 1536.0
const COLLECT_DISTANCE := 64.0
var velocity := Vector2.ZERO
@onready var player : PlayerMain = get_tree().get_first_node_in_group("player")




func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(randf_range(0, 2 * PI)) * randf_range(INIT_MIN_SPEED, INIT_MAX_SPEED)


func _physics_process(delta: float) -> void:
	var player_delta = (player.global_position - global_position).normalized()
	velocity += player_delta * delta * ATTRACT_FORCE
	if velocity.length() > MAX_SPEED:
		velocity += -velocity.normalized() * STALL_FRICTION * delta
	else: 
		velocity += -velocity.normalized() * FRICTION * delta
	translate(velocity * delta)
	if global_position.distance_to(player.global_position) < COLLECT_DISTANCE:
		player.collect_mana_spark()
		queue_free()
