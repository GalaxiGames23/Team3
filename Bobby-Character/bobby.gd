extends KinematicBody2D

onready var anim_tree  = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

var Flag = preload("res://Flag/flag.tscn")
var Ball = preload("res://Ball/Ball.tscn")
var flag_instance : KinematicBody2D

var direction      : Vector2 = Vector2.ZERO
var velocity       : Vector2 = Vector2.ZERO
var store_position : Vector2 = Vector2.ZERO
var base_scale: Vector2
var last_direction: Vector2
var freeze       : bool = false
var is_falling   : bool = false
var flag_dropped : bool = false
var respawn_position
var myCamera

export var speed : float = 125.0
export var acceleration: float = 500
export var run_factor: float = 3

func _ready():
	
	anim_tree.active = true
	respawn_position = global_position
	base_scale = scale

func _physics_process(delta):
	if freeze == false and !is_falling :
		direction = get_input_velocity()
		if (Input.is_action_pressed("ui_run")):
			velocity = velocity.move_toward(direction * run_factor * speed, delta * acceleration*2.5) 
		else:
			velocity = velocity.move_toward(direction * speed, delta * acceleration) 
		if velocity.length() > speed/3 :
			_orientation(direction + 0.2 * velocity.move_toward(direction * speed,acceleration * delta * 5))
		velocity = move_and_slide(velocity,Vector2.UP)
	elif is_falling:
		velocity = move_and_slide(velocity,Vector2.UP)
		

#oriente le joueur correctement
func _orientation(dir):
	self.rotation=dir.angle()-PI/2

#retourne un Vecteur 2D indiquant la direction du personnage et l'oriente
func get_input_velocity() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	if (Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right")) or (!Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right")) :
		dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	if (Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down")) or (!Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down")) :
		dir.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	dir=dir.normalized()
	
	return dir

#fonction pour l'input
func _input(event):
	if event is InputEventKey and freeze==false:
		#supprimer la liaison shoot->freeze dans le AnimationTree ne semble pas suffire, d'ou le freeze==false
		if Input.is_action_pressed("ui_shoot") :
			anim_state.travel("shoot")
			
			#print_debug("SHOOOOT",randi())
		elif Input.is_action_pressed("ui_flag") and flag_dropped==false:
			store_position=position
			flag_dropped=true
			flag_instance=Flag.instance()
			flag_instance.position=position+Vector2(100,100)
			get_node("/root").add_child(flag_instance)
		elif Input.is_action_pressed("ui_tp") and flag_dropped==true :
			position=store_position
			store_position=Vector2.ZERO
			flag_dropped=false
			flag_instance.queue_free()

#Add a Ball to the scene
func spawn_ball():
	assert(myCamera )
	var ball_instance=Ball.instance()
	ball_instance.global_position = $SpawnBallPoint.global_position
	ball_instance.save_player = self
	ball_instance.spawn_direction = ($SpawnBallPoint.global_position - global_position).normalized()
	ball_instance.myCamera = myCamera
	get_node("/root").add_child(ball_instance)
	myCamera.change_focus(ball_instance)

func start_falling(hole):
	last_direction = direction
	is_falling = true
	velocity = Vector2.ZERO
	velocity = (hole.global_position - global_position) 
	anim_state.travel("fall")

func respawn_player():
	is_falling = false
	freeze = false
	scale = base_scale
	_orientation(last_direction)
	global_position = respawn_position

func On_shoot_End():
	freeze = true
	anim_state.travel("freeze")
	
func On_Ball_Touch():
	freeze = false
	anim_state.travel("run")
