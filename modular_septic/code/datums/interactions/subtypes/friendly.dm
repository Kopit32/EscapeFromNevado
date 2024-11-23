/datum/interaction/friendly
	category = INTERACTION_CATEGORY_FRIENDLY
	interaction_flags = INTERACTION_RESPECT_COOLDOWN|INTERACTION_NEEDS_PHYSICAL_CONTACT
	user_cooldown_duration = INTERACTION_COOLDOWN
	target_cooldown_duraction = INTERACTION_COOLDOWN
	button_icon = "handshake"

/datum/interaction/friendly/handshake
	name = "Пожать руку"
	desc = "Рукопожатие."
	message = span_notice("%USER пожимает руку %TARGET.")
	user_message = span_notice("Я пожимаю руку %TARGET.")
	target_message = span_notice("%USER пожимает мою руку.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	target_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = 1
	sound_extrarange = -1
	button_icon = "handshake"

/datum/interaction/friendly/hug
	name = "Обнять"
	desc = "Объятия! Как мило."
	message = span_notice("%USER обнимает %TARGET.")
	user_message = span_notice("Я обнимаю %TARGET.")
	target_message = span_notice("%USER обнимает меня.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = 1
	sound_extrarange = -1
	button_icon = "grin-beam"

/datum/interaction/friendly/hug/do_interaction(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_target = target.parent
	human_target.hug_act(user.parent)

/datum/interaction/friendly/headpat
	name = "Погладить"
	desc = "Погладить по голове! Как мило."
	message = span_notice("%USER гладит %TARGET по голове.")
	user_message = span_notice("Я глажу %TARGET по голове.")
	target_message = span_notice("%USER гладит меня по голове.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = 1
	sound_extrarange = -1
	button_icon = "hand-paper"

/datum/interaction/friendly/headpat/do_interaction(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_target = target.parent
	human_target.headpat_act(user.parent)

/datum/interaction/friendly/brofist
	name = "Брофист"
	desc = "Удариться кулачками."
	message = span_notice("%USER ударяется кулачком с %TARGET.")
	user_message = span_notice("Я ударяю кулачком с %TARGET.")
	target_message = span_notice("Кулачком ударяюсь с %USER в ответ.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	target_hands_required = 1
	sounds = 'sound/weapons/throwtap.ogg'
	sound_vary = 1
	sound_extrarange = 1
	button_icon = "handshake"

/datum/interaction/friendly/backpat
	name = "Похлопать по спине"
	desc = "Дружески похлопать по спине."
	message = span_notice("%USER похлопывает %TARGET по спине.")
	user_message = span_notice("Я похлопываю %TARGET по спине.")
	target_message = span_notice("%USER похлопывает меня по спине.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	sounds = 'sound/weapons/tap.ogg'
	sound_vary = 1
	sound_extrarange = 1
	button_icon = "hand-paper"

/datum/interaction/friendly/pinkypromise
	name = "Покляться на мизинцах"
	desc = "Пообещать что-то, сцепив мизинцы."
	message = span_notice("%USER сцепляет мизинец с %TARGET и клянется!")
	user_message = span_notice("Я сцепляю мизинец с %TARGET и клянусь!")
	target_message = span_notice("%USER сцепляет мизинец со мной и клянется!")
	usage = INTERACT_OTHER
	sound_extrarange = -1
	user_hands_required = 1
	target_hands_required = 1
	button_icon = "handshake"

/datum/interaction/friendly/highfive
	name = "Дать пять"
	desc = "Дать пять друг другу!"
	message = span_notice("%USER дает пять %TARGET!")
	user_message = span_notice("Я даю пять %TARGET!")
	target_message = span_notice("%USER дает мне пять!")
	usage = INTERACT_OTHER
	user_hands_required = 1
	target_hands_required = 1
	sounds = 'sound/weapons/slap.ogg'
	sound_vary = 1
	sound_extrarange = 1
	button_icon = "hand-paper"

/datum/interaction/friendly/pat
	name = "Подбодрить"
	desc = "Похлопать по плечу."
	message = span_notice("%USER похлопывает %TARGET по плечу.")
	user_message = span_notice("Я похлопываю %TARGET по плечу.")
	target_message = span_notice("%USER похлопывает меня по плечу.")
	usage = INTERACT_OTHER
	user_hands_required = 1
	sounds = 'sound/weapons/tap.ogg'
	sound_vary = 1
	sound_extrarange = -1
	button_icon = "handshake"
