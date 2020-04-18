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
	
	Energy = clamp(Energy - (1.0 * delta), 0.0, 100.0)
	Fitness = clamp(Fitness - (1.0 * delta), 0.0, 100.0)
	Social = clamp(Social - (1.0 * delta), 0.0, 100.0)
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
	
	var eventType = randi() % 6
	match eventType: #                       Fit, Energy, Social
		0: # Bed
			event.SetEventType(3, eventType, 0.0, 30.0, -15.0)
		1: # Shower
			event.SetEventType(2, eventType, 10.0, 0.0, -5.0)
		2: # Bar
			event.SetEventType(1, eventType, 0.0, -15.0, 30.0)
		3: # Energy Drink
			event.SetEventType(3, eventType, -20.0, 0, 30.0)
		4: # GYM
			event.SetEventType(2, eventType, 30.0, -20.0, 0.0)
		5: # Talk
			event.SetEventType(1, eventType, 0, -5.0, 30.0)
		6: 
			event.SetEventType(0, eventType, 0, 0, 0)
		7: 
			event.SetEventType(0, eventType, 0, 0, 0)
		8:
			event.SetEventType(0, eventType, 0, 0, 0)
		9:
			event.SetEventType(0, eventType, 0, 0, 0)
	
	event.connect("Impact", self, "onEventImpact")
	
	$Events.add_child(event)

func onEventImpact(fitness, energy, social):
	Fitness += fitness
	Energy += energy
	Social += social

func _on_Middle_body_entered(body):
	body.ReachedMiddle()
