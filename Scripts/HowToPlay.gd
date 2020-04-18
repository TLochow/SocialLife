extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.ChangeScene("res://Scenes/Menu.tscn")

func _on_MenuButton_pressed():
	SceneChanger.ChangeScene("res://Scenes/Menu.tscn")
