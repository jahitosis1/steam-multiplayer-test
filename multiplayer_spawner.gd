extends MultiplayerSpawner

@export var player: PackedScene

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)

func spawn_player(data = 1):
	var p = player.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	p.name = str(data)
	#call_deferred("add_child", p)
	return p

func remove_player(data):
	players[data].queue_free()
	players.erase(data)
