extends Node2D

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