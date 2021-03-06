extends Node
class_name State

var state_machine = null
var is_active := false

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void: pass

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void: pass

# Virtual function. Corresponds to the `_process()` callback.
# Used to check input
func check() -> void: pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void: pass

# Virtual function. Called by the state machine upon changing the active state.
# The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void: pass

# Virtual function. Called by the state machine before changing the active state.
# Use this function to clean up the state.
func exit() -> void: pass

# Shortcut for `state_machine.transition_to()`
func goto(state_name, msg={}): state_machine.transition_to(state_name, msg)
