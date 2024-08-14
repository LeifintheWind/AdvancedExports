@tool
extends Resource
class_name NewResource

var teamName: String:
	set(value):
		teamName = value
		check_team_color()
var teamColor: Color
var npcBaseHealth: float
var npcExtraAttackPower: int
var npcExtraSpellFriendlyFire: bool
var npcExtraSpellDamage: float

var npcExtraPotionBags: Array = []
var potionsKeys: Array = potionTypes.keys()
var potionsList: String = ",".join(potionsKeys)
enum potionTypes {
	HEALTH,
	STAMINA,
	MANA,
}

var npcBaseTrainedClasses: int:
	set(value):
		npcBaseTrainedClasses = value
		notify_property_list_changed()
var classesKeys: Array = classes.keys()
var classesList: String = ",".join(classesKeys)
enum classes {
	PALADIN = 1 << 0,
	WIZARD = 1 << 1,
	WARRIOR = 1 << 2,
	THIEF = 1 << 3,
}

var npcBaseSpells: Array = []

var npcBaseHurtboxShape: Shape2D

func check_team_color() -> void:
	match teamName:
		"Red":
			teamColor = Color(1, 0, 0, 1)
		"Green":
			teamColor = Color(0, 1, 0, 1)
		"Blue":
			teamColor = Color(0, 0, 1, 1)

func _get_property_list() -> Array:
	var properties: Array = []
	properties.append({
		"name": "Team Category",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY,
		"hint_string": "team"
	})
	properties.append({
		"name": "teamName",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
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
		"hint_string": "npcBase"
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
			"hint_string": "npcExtraSpell"
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