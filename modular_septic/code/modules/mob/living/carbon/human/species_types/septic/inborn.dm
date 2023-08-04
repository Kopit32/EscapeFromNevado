/datum/species/inborn
	name = "Inborn"
	id = SPECIES_INBORN
	default_color = "4B4B4B"
	sexes = FALSE
	species_traits = list(
		AGENDER,
        NOEYESPRITES,
	)
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_FLUORIDE_STARE,
	)
	inherent_biotypes = MOB_ORGANIC | MOB_BEAST
	mutant_bodyparts = list()
	heatmod = 4
	coldmod = 0
	liked_food = RAW | MEAT | SEWAGE
	disliked_food = VEGETABLES
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	say_mod = "screeches"
	attack_verb = "slashes"
	bite_sharpness = SHARP_POINTY
	limbs_icon = 'modular_septic/icons/mob/human/species/human/creepypasta_parts.dmi'
	limbs_id = "human"
	examine_icon_state = "inborn"
	mutantheart = /obj/item/organ/heart/inborn
	exotic_bloodtype = "U"

/datum/species/inborn/random_name(gender, unique, lastname)
	return pick(GLOB.inborn_names)
