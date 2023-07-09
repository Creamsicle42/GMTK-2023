class_name Cavalier extends CharacterBody2D

@export var damage : int = 10
@export var xp : int = 4

@onready var health_component: Node = $HealthComponent
@onready var misc_anim_controller: AnimationPlayer = $FlipPivot/MiscAnimController
@onready var soft_mover: Node2D = $SoftMover
@onready var attack_cooldown: Timer = $AttackCooldown

var ai_update_id : int
var movement_update_id : int

func _ready() -> void:
	ai_update_id = UpdateQueueSystem.add_queued_update(UpdateQueueSystem.ENEMY_AI, $UtilityAIController.update_utility_pritority)
	movement_update_id = UpdateQueueSystem.add_queued_update(UpdateQueueSystem.ENEMY_MOVEMENT, soft_mover.update_movement_direction)

func _exit_tree() -> void:
	UpdateQueueSystem.remove_queued_update(UpdateQueueSystem.ENEMY_AI, ai_update_id)
	UpdateQueueSystem.remove_queued_update(UpdateQueueSystem.ENEMY_MOVEMENT, movement_update_id)



func _process(delta: float) -> void:
	update_animations()

func get_enemy_group() -> Array[Node2D]:
	return $EnemyDetector.get_overlapping_bodies()


func update_animations() -> void:
	if not attack_cooldown.is_stopped():
		misc_anim_controller.set_animation("attack")
		return
	if soft_mover.is_moving:
		misc_anim_controller.set_animation("walk")
		return
	else:
		misc_anim_controller.set_animation("idle")
		return


func do_attack(direction: Vector2) -> void:
	if not $AttackCooldown.is_stopped(): return
	$AttackCooldown.start()
	$AttackArea.rotation = direction.angle()
	for i in $AttackArea.get_overlapping_bodies():
		i.health_component.change_health(-damage)


func _on_health_component_health_depleted() -> void:
	
	die()


func die() -> void:
	for i in xp:
		var spark = SceneDict.MANA_SPARK.instantiate()
		get_parent().add_child(spark)
		spark.global_position = global_position
	translate(Vector2(-10000, -10000))
	await get_tree().process_frame
	queue_free()
