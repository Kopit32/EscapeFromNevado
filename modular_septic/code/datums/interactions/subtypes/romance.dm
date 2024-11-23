/datum/interaction/romance
	category = INTERACTION_CATEGORY_ROMANTIC
	interaction_flags = INTERACTION_RESPECT_COOLDOWN|INTERACTION_NEEDS_PHYSICAL_CONTACT
	user_cooldown_duration = INTERACTION_COOLDOWN
	target_cooldown_duraction = INTERACTION_COOLDOWN
	button_icon = "heart"

/datum/interaction/romance/handholding
	name = "Держаться за руки"
	desc = "Возьмёмся за руки. Как мило!"
	message = span_love("%USER держит %TARGET за руку.")
	user_message = span_love("Я держу %TARGET за руку.")
	target_message = span_love("%USER держит меня за руку.")
	button_icon = "hands-helping"

/datum/interaction/romance/kisscheeks
	name = "Поцеловать в щеку"
	desc = "Поцелуй в щеку."
	message = span_horny("%USER целует %TARGET в щеку.")
	user_message = span_horny("Я целую %TARGET в щеку.")
	target_message = span_horny("%USER целует меня в щеку.")
	button_icon = "kiss-beam"

/datum/interaction/romance/kisscheeks/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_user = target.parent
	if(!human_user.get_bodypart_nostump(BODY_ZONE_PRECISE_FACE))
		return FALSE

/datum/interaction/romance/kisscheeks/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(!human_target.get_bodypart_nostump(BODY_ZONE_PRECISE_FACE))
		return FALSE

/datum/interaction/romance/kiss
	name = "Поцеловать в губы"
	desc = "Поцелуй в губы."
	message = span_horny("%USER целует %TARGET в губы.")
	user_message = span_horny("Я целую %TARGET в губы.")
	target_message = span_horny("%USER целует меня в губы.")
	button_icon = "kiss-wink-heart"

/datum/interaction/romance/kiss/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_user = target.parent
	if(!human_user.get_bodypart_nostump(BODY_ZONE_PRECISE_MOUTH) || human_user.is_mouth_covered())
		return FALSE

/datum/interaction/romance/kiss/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(!human_target.get_bodypart_nostump(BODY_ZONE_PRECISE_MOUTH) || human_target.is_mouth_covered())
		return FALSE
