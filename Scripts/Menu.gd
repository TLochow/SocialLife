extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()

func _on_StartButton_pressed():
	SceneChanger.ChangeScene("res://Scenes/Main.tscn")

func _on_HowToPlayButton_pressed():
	SceneChanger.ChangeScene("res://Scenes/HowToPlay.tscn")

func _on_QuitButton_pressed():
	SceneChanger.EndGame()
