@tool
extends Node2D
## Made by LeifInTheWind 13-Aug-24
## This is a companion project for the advanced exports tutorial on
## youtube by https://www.youtube.com/@Leif_in_the_Wind

## Double hash addes the comment to the inspector.
var teamName: String:
	set(value):
		teamName = value
		check_team_color()
## The team color will update if the team name is set to
## Red, Green, or Blue.
var teamColor: Color
## [b]Double hash comments can be formatted like so. [/b] [br]
## More information is in the Godot docs here: [br]
## https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html
var npcBaseHealth: float
var npcExtraAttackPower: int
var npcExtraSpellFriendlyFire: bool
var npcExtraSpellDamage: float

var npcExtraPotionBags: Array = []
## This produces an array of strings that match the Enum "names"
var potionsKeys: Array = potionTypes.keys()
## This joins the array of strings together to form one string
## with each value separated by a comma. This is the format needed by
## the hint_string
var potionsList: String = ",".join(potionsKeys)
enum potionTypes {
	HEALTH,
	STAMINA,
	MANA,
}

## notify_property_list_changed() is required here as this variable
## is being used to update what the inspector is displaying, and
## so the  _get_property_list() needs to be run again.
var npcBaseTrainedClasses: int:
	set(value):
		npcBaseTrainedClasses = value
		notify_property_list_changed()
## This produces an array of strings that match the Enum "names"
var classesKeys: Array = classes.keys()
## This joins the array of strings together to form one string
## with each value separated by a comma. This is the format needed by
## the hint_string
var classesList: String = ",".join(classesKeys)
## Bit flags related to exported variables need to be in order and complete
## (starting at 1 << 0) otherwise the integer and enum values will not match
enum classes {
	PALADIN = 1 << 0, ## Specifying that the first bit in the bit array is flipped
					## resulting in an integer value of 1
	WIZARD = 1 << 1,
	WARRIOR = 1 << 2,
	THIEF = 1 << 3,
}

var npcBaseSpells: Array = []

var npcBaseHurtboxShape: Shape2D

## A simple function that updates the team color
## to match specific team names. notify_property_list_changed()
## is not required as the inspector does not need to update.
func check_team_color() -> void:
	match teamName:
		"Red":
			teamColor = Color(1, 0, 0, 1)
		"Green":
			teamColor = Color(0, 1, 0, 1)
		"Blue":
			teamColor = Color(0, 0, 1, 1)

## Incorrect scripting in a tool script can cause the script to completely
## "shut down" and for the inspector to not display anything at all related
## to the script. Save/commit often and add things slowly to prevent confusion
## and difficult-to-locate bugs.
# More documentation here:
# https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-private-method-get-property-list
# and here:
# https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-get-property-list
func _get_property_list() -> Array:
	var properties: Array = []
	properties.append({
		"name": "Team Category",
		# More documentation here:
		# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-variant-type
		"type": TYPE_NIL, # Categories don't have a variant type
		# More documentation here:
		# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-propertyusageflags
		"usage": PROPERTY_USAGE_CATEGORY, # Categories do not work in tool resources,
										# but do work in standalone node scripts
		"hint_string": "team" # This must match the proceeding variable prefixes,
								# such as in the following teamName and teamColor
	})
	properties.append({
		"name": "teamName",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT, # Simple variables don't need hints
										# or hint_strings
	})
	properties.append({
		"name": "teamColor",
		"type": TYPE_COLOR,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	properties.append({
		"name": "NPC Info",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY,
		"hint_string": "npc"
	})
	properties.append({
		"name": "Base Properties",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "npcBase" # This hint string must contain "npc" in order
								# to be apart of the "NPC Info" category
	})
	properties.append({
		"name": "npcBaseHealth",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,50,0.5,or_greater",
	})
	properties.append({
		"name": "npcBaseHurtboxShape",
		"type": TYPE_OBJECT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Shape2D",
	})
	properties.append({
		"name": "npcBaseTrainedClasses",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": classesList,
	})
	properties.append({
		"name": "npcBaseSpells",
		"type": TYPE_ARRAY,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_TYPE_STRING,
		# More examples of this are in the documentation here:
		#	https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-propertyhint
		"hint_string": str("%d/%d:" + "SpellResource") % \
				[TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE]
	})
	properties.append({
		"name": "Extra Properties",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "npcExtra"
	})
	properties.append({
		"name": "npcExtraAttackPower",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	properties.append({
		"name": "npcExtraPotionBags",
		"type": TYPE_ARRAY,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_TYPE_STRING,
		"hint_string": str("%d:%d/%d:" + potionsList) % \
				[TYPE_ARRAY, TYPE_INT, PROPERTY_HINT_ENUM],
	})
	if classes.WIZARD & npcBaseTrainedClasses != 0:
		properties.append({
			"name": "Wizard Spell",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_SUBGROUP,
			"hint_string": "npcExtraSpell" # This hint string must contain "npcExtra" in order
								# to be apart of the "Extra Properties" group
		})
		properties.append({
			"name": "npcExtraSpellFriendlyFire",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "npcExtraSpellDamage",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "1,20,0.2",
		})
	return properties