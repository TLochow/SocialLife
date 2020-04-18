extends Node2D

var EVENTSCENE = preload("res://Scenes/Event.tscn")

var Score = 0

var Fitness = 50.0
var Energy = 50.0
var Social = 50.0

var SelectedPaddle = 0

var EventSpawnTime = 5.0

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
	
	var malus = 0.1 * delta
	Energy = clamp(Energy - malus, 0.0, 100.0)
	Fitness = clamp(Fitness - malus, 0.0, 100.0)
	Social = clamp(Social - malus, 0.0, 100.0)
	$Camera2D/UI/Control/Scores/EnergyBar.value = Energy
	$Camera2D/UI/Control/Scores/FitnessBar.value = Fitness
	$Camera2D/UI/Control/Scores/SocialBar.value = Social
	
	$Camera2D/UI/Control/Score.text = str(Score)
	
	EventSpawnTime = max(EventSpawnTime - (0.01 * delta), 0.5)
	$EventSpawnTimer.wait_time = EventSpawnTime

func _on_EventSpawnTimer_timeout():
	SpawnNewEvent()

func SpawnNewEvent():
	var event = EVENTSCENE.instance()
	var angle = rand_range(-PI, PI)
	var pos = Vector2(cos(angle), sin(angle))
	pos *= 800.0
	event.set_position(pos)
	event.set_linear_velocity(pos.normalized() * -80.0)
	
	var eventType = randi() % 9
	match eventType: #                       Fit, Energy, Social
		0: # Bed
			event.SetEventType(3, eventType, 0.0, 30.0, -15.0)
		1: # Apple
			event.SetEventType(2, eventType, 15.0, 0.0, 0.0)
		2: # Bar
			event.SetEventType(1, eventType, -15.0, 0.0, 30.0)
		3: # Energy Drink
			event.SetEventType(3, eventType, -15.0, 30.0, 0.0)
		4: # GYM
			event.SetEventType(2, eventType, 30.0, -15.0, 0.0)
		5: # Talk
			event.SetEventType(1, eventType, 0, 0.0, 15.0)
		6: # Concert
			event.SetEventType(1, eventType, 0, -15.0, 30.0)
		7: # Coffee
			event.SetEventType(3, eventType, 0, 15.0, 0)
		8: # Meditation
			event.SetEventType(2, eventType, 30.0, 0, -15.0)
	
	event.connect("Impact", self, "onEventImpact")
	
	$Events.add_child(event)

func onEventImpact(fitness, energy, social):
	Fitness += fitness
	Energy += energy
	Social += social

func _on_Middle_body_entered(body):
	body.ReachedMiddle()

func _on_ScoringTimer_timeout():
	if Social > 50:
		Score += int(Social - 50)
	if Fitness > 50:
		Score += int(Fitness - 50)
	if Energy > 50:
		Score += int(Energy - 50)
