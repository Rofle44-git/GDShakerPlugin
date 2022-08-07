@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Shaker", "Node", load("res://addons/ShakerPlugin/Shaker.gd"), load("res://addons/ShakerPlugin/Shaker.svg"));
