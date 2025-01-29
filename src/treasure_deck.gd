class_name TreasureDeck extends Node

var _deck: Array[Util.TreasureType] = []
var _discard_pile: Array[Util.TreasureType] = []

func _ready():
	for i in range(2):
		_deck.append(Util.TreasureType.SANDBAGS)
	
	for i in range(2):
		_deck.append(Util.TreasureType.HELICOPTER)
		
	for i in range(6):
		_deck.append(Util.TreasureType.WATER_RISING)
		
	for i in range(6):
		_deck.append(Util.TreasureType.TOTEM_AIR)
		
	for i in range(6):
		_deck.append(Util.TreasureType.TOTEM_WATER)
		
	for i in range(6):
		_deck.append(Util.TreasureType.TOTEM_EARTH)
		
	for i in range(6):
		_deck.append(Util.TreasureType.TOTEM_FIRE)
		
	_deck.shuffle()
	print("deck:    ", _deck)
	print("discard: ", _discard_pile)
	
# Returns `true` if deck contains cards and got reshuffled successfully.
func reshuffle() -> bool:
	print("reshuffling")
	for card in _discard_pile:
		_deck.append(card)
	_discard_pile.resize(0)
	_deck.shuffle()
	return _deck.size() > 0


func draw() -> Util.TreasureType:
	var card
	if _deck.size() <= 0:
		if !reshuffle():
			return Util.TreasureType.NONE
	card = _deck.pop_front()
	return card
	
func discard(card: Util.TreasureType):
	_discard_pile.append(card)
