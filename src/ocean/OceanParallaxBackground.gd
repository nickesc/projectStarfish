extends ParallaxBackground



func send_to_back():
    set_layer(-2)

func send_to_front():
    set_layer(1)


func _on_Star_fallen():
    send_to_front()



func _on_Star_thrown(speed, angle):
    pass


func _on_Star_flying():
    send_to_back()


func _on_Star_reset():
    send_to_back()
