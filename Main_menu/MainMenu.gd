extends Control

var STAGE_NUM = 22
var MAX_STAGE_PER_PAGE = 10
var start_menu
var stage_menu
var story_menu
var page

func _ready():
    start_menu = $Panel/Margin_Container/Start_Menu
    stage_menu = $Panel/Margin_Container/Stage_Menu
    story_menu = $Panel/Margin_Container/Story_Menu
    $Panel/Margin_Container/Start_Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Start.connect("pressed", self, "start_menu_pressed",["start"])
    $Panel/Margin_Container/Start_Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Story.connect("pressed", self, "start_menu_pressed",["story"])
    $Panel/Margin_Container/Start_Menu/VBoxContainer/HBoxContainer2/VBoxContainer/Button_Quit.connect("pressed", self, "start_menu_pressed",["quit"])
    $Panel/Margin_Container/Stage_Menu/Button_back.connect("pressed", self, "stage_menu_pressed",["back"])
    $Panel/Margin_Container/Story_Menu/Button_back.connect("pressed", self, "story_menu_pressed",["back"])
    var left_button = $Panel/Margin_Container/Stage_Menu/Stage/CenterContainer/Button_left
    var right_button = $Panel/Margin_Container/Stage_Menu/Stage/CenterContainer2/Button_right
    left_button.connect("pressed", self, "stage_page_button_pressed",["left"])
    right_button.connect("pressed", self, "stage_page_button_pressed",["right"])
    
    var stage = $Panel/Margin_Container/Stage_Menu/Stage/GridContainer
    for i in range(0, MAX_STAGE_PER_PAGE):
        stage.get_children()[i].connect("pressed", self, "stage_button_pressed",[i + 1])

func stage_button_pressed(button_num):
    var pressed_button_num = page * MAX_STAGE_PER_PAGE + button_num
    get_tree().change_scene("res://Stage/" + str(pressed_button_num) + ".tscn")

func load_stage():
    var stage = $Panel/Margin_Container/Stage_Menu/Stage/GridContainer
    var left_button = $Panel/Margin_Container/Stage_Menu/Stage/CenterContainer/Button_left
    var right_button = $Panel/Margin_Container/Stage_Menu/Stage/CenterContainer2/Button_right
    
    for i in range(0, min(MAX_STAGE_PER_PAGE,STAGE_NUM - page*MAX_STAGE_PER_PAGE)):
        stage.get_children()[i].text = str((page * 10 + i + 1))
        stage.get_children()[i].visible = true
    for i in range(min(MAX_STAGE_PER_PAGE,STAGE_NUM - page*MAX_STAGE_PER_PAGE), MAX_STAGE_PER_PAGE):
        stage.get_children()[i].visible = false
    if page == 0:
        left_button.visible = false
    else:
        left_button.visible = true
    if (page + 1) * 10 >= STAGE_NUM:
        right_button.visible = false
    else:
        right_button.visible = true
func stage_page_button_pressed(button_name):
    if button_name == "left":
        page -= 1
    if button_name == "right":
        page += 1
    load_stage()
    
func start_menu_pressed(button_name):
    if button_name == "start":
        start_menu.visible = false
        stage_menu.visible = true
        page = 0
        load_stage()
        stage_menu.visible = true
    elif button_name == "story":
        start_menu.visible = false
        story_menu.visible = true
    elif button_name == "quit":
        get_tree().quit()
        
func stage_menu_pressed(button_name):
    if button_name == "back":
        stage_menu.visible = false
        start_menu.visible = true
func story_menu_pressed(button_name):
    if button_name == "back":
        story_menu.visible = false
        start_menu.visible = true

        