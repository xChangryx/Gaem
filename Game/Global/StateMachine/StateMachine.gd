extends Node
class_name StateMachine

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
export var initial_state := NodePath()

# Write state for debugging
export var label := NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
onready var state: State = get_node(initial_state)


func _ready() -> void:
	yield(owner, "ready")
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()
	update_label()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)
	state.check()


func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func update_label() -> void:
	if label: get_node(label).text = state.name

# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name): return
	state.is_active = false
	state.exit()
	state = get_node(target_state_name)
	state.is_active = true
	state.enter(msg)
	emit_signal("transitioned", state.name)
	update_label()
