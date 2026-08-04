extends SceneTree

func _init():
	var launcher_scene = load("res://Launcher.tscn")
	var launcher = launcher_scene.instantiate()
	root.add_child(launcher)
	await process_frame
	await process_frame
	print("code_field: ", launcher.code_field)
	print("condition_picker: ", launcher.condition_picker)
	print("start_button: ", launcher.start_button)
	print("first_level: ", launcher.first_level)
	print("start_button connections: ", launcher.start_button.pressed.get_connections() if launcher.start_button else "N/A")
	if launcher.start_button:
		print("--- simulating press ---")
		launcher.start_button.emit_signal("pressed")
		await process_frame
		await process_frame
		await process_frame
	print("current_scene after press: ", current_scene)
	print("--- done ---")
	quit()
