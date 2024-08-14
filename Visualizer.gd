@tool
extends Node2D

@export var parentNode: Node2D
var collisionShape: CollisionShape2D
var newResource: NewResource

func _process(_delta) -> void:
	if Engine.is_editor_hint():
		if is_instance_valid(parentNode):
			newResource = parentNode.newResource
			update_shape()

func update_shape() -> void:
	if get_child_count() < 1:
		collisionShape = CollisionShape2D.new()
		add_child(collisionShape)
	var newShape: Shape2D
	newShape = newResource.npcBaseHurtboxShape
	collisionShape.shape = newShape
