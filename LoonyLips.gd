extends Node2D

var player_words = []
var current_story
var other_strings
var prompt

func _ready():
	set_random_story()
	clear_text_box()
	other_strings = get_from_json("res://other_strings.json")
	prompt = current_story.prompt[player_words.size()]
	$Blackboard/StoryText.set_bbcode(other_strings.intro_text + \
		other_strings.prompt % prompt)
	$Blackboard/TextureButton/ButtonLabel.set_text("Ok!")

func set_random_story():
	var stories = get_from_json("res://stories.json")
	randomize()
	current_story = stories[randi() % stories.size()]

func get_from_json(filename):
	var file = File.new()
	file.open(filename, File.READ) # Assumes the file exists
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

func clear_text_box():
	$Blackboard/TextBox.set_text("")
	
func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	clear_text_box()
	check_player_word_length()

func _on_TextureButton_pressed():
	if not is_story_done():
		var new_text = $Blackboard/TextBox.get_text()
		_on_TextBox_text_entered(new_text)
	else:
		get_tree().reload_current_scene()

func prompt_player():
	prompt = current_story.prompt[player_words.size()]
	$Blackboard/StoryText.set_bbcode(other_strings.prompt % prompt)

func check_player_word_length():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	$Blackboard/StoryText.set_bbcode(current_story.story % player_words)
	end_game()

func is_story_done():
	return player_words.size() == current_story.prompt.size()

func end_game():
	$Blackboard/TextBox.queue_free()
	$Blackboard/TextureButton/ButtonLabel.set_text(other_strings.again)