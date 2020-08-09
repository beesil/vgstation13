/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "drinking glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	item_state = "glass_empty"
	isGlass = 1
	amount_per_transfer_from_this = 10
	volume = 50
	starting_materials = list(MAT_GLASS = 500)
	force = 5
	smashtext = ""  //due to inconsistencies in the names of the drinks just don't say anything
	smashname = "broken glass"
	melt_temperature = MELTPOINT_GLASS
	w_type=RECYK_GLASS

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	..()

	viewcontents = 1
	overlays.len = 0
	flammable = 0
	if(!molotov)
		lit = 0
	light_color = null
	set_light(0)
	origin_tech = ""

	if (reagents.reagent_list.len > 0)
		if(reagents.has_reagent(BLACKCOLOR))
			icon_state ="blackglass"
			name = "international drink of mystery"
			desc = "The identity of this drink has been concealed for its protection."
			viewcontents = 0 
		else
			var/datum/reagent/R = reagents.get_master_reagent()

			if(R.light_color)
				light_color = R.light_color
			
			if(R.flammable)
				if(!lit)
					flammable = 1

			name = R.glass_name ? R.glass_name : "glass of " + R.name //uses glass of [reagent name] if a glass name isn't defined
			desc = R.glass_desc ? R.glass_desc : R.description //uses the description if a glass description isn't defined
			isGlass = R.glass_isGlass

			if(R.glass_icon_state)
				icon_state = R.glass_icon_state
				item_state = R.glass_icon_state
			else
				icon_state ="glass_colour"
				item_state ="glass_colour"
				var/image/filling = image('icons/obj/reagentfillings.dmi', src, "glass")
				filling.icon += mix_color_from_reagents(reagents.reagent_list)
				filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
				overlays += filling
	else
		icon_state = "glass_empty"
		item_state = "glass_empty"
		name = "drinking glass"
		desc = "Your standard drinking glass."

	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		M.update_inv_hands()

		/*
			if(PINTPOINTER)
				var/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/pintpointer/P = new (get_turf(src))
				if(reagents.last_ckey_transferred_to_this)
					for(var/client/C in clients)
						if(C.ckey == reagents.last_ckey_transferred_to_this)
							var/mob/M = C.mob
							P.creator = M
				reagents.trans_to(P, reagents.total_volume)
				spawn(1)
					qdel(src)
			if(SCIENTISTS_SERENDIPITY)
				if(reagents.get_reagent_amount(SCIENTISTS_SERENDIPITY)<10) //You need at least 10u to get the tech bonus
					icon_state = "scientists_surprise"
					name = "\improper Scientist's Surprise"
					desc = "There is as yet insufficient data for a meaningful answer."
				else
					icon_state = "scientists_serendipity"
					name = "\improper Scientist's Serendipity"
					desc = "Knock back a cold glass of R&D."
					origin_tech = "materials=7;engineering=3;plasmatech=2;powerstorage=4;bluespace=6;combat=3;magnets=6;programming=3"*/

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/examine(mob/user)
	..()
	if(reagents.get_master_reagent_id() == METABUDDY && istype(user) && user.client)
		to_chat(user,"<span class='warning'>This one is made out to 'My very best friend, [user.client.ckey]'</span>")

// for /obj/machinery/vending/sovietsoda
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda/New()
	..()
	reagents.add_reagent(SODAWATER, 50)
	on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola/New()
	..()
	reagents.add_reagent(COLA, 50)
	on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/toxinsspecial/New()
	..()
	reagents.add_reagent(TOXINSSPECIAL, 30)
	on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/irishcoffee
	name = "irish coffee"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/irishcoffee/New()
	..()
	reagents.add_reagent(IRISHCOFFEE, 50)
	on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/sake
	name = "glass of sake"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/sake/New()
	..()
	reagents.add_reagent(SAKE, 50)
	on_reagent_change()

// Cafe Stuff. Mugs act the same as drinking glasses, but they don't break when thrown.

/obj/item/weapon/reagent_containers/food/drinks/mug
	name = "mug"
	desc = "A simple mug."
	icon = 'icons/obj/cafe.dmi'
	icon_state = "mug_empty"
	item_state = "mug_empty"
	isGlass = 0
	amount_per_transfer_from_this = 10
	volume = 30
	starting_materials = list(MAT_IRON = 500)

/obj/item/weapon/reagent_containers/food/drinks/mug/on_reagent_change()

	if (reagents.reagent_list.len > 0)
		item_state = "mug_empty"

		var/datum/reagent/R = reagents.get_master_reagent()

		name = R.mug_name ? R.mug_name : "\improper [R.name]"
		desc = R.mug_desc ? R.mug_desc : R.description
		isGlass = R.glass_isGlass

		if(R.mug_icon_state)
			icon_state = R.mug_icon_state
			item_state = R.mug_icon_state

		else
			make_reagent_overlay()
	else
		overlays.len = 0
		icon_state = "mug_empty"
		name = "mug"
		desc = "A simple mug."
		return

/obj/item/weapon/reagent_containers/food/drinks/mug/proc/make_reagent_overlay()
	overlays.len = 0
	icon_state ="mug_empty"
	var/image/filling = image('icons/obj/reagentfillings.dmi', src, "mug")
	filling.icon += mix_color_from_reagents(reagents.reagent_list)
	filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
	overlays += filling