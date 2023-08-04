/datum/reagent/drug/lean
	name = "lean"
	description = "I LOVE LEAN."
	reagent_state = SOLID
	taste_description = "purple"
	color = "#7E3990"
	overdose_threshold = 35
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 3
	addiction_types = list(/datum/addiction/maintenance_drugs = 20)

/datum/reagent/drug/lean/on_mob_life(mob/living/carbon/lean_monster, delta_time, times_fired)
	. = ..()
	//Chance of Willador Afton
	if(DT_PROB(3, delta_time))
		INVOKE_ASYNC(src, .proc/handle_lean_monster_hallucinations, lean_monster)

/datum/reagent/drug/lean/on_mob_metabolize(mob/living/lean_monster, delta_time)
	. = ..()
	var/static/list/lean_quotes = list(
		"Dope dick give your bitch withdrawals",
		"But envy may kill, still don't give a fuck how they feel",
		"Oh man, I been gettin' in my zone",
		"Invested in my fucking self I need a loan, I'm alone",
	)
	if(DT_PROB(2.5, delta_time))
		to_chat(lean_monster, span_horny(pick(lean_quotes)))
	to_chat(lean_monster, span_horny(span_big("Lean... I LOVE LEAAAANNNNNNN!!!")))
	ADD_TRAIT(lean_monster, TRAIT_LEAN, name)
	lean_monster.add_chem_effect(CE_STIMULANT, 2, "[type]")
	lean_monster.add_chem_effect(CE_ENERGETIC, 1, "[type]")
	lean_monster.attributes?.add_attribute_modifier(/datum/attribute_modifier/lean, TRUE)
	to_chat(lean_monster, span_warning("I feel myself stronger, so nice!"))
	SEND_SIGNAL(lean_monster, COMSIG_ADD_MOOD_EVENT, "forbidden_sizzup", /datum/mood_event/lean, lean_monster)
	lean_monster.playsound_local(lean_monster, 'modular_septic/sound/insanity/leanlaugh.ogg', 50)

	if(!lean_monster.hud_used)
		return

	//Chance of Willador Afton
	if(DT_PROB(2.5, delta_time))
		INVOKE_ASYNC(src, .proc/handle_lean_monster_hallucinations, lean_monster)

	var/atom/movable/screen/plane_master/rendering_plate/filter_plate = lean_monster.hud_used.plane_masters["[RENDER_PLANE_GAME]"]

	var/static/list/col_filter_lean = list(1,0,0,0, 0,1.00,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	var/static/list/col_filter_empty = list(1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

	filter_plate.add_filter("lean_filter", 100, color_matrix_filter(col_filter_lean))

	animate(filter_plate.get_filter("lean_filter"), loop = -1, color = col_filter_lean, time = 4 SECONDS, easing = CIRCULAR_EASING|EASE_IN, flags = ANIMATION_PARALLEL)
	animate(color = col_filter_empty, time = 3 SECONDS, easing = LINEAR_EASING)

/datum/reagent/drug/lean/on_mob_end_metabolize(mob/living/lean_monster)
	. = ..()
	REMOVE_TRAIT(lean_monster, TRAIT_LEAN, name)
	to_chat(lean_monster, span_love(span_big("NOOOO... I NEED MORE LEAN...")))
	lean_monster.remove_chem_effect(CE_STIMULANT, "[type]")
	lean_monster.remove_chem_effect(CE_ENERGETIC, "[type]")
	lean_monster.attributes?.remove_attribute_modifier(/datum/attribute_modifier/lean, TRUE)
	if(!lean_monster.hud_used)
		return

	var/atom/movable/screen/plane_master/rendering_plate/filter_plate = lean_monster.hud_used.plane_masters["[RENDER_PLANE_GAME]"]
	lean_monster.playsound_local(lean_monster, 'modular_septic/sound/insanity/leanend.ogg', 50)
	lean_monster.flash_pain_mental(30)

	filter_plate.remove_filter("lean_filter")

/datum/reagent/drug/lean/proc/handle_lean_monster_hallucinations(mob/living/lean_monster)
	if(QDELETED(lean_monster))
		return
	var/purple_msg = pick("SAVE THEM!", "IT'S ME!", "I AM STILL HERE!", "I ALWAYS COME BACK!")
	var/turf/turfie
	var/list/turf/turfies = list()
	for(var/turf/torf in view(lean_monster))
		turfies += torf
	if(length(turfies))
		turfie = pick(turfies)
	if(!turfie)
		return
	var/image/purple_guy = image('modular_septic/icons/mob/lean.dmi', turfie, "ILOVELEAN", FLOAT_LAYER, get_dir(turfie, lean_monster))
	purple_guy.plane = GAME_PLANE_FOV_HIDDEN
	purple_guy.layer = lean_monster.layer + 10
	lean_monster.client?.images += purple_guy
	to_chat(lean_monster, span_purple(span_big("[purple_msg]")))
	sleep(0.5 SECONDS)
	var/hallsound = 'modular_septic/sound/insanity/purpleappear.ogg'
	var/catchsound = 'modular_septic/sound/insanity/purplecatch.ogg'
	lean_monster.playsound_local(get_turf(lean_monster), hallsound, 100, 0)
	var/chase_tiles = 7
	var/chase_wait_per_tile = rand(4,6)
	var/caught_monster = FALSE
	while(chase_tiles > 0)
		turfie = get_step(turfie, get_dir(turfie, lean_monster))
		if(turfie)
			purple_guy.loc = turfie
			if(turfie == get_turf(lean_monster))
				caught_monster = TRUE
				sleep(chase_wait_per_tile)
				break
		chase_tiles--
		sleep(chase_wait_per_tile)
	lean_monster.client?.images -= purple_guy
	if(!QDELETED(purple_guy))
		qdel(purple_guy)
	if(caught_monster)
		lean_monster.playsound_local(lean_monster, catchsound, 100)
		lean_monster.Paralyze(rand(2, 5) SECONDS)
		var/pain_msg = pick("NO!", "HE GOT ME!", "AGH!")
		to_chat(lean_monster, span_userdanger("<b>[pain_msg]</b>"))
		lean_monster.flash_pain_mental(100)

/datum/reagent/drug/carbonylmethamphetamine
	name = "Carbonylmethamphetamine"
	description = "Finally some good fucking drugs."
	reagent_state = LIQUID
	taste_description = "grape"
	color = "#D3D3D3"
	overdose_threshold = 40
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	ph = 3

/datum/reagent/drug/carbonylmethamphetamine/on_mob_metabolize(mob/living/crack_addict)
	. = ..()
	crack_addict.crack_addict()
	crack_addict.add_chem_effect(CE_STIMULANT, 2, "[type]")
	crack_addict.attributes?.add_attribute_modifier(/datum/attribute_modifier/carbonylmethamphetamine, TRUE)
	crack_addict.playsound_local(crack_addict, 'modular_septic/sound/insanity/bass.ogg', 100)
	to_chat(crack_addict, span_achievementrare("My brain swells and my muscles become faster."))
	crack_addict.flash_pain_endorphine()
	INVOKE_ASYNC(src, .proc/cool_animation, crack_addict)

/datum/reagent/drug/carbonylmethamphetamine/on_mob_end_metabolize(mob/living/crack_addict)
	. = ..()
	crack_addict.remove_chem_effect(CE_STIMULANT, "[type]")
	to_chat(crack_addict, span_achievementbad("My brain feels smaller..."))
	crack_addict.attributes?.remove_attribute_modifier(/datum/attribute_modifier/carbonylmethamphetamine, TRUE)

/datum/reagent/drug/carbonylmethamphetamine/proc/cool_animation(mob/living/crack_addict)
	if(!crack_addict.client)
		return
	animate(crack_addict.client, pixel_y = (crack_addict.client.pixel_y + 4), time = 2)
	sleep(4)
	animate(crack_addict.client, pixel_y = (crack_addict.client.pixel_y - 4), time = 2)
	sleep(4)

/datum/reagent/drug/methylenedioxymethamphetamine
	name = "Methylenedioxymethamphetamine"
	description = "Oh god, I'm stimming!"
	reagent_state = LIQUID
	taste_description = "coffee"
	color = "#ffba95"
	overdose_threshold = 40
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	ph = 4.5
	/// Overlay used while stimming
	var/atom/movable/screen/fullscreen/stimming/stimming_overlay

/datum/reagent/drug/methylenedioxymethamphetamine/on_mob_metabolize(mob/living/crack_addict)
	. = ..()
	crack_addict.emote("moan")
	crack_addict.add_chem_effect(CE_STIMULANT, 2, "[type]")
	crack_addict.add_chem_effect(CE_ENERGETIC, 2, "[type]")
	crack_addict.attributes?.add_attribute_modifier(/datum/attribute_modifier/methylenedioxymethamphetamine, TRUE)
	crack_addict.playsound_local(crack_addict, 'modular_septic/sound/effects/stimming.ogg', 100)
	to_chat(crack_addict, span_achievementrare("I'm stimming!!!"))
	stimming_overlay = crack_addict.overlay_fullscreen("stimming", /atom/movable/screen/fullscreen/stimming)
	stimming_overlay.alpha = 0
	animate(stimming_overlay, alpha = 60, time = 1 SECONDS, flags = BOUNCE_EASING|EASE_OUT, loop = -1)

/datum/reagent/drug/methylenedioxymethamphetamine/on_mob_end_metabolize(mob/living/crack_addict)
	. = ..()
	animate(stimming_overlay, alpha = 0, time = 1 SECONDS, flags = BOUNCE_EASING|EASE_IN)
	stimming_overlay = null
	addtimer(CALLBACK(src, .proc/end_stimming, crack_addict))
	crack_addict.emote("cry")
	crack_addict.remove_chem_effect(CE_STIMULANT, "[type]")
	crack_addict.remove_chem_effect(CE_ENERGETIC, "[type]")
	crack_addict.attributes?.remove_attribute_modifier(/datum/attribute_modifier/methylenedioxymethamphetamine, TRUE)
	crack_addict.playsound_local(crack_addict, 'modular_septic/sound/effects/stimming_end.ogg', 100)
	to_chat(crack_addict, span_achievementbad("NOO... I need to stim..."))

/datum/reagent/drug/methylenedioxymethamphetamine/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	var/static/list/waifu_quotes = list(
		"She gives me the energy to keep going.",
		"Do it for her.",
		"I'm going to Belgium once I escape.",
		"This is all for her.",
		"I love her so much.",
		"I want to marry her.",
		"What would I do without her?",
		"She is a gem.",
		"I would do anything for her.",
		"Life without her is pointless.",
		"She needs me.",
		"Must keep going. For her.",
	)
	if(DT_PROB(3, delta_time))
		to_chat(M, span_horny(pick(waifu_quotes)))

/datum/reagent/drug/methylenedioxymethamphetamine/proc/end_stimming(mob/living/crack_addict)
	if(QDELETED(crack_addict))
		return
	crack_addict.clear_fullscreen("poopmadness")
