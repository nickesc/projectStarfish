extends Label

var time_format = "%.2f sec"


func _on_Star_score_change(score):
    #text = str(score) + " sec"
    pass

func _on_TimeLimitTimer_time_change(time):
    
    time = time * 10
    time = round(time)
    time = float(time / 10)
    
     
    var time_string = time_format % time
    
    text = time_string


func _on_Main_time_limit_set(time_limit):
    _on_TimeLimitTimer_time_change(time_limit)
