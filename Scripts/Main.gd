extends Node2D

var EVENTSCENE = preload("res://Scenes/Event.tscn")

var Fitness = 50.0
var Energy = 50.0
var Social = 50.0

var SelectedPaddle = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Paddles/RedPaddle.SetPaddleType(1)
	$Paddles/GreenPaddle.SetPaddleType(2)
	$Paddles/BluePaddle.SetPaddleType(3)
	ChangePaddle(1)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("mouse_wheel_up"):
		ChangePaddle(-1)
	elif event.is_action_pressed("mouse_wheel_down"):
		ChangePaddle(1)

func ChangePaddle(direction):
	SelectedPaddle += direction
	if SelectedPaddle < 1:
		SelectedPaddle = 3
	elif SelectedPaddle > 3:
		SelectedPaddle = 1
	
	$Paddles/RedPaddle.IsActive = SelectedPaddle == 1
	$Paddles/GreenPaddle.IsActive = SelectedPaddle == 2
	$Paddles/BluePaddle.IsActive = SelectedPaddle == 3

func _process(delta):
	var mousePos = get_global_mouse_position()
	var mouseDir = (Vector2(0, 0) - mousePos)
	var mouseAngle = mouseDir.angle() - (PI / 2.0)
	match SelectedPaddle:
		1:
			$Paddles/RedPaddle.Angle = mouseAngle
		2:
			$Paddles/GreenPaddle.Angle = mouseAngle
		3:
			$Paddles/BluePaddle.Angle = mouseAngle
		
	if mousePos.distance_to(Vector2(0, 0)) > 30.0:
		get_viewport().warp_mouse(Vector2(400, 400) - (mouseDir.normalized() * 30.0))
	
	Energy = clamp(Energy - (0.1 * delta), 0.0, 100.0)
	Fitness = clamp(Fitness - (0.1 * delta), 0.0, 100.0)
	Social = clamp(Social - (0.1 * delta), 0.0, 100.0)
	$Camera2D/UI/Control/Scores/EnergyBar.value = Energy
	$Camera2D/UI/Control/Scores/FitnessBar.value = Fitness
	$Camera2D/UI/Control/Scores/SocialBar.value = Social

func _on_EventSpawnTimer_timeout():
	SpawnNewEvent()

func SpawnNewEvent():
	var event = EVENTSCENE.instance()
	var angle = rand_range(-PI, PI)
	var pos = Vector2(cos(angle), sin(angle))
	pos *= 800.0
	event.set_position(pos)
	event.set_linear_velocity(pos.normalized() * -80.0)
	
	var eventType = randi() % 10
	
	event.SetEventType(1, 0, 1.0, -1.0, 0.0)
	
	event.connect("Impact", self, "onEventImpact")
	
	$Events.add_child(event)

func onEventImpact(fitness, energy, social):
	Fitness += fitness
	Energy += energy
	Social += social

func _on_Middle_body_entered(body):
	body.ReachedMiddle()
