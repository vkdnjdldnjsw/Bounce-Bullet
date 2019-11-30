extends Spatial

const TURRET_DAMAGE = 100

const FLASH_TIME = 0.4
var flash_timer = 0

const FIRE_TIME = 0.5
var fire_timer = 0

var node_turret_head = null
var node_raycast = null

var node_left_raycastt = null
var node_right_raycastt = null

var node_flash_one = null

var current_target = null

var is_active = false

const PLAYER_HEIGHT = 4

var smoke_particles1
var smoke_particles2
var smoke_particles3

var turret_health = 1
export (int) var MAX_TURRET_HEALTH = 1
var isExplosed = false
const DESTROYED_TIME = 20
var destroyed_timer = 0
var is_broken

var simple_audio_player = preload("res://basic/assets/turret/Explosion_Audio_Player.tscn")

func create_sound(sound_name, position=null):
    if sound_name == "explosion":
        var audio_clone = simple_audio_player.instance()
        var scene_root = get_tree().root.get_children()[0]
        scene_root.add_child(audio_clone)
        audio_clone.play_sound(sound_name, position)
    
func _ready():
    is_broken = false
    node_turret_head = $Head
    node_raycast = $Ray_Cast
    node_flash_one = $Head/Flash
   
    $Vision_Area.connect("body_entered", self, "body_entered_vision")
    $Vision_Area.connect("body_exited", self, "body_exited_vision")

    for rayCast in $Ray_Cast.get_children():
        rayCast.add_exception($Base/foot)
        rayCast.add_exception($Base/body)
        rayCast.add_exception($Head/gun)
        rayCast.add_exception($Head/Main_body)
        rayCast.add_exception($Vision_Area)
        for rayCast2 in $Ray_Cast.get_children():
            rayCast.add_exception(rayCast2)

    node_flash_one.visible = false

    smoke_particles1 = $Base/body/Smoke
    smoke_particles2 = $Head/Main_body/Smoke
    smoke_particles3 = $Base/foot/Smoke
    smoke_particles1.emitting = false
    smoke_particles2.emitting = false
    smoke_particles3.emitting = false

    turret_health = MAX_TURRET_HEALTH


func _physics_process(delta):
    if flash_timer > 0:
        flash_timer -= delta

    if flash_timer <= 0:
        node_flash_one.visible = false
    if turret_health <= 0:
        if destroyed_timer > 0:
            destroyed_timer -= delta
        else:
            turret_health = MAX_TURRET_HEALTH
#            smoke_particles.emitting = false
    if turret_health <= 0:
        return
    if fire_timer > 0:
        fire_timer -= delta
        return
    else:
        fire_timer = 0
    if is_active == true and is_broken == false:
        if current_target != null:
            for rayCast in $Ray_Cast.get_children():
                rayCast.look_at(current_target.global_transform.origin + Vector3(0, PLAYER_HEIGHT, 0), Vector3(0, 1, 0))
                rayCast.force_raycast_update()
                if rayCast.is_colliding():
                    var body = rayCast.get_collider()
                    if body.has_method("getObjectName"):
                        if body.getObjectName() == "Player":
                                fire_bullet(rayCast)
                                break

func fire_bullet(rayCast):
    self.look_at(current_target.global_transform.origin + Vector3(0, PLAYER_HEIGHT, 0), Vector3(0, 1, 0))
    if current_target.has_method("bullet_hit"):
        current_target.bullet_hit(TURRET_DAMAGE, rayCast.get_collision_point())
    node_flash_one.visible = true
    flash_timer = FLASH_TIME
    fire_timer = FIRE_TIME
    is_active = false


func body_entered_vision(body):
    if current_target == null and is_broken == false:
        if body is KinematicBody:
            if body.has_method("getObjectName"):
                if(body.getObjectName() == "Player"):
                    current_target = body
                    is_active = true


func body_exited_vision(body):
    if current_target != null and is_broken == false:
        if body == current_target:
            current_target = null
            is_active = false

            flash_timer = 0
            fire_timer = 0
            node_flash_one.visible = false


func bullet_hit(damage, bullet_hit_pos):
    if turret_health > 0:
        turret_health -= 1
    if turret_health <= 0:
        if isExplosed == false:
            create_sound("explosion", self.global_transform.origin)
            isExplosed = true
        smoke_particles1.emitting = true
        smoke_particles2.emitting = true
        smoke_particles3.emitting = true
        destroyed_timer = DESTROYED_TIME
        is_active = false
        is_broken = true
        $Head/gun.mode = RigidBody.MODE_RIGID
        $Head/Main_body.mode = RigidBody.MODE_RIGID
        $Base/body.mode = RigidBody.MODE_RIGID
        $Base/foot.mode = RigidBody.MODE_RIGID;

func getObjectName():
    return "Turret"