@tool
extends Node


## The node to target. Defaults to parent.
@export var target_node:Node = get_parent();
## The property to shake.
@export var target_var:StringName = "";
## Minimum value.
@export var min_value:float = 0.0;
## Maximum value.
@export var max_value:float = 0.0;
## True: Shake until manually disabled.\nFalse: Use a timer to automatically disable shaking.
@export var constant:bool = false;
## If true, the timer starts automatically.
@export var auto_start:bool = false;
## Shake duration. Only applies if constant == false.
@export_range(0.0, 3600, 0.01) var duration:float = 0.8;
## Shake fall off curve. Only applies if constant == false.
@export var fall_off:Curve;
var timer:Timer = Timer.new();


func _ready() -> void:
	add_child(timer);
	timer.wait_time = duration;
	timer.connect("timeout", stop);
	
	if var_is_valid(target_node, target_var) and constant:
		set_process(true);
	else:
		set_process(false);
	
	if auto_start: start();
	
static func var_is_valid(node:Node, property:String) -> bool:
	if !(property in node): print_debug("invalid setup");
	return property in node;

func start(time_sec:float = -1.0) -> void:
	timer.start(time_sec);
	if !var_is_valid(target_node, target_var): print_debug("%s does not have a variable called %s" % [target_node, target_var]);
	else: set_process(true);
	
func stop() -> void:
	timer.stop();
	set_process(false);

func _process(_delta:float) -> void:
	print("shake")
	match typeof(target_node.get(target_var)):
		TYPE_INT: 
			target_node.set(target_var,
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant))
				);
		
		TYPE_FLOAT:
			target_node.set(target_var,
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)
				);
			
		TYPE_VECTOR2I:
			target_node.set(target_var, Vector2i(
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant))
				));
		
		TYPE_VECTOR2:
			target_node.set(target_var, Vector2(
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)
				));
		
		TYPE_VECTOR3I:
			target_node.set(target_var, Vector3i(
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant))
				));
		
		TYPE_VECTOR3:
			target_node.set(target_var, Vector3(
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)
				));
		
		TYPE_VECTOR4I:
			target_node.set(target_var, Vector4i(
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)),
				int(randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant))
				));
		
		TYPE_VECTOR4:
			target_node.set(target_var, Vector4(
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant),
				randf_range(min_value, max_value) * get_curve_interpolation(fall_off, duration, timer.time_left, constant)
				));
		
		_:
			print_debug("Unmatched var type");

static func get_curve_interpolation(curve:Curve, max_time:float, time_left:float, constant:bool) -> Variant:
	if !constant:
		return 1 - curve.interpolate(time_left / max_time);
		
	else:
		return 1;
