extends Control

var SCOREENTRYSCENE = preload("res://Scenes/ScoreEntry.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$EnterName/ScoreLabel.text = "Score: " + str(Global.Score)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_EnterNameButton_pressed()

func _on_EnterNameButton_pressed():
	var name = $EnterName/NameTextBox.text
	if name.length() == 0 or "*" in name or "/" in name:
		$EnterName/ErrorText.visible = true
	else:
		OnlineScore()
		$EnterName.visible = false
		$Highscores.visible = true

func OnlineScore():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "HighScoreCallCompleted")
	http_request.request("http://dreamlo.com/lb/HSulBo1gVUSvnIyAtfMQCwTU2l7auMF027ifyqYzLKeg/add-json-desc/" + str($EnterName/NameTextBox.text) + "/" + str(Global.Score))

func HighScoreCallCompleted(result, response_code, headers, body):
	$Highscores/Loading.visible = false
	var response = parse_json(body.get_string_from_utf8())
	var entries = response.dreamlo.leaderboard.entry
	if typeof(entries) == TYPE_ARRAY: #Wenn nur ein Eintrag existiert returend dreamLo kein Array.
		for online_entry in entries:
			var entry = SCOREENTRYSCENE.instance()
			entry.get_node("Name").text = str(online_entry.name)
			entry.get_node("Score").text = str(online_entry.score)
			$Highscores/Online/Scores.add_child(entry)
	else:
		var entry = SCOREENTRYSCENE.instance()
		entry.get_node("Name").text = str(entries.name)
		entry.get_node("Score").text = str(entries.score)
		$Highscores/Online/Scores.add_child(entry)

func _on_MenuButton_pressed():
	SceneChanger.ChangeScene("res://Scenes/Menu.tscn")
