@tool
extends Node2D
## Made by LeifInTheWind 13-Aug-24
## This is a companion project for the advanced exports tutorial on
## youtube by https://www.youtube.com/@Leif_in_the_Wind

@export var parentNode: Node2D
var collisionShape: CollisionShape2D
var newResource: NewResource

## Be careful when running the process function in a tool script.
## If errors are written it can quickly crash the editor, fill
## the output log with errors, or slow down the editor to a crawl.
func _process(_delta) -> void:
	if Engine.is_editor_hint():
		if is_instance_valid(parentNode):
			## The variable in the parent node has to be an exported
			## variable for a tool script to be able to access it
			## if the parent's script is not a tool.
			newResource = parentNode.newResource
			update_shape()

## A simple function. Other methods for getting the necessary
## information to the visualizer and updating the editor are possible
## including using the draw function. The visualizer can also call
## functions from tool resources/scripts in order to set up variables that
## the visualizer wants to access.
func update_shape() -> void:
	if get_child_count() < 1:
		collisionShape = CollisionShape2D.new()
		# Be cautious when adding children via tool scripts, as
		# if done incorrectly it will overload the editor and
		# cause slowdowns and crashes.
		add_child(collisionShape)
	var newShape: Shape2D
	newShape = newResource.npcBaseHurtboxShape
	collisionShape.shape = newShape
