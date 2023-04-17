extends ParallaxBackground



func _on_Star_fallen():
    print("set_Layer")
    set_layer(1)



func _on_Star_thrown(speed, angle):
    print("set_Layer")
    set_layer(-2)
