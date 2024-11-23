/mob/living/carbon/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_His = p_their(TRUE)
	var/t_his = p_their()
	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()

	. = list("<span class='info'>*---------*\nThis is [icon2html(src, user)] \a <EM>[src]</EM>!")
	var/obscured = check_obscured_slots()

	if (handcuffed)
		. += span_warning("[t_He] [t_is] [icon2html(handcuffed, user)] арестован!")
	if (head)
		. += "[t_He] [t_is] носит [head.get_examine_string(user)] на [t_his] голове. "
	if(wear_mask && !(obscured & ITEM_SLOT_MASK))
		. += "[t_He] [t_is] носит [wear_mask.get_examine_string(user)] на [t_his] лице."
	if(wear_neck && !(obscured & ITEM_SLOT_NECK))
		. += "[t_He] [t_is] носит [wear_neck.get_examine_string(user)] вокруг [t_his] шеи."

	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[t_He] [t_is] удерживает [I.get_examine_string(user)] в [t_his] [get_held_index_name(get_held_index_of_item(I))]."

	if (back)
		. += "[t_He] [t_has] [back.get_examine_string(user)] на [t_his] спине."
	var/appears_dead = FALSE
	if (stat == DEAD)
		appears_dead = TRUE
		if(getorgan(/obj/item/organ/brain))
			. += span_deadsay("[t_He] [t_is] кожа бледна, реакция на окружающий мир пуста. У тела отсутствуют признаки жизни!")
		else if(get_bodypart(BODY_ZONE_HEAD))
			. += span_deadsay("В [t_his] голове нет мозга...")

	var/list/msg = list("<span class='warning'>")
	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	var/list/disabled = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.bodypart_disabled)
			disabled += BP
		missing -= BP.body_zone
		for(var/obj/item/I in BP.embedded_objects)
			if(I.isEmbedHarmless())
				msg += "<B>[t_He] [t_has] [icon2html(I, user)] \a [I] застрял в [t_his] [BP.name]!</B>\n"
			else
				msg += "<B>[t_He] [t_has] [icon2html(I, user)] \a [I] вонзит в [t_his] [BP.name]!</B>\n"
		for(var/i in BP.wounds)
			var/datum/wound/W = i
			msg += "[W.get_examine_description(user)]\n"

	for(var/X in disabled)
		var/obj/item/bodypart/BP = X
		var/damage_text
		if(!(BP.get_damage(include_stamina = FALSE) >= BP.max_damage)) //Stamina is disabling the limb
			damage_text = "бледное и безжизненное"
		else
			damage_text = (BP.brute_dam >= BP.burn_dam) ? BP.heavy_brute_msg : BP.heavy_burn_msg
		msg += "<B>[capitalize(t_his)] [BP.name] is [damage_text]!</B>\n"

	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			msg += "[span_deadsay("<B>[t_His] [parse_zone(t)] отсутствует!</B>")]\n"
			continue
		msg += "[span_warning("<B>[t_His] [parse_zone(t)] отсутствует!</B>")]\n"


	var/temp = getBruteLoss()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		switch(temp) /// пробую свитч импут
			if(temp < 25)
				msg += "[t_He] [t_has] незначительные синяки.\n"
			if(temp < 50)
				msg += "[t_He] [t_has] <b>видные гематомы</b>!\n"
			if(temp >= 50)
				msg += "<B>[t_He] [t_has] значительные повреждения кожи!</B>\n"

		temp = getFireLoss()
		if(temp)
			if (temp < 25)
				msg += "[t_He] [t_has] незначительное покраснение и отек кожи.\n"
			else if (temp < 50)
				msg += "[t_He] [t_has] множественные <b>пузыри и покраснения</b> на коже!\n"
			else
				msg += "<B>[t_He] [t_has] обугленную кожную ткань!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_He] [t_is] выглядит странно, немного деформированным.\n"
			else if (temp < 50)
				msg += "[t_He] [t_is] <b>сильно</b> деформированным!\n"
			else
				msg += "<b>[t_He] [t_is] тело полностью кривое!</b>\n"

	if(HAS_TRAIT(src, TRAIT_DUMB))
		msg += "[t_He] выглядит[p_s()] туповатым и неряшливо передвигается.\n"

	if(fire_stacks > 0)
		msg += "[t_He] [t_is] тело покрыто чем-то воспламеняемым.\n"
	if(fire_stacks < 0)
		msg += "[t_He] полностью промокло!\n"

	if(pulledby?.grab_state)
		msg += "[t_He] [t_is] удерживается захватом [pulledby].\n"

	var/scar_severity = 0
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			scar_severity += S.severity

	switch(scar_severity)
		if(1 to 4)
			msg += "[span_tinynoticeital("[t_He] [t_has] имеет незначительные шрамы, ты можешь посмотреть вновь, чтобы изучить ещё лучше...")]\n"
		if(5 to 8)
			msg += "[span_smallnoticeital("[t_He] [t_has] имеет значительное количество шрамов, ты можешь посмотреть вновь, чтобы изучить ещё лучше...")]\n"
		if(9 to 11)
			msg += "[span_notice("<i>[t_He] [t_has] полно шрамов! Ты можешь посмотреть вновь, чтобы изучить ещё лучше...</i>")]\n"
		if(12 to INFINITY)
			msg += "[span_notice("<b><i>[t_He] [t_is] имеет несчётное количество шрамов! Ты можешь посмотреть вновь, чтобы изучить ещё лучше...</i></b>")]\n"

	msg += "</span>"

	. += msg.Join("")

	if(!appears_dead)
		switch(stat)
			if(SOFT_CRIT)
				. += "[t_His] дыхание сбивчивое и глубокое."
			if(UNCONSCIOUS, HARD_CRIT)
				. += "[t_He] не реагирует на внешние воздействия, [t_him] глаза закрыты. Похоже [t_He] спит."

	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	var/datum/component/mood/mood = src.GetComponent(/datum/component/mood)
	if(mood)
		switch(mood.shown_mood)
			if(-INFINITY to MOOD_LEVEL_SAD4)
				. += "[t_He] выглядит опечаленным, [t_him] взгляд пуст."
			if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
				. += "[t_He] выглядит печально."
			if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
				. += "[t_He] выглядит не в настроении."
			if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
				. += "[t_He] имеет улыбку на лице."
			if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
				. += "[t_He] выглядит счастливо."
			if(MOOD_LEVEL_HAPPY4 to INFINITY)
				. += "[t_He] находится в экстазе."
	. += "*---------*</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)
/* SEPTIC EDIT REMOVAL
/mob/living/carbon/examine_more(mob/user)
	if(!all_scars)
		return ..()

	var/list/visible_scars
	for(var/i in all_scars)
		var/datum/scar/S = i
		if(S.is_visible(user))
			LAZYADD(visible_scars, S)

	if(!visible_scars)
		return ..()

	var/msg = list(span_notice("<i>You examine [src] closer, and note the following...</i>"))
	for(var/i in visible_scars)
		var/datum/scar/S = i
		var/scar_text = S.get_examine_description(user)
		if(scar_text)
			msg += "[scar_text]"

	return msg
*/
