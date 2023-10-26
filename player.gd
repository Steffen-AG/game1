
extends Area2D

@export var speed = 400
@export var bullet_scene: PackedScene
@export var health = 100
@export var coolDown = 3.0
var coolDownTimer = 0.0
var maxHealth = 100
var screen_size
var healthbar
var canFire
var progbar


func _ready():
	
	screen_size = get_viewport_rect().size
	healthbar = $Healthbar
	progbar = $TextureProgressBar
	healthbar.value = maxHealth
	progbar.value = 0
	canFire = true

func _process(delta):
	#progress bars should probably update here
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if !canFire:
		coolDownTimer += delta
		
		if coolDownTimer >= coolDown:
			canFire = true
	
	if Input.is_action_pressed("shoot") and canFire:
		shoot()
	
	
func shoot():
	canFire = false
	coolDownTimer = 0.0
	health -= 1
	healthbar.value = health
	#progbar.value = health
	print(healthbar.value)
	print(health)
	var pos = get_global_mouse_position()
	var shot = bullet_scene.instantiate() 
	shot.linear_velocity = global_position.direction_to(pos) * 400
	shot.position = get_node(".").position
	get_parent().add_child(shot)
