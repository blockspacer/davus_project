extends MarginContainer

const Lobby = preload("Lobby.tscn")

onready var _lobbies = $VBoxContainer/Lobbies

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func refresh():
	pass


func clear_lobbies():
	for lobby in _lobbies.get_children():
		lobby.queue_free()


func _on_RefreshButton_pressed():
	clear_lobbies()
	$LobbiesDiscover.discover()


func _on_LobbiesDiscover_on_update_lobbies(lobbies):
	clear_lobbies()
	for lobby in lobbies:
		var item = Lobby.instance()
		item.lobby_name = lobby.name
		item.current_player = lobby.current_player
		item.max_player = lobby.max_player
		item.connect("joined", self, "_on_JoinButton_pressed")
		_lobbies.add_child(item)


func _on_JoinButton_pressed(host, port):
	
	# TODO : join game then start game
	
	pass

func _on_CreateButton_pressed():
	
	# TODO : launch game and register game to lobby service
	
	$LobbyCreator.create_lobby("My Game")
	
	pass # Replace with function body.


func _on_ExitButton_pressed():
	
	# TODO : return to main menu
	
	pass # Replace with function body.