class_name SpellType extends Resource

# Acts as the representation of a spell the player can cast

# The name of the spell
@export var spell_name := ""
# The displayed spell cost of the spell
@export var spell_cost := 25.0
# The world instance of the spell
@export var world_instance : PackedScene
