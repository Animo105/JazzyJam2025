extends Node
signal plushCollected(id : int)
signal lookingAtPlush(looking : bool)
signal message(text : String)

var nbPlushCollected : int = 0

signal is_chasing(enable : bool)

const mouse_sensitivity : float = 0.2
