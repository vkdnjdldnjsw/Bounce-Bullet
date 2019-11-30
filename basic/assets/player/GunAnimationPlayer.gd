extends AnimationPlayer

# Structure -> Animation name :[Connecting Animation states]
var states = {
    "gun_shoot":["gun_idle", "gun_die"],
    "gun_idle":["gun_shoot", "gun_idle", "gun_die"],
    "gun_die" : []
}

var animation_speeds = {
    "gun_shoot":2,
    "gun_idle":1,
    "gun_die":1
}

var current_state = null
var callback_function = null

func _ready():
    set_animation("gun_idle")
    connect("animation_finished", self, "animation_ended")

func set_animation(animation_name):
    if animation_name == current_state:
        print ("AnimationPlayer_Manager.gd -- WARNING: animation is already ", animation_name)
        return true


    if has_animation(animation_name) == true:
        if current_state != null:
            var possible_animations = states[current_state]
            if animation_name in possible_animations:
                current_state = animation_name
                play(animation_name, -1, animation_speeds[animation_name])
                return true
            else:
                print ("AnimationPlayer_Manager.gd -- WARNING: Cannot change to ", animation_name, " from ", current_state)
                return false
        else:
            current_state = animation_name
            play(animation_name, -1, animation_speeds[animation_name])
            return true
    return false


func animation_ended(anim_name):
    if current_state == "gun_idle":
        pass
    elif current_state == "gun_shoot":
        set_animation("gun_idle")
    elif current_state == "gun_die":
        pass

func animation_callback():
    if callback_function == null:
        print ("AnimationPlayer_Manager.gd -- WARNING: No callback function for the animation to call!")
    else:
        callback_function.call_func()