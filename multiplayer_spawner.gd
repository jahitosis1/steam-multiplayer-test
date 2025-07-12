extends MultiplayerSpawner

@export var player: PackedScene

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_function = spawn_player
	if is_multiplayer_authority():
		multiplayer.peer_connected.connect(spawn_player)
		multiplayer.peer_disconnected.connect(remove_player)
		spawn_player()

func spawn_player(data = 1):
	var p = player.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	p.name = str(data)
	call_deferred("add_child", p)

func remove_player(data):
	players[data].queue_free()
	players.erase(data)
