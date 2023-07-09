class_name SpellWorldInstance extends Node2D


# Abstract class used as the basis of spells


@warning_ignore("unused_private_class_variable")
var _caster : PlayerMain :
	set(new_value):
		_caster = new_value

func attempt_cast() -> void:
	pass
