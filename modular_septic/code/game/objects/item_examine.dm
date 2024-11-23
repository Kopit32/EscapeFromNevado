// Nice examine stuff
/obj/item/examine_chaser(mob/user)
	. = list()
	var/p_They = p_they(TRUE)
	var/p_they = p_they()
	var/p_Theyre = p_theyre(TRUE)
	var/p_are = p_are()
	var/p_s = p_s()

	switch(germ_level)
		if(0 to GERM_LEVEL_DIRTY)
			. += "[p_They] [p_are] чист."
		if(GERM_LEVEL_DIRTY to GERM_LEVEL_FILTHY)
			. += "[p_They] [p_are] немного грязноват."
		if(GERM_LEVEL_FILTHY to GERM_LEVEL_SMASHPLAYER)
			. += span_warning("[p_They] [p_are] грязный.")
		if(GERM_LEVEL_SMASHPLAYER to INFINITY)
			. += span_warning("[p_They] [p_are] <b>словно в говне!</b>")

	var/weight_text = weight_class_to_text(w_class)
	. += "[p_Theyre] [prefix_a_or_an(weight_text)] [weight_text] item."
	if(isobserver(user))
		. += "[p_They] весит [p_s] ровно <b>[get_carry_weight()] килограмм</b>."
	else if(user.is_holding(src))
		. += "[p_They] весит [p_s] около <b>[round_to_nearest(get_carry_weight(), 1)] килограмм</b>."

	if(resistance_flags & INDESTRUCTIBLE)
		. += "[p_They] кажется [p_s] очень прочным! Эта /"скала/" явно выдержит многое!"
	else
		if(resistance_flags & LAVA_PROOF)
			. += "[p_They] [p_are] сделан из жаростойкого материала, [p_they] вероятнее всего выдержит аж лаву!"
		if(resistance_flags & (ACID_PROOF | UNACIDABLE))
			. += "[p_They] ощущается [p_s] достаточно крепким! [p_they] вероятнее всего выдержит кислоту!"
		if(resistance_flags & FREEZE_PROOF)
			. += "[p_They] [p_are] сделан из холодностойкого материала."
		if(resistance_flags & FIRE_PROOF)
			. += "[p_They] [p_are] сделан из жаростойкого материала."

	. += ..()
