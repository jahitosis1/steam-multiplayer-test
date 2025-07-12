extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	Steam.steamInitEx(480)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()
