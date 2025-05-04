extends CanvasLayer
@onready var lives_counter: Label = %lives_counter
@onready var twigs_counter: Label = %twigs_counter

func _ready() -> void:
	lives_counter.text = '3'
	SignalBus.update_lives_counter.connect(_update_player_lives_display)
	SignalBus.update_twigs_counter.connect(_update_twigs_display)

func _update_player_lives_display(lives: int) -> void:
	lives_counter.text = str(lives)

func _update_twigs_display(twigs: int) -> void:
	Global.twigs_total += twigs
	twigs_counter.text = str(Global.twigs_total)
