extends Node2D
## Made by LeifInTheWind 13-Aug-24
## This is a companion project for the advanced exports tutorial on
## youtube by https://www.youtube.com/@Leif_in_the_Wind

## Basic exports documentation here:
## https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
@export_category("Team Category")
@export var teamName: String = ""
@export var teamColor: Color

@export_category("NPC Category")
@export_group("Base Properties")
@export_flags("WIZARD:4", "WARRIOR:8", "THIEF:16") var trainedClasses: int
@export var health: float = 3.0

@export_group("Extra Properties")
@export var baseAttack: int = 3
@export var potionBags: Array[Array] = [[1, 2], [3, 4]]

@export_subgroup("Wizard Spell Attack")
@export var friendlyFire: bool = false
@export_range(1, 20, 0.2) var spellDamage: float