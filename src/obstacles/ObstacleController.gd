class_name ObstacleController
extends Node

export var spawn_seed: int = 1234

export var spawn_distance_interval = Vector2(4000,5000)
export var num_walters = 20
export var num_lower_clouds = 20
export var num_middle_clouds = 20
export var num_high_clouds = 20
export var num_boosts = 5
export var num_planes = 20
export var num_shells = 250
export var num_boats = 1
export var num_ufos = 20
export var num_twinkles = 150
export var num_fish = 2

export var cloud_speed = .3

var offscreen_x_offset = 2000
#export var star_path: NodePath
#var star: Star

var obstacles: Array = []
var obstacle_randomizer: RandomNumberGenerator

var configured = false
var max_position = 0

var intervals_spawned = 0

func _clear_obstacle(obstacle):
    var i = 0
    while obstacles[i]!=obstacle:
        i+=1
    obstacles.pop_at(i)
    obstacle.queue_free()

        

func _ready():
    #if get_node_or_null(star_path):
        #star = get_node(star_path)
    
    set_randomizer(spawn_seed)
    configured = true
    spawn_obstacles(Vector2.ZERO)

func _process(delta):
    pass



func set_spawn_parameters(distance_interval,walters,lower_clouds,middle_clouds,high_clouds,boosts,planes,shells,boats,ufos,twinkles,fish):
    spawn_distance_interval = distance_interval
    num_walters = walters
    num_lower_clouds = lower_clouds
    num_middle_clouds = middle_clouds
    num_high_clouds = high_clouds
    num_boosts = boosts
    num_planes = planes
    num_shells = shells
    num_boats = boats
    num_ufos = ufos
    num_twinkles = twinkles
    num_fish = fish

func spawn_obstacles(position_offset):
    print("spawning")
    
    if configured:
        intervals_spawned += 1
        make_walters(position_offset)
        make_boats(position_offset)
        make_lower_clouds(position_offset)
        make_shells(position_offset)
        make_planes(position_offset)
        make_ufos(position_offset)
        make_boosts(position_offset)
        make_twinkles(position_offset)
        make_fish(position_offset)

func clear_obstacles():
    intervals_spawned = 0
    max_position = 0
    for obstacle in obstacles:
        obstacle.queue_free()
    
    obstacles = []

func make_shells(position_offset = Vector2.ZERO):
    if configured:

        var shell = load("res://scenes/obstacles/Shell.tscn")
        
        var shell_positions = generate_random_vector_list(num_shells, position_offset, [0,8000])
        
        for vector in shell_positions:
            var shell_instance = shell.instance()
            shell_instance.controller = self
            $Shells.add_child(shell_instance)
            obstacles.append(shell_instance)
            shell_instance.position = vector
            shell_instance.connect("collect_shell", owner, "_on_collect_shell")

func make_boosts(position_offset = Vector2.ZERO):
    if configured:
        
        var boost = load("res://scenes/obstacles/Boost.tscn")
        
        var boost_positions = generate_random_vector_list(num_boosts, position_offset, [400,4000])
        
        for vector in boost_positions:
            var boost_instance = boost.instance()
            boost_instance.controller = self
            $Boosts.add_child(boost_instance)
            obstacles.append(boost_instance)
            boost_instance.position = vector

func make_twinkles(position_offset = Vector2.ZERO):
    if configured:
        var twinkle = load("res://scenes/obstacles/Twinkle.tscn")
        
        var twinkle_positions = generate_random_vector_list(num_twinkles, position_offset, [2750,7000])
        
        
        for vector in twinkle_positions:
            var twinkle_instance = twinkle.instance()
            twinkle_instance.controller = self
            $Twinkles.add_child(twinkle_instance)
            obstacles.append(twinkle_instance)
            twinkle_instance.position = vector

func make_fish(position_offset = Vector2.ZERO):
    if configured:
        var fish = load("res://scenes/obstacles/Fish.tscn")
        
        var fish_positions = generate_random_vector_list(num_fish, position_offset)
        
        for vector in fish_positions:
            var fish_instance = fish.instance()
            fish_instance.controller = self
            $Fish.add_child(fish_instance)
            obstacles.append(fish_instance)
            vector.y = 450
            fish_instance.position = vector


