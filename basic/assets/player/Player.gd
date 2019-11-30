extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL= 4.5

const MAX_SPRINT_SPEED = 30
const SPRINT_ACCEL = 18
var is_sprinting = false

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05

export (int) var current_stage
var player_animation_manager
var gun_animation_manager

var pistol
var cameara_changing_time = 0
var MAX_CAMEARA_CHANGEING_TIME = 0.3

var health = 100
export (int) var Max_Ammo = 10
var UI_status_label
var bounce_audio_player = preload("res://basic/assets/player/Bounce_Audio_Player.tscn")
var shot_audio_player = preload("res://basic/assets/turret/turret_shot_Audio_Player.tscn")
var next_loading
var interact_area
var is_interacted
var is_escaped
var is_dead
var MAX_DEAD_TIME = 1.5
var dead_time
func _ready():
    get_tree().paused = false
    is_dead = false
    $Escape.current_stage = current_stage
    $Rotation_Helper/Gun_Fire_Points/Pistol_Point.ammo_in_weapon = Max_Ammo
    $Rotation_Helper/Gun_Fire_Points/Pistol_Point.AMMO_IN_MAG = Max_Ammo
    next_loading = false
    is_escaped = false
    camera = $Rotation_Helper/Model/Camera
    rotation_helper = $Rotation_Helper

    player_animation_manager = $Rotation_Helper/Model/AnimationPlayer
    gun_animation_manager = $Rotation_Helper/Model/Gun/AnimationPlayer
    gun_animation_manager.callback_function = funcref(self, "fire_bullet")
    
    is_interacted = false
    interact_area = $Interact_Area
    interact_area.connect("body_entered", self, "interact_area_entered")
    interact_area.connect("body_exited", self, "interact_area_exited")

    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
    var gun_aim_point_pos = $Rotation_Helper/Gun_Aim_Point.global_transform.origin
    
    pistol = $Rotation_Helper/Gun_Fire_Points/Pistol_Point
    pistol.player_node = self
    pistol.look_at(gun_aim_point_pos, Vector3(0, 1, 0))
    pistol.rotate_object_local(Vector3(0, 1, 0), deg2rad(180))

    UI_status_label = $HUD/Panel/Gun_label

func interact_area_entered(body):
    if body.has_method("getObjectName"):
        if body.getObjectName() == "door":
            $HUD/Label.text = "Press E"
            is_interacted = true

func interact_area_exited(body):
    if body.has_method("getObjectName"):
        if body.getObjectName() == "door":
            $HUD/Label.text = ""
            is_interacted = false

func _physics_process(delta):
    if is_dead == false:   
        process_input(delta)
        process_movement(delta)
        process_UI(delta)
    else:
        process_dead(delta)

func process_dead(delta):
    dead_time -= delta
    if dead_time <= 0:
        $Escape.button_game.visible = false
        $Escape.show()
        #get_tree().change_scene("res://Stage/" + str(current_stage) + ".tscn")

func create_sound(sound_name, position=null):
        var audio_clone = shot_audio_player.instance()
        var scene_root = get_tree().root.get_children()[0]
        scene_root.add_child(audio_clone)
        audio_clone.play_sound(sound_name, position)
    
func process_input(delta):
    # ----------------------------------
    # Walking
    
    dir = Vector3()
    var cam_xform = camera.get_global_transform()

    var input_movement_vector = Vector2()

    if Input.is_action_pressed("movement_forward"):
        input_movement_vector.y += 1
    if Input.is_action_pressed("movement_backward"):
        input_movement_vector.y -= 1
    if Input.is_action_pressed("movement_left"):
        input_movement_vector.x -= 1
    if Input.is_action_pressed("movement_right"):
        input_movement_vector.x = 1

    input_movement_vector = input_movement_vector.normalized()

    dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
    dir += cam_xform.basis.x.normalized() * input_movement_vector.x
    # ----------------------------------
    if Input.is_action_pressed("intertact") and is_interacted and !next_loading:
        next_loading = true
        get_tree().change_scene("res://Stage/" + str(current_stage + 1) + ".tscn")
        
    # ----------------------------------
    # Jumping
    if is_on_floor():
        if Input.is_action_just_pressed("movement_jump"):
            vel.y = JUMP_SPEED
    # ----------------------------------
    # show map
    if cameara_changing_time > 0:
        cameara_changing_time -= delta
    
    if Input.is_action_pressed("show_map"):
        if cameara_changing_time <= 0:
            cameara_changing_time = MAX_CAMEARA_CHANGEING_TIME
            if $Camera.current:
                $Rotation_Helper/Model/rp_eric_rigged_001.visible = true
                $Rotation_Helper/Model/Gun/Gun.visible = true
                $mark.visible = false
                $Camera.current = false
                $Rotation_Helper/Model/Camera.current = true
                $HUD/Crosshair.visible = true
                $HUD/Panel.visible = true
            else :
                $Rotation_Helper/Model/rp_eric_rigged_001.visible = false
                $Rotation_Helper/Model/Gun/Gun.visible = false
                $mark.visible = true
                $Rotation_Helper/Model/Camera.current = false
                $Camera.current = true
                $HUD/Crosshair.visible = false
                $HUD/Panel.visible = false
            
    # ----------------------------------
    # Sprinting
    if Input.is_action_pressed("movement_sprint"):
        is_sprinting = true
    else:
        is_sprinting = false
    # ----------------------------------
    
    # Firing the weapons
    if Input.is_action_pressed("fire"):
        if pistol.ammo_in_weapon > 0:
            if player_animation_manager.current_state == "man_idle" and gun_animation_manager.current_state == "gun_idle":
                player_animation_manager.set_animation("man_shoot")
                gun_animation_manager.set_animation("gun_shoot")
    # ----------------------------------
    if Input.is_action_pressed("retry"):
        get_tree().change_scene("res://Stage/" + str(current_stage) + ".tscn")
    
func process_UI(delta):
    UI_status_label.text = "Ammo: " + str(pistol.ammo_in_weapon)
     
func process_movement(delta):
    dir.y = 0
    dir = dir.normalized()

    vel.y += delta*GRAVITY

    var hvel = vel
    hvel.y = 0

    var target = dir
    if is_sprinting:
        target *= MAX_SPRINT_SPEED
    else:
        target *= MAX_SPEED

    var accel
    if dir.dot(hvel) > 0:
        if is_sprinting:
            accel = SPRINT_ACCEL
        else:
            accel = ACCEL
    else:
        accel = DEACCEL

    hvel = hvel.linear_interpolate(target, accel*delta)
    vel.x = hvel.x
    vel.z = hvel.z
    vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))



func _input(event):
    if is_dead == true:
        return
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        rotation_helper.rotation_degrees = camera_rot

func fire_bullet():
    pistol.fire_weapon()
    
func getObjectName():
    return "Player"

func bullet_hit(damage, bullet_hit_pos):
    player_animation_manager.set_animation("man_die")
    gun_animation_manager.set_animation("gun_die")
    create_sound("fire", self.global_transform.origin)
    is_dead = true
    dead_time = MAX_DEAD_TIME

func setEscapePoseMode(mode):
    $Escape.pause_mode = mode