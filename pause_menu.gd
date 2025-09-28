extends Control

func pause():
	get_tree().paused == true;

func resume():
	get_tree().paused == false;

func testEsc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause();
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume();




func _on_resume_pressed() -> void:
	resume()

func _on_save_pressed() -> void:
	pass # replace with save game logic

func _on_exit_pressed() -> void:
	get_tree().quit()