func make_lower_clouds(position_offset = Vector2.ZERO):
    if configured:
        
        
        var lower_cloud = load("res://scenes/obstacles/LowerCloud.tscn")
        
        var lower_cloud_positions = generate_random_vector_list(num_lower_clouds, position_offset, [400,2750])
        
        for vector in lower_cloud_positions:
            var lower_cloud_instance = lower_cloud.instance()
            lower_cloud_instance.controller = self
            $LowerClouds.add_child(lower_cloud_instance)
            obstacles.append(lower_cloud_instance)
            lower_cloud_instance.position = vector
            
func make_ufos(position_offset = Vector2.ZERO):
    if configured:
        var ufo = load("res://scenes/obstacles/UFO.tscn")
        
        var ufo_positions = generate_random_vector_list(num_ufos, position_offset, [3500,6000])
        
        
        for vector in ufo_positions:
            var ufo_instance = ufo.instance()
            ufo_instance.controller = self
            $UFOs.add_child(ufo_instance)
            obstacles.append(ufo_instance)
            ufo_instance.position = vector
            ufo_instance.add_to_group("boats")

func make_planes(position_offset = Vector2.ZERO):
    if configured:
        var plane = load("res://scenes/obstacles/Plane.tscn")
        
        var plane_positions = generate_random_vector_list(num_planes, position_offset, [1600,3000])
        
        
        for vector in plane_positions:
            var plane_instance = plane.instance()
            plane_instance.controller = self
            $Planes.add_child(plane_instance)
            obstacles.append(plane_instance)
            plane_instance.position = vector
            plane_instance.add_to_group("boats")

func make_boats(position_offset = Vector2.ZERO):
    if configured:
        var boat = load("res://scenes/obstacles/Boat.tscn")
        
        var boat_positions = generate_random_vector_list(num_boats, position_offset)
        
        for vector in boat_positions:
            var boat_instance = boat.instance()
            boat_instance.controller = self
            $Boats.add_child(boat_instance)
            obstacles.append(boat_instance)
            vector.y = 285
            boat_instance.position = vector
            boat_instance.add_to_group("boats")

func make_walters(position_offset = Vector2.ZERO):
    if configured:
        var walter = load("res://scenes/obstacles/WalterBird.tscn")
        
        var walter_positions = generate_random_vector_list(num_walters, position_offset, [0,1600])
        
        
        for vector in walter_positions:
            var walter_instance = walter.instance()
            walter_instance.controller = self
            $Walters.add_child(walter_instance)
            obstacles.append(walter_instance)
            walter_instance.position = vector
            walter_instance.add_to_group("walters")
    
func generate_random_vector_list(num_vectors = 0, position_offset = Vector2.ZERO, y_range = [0,0]) -> PoolVector2Array:
    var vector_list = PoolVector2Array()
    var x_list = PoolIntArray()
    var y_list = PoolIntArray()
    
    # add 250 and subtract the minimum y range from the y position of all obstacles to bring them below y=0, then to get them to their minimum height
    var adjust_obstacles_offset = Vector2(0,250 - y_range[0])
    
    if configured:
        var max_x = int(spawn_distance_interval.x)
        var max_y
        # max y refers to the maximum height that the vector will generate to
        # if there is no set maximum y, use the max of the spawn interval
        # otherwise, max y is the second y in the y_range
        if y_range[1] == 0:
             max_y = int(spawn_distance_interval.y)
        else:
            max_y = int(y_range[1])
        
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
        max_position = new_max_position.x
        
        var star_position_required_for_next_spawn = (intervals_spawned * spawn_distance_interval.x) - offscreen_x_offset
        
        #print(star_position_required_for_next_spawn, " ",max_position)
        
        if max_position >= star_position_required_for_next_spawn:
            spawn_obstacles(Vector2((intervals_spawned) * spawn_distance_interval.x,0))
