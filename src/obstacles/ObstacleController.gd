class_name ObstacleController
extends Node


export var star_path: NodePath
var star: Star

var obstacles: Array = []

func _ready():
    star = get_node(star_path)
    obstacles = get_children()

func move_all():
    for obstacle in obstacles:
        obstacle.moving = true
