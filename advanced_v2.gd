extends Node2D

@export var newResource: NewResource = NewResource.new()

@export var childNode: Node2D

func _ready():
	childNode.get_resource_info(newResource)