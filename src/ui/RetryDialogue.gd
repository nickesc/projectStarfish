extends PanelContainer

signal get_ready()

var amount_format = "x%02d"

export var initial_global_cost = 10
export var initial_global_amount = 0
export var throw_upgrade_increase = .2
var global_cost_increase
var time_limit = {"name":"TimeLimit","cost":0,"amount":0}
var throw_power = {"name":"ThrowPower","cost":0,"amount":0}
var throw_number = {"name":"ThrowNumber","cost":0,"amount":0}

export var star_path: NodePath
var star: Star

export var main_path: NodePath
var main: Node

var position_format = "Longest Throw:\n %.1f m"

func set_cost(upgrade, new_cost):
    if new_cost>99:
        new_cost = 99
    upgrade["cost"] = new_cost
    get_node("Store/"+upgrade["name"]+"/Buy").text = "x" + str(new_cost)

func set_amount(upgrade, new_amount):
    if new_amount>10:
        return false
    upgrade["amount"] = new_amount
    get_node("Store/"+upgrade["name"]+"/Amount").text = amount_format % new_amount
    return true

func swap_to_store():
    $Retry.set_visible(false)
    $Store.set_visible(true)

func swap_to_retry():
    $Store.set_visible(false)
    $Retry.set_visible(true)
    

func hide_and_ready():
    swap_to_retry()
    set_visible(false)
    emit_signal("get_ready")

# Called when the node enters the scene tree for the first time.
func _ready():
    star = get_node(star_path)
    main = get_node(main_path)
    
    global_cost_increase = initial_global_cost/2
    
    set_cost(time_limit,initial_global_cost)
    set_amount(time_limit,initial_global_amount)
    set_cost(throw_power,initial_global_cost)
    set_amount(throw_power,initial_global_amount)
    set_cost(throw_number,initial_global_cost)
    set_amount(throw_number,initial_global_amount)
    
    #pass # Replace with function body.
    
func _process(delta):
    #if star.retry
    pass
    
func unhide():
    set_visible(true)
    swap_to_retry()

func _on_RetryButton_button_up():
    hide_and_ready()


func _on_Star_max_max_position_changed(new_max_max):
    
    #new_max_max = new_max_max.x * 10
    #new_max_max = round(new_max_max)
    #new_max_max = float(new_max_max / 10)
    
    new_max_max = new_max_max.x / star.pixel_to_meter_conversion_factor
    
     
    var max_max_string = position_format % new_max_max
    
    $Retry/BestLabel.text = max_max_string


func _on_Star_retry_dialogue():
    unhide()


func _on_StoreButton_button_up():
    swap_to_store()


func _on_BackButton_button_up():
    swap_to_retry() # Replace with function body.


func _on_ThrowNumber_Buy_button_up():
    
    if main.shells >= throw_number["cost"]:
        
        if set_amount(throw_number, throw_number["amount"]+1):
            main.update_shells(main.shells - throw_number["cost"])
            set_cost(throw_number,throw_number["cost"]+global_cost_increase)
            star.max_jumps += 1
            star.initial_max_jumps = star.max_jumps
            star.update_jumps(star.max_jumps)
    
    #print(main.shells)
    #print(time_limit,throw_number,throw_power)


func _on_ThrowPower_Buy_button_up():
    if main.shells >= throw_power["cost"]:
        if set_amount(throw_power, throw_power["amount"]+1):
            main.update_shells(main.shells - throw_power["cost"])
            set_cost(throw_power,throw_power["cost"]+global_cost_increase)
            star.throw_power_upgrade += throw_upgrade_increase


func _on_TimeLimit_Buy_button_up():
    if main.shells >= time_limit["cost"]:
        if set_amount(time_limit, time_limit["amount"]+1):
            main.update_shells(main.shells - time_limit["cost"])
            set_cost(time_limit,time_limit["cost"]+global_cost_increase)
            main.initial_time_limit += 5
            main.reset_time_limit_timer()
