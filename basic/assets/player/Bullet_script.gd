extends KinematicBody
var BULLET_SPEED = 70
var BULLET_DAMAGE = 1
var BULLET_MAX_BOUND = 3
var simple_audio_player = preload("res://basic/assets/player/Bounce_Audio_Player.tscn")
var velocity = Vector3()
var isMainMenu = false
export (bool) var sound = true

func _ready():
    pass
    
var colNum = 0

func _go(facing):
    velocity = facing.normalized() * BULLET_SPEED
func create_sound(sound_name, position=null):
    if sound == false:
        return
    var audio_clone = simple_audio_player.instance()
    var scene_root = get_tree().root.get_children()[0]
    scene_root.add_child(audio_clone)
    audio_clone.play_sound(sound_name, position)
func _physics_process(delta):
    if colNum > BULLET_MAX_BOUND:
        return
    var collision = move_and_collide(velocity * delta)
    
    if collision:
        if collision.collider.has_method("getObjectName"):
            if collision.collider.getObjectName() == "Player":
                queue_free()
                colNum = BULLET_MAX_BOUND
                #just kill
                return
            if collision.collider.getObjectName() == "Turret":
                collision.collider.bullet_hit(BULLET_DAMAGE, global_transform)
                queue_free()
                colNum = BULLET_MAX_BOUND
                return
        if isMainMenu == false:
            colNum = colNum + 1
        if colNum > BULLET_MAX_BOUND:
            queue_free()
        else :
            create_sound("bounce", self.global_transform.origin)
        velocity = velocity.bounce(collision.normal)
        #self.look_at(motion.normalized(), Vector3(0,1,0))
        #look_at(motion, Vector3(0,1,0))
        #move_and_collide(motion)


