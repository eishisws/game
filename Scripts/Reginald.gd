extends NpcInteraction
var has_talked_to_reg = false

func get_dialogue_lines() -> Array:
	var player := get_tree().get_first_node_in_group("player")
	var has_key_card: bool = false

	if player and "has_key_card" in player:
		has_key_card = player.has_key_card

	if has_key_card:
		has_talked_to_reg = true
		return [
			"Ah, welcome, welcome! Reginald, at your service.",
			"A Key Card!!! Wonderful!! Elevator is at the end of the hall! Enjoy your stay!"
		]
	elif has_talked_to_reg:
		return [
			"Listen...",
			"I'm too busy to deal with your shenanigans.",
			"Either get a key card, or get lost!",
			"𝘴𝘵𝘶𝘱𝘪𝘥 𝘨𝘪𝘳𝘭..."
		]
	else:
		has_talked_to_reg = true
		return [
			"Ah, welcome, welcome! Reginald, at your service — is there anything I can help you with tonight?",
			"...I'm sorry, could you show me your key card?",
			"No key card. Of course not.",
			"I'm going to need you to step aside, please. This lobby isn't a waiting room."
		]
