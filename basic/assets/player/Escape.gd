extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_stage
var button_game
# Called when the node enters the scene tree for the first time.
func _ready():
    var button_main_menu = $Panel/Margin_Container/Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Main_Menu
    var button_quit = $Panel/Margin_Container/Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Quit
    var button_retry = $Panel/Margin_Container/Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Retry
    button_game = $Panel/Margin_Container/Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Game
    button_main_menu.connect("pressed", self, "main_menu_pressed")
    button_quit.connect("pressed", self, "quit_pressed")
    button_retry.connect("pressed", self, "retry_pressed")    
    button_game.connect("pressed", self, "game_pressed")
    
func _physics_process(delta):
    process_input(delta)
func process_input(delta):
    # ----------------------------------
    # Capturing/Freeing the cursor
    if Input.is_action_just_pressed("ui_cancel"):
        if self.visible == false:
            show()
        else:
            unshow()
    # ----------------------------------
func show():
    self.visible = true
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    get_tree().paused = true
func unshow():
    self.visible = false
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    get_tree().paused = false
func game_pressed():
    unshow()
func main_menu_pressed():
    get_tree().change_scene("res://Main_menu/MainMenu2.tscn")
    get_tree().paused = false
func retry_pressed():
    get_tree().change_scene("res://Stage/" + str(current_stage) + ".tscn")
    get_tree().paused = false
func quit_pressed():
    get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
