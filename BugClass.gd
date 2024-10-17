extends KinematicBody2D

#Movement Variables#
enum {
	IDLE,
	IDLE_REACH,
	NEW_DIR,
	MOVE,
	LAY_DOWN
}

const speed = 32
var current_state = IDLE
var dir = Vector2.RIGHT

