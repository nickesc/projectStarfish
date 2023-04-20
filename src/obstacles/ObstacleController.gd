class_name ObstacleController
extends Node

export var spawn_seed: int = 1234

export var spawn_distance_interval = Vector2(4000,5000)
export var num_walters = 80
export var num_clouds = 150
export var num_boosts = 150
export var num_trampolines = 150
export var num_coins = 150
export var num_boats = 5

var offscreen_x_offset = 2000
#export var star_path: NodePath
#var star: Star

var obstacles: Array = []
var obstacle_randomizer: RandomNumberGenerator

var configured = false
var max_position = 0

var intervals_spawned = 0

func _ready():
    #if get_node_or_null(star_path):
        #star = get_node(star_path)
    
    set_randomizer(spawn_seed)
    configured = true
    spawn_obstacles(Vector2.ZERO)
    
func set_spawn_parameters(distance_interval,walters,clouds,boosts,trampolines,coins,boats):
    spawn_distance_interval = distance_interval
    num_walters = walters
    num_clouds = clouds
    num_boosts = boosts
    num_trampolines = trampolines
    num_coins = coins
    num_boats = boats 
    
func spawn_initial_obstacles():
    intervals_spawned += 1
    if configured:
        make_walters() 

func spawn_obstacles(position_offset):
    print("spawning")
    intervals_spawned += 1
    if configured:
        make_walters(position_offset)
        make_boats(position_offset)

func clear_obstacles():
    intervals_spawned = 0
    max_position = 0
    for obstacle in obstacles:
        obstacle.queue_free()
    
    obstacles = []

func make_boats(position_offset = Vector2.ZERO):
    if configured:
        var boat = load("res://scenes/obstacles/Boat.tscn")
        
        var boat_positions = generate_random_vector_list(num_boats, position_offset)
        
        for vector in boat_positions:
            var boat_instance = boat.instance()
            boat_instance.controller = self
            add_child(boat_instance)
            obstacles.append(boat_instance)
            vector.y = 285
            boat_instance.position = vector

func make_walters(position_offset = Vector2.ZERO):
    if configured:
        var walter = load("res://scenes/obstacles/WalterBird.tscn")
        
        var walter_positions = generate_random_vector_list(num_walters, position_offset)
        
        
        for vector in walter_positions:
            var walter_instance = walter.instance()
            walter_instance.controller = self
            add_child(walter_instance)
            obstacles.append(walter_instance)
            walter_instance.position = vector
    
func generate_random_vector_list(num_vectors = 0, position_offset = Vector2.ZERO) -> PoolVector2Array:
    var vector_list = PoolVector2Array()
    var x_list = PoolIntArray()
    var y_list = PoolIntArray()
    
    # add 250 to the y position of all obstacles to bring them below y=0
    var adjust_obstacles_offset = Vector2(0,250)
    
    if configured:
        var max_x = int(spawn_distance_interval.x)
        var max_y = int(spawn_distance_interval.y)
        
        var vector = 0
        if num_vectors == 0:
            num_vectors = 500
        
        while vector < num_vectors:
            x_list.append(random_int(max_x))
            vector += 1
        
        x_list.sort()
        
        vector = 0
        while vector < num_vectors:
            y_list.append(random_int(max_y) * -1)
            vector += 1
        
        vector = 0
        while vector < num_vectors:
            vector_list.append(Vector2(x_list[vector], y_list[vector]) + position_offset + adjust_obstacles_offset)
            vector += 1
    
    
    return vector_list
    

func move_all():
    for obstacle in obstacles:
        obstacle.moving = true

func set_randomizer(random_seed = null):
    obstacle_randomizer = RandomNumberGenerator.new()
    if random_seed:
        obstacle_randomizer.set_seed(random_seed)
    else:
        obstacle_randomizer.randomize()

func random_int(max_value = 0) -> int: 
    return int(obstacle_randomizer.randi() % max_value)

func random_from(array):
    return array[obstacle_randomizer.randi() % array.size()]

func random_order(array, do_not_start_with = null):
    var randomized_array = []
    
    var curr_randomized_array_index = 0
    var random_pop_index
    while not array.empty():
        random_pop_index = random_int(array.size())
        if array[random_pop_index] != do_not_start_with or curr_randomized_array_index != 0:
            randomized_array.append(array.pop_at(random_pop_index))
            curr_randomized_array_index+=1
    
    return randomized_array


func _on_Star_reset():
    set_randomizer(spawn_seed)
    clear_obstacles()
    if configured:
        spawn_obstacles(Vector2.ZERO)

func _on_Star_max_position_change(new_max_position):
    if configured:
        max_position = new_max_position
        
        var star_position_required_for_next_spawn = (intervals_spawned * spawn_distance_interval.x) - offscreen_x_offset
        
        print(star_position_required_for_next_spawn, " ",max_position.x)
        
        if max_position.x >= star_position_required_for_next_spawn:
            spawn_obstacles(Vector2((intervals_spawned) * spawn_distance_interval.x,0))
