extends Control

@onready var question_label = $VBoxContainer/QuestionLabel
@onready var btn_1: Button = $VBoxContainer/Button
@onready var btn_2: Button = $VBoxContainer/Button2
@onready var btn_3: Button = $VBoxContainer/Button3
@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer
@onready var whisper_label: Label = $WhisperLabel
@onready var intro_player: VideoStreamPlayer = $IntroPlayer
@onready var bg_player : VideoStreamPlayer= $BGPlayer
@onready var sp_player: VideoStreamPlayer = $SafetyProtocol

var time_left : int = 40
var current_q : int= 0
var whispers = [
	"iambehindyou",
	"godisdead",
	"iwillkillyou",
	"iambehindyou",
	"iloveyou",
	"iseeyou",
	"ipromise",
	"sheisme",
	"youcanonlypraytome"
]
var questions = [
	{
		"prompt": "If an alternate of you appears at your window, do you open it?",
		"choices": ["Open window", "Close blinds", "Scream"]
	},
	{
		"prompt": "Do you believe in God?",
		"choices": ["No", "I don't know", "Yes"]
	},
	{
		"prompt": "What does M.A.D. stand ?",
		"choices": ["Metaphysical Awareness Disorder", "I will not deceive you", "I will heal you"]
	},
	{
		"prompt": "You stare at your bathroom mirror and your reflection does not blink ",
		"choices": ["Smile back", "Smile back", "Smile back"]
	},
	{
		"prompt": "In the middle of the night, you will feel a hand brush your hair.",
		"choices": [" ", " ", " "]
	},
	{
		"prompt": "How do you identify an alternate?",
		"choices": ["I forgot", "Distorted physical features", "I don't remember"]
	},
	{
		"prompt": "You hear a knock on your bedroom door and a voice promises to save you",
		"choices": ["Open the door", "Keep the door shut it will not work", "Escape from a window there is no window"]
	},
	{
		"prompt": "You see your mother with no mouth and no eyes. What do you do?",
		"choices": ["Hug her", "Run away there is no way to run", "She has always looked like this"]
	},
	{
		"prompt": "Do you pray?",
		"choices": ["Yes and God will not save me", "I pray to alternates", "Why do you do this to me?"]
	},
]

func _ready():
	whisper_label.text = ""
	$VBoxContainer.hide()
	timer_label.hide()

	intro_player.finished.connect(_on_intro_finished)
	intro_player.play()


func _on_intro_finished():
	intro_player.queue_free()
	sp_player.play()


func _on_safety_protocol_finished():
	sp_player.queue_free()

	$VBoxContainer.show()
	timer_label.show()

	bg_player.play()

	current_q = 0
	update_question()

	time_left = 40
	timer_label.text = str(time_left)
	timer.start()


func update_question():
	question_label.text = questions[current_q]["prompt"]
	btn_1.text = questions[current_q]["choices"][0]
	btn_2.text = questions[current_q]["choices"][1]
	btn_3.text = questions[current_q]["choices"][2]


func next_question():
	current_q += 1

	if current_q >= questions.size():
		end_quiz()
		return

	update_question()


func _on_button_pressed():
	update_whisper()
	next_question()


func _on_button_2_pressed():
	update_whisper()
	next_question()


func _on_button_3_pressed():
	update_whisper()
	next_question()


func end_quiz():
	btn_1.hide()
	btn_2.hide()
	btn_3.hide()

	question_label.text = ":)"
	await get_tree().create_timer(2).timeout
	$HZ.play()


func _on_timer_timeout():
	time_left -= 1
	timer_label.text = str(time_left)

	if time_left <= 0:
		timer.stop()
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
		
func update_whisper()->void:
	whisper_label.text = whispers[current_q]
