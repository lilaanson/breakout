extends CharacterBody2D

##loop music, reset on end, decay sprite over each flower (collision w rabbit), MOVE BUNNY, screen shake on power up

@export var speed: float = 250.0
@export var max_speed: float = 1000.0
@export var score_label: RichTextLabel
@export var start_text: RichTextLabel
##@export var timer_text: RichTextLabel
##@export var timer_count: int = 30

var forward = Vector2(1,1).normalized()
const paddle_width: float = 177.0
var current_score: int = 0
var is_running: bool = false
var bg_music: AudioStreamPlayer = AudioStreamPlayer.new()
var sound_bee : AudioStreamPlayer = AudioStreamPlayer.new()
var game_over: bool = false
var win: bool = false
var hit_count: int = 0


func _ready():
	add_child(sound_bee)
	bg_music.stream = load("res://257997__foolboymedia__shanty-town.wav")
	bg_music.autoplay = true
	add_child(bg_music)


func _physics_process(delta: float) -> void:
	if (not is_running):
		if not game_over:
			if (Input.is_action_just_pressed("click_window")):
				is_running = true
				start_text.visible = false
				score_label.text = "score: 0"
			return
		else:
			speed = 0
			if win:
				start_text.visible = true
				start_text.text = "[center]winner!!! click to play again<33[/center]"
				if (Input.is_action_just_pressed("click_window")):
					is_running = true
					start_text.visible = false
					win = false
					speed = 250
			else:
				start_text.visible = true
				start_text.text = "[center]game over... click to try again :([/center]"
				if (Input.is_action_just_pressed("click_window")):
					is_running = true
					start_text.visible = false
					speed = 250
	##timer_count -= delta
	##timer_text.text = "time left: " +str(timer_count)
	var collision: KinematicCollision2D = move_and_collide(forward * speed * delta)
	if (collision):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 0.5, 1, max_speed)
		
		if collision.get_collider().is_in_group("bricks"):
			collision.get_collider().queue_free()
			if collision.get_collider().is_in_group("slowMoPowerUp") or collision.get_collider().is_in_group("rabbits"):
				var sound_effect = load ("res://Untitled video - Made with Clipchamp (13).mp3") ##not happening on rabbit  -not in a group?
				sound_bee.stream = sound_effect
				sound_bee.play()
			else:
				hit_count += 1
				current_score += 10
				score_label.text = "score: "+str(current_score)
				if hit_count >= 28:
					is_running = false
					game_over = true
					win = true
					var sound_effect = load ("res://413629__djlprojects__video-game-sfx-positive-action-long-tail.wav")
					sound_bee.stream = sound_effect
					sound_bee.play()
				else:
					var sound_effect = load ("res://166186__drminky__menu-screen-mouse-over.wav")
					sound_bee.stream = sound_effect
					sound_bee.play()
			
		if collision.get_collider().is_in_group("slowMoPowerUp"):
			Engine.time_scale = 1.6
			$slowMo.start(5)
			current_score += 15
			score_label.text = "score: "+str(current_score)


		if collision.get_collider().is_in_group("paddle"):
			var paddle_x = collision.get_collider().position.x - paddle_width / 2
			var pos_on_paddle = (position.x-paddle_x) / paddle_width
			var bounce_angle = lerp(-PI*0.7,-PI*0.3, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			current_score -= 2
			score_label.text = "score: "+str(current_score)

			
		
		if collision.get_collider().is_in_group("gameOver"):
			var sound_effect = load ("res://159408__noirenex__life-lost-game-over.wav")
			sound_bee.stream = sound_effect
			sound_bee.play()
			is_running = false
			game_over = true
			win = false
	

		

			
	


func _on_slow_mo_timeout() -> void:
	Engine.time_scale = 1
