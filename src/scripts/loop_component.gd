class_name LoopComponent
extends Node

@export var left_overrides: Dictionary
@export var right_overrides: Dictionary

# The node that will be cloned
@onready var obj: Node2D = get_parent()

@onready var overrides: Array[Dictionary] = [ left_overrides, right_overrides ]


var level: InfiniteScrollingLevel

# The cloned instances of the parent node
var left_instance: Node2D
var right_instance: Node2D
var instances: Array[Node2D]

# Store the previous transform to detect any changes
var prev_transform: Transform2D


func _ready() -> void:
	# Find the Level node
	var lookup_node: Node = get_parent()
	while level == null:
		if lookup_node is InfiniteScrollingLevel:
			level = lookup_node
		else:
			lookup_node = lookup_node.get_parent()

	prev_transform = obj.global_transform

	late_ready.call_deferred()

# Deferring this may not be necessary, I'm not sure
func late_ready():
	# Create clones of the parent node including all children
	# but without scripts
	const duplicate_flags: int = 0
	left_instance = obj.duplicate(duplicate_flags)
	right_instance = obj.duplicate(duplicate_flags)
	left_instance.name = "Left Clone " + obj.name 
	right_instance.name = "Right Clone " + obj.name 
	instances.append(left_instance)
	instances.append(right_instance)
	
	# Set the proper initial positions of the clones
	left_instance.position.x -= level.tile_map_offset
	right_instance.position.x += level.tile_map_offset

	for i in 2:
		var instance: Node2D= instances[i]
		var override_dict: Dictionary= overrides[i]
		level.add_child(instance)
		# Physics interpolation should probably be turned off because
		# we sync the transform in _process
		instance.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		# Run any clone process functions after the original ones
		instance.process_priority = 1
		instance.process_physics_priority = 1
		apply_overrides(instance, override_dict)
		connect_signals(instance)

func _process(_delta: float) -> void:
	# Sync transforms, if necessary
	if not obj.global_transform.is_equal_approx(prev_transform):
		var left: bool= true
		for instance in instances:
			instance.global_position = obj.global_position + Vector2( level.tile_map_offset * ( -1 if left else 1 ), 0) 
			instance.global_rotation = obj.global_rotation
			instance.global_scale = obj.global_scale
			left= false
			
		prev_transform = obj.global_transform

func connect_signals(instance: Node2D):
	var all_orginal_nodes: Array[Node] = get_all_orginal_nodes()
	var all_cloned_nodes: Array[Node] = get_all_cloned_nodes(instance)
	
	# Loop through all original nodes ( including the root node ) and the respective
	# clone nodes
	for i in all_orginal_nodes.size():
		var orig_node: Node = all_orginal_nodes[i]
		var clone_node: Node = all_cloned_nodes[i]
		#prints(orig_node, clone_node)
		assert(orig_node.get_class() == clone_node.get_class())
		
		# Skip nodes that won't require any syncing
		if orig_node is not Node2D:
			#print(" skipped")
			continue
		
		# Connect signals from the original nodes to clone nodes properties
		# From here on out we assume all the nodes are Node2D
		var orig_node2d: Node2D = orig_node
		var clone_node2d: Node2D = clone_node
		assert(orig_node2d and clone_node2d)
		
		orig_node2d.visibility_changed.connect(func():
			clone_node2d.visible = orig_node2d.visible)
			
		if orig_node2d is AnimatedSprite2D:
			(orig_node2d as AnimatedSprite2D).animation_changed.connect(func():
				(clone_node2d as AnimatedSprite2D).play((orig_node2d as AnimatedSprite2D).animation))

# Sets a nodes property on the passed Node and all cloned Nodes
func set_property(node: Node, property_name: StringName, value: Variant):
	var all_orginal_nodes: Array[Node] = get_all_orginal_nodes()
	var left_cloned_nodes: Array[Node] = get_all_cloned_nodes(left_instance)
	var right_cloned_nodes: Array[Node] = get_all_cloned_nodes(right_instance)
	
	# Loop through all original nodes ( including the root node ) and the respective
	# clone nodes
	for i in all_orginal_nodes.size():
		var orig_node: Node = all_orginal_nodes[i]
		if orig_node == node:
			var left_node: Node = left_cloned_nodes[i]
			var right_node: Node = right_cloned_nodes[i]
			orig_node.set(property_name, value)
			if not left_overrides.has(property_name):
				left_node.set(property_name, value)
			if not right_overrides.has(property_name):
				right_node.set(property_name, value)
			break


func apply_overrides(instance: Node2D, override_dict: Dictionary):
	for key in override_dict.keys():
		instance.set(key, override_dict[key])


func get_all_orginal_nodes()-> Array[Node]:
	var result: Array[Node] = obj.find_children("*")
	result.push_front(obj)
	return result

func get_all_cloned_nodes(instance: Node2D)-> Array[Node]:
	var result: Array[Node] = instance.find_children("*", "", true, false)
	result.push_front(instance)
	return result
