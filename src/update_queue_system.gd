extends Node

const PLAYER_MINION_AI = "player_minion_ai"
const PLAYER_MINION_MOVEMENT = "player_minion_movement"
const ENEMY_AI = "enemy_ai"
const ENEMY_MOVEMENT = "enemy_movement"

var update_queues := {}


func _ready() -> void:
	create_update_queue(PLAYER_MINION_AI, 3)
	create_update_queue(PLAYER_MINION_MOVEMENT, 3)
	create_update_queue(ENEMY_AI, 2)
	create_update_queue(ENEMY_MOVEMENT, 1)


func _physics_process(delta: float) -> void:
	for i in update_queues:
		process_queue(update_queues[i])


func process_queue(queue: Dictionary) -> void:
	if queue.update_callbacks.size() == 0: return
	for i in min(queue.calls_per_update, queue.update_callbacks.size()):
		queue.last_called += 1
		if queue.last_called >= queue.update_callbacks.size():
			queue.last_called = 0
		var method :Callable = queue.update_callbacks[queue.last_called].method
		if method.is_valid(): method.call()


func create_update_queue(queue_id: String, calls_per_update: int) -> void:
	update_queues[queue_id] = {
		"update_callbacks": [],
		"last_called": 0,
		"calls_per_update": calls_per_update
	}

func add_queued_update(queue_id: String, method: Callable) -> int:
	var id = randi()
	if not update_queues.has(queue_id): return -1
	update_queues[queue_id].update_callbacks.append(
		{
			"id": id,
			"method": method
		}
	)
	return id

func remove_queued_update(queue_id: String, method_id: int) -> void:
	if not update_queues.has(queue_id): return
	for i in update_queues[queue_id].update_callbacks:
		if i.id == method_id:
			(update_queues[queue_id].update_callbacks as Array).erase(i)
