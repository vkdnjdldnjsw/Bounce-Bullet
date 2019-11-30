extends Spatial

var audio_bounce = preload("res://sounds/bounce.wav")

var audio_node = null

func _ready():
    audio_node = $Audio_Stream_Player3D
    audio_node.connect("finished", self, "destroy_self")
    audio_node.stop()


func play_sound(sound_name, position=null):

    if audio_bounce == null:
        print ("Audio not set!")
        queue_free()
        return

    if sound_name == "bounce":
        audio_node.stream = audio_bounce
    else:
        print ("UNKNOWN STREAM")
        queue_free()
        return

    # If you are using an AudioStreamPlayer3D, then uncomment these lines to set the position.
    #if audio_node is AudioStreamPlayer3D:
        if position != null:
            audio_node.global_transform.origin = position

    audio_node.play()


func destroy_self():
    audio_node.stop()
    queue_free()