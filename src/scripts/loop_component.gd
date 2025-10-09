class_name LoopComponent
extends Node

# The node that will be cloned
@onready var obj: Node2D = get_parent()

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

	prev_transform = obj.transform

	late_ready.call_deferred()

# Deferring this may not be necessary, I'm not sure
func late_ready():
	# Create clones of the parent node including all children
	# but without scripts
	const duplicate_flags: int = DUPLICATE_SIGNALS | DUPLICATE_GROUPS
	left_instance = obj.duplicate(duplicate_flags)
	right_instance = obj.duplicate(duplicate_flags)
	left_instance.name = "Left Clone " + obj.name 
	right_instance.name = "Right Clone " + obj.name 
	instances.append(left_instance)
	instances.append(right_instance)
	
	# Set the proper initial positions of the clones
	left_instance.position.x -= level.tile_map_offset
	right_instance.position.x += level.tile_map_offset

	for instance in instances:
		level.add_child(instance)
		# Physics interpolation should probably be turned off because
		# we sync the transform in _process
		instance.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		# Run any clone process functions after the original ones
		instance.process_priority = 1
		instance.process_physics_priority = 1
		connect_signals(instance)

func _process(_delta: float) -> void:
	# Sync transforms, if necessary
	if not obj.global_transform.is_equal_approx(prev_transform):
		var delta_pos: Vector2 = obj.global_transform.origin - prev_transform.origin
		for instance in instances:
			instance.global_position += delta_pos
			instance.global_rotation = obj.global_rotation
			instance.global_scale = obj.global_scale
			
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
			left_node.set(property_name, value)
			right_node.set(property_name, value)
			break

func get_all_orginal_nodes()-> Array[Node]:
	var result: Array[Node] = obj.find_children("*")
	result.push_front(obj)
	return result

func get_all_cloned_nodes(instance: Node2D)-> Array[Node]:
	var result: Array[Node] = instance.find_children("*", "", true, false)
	result.push_front(instance)
	return result
