extends TextureRect

func _ready():
	Events.connect("player_hurt", self, "_event_player_hurt")

func _event_player_hurt(hp, damage):
	$Hearts.get_children().front().queue_free()
