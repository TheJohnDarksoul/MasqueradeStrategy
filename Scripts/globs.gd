extends Node

enum weaponTypes {SWORD, GUN, TOME, KNUCKLES}

var selectedPlayer:Unit = null
var selectedEnemy:Unit = null

enum GameState {
	BEGIN_TURN,
	SELECTING,
	CHOOSING,
	MOVING,
	ATTACKING,
	ENEMY_TURN,
}
var current_state: GameState = GameState.BEGIN_TURN

var mvt_setup = false
var eTurnSetup = false

var char_to_act = []
