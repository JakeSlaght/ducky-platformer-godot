extends CanvasLayer
@onready var lives_counter: Label = %lives_counter


func _ready() -> void:
	lives_counter.text = '3'
	SignalBus.update_lives_counter.connect(_update_player_lives_display)

func _update_player_lives_display(lives: int) -> void:
	print_debug('player has: ', lives)
	lives_counter.text = str(lives)
