extends Spatial

const DAMAGE = 15

var ammo_in_weapon = 10
var spare_ammo = 20
var AMMO_IN_MAG = 10

const IDLE_ANIM_NAME = "Pistol_idle"
const FIRE_ANIM_NAME = "Pistol_fire"

var is_weapon_enabled = false

var bullet_scene = preload("res://basic/assets/player/Bullet_Scene.tscn")
var shot_audio_player = preload("res://basic/assets/player/shot_audio_player.tscn")
var player_node = null

const CAN_RELOAD = true
const CAN_REFILL = true

const RELOADING_ANIM_NAME = "Pistol_reload"
func _ready():
    pass
func fire_weapon():
    var clone = bullet_scene.instance()
    var scene_root = get_tree().root.get_children()[0]
    scene_root.add_child(clone)
    clone._go(self.global_transform.basis.z)
    clone.global_transform = self.global_transform
   # clone.scale = Vector3(4, 4, 4)
    ammo_in_weapon -= 1
    create_sound("Pistol_shot", self.global_transform.origin)
    #clone.BULLET_DAMAGE = DAMAGE
    

func create_sound(sound_name, position=null):
    var audio_clone = shot_audio_player.instance()
    var scene_root = get_tree().root.get_children()[0]
    scene_root.add_child(audio_clone)
    audio_clone.play_sound(sound_name, position)
    
func reload_weapon():
    var can_reload = false

    if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
        can_reload = true

    if spare_ammo <= 0 or ammo_in_weapon == AMMO_IN_MAG:
        can_reload = false

    if can_reload == true:
        var ammo_needed = AMMO_IN_MAG - ammo_in_weapon

        if spare_ammo >= ammo_needed:
            spare_ammo -= ammo_needed
            ammo_in_weapon = AMMO_IN_MAG
        else:
            ammo_in_weapon += spare_ammo
            spare_ammo = 0

        player_node.animation_manager.set_animation(RELOADING_ANIM_NAME)

        return true

    return false
func equip_weapon():
    if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
        is_weapon_enabled = true
        return true

    if player_node.animation_manager.current_state == "Idle_unarmed":
        player_node.animation_manager.set_animation("Pistol_equip")

    return false

func unequip_weapon():
    if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
        if player_node.animation_manager.current_state != "Pistol_unequip":
            player_node.animation_manager.set_animation("Pistol_unequip")

    if player_node.animation_manager.current_state == "Idle_unarmed":
        is_weapon_enabled = false
        return true
    else:
        return false