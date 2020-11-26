obj/machinery/cryopod
	name = "ancient cryogenic pod"
	desc = "An ancient looking cryogenic stasis pod. You can faintly see a human figure inside..."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "sleeper_1"
	machine_flags = WRENCHMOVE | FIXED2WORK
	mech_flags = MECH_SCAN_FAIL
	var/datum/recruiter/recruiter = null
	var/thawing = FALSE
	var/last_ping_time = 0
	var/ping_cooldown = 5 SECONDS
	density = 1
	var/datum/cryorole/role
	var/possible_roles = list(
		/datum/cryorole/cowboy,
		/datum/cryorole/pirate,
		/datum/cryorole/samurai,
		/datum/cryorole/inquisitor,
		/datum/cryorole/prisoner,
		/datum/cryorole/roman,
		/datum/cryorole/tourist,
		/datum/cryorole/cosmonaut,
		/datum/cryorole/gangster,
		/datum/cryorole/pizzaman)

/obj/machinery/cryopod/attack_hand(mob/user as mob)
	if(thawing)
		return
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	var/pressure = environment.return_pressure()
	if(((pressure < WARNING_HIGH_PRESSURE) && pressure > WARNING_LOW_PRESSURE))
		thawing = TRUE
		visible_message("<span class='notice'>\The [name] beeps and clicks, then its screen flickers to life, displaying the text 'Attempting to revive occupant...'.</span>")
		if(!recruiter)
			recruiter = new(src)
			recruiter.display_name = name
			recruiter.role = ROLE_MINOR
		// Role set to Yes or Always
		recruiter.player_volunteering.Add(src, "recruiter_recruiting")
		// Role set to No or Never
		recruiter.player_not_volunteering.Add(src, "recruiter_not_recruiting")

		recruiter.recruited.Add(src, "recruiter_recruited")
		recruiter.request_player()
	else
		visible_message("<span class='notice'>\The [name]'s screen flickers to life and displays an error message: 'Unable to revive occupant, enviromental pressure inadequate for sustaining human life.'</span>")

/obj/machinery/cryopod/proc/recruiter_recruiting(var/list/args)
	var/mob/dead/observer/O = args["player"]
	var/controls = args["controls"]
	to_chat(O, "<span class='recruit'>\The [name] has been activated. You have been added to the list of potential ghosts. ([controls])</span>")

/obj/machinery/cryopod/proc/recruiter_not_recruiting(var/list/args)
	var/mob/dead/observer/O = args["player"]
	var/controls = args["controls"]
	to_chat(O, "<span class='recruit'>\The [src] has been activated. ([controls])</span>")

/obj/machinery/cryopod/proc/recruiter_recruited(var/list/args)
	var/mob/dead/observer/O = args["player"]
	if(O)
		qdel(recruiter)
		recruiter = null
		thawing = FALSE
		visible_message("<span class='notice'>\The [name] opens with a hiss of frigid air!</span>")
		playsound(src, 'sound/machines/pressurehiss.ogg', 30, 1)
		new /obj/effect/effect/smoke(get_turf(src))
		var/mob/living/carbon/human/S = new(get_turf(src))
		var/roll = pick(possible_roles)
		role = new roll
		S.ckey = O.ckey
		S.randomise_appearance_for()
		role.gear_occupant(S)
	else
		thawing = FALSE
		visible_message("<span class='notice'>\The [name] quietly beeps and displays an error message.</span>")

/datum/cryorole/proc/gear_occupant(var/mob/living/carbon/human/M)
	var/datum/outfit/roleoutfit = new outfit_datum
	roleoutfit.equip(M)
	to_chat(M, "[blurb]")
	var/podname = copytext(sanitize(input(M, "Pick your name","Name") as null|text), 1, 2*MAX_NAME_LEN)
	M.real_name = podname
	M.name = podname

/datum/cryorole
	var/title
	var/outfit_datum
	var/blurb
	var/timeperiod
	var/location

/datum/cryorole/cowboy
	title = "cowboy"
	outfit_datum = /datum/outfit/special/cowboy

