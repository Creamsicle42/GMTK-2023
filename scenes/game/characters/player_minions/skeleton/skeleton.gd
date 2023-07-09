class_name Skeleton extends CharacterBody2D


@onready var player : PlayerMain = get_tree().get_first_node_in_group("player")
@onready var health_component: Node = $HealthComponent
@onready var misc_anim_controller: AnimationPlayer = $MiscAnimController
@onready var soft_mover: Node2D = $SoftMover
@onready var attack_cooldown: Timer = $AttackCooldown

var ai_update_id : int
var movement_update_id : int

var halt_anim := true

func _ready() -> void:
	visible = false
	await get_tree().create_timer(randf_range(0.0, 0.8)).timeout
	$RaiseSound.pitch_scale = randf_range(0.9, 1.1)
	$RaiseSound.play()
	misc_anim_controller.play("raise")
	visible = true
	$BoneParticles.emitting = true
	await misc_anim_controller.animation_finished
	halt_anim = false
	ai_update_id = UpdateQueueSystem.add_queued_update(UpdateQueueSystem.PLAYER_MINION_AI, $UtilityAIController.update_utility_pritority)
	movement_update_id = UpdateQueueSystem.add_queued_update(UpdateQueueSystem.PLAYER_MINION_MOVEMENT, soft_mover.update_movement_direction)
	

func _exit_tree() -> void:
	UpdateQueueSystem.remove_queued_update(UpdateQueueSystem.PLAYER_MINION_AI, ai_update_id)
	UpdateQueueSystem.remove_queued_update(UpdateQueueSystem.PLAYER_MINION_MOVEMENT, movement_update_id)


func _process(delta: float) -> void:
	update_animations()


func get_craft_type() -> String: return "skeleton"


func get_enemy_group() -> Array[Node2D]:
	if player == null: return []
	return player.get_enemies_in_range()


func _on_health_component_health_depleted() -> void:
	halt_anim = true
	$DieSound.pitch_scale = randf_range(0.9, 1.1)
	$DieSound.play()
	misc_anim_controller.play("die")
	await misc_anim_controller.animation_finished
	translate(Vector2(-10000, -10000))
	await get_tree().process_frame
	queue_free()

func update_animations() -> void:
	if halt_anim: return
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
	if not attack_cooldown.is_stopped(): return
	attack_cooldown.start()
	$AttackArea.rotation = direction.angle()
	for i in $AttackArea.get_overlapping_bodies():
		i.health_component.change_health(-8)


func reclaim() -> void:
	if(randf_range(0, 0.9) < health_component.get_percent_health()):
		var spark = SceneDict.MANA_SPARK.instantiate()
		get_parent().add_child(spark)
		spark.global_position = global_position
	if(randf_range(0, 0.7) < health_component.get_percent_health()):
		var spark = SceneDict.MANA_SPARK.instantiate()
		get_parent().add_child(spark)
		spark.global_position = global_position
	if(randf_range(0, 0.5) < health_component.get_percent_health()):
		var spark = SceneDict.MANA_SPARK.instantiate()
		get_parent().add_child(spark)
		spark.global_position = global_position
	queue_free()


func _on_health_component_damage_taken(damage) -> void:
	$HurtSound.pitch_scale = randf_range(0.9, 1.1)
	$HurtSound.play()
	$BoneParticles.emitting = true
