extends Node2D

@onready var ms: MultiplayerSpawner = $MultiplayerSpawner
@onready var button: Button = $Host
@onready var refresh: Button = $Refresh
@onready var lobbies: VBoxContainer = $"Lobby container/Lobbies"
@onready var text_edit: TextEdit = $TextEdit
@onready var join_with_id: Button = $"Join Lobby"

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()
	
func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	button.hide()
	lobbies.hide()
	refresh.hide()
	text_edit.hide()
	join_with_id.hide()

func _on_button_pressed() -> void:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://level.tscn")
	button.hide()
	lobbies.hide()
	refresh.hide()
	text_edit.hide()
	join_with_id.hide()
	
func _on_lobby_created(connected, id):
	if connected:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyData(lobby_id, "game", "ALT: Theatre Games")
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)
		print(Steam.getAllLobbyData(lobby_id))

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.requestLobbyList()
	
func _on_lobby_match_list(lobby_list):
	for lobby in lobby_list:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var game_name = Steam.getLobbyData(lobby, "game")
		var mem_count = Steam.getNumLobbyMembers(lobby)
		
		
		#print(Steam.getAllLobbyData(lobby))
		if game_name != "":
			print("name: ", game_name)
		if game_name != "ALT: Theatre Games":
			continue
		
		var btn = Button.new()
		btn.set_text(str(lobby_name, "| Player Count: ", mem_count))
		btn.set_size(Vector2(100, 5))
		
		btn.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		lobbies.add_child(btn)


func _on_refresh_pressed() -> void:
	if lobbies.get_child_count() > 0:
		for child in lobbies.get_children():
			child.queue_free()
	open_lobby_list()


func _on_join_lobby_pressed() -> void:
	var lobby = text_edit.text.strip_edges()
	join_lobby(int(lobby))
