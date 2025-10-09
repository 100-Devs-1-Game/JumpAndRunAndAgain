class_name Killzone
extends Area2D


func _ready() -> void:
	monitorable= false
	# Set to players collision layer
	collision_mask= 2
	body_entered.connect(_on_body_entered)

	# If no CollisionShape child is provided, assume existing
	# CollisionShape shall be used 
	if get_child_count() == 0:
		var coll_shape: CollisionShape2D= get_parent().find_children("", "CollisionShape2D")[0]
		add_child(coll_shape.duplicate())
		
	assert(get_child_count() > 0)
	

func _on_body_entered(body: Node2D):
	assert(body is Player)
	(body as Player).kill()
	
