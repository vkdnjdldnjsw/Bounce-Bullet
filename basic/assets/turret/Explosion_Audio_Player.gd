extends Spatial

# All of the audio files.
# You will need to provide your own sound files.
var audio_bounce = preload("res://sounds/explosion.wav")

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

    if sound_name == "explosion":
        audio_node.stream = audio_bounce
    else:
        print ("UNKNOWN STREAM")
        queue_free()
        return

    if position != null:
        audio_node.global_transform.origin = position

    audio_node.play()


func destroy_self():
    audio_node.stop()
    queue_free()