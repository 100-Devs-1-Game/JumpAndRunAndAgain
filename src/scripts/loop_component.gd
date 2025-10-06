class_name LoopComponent
extends Node

@onready var obj: Node2D= get_parent()

var level: InfiniteScrollingLevel

var left_instance: Node2D
var right_instance: Node2D
var instances: Array[Node2D]

var prev_transform: Transform2D


func _ready() -> void:
	var lookup_node: Node= get_parent()
	while level == null:
		if lookup_node is InfiniteScrollingLevel:
			level= lookup_node
		else:
			lookup_node= lookup_node.get_parent()

	prev_transform= obj.transform

	late_ready.call_deferred()

func late_ready():
	left_instance= obj.duplicate(11)
	right_instance= obj.duplicate(11)
	instances.append(left_instance)
	instances.append(right_instance)
	
	left_instance.position.x-= level.tile_map_offset
	right_instance.position.x+= level.tile_map_offset

	for instance in instances:
		level.add_child(instance)
		instance.physics_interpolation_mode= Node.PHYSICS_INTERPOLATION_MODE_OFF
		connect_signals(instance)


func _process(_delta: float) -> void:
	if not obj.global_transform.is_equal_approx(prev_transform):
		var delta_pos: Vector2= obj.global_transform.origin - prev_transform.origin
		for instance in instances:
			instance.global_position+= delta_pos
			instance.global_rotation= obj.global_rotation
			instance.global_scale= obj.global_scale
			
		prev_transform= obj.global_transform

func connect_signals(instance: Node2D):
	var all_orginal_nodes: Array[Node]= obj.find_children("*")
	all_orginal_nodes.push_front(obj)
	var all_duplicated_nodes: Array[Node]= instance.find_children("*", "", true, false)
	all_duplicated_nodes.push_front(instance)
	
	for i in all_orginal_nodes.size():
		var orig_node: Node= all_orginal_nodes[i]
		var dup_node: Node= all_duplicated_nodes[i]
		prints(orig_node, dup_node)
		assert(orig_node.get_class() == dup_node.get_class())
		if orig_node is LoopComponent or orig_node is not Node2D:
			print(" skipped")
			continue
		
		var orig_node2d: Node2D= orig_node
		var dup_node2d: Node2D= dup_node
		
		orig_node2d.visibility_changed.connect(func():
			dup_node2d.visible= orig_node2d.visible)
			
