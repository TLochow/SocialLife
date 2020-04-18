extends CanvasLayer

var ColorBlindMode = 0

func _ready():
	randomize()
	$AnimationPlayer.play("FadeIn")

func ChangeScene(path):
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(path)
	$AnimationPlayer.play("FadeIn")

func EndGame():
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	get_tree().quit()

func ChangeColorblindMode():
	ColorBlindMode += 1
	if ColorBlindMode > 3:
		ColorBlindMode = 0
	
	$Shader.get_material().set_shader_param("colorblindmode", ColorBlindMode)
