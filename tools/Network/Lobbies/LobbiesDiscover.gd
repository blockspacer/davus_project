extends Node

export var host := "localhost"
export(int, 3000, 65000 ) var port := 8080
export var game := "game_name"

signal on_update_lobbies

var _lobbies_list := []

var _current_lobby_name = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_lobbies():
	return _lobbies_list


func discover():
	
	$GetLobbies.request("http://%s:%d/games-lobbies/games/%s/lobbies" % [host, port, game] )
	


func _on_GetLobbies_request_completed(result, response_code, headers, body):
	
	if result == 2:
		print("Cannot connect to the server")
		return
	
	print("result: ", result, ", response_code: ", response_code, ", headers: ", headers, ", body: ", body.get_string_from_utf8() )
	
	if response_code == 200:
		var lobbies = JSON.parse( body.get_string_from_utf8() )
		print("lobbies: ", lobbies)
		#_lobbies_list = lobbies
		emit_signal("on_update_lobbies", lobbies)