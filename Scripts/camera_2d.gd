# Code from https://www.reddit.com/r/godot/comments/uj71l6/pan_camera_with_mouse_and_change_speed_according/
extends Camera2D

const ZOOM_INCREMENT = 0.0
const ZOOM_MIN = 2.0
const ZOOM_MAX = 8.0

var panning := false
var zoom_level := 1.0

func _unhandled_input(_event:InputEvent) -> void:
	if _event is InputEventMouseButton:
		match _event.button_index:
			MOUSE_BUTTON_RIGHT:
				if _event.pressed:
					panning = true
				else:
					panning = false
				get_tree().get_root().set_input_as_handled()
				
			#MOUSE_BUTTON_WHEEL_UP:
				#zoom_level = clamp(zoom_level + ZOOM_INCREMENT, ZOOM_MIN, ZOOM_MAX)
				#zoom = zoom_level * Vector2.ONE
				#get_tree().get_root().set_input_as_handled()
				#
			#MOUSE_BUTTON_WHEEL_DOWN:
				#zoom_level = clamp(zoom_level - ZOOM_INCREMENT, ZOOM_MIN, ZOOM_MAX)
				#zoom = zoom_level * Vector2.ONE
				#get_tree().get_root().set_input_as_handled()
				
	elif _event is InputEventMouseMotion and panning:
		get_tree().get_root().set_input_as_handled()
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			global_position -= _event.relative / zoom_level
		else:
			panning = false
	#$PlayerMenu.size = Vector2(1152,648)
	#$PlayerMenu.position = Vector2(576,324)
	#$PlayerMenu.visible = true
	
