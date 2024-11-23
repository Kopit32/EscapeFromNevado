#define CACHE_CLOSED 1
#define CACHE_CLOSING 2
#define CACHE_OPEN 3
#define CACHE_OPENING 4

/obj/machinery/cache
	name = "Настенный схрон"
	desc = "Специально вмонтированный в стену схрон предназначенный для хранения товаров в красивой, армированной сталью, упаковке."
	icon = 'modular_septic/icons/obj/structures/efn.dmi'
	icon_state = "cache"
	base_icon_state = "cache"
	plane = GAME_PLANE_UPPER
	layer = WALL_OBJ_LAYER
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	// Determines If people can reach inside and use the cache.
	var/locked = TRUE
	var/buttonsound = 'modular_septic/sound/efn/cache_button.ogg'
	var/cacheOpen = 'modular_septic/sound/efn/cache_open.ogg'
	var/cacheClose = 'modular_septic/sound/efn/cache_close.ogg'
	var/cachecoverBreak = 'modular_septic/sound/efn/cache_cover_open.ogg'
	var/state = CACHE_CLOSED
	var/cover_open = FALSE
	var/firsthack = 'modular_septic/sound/efn/cache_elec1.ogg'
	var/secondhack = 'modular_septic/sound/efn/cache_elec2.ogg'

/obj/machinery/cache/update_overlays()
	. = ..()
	switch(state)
		if(CACHE_CLOSED)
			. += "[base_icon_state]_closed"
		if(CACHE_CLOSING)
			. += "[base_icon_state]_closing"
		if(CACHE_OPEN)
			. += "[base_icon_state]_opened"
		if(CACHE_OPENING)
			. += "[base_icon_state]_opening"
	if(cover_open)
		. += "[base_icon_state]_insides"

/obj/machinery/cache/Initialize(mapload)
	. = ..()
	update_appearance()
	if(locked)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SET_LOCKSTATE, TRUE)

/obj/machinery/cache/goated_with_the_sauce

/obj/machinery/cache/goated_with_the_sauce/Initialize(mapload)
	. = ..()
	new /obj/effect/spawner/random/lootshoot/clothing(src)
	if(prob(80))
		new /obj/effect/spawner/random/lootshoot(src)
	if(prob(30))
		new /obj/effect/spawner/random/lootshoot/clothing(src)
	if(prob(5))
		new /obj/effect/spawner/random/lootshoot/rare(src)

/obj/machinery/cache/goated_with_the_sauce/north
	pixel_y = 30

/obj/machinery/cache/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = 12

/obj/machinery/cache/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!cover_open)
		to_chat(user, span_warning("крышка закрыта."))
		return
	if(!locked)
		to_chat(user, span_warning("[src] уже успешно вскрыт."))
		return
	if(GET_MOB_SKILL_VALUE(user, SKILL_ELECTRONICS) <= 4)
		to_chat(user, span_danger("Я, бля, не понимаю как эта хуета работает. Ебучие технологии."))
		return
	to_chat(user, span_warning("Я начинаю вскрывать..."))
	if(!do_after(user, 1.2 SECONDS, src))
		to_chat(user, span_warning(fail_msg()))
		return
	to_chat(user, span_warning("Я оторвал какую-то проводку."))
	playsound(src, firsthack, 70, FALSE)
	do_sparks(1, FALSE, src)
	if(!do_after(user, 1.2 SECONDS, src))
		to_chat(user, span_warning(fail_msg()))
		return
	to_chat("Я успешно достал правильный провод [src]!")
	playsound(src, secondhack, 70, FALSE)
	do_sparks(2, FALSE, src)
	locked = FALSE
	update_appearance()

/obj/machinery/cache/attack_hand_secondary(mob/living/user, list/modifiers)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	playsound(src, buttonsound, 75, FALSE)
	if(locked)
		user.visible_message(span_notice("[user] нажимает на кнопку, однако та только жужжит."), \
		span_notice("[fail_msg()] проклятье, оно закрыто!"))
		return
	else
		user.visible_message(span_notice("[user] нажимает на кнопку."), \
		span_notice("Я нажимаю на кнопку [src]."))
		open_cache()

/obj/machinery/cache/attack_hand_tertiary(mob/living/user, list/modifiers)
	. = ..()
	if(cover_open)
		to_chat(user, span_warning("[fail_msg()] оно уже вскрыто, нет смысла далее ломать!"))
		return
	to_chat(user, span_notice("Я начинаю открывать крышку с [src]..."))
	if(!do_after(user, 2 SECONDS, src))
		to_chat(user, span_warning("[fail_msg()]"))
		return
	if(GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH) > 11)
		user.visible_message(span_danger("[user] отрывает со всей силой пластину [src]!") , \
			span_warning("Я оторвал пластину [src]!"))
		open_cover()
	else
		to_chat(user, span_warning("[fail_msg()] крышка оказалась сильнее, чем я думал!"))
	return COMPONENT_TERTIARY_CANCEL_ATTACK_CHAIN

/obj/machinery/cache/crowbar_act(mob/living/user, obj/item/tool)
	if(cover_open)
		to_chat(user, span_warning("[fail_msg()] оно уже вскрыто, нет смысла далее ломать!"))
		return TRUE
	to_chat(user, span_notice("я начинаю отрывать пластину с [src]..."))
	if(!do_after(user, 1.2 SECONDS, src))
		to_chat(user, span_warning("[fail_msg()]"))
		return TRUE
	if(GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH) > 7)
		user.visible_message(span_danger("[user] отрывает пластину с [src], используя [tool]!") , \
			span_warning("Я с силой оторвал крышку [src], используя [tool]!"))
		open_cover()
	else
		to_chat(user, span_warning("[fail_msg()] крышка оказалась сильнее, чем я думал!"))
	return TRUE

/obj/machinery/cache/proc/open_cover(mob/living/user)
	if((state == CACHE_OPENING) || (state == CACHE_CLOSING))
		to_chat(user, span_notice("[fail_msg()] It's doing It's thing!"))
		return
	cover_open = TRUE
	playsound(src, cachecoverBreak, 35, FALSE)
	update_appearance()

/obj/machinery/cache/proc/open_cache(mob/living/user)
	if((state == CACHE_OPENING) || (state == CACHE_CLOSING))
		to_chat(user, span_notice("[fail_msg()] It's doing It's thing!"))
		return
	var/nice
	if(prob(20))
		nice = "nice"
	if(state == CACHE_CLOSED)
		visible_message(span_achievementgood("крышка [src] устремляется наверх [nice], с хорошо слышимым скрежетом!"))
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SET_LOCKSTATE, FALSE)
		playsound(src, cacheOpen, 85, FALSE)
		INVOKE_ASYNC(src, .proc/open)
	else
		visible_message(span_danger("крышка [src] устремляется вниз [nice], с хорошо слышимым скрежетом!"))
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SET_LOCKSTATE, TRUE)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_HIDE_FROM, usr)
		playsound(src, cacheClose, 85, FALSE)
		INVOKE_ASYNC(src, .proc/close)

/obj/machinery/cache/proc/open()
	state = CACHE_OPENING
	update_appearance()
	sleep(6)
	state = CACHE_OPEN
	update_appearance()

/obj/machinery/cache/proc/close()
	state = CACHE_CLOSING
	update_appearance()
	sleep(6)
	state = CACHE_CLOSED
	update_appearance()

#undef CACHE_CLOSED
#undef CACHE_CLOSING
#undef CACHE_OPEN
#undef CACHE_OPENING