/datum/cryorole/pirate
	title = "pirate"
	outfit_datum = /datum/outfit/special/piratealt

/datum/cryorole/samurai
	title = "samurai"
	outfit_datum = /datum/outfit/special/samurai

/datum/cryorole/inquisitor
	title = "church inquisitor"
	outfit_datum = /datum/outfit/special/inquisitor

/datum/cryorole/prisoner
	title = "prisoner"
	outfit_datum = /datum/outfit/special/prisoner

/datum/cryorole/roman
	title = "roman legionare"
	outfit_datum = /datum/outfit/special/roman

/datum/cryorole/tourist
	title = "tourist"
	outfit_datum = /datum/outfit/special/tourist

/datum/cryorole/cosmonaut
	title = "cosmonaut"
	outfit_datum = /datum/outfit/special/cosmonaut

/datum/cryorole/gangster
	title = "gangster"
	outfit_datum = /datum/outfit/special/gangster

/datum/cryorole/pizzaman
	title = "pizza delivery guy"
	outfit_datum = /datum/outfit/special/pizzaman

/datum/outfit/special/pizzaman
	outfit_name = "Pizza Delivery Guy"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/rank/dispatch,
			slot_shoes_str = /obj/item/clothing/shoes/black,
			slot_head_str = /obj/item/clothing/head/soft/blue,
		)
	)

/datum/outfit/special/gangster
	outfit_name = "Gangster"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/callum,
			slot_shoes_str = /obj/item/clothing/shoes/knifeboot,
			slot_head_str = /obj/item/clothing/head/det_hat/noir,
		)
	)

/datum/outfit/special/roman
	outfit_name = "Roman"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/roman,
			slot_shoes_str = /obj/item/clothing/shoes/roman,
			slot_head_str = /obj/item/clothing/head/helmet/roman,
		)
	)

/datum/outfit/special/prisoner
	outfit_name = "Prisoner"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/color/prisoner,
			slot_shoes_str = /obj/item/clothing/shoes/orange,
		)
	)

/datum/outfit/special/inquisitor
	outfit_name = "Church Inquisitor"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/inquisitor,
			slot_shoes_str = /obj/item/clothing/shoes/jackboots/inquisitor,
			slot_wear_suit_str = /obj/item/clothing/suit/inquisitor,
			slot_head_str = /obj/item/clothing/head/inquisitor,
		)
	)

/datum/outfit/special/samurai
	outfit_name = "Samurai"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/color/black,
			slot_shoes_str = /obj/item/clothing/shoes/sandal,
			slot_wear_suit_str = /obj/item/clothing/suit/armor/samurai,
			slot_head_str = /obj/item/clothing/head/helmet/samurai,
			slot_wear_mask_str = /obj/item/clothing/mask/gas/oni,
		)
	)

/datum/outfit/special/cowboy
	outfit_name = "Cowboy"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/det,
			slot_shoes_str = /obj/item/clothing/shoes/jackboots/cowboy,
			slot_wear_suit_str = /obj/item/clothing/suit/suspenders,
			slot_head_str = /obj/item/clothing/head/cowboy,
			slot_wear_mask_str = /obj/item/clothing/mask/bandana/red,
		)
	)

/datum/outfit/special/tourist
	outfit_name = "Tourist"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/tourist,
			slot_shoes_str = /obj/item/clothing/shoes/sandal,
		)
	)

/datum/outfit/special/cosmonaut
	outfit_name = "Cosmonaut"
	items_to_spawn = list(
		"Default" = list(
			slot_w_uniform_str = /obj/item/clothing/under/soviet,
			slot_shoes_str = /obj/item/clothing/shoes/jackboots/neorussian,
			slot_wear_suit_str = /obj/item/clothing/suit/space/ancient,
			slot_head_str = /obj/item/clothing/head/helmet/space/ancient,
			slot_wear_mask_str = /obj/item/clothing/mask/breath,
		)
	)

/datum/outfit/special/cosmonaut/post_equip(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot(/obj/item/weapon/tank/oxygen, slot_back)