/datum/dna/gene/monkey
	name="Monkey"

/datum/dna/gene/monkey/New()
	block=MONKEYBLOCK

/datum/dna/gene/monkey/can_activate(var/mob/M,var/flags)
	return ishuman(M)

/datum/dna/gene/monkey/activate(var/mob/living/carbon/human/H, var/connected, var/flags)
	if(!istype(H,/mob/living/carbon/human))
		return
	if(issmall(H))
		return
	for(var/obj/item/W in H)
		if(istype(W,/obj/item/organ))
			continue
		if(istype(W,/obj/item/implant))
			continue
		H.unEquip(W)

	H.regenerate_icons()
	H.SetStunned(1)
	H.canmove = 0
	H.icon = null
	H.invisibility = 101

	new /obj/effect/temp_visual/monkeyify(H.loc)
	sleep(22)

	H.SetStunned(0)
	H.invisibility = initial(H.invisibility)

	if(!H.species.primitive_form) //If the creature in question has no primitive set, this is going to be messy.
		H.gib()
		return

	H.set_species(H.species.primitive_form)

	QDEL_NULL(H.hud_used)

	if(H.client)
		H.hud_used = new /datum/hud/monkey(H, ui_style2icon(H.client.prefs.UI_style), H.client.prefs.UI_style_color, H.client.prefs.UI_style_alpha)

	to_chat(H, "<B>You are now a [H.species.name].</B>")

	return H

/datum/dna/gene/monkey/deactivate(var/mob/living/carbon/human/H, var/connected, var/flags)
	if(!istype(H,/mob/living/carbon/human))
		return
	for(var/obj/item/W in H)
		if(W == H.w_uniform) // will be torn
			continue
		if(istype(W,/obj/item/organ))
			continue
		if(istype(W,/obj/item/implant))
			continue
		H.unEquip(W)
	H.regenerate_icons()
	H.SetStunned(1)
	H.canmove = 0
	H.icon = null
	H.invisibility = 101

	new /obj/effect/temp_visual/monkeyify/humanify(H.loc)
	sleep(22)

	H.SetStunned(0)
	H.invisibility = initial(H.invisibility)

	if(!H.species.greater_form) //If the creature in question has no primitive set, this is going to be messy.
		H.gib()
		return

	H.set_species(H.species.greater_form)
	H.real_name = H.dna.real_name
	H.name = H.real_name

	QDEL_NULL(H.hud_used)

	if(H.client)
		H.hud_used = new /datum/hud/human(H, ui_style2icon(H.client.prefs.UI_style), H.client.prefs.UI_style_color, H.client.prefs.UI_style_alpha)

	to_chat(H, "<B>You are now a [H.species.name].</B>")

	return H
