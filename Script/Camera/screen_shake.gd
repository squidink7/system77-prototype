class_name ScreenShake extends Node2D

var shake_factor:float = 10.0
var shake_duration:float = 0.1
var shake_per_sec:float = 0.01

var duration: Timer
var physics: Timer

var camera:Camera2D

func _init(camera_node:Camera2D):
	camera = camera_node
	
func screen_shake_short_weak():
	screen_shake(0.75, 0.5)
func screen_shake_short_strong():
	screen_shake(2.0, 1)
func screen_shake_long_weak():
	screen_shake(1.00, 1)
func screen_shake_long_strong():
	screen_shake(2.0, 1.5)
func comically_strong_shake():
	screen_shake(100, 5)
	
func screen_shake(factor:float, time_duration:float):
	
	if not is_instance_valid(duration) or not is_instance_valid(physics):
		duration = Timer.new()
		physics = Timer.new()
		duration.timeout.connect(_on_duration_timeout)
		physics.timeout.connect(_on_physics_timeout)
		
		camera.add_child(duration)
		camera.add_child(physics)
	
	shake_factor = factor
	shake_duration = time_duration
	
	duration.wait_time = shake_duration
	duration.one_shot = true
	duration.autostart = false
	
	physics.wait_time = shake_per_sec
	physics.one_shot = false
	physics.autostart = false
	
	duration.start()
	physics.start()
	
func shake():
	var shake_duration_normalized = duration.time_left/shake_duration
	var rng_x = randf_range(-shake_factor*shake_duration_normalized,shake_factor*shake_duration_normalized)
	var rng_y = randf_range(-shake_factor*shake_duration_normalized,shake_factor*shake_duration_normalized)
	camera.position += Vector2(rng_x, rng_y)

func _on_duration_timeout():
	duration.queue_free()
	physics.queue_free()
	
func _on_physics_timeout():
	shake()
