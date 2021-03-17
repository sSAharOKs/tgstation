#define PARTY_COOLDOWN_LENGTH_MIN 6 MINUTES
#define PARTY_COOLDOWN_LENGTH_MAX 12 MINUTES


/datum/station_trait/lucky_winner
	name = "Счастливчик"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 1
	show_in_report = TRUE
	report_message = "Ваша станция выиграла главный приз ежегодной благотворительной акции. Время от времени в бар будут доставляться бесплатные закуски."
	trait_processes = TRUE
	COOLDOWN_DECLARE(party_cooldown)

/datum/station_trait/lucky_winner/on_round_start()
	. = ..()
	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

/datum/station_trait/lucky_winner/process(delta_time)
	if(!COOLDOWN_FINISHED(src, party_cooldown))
		return

	COOLDOWN_START(src, party_cooldown, rand(PARTY_COOLDOWN_LENGTH_MIN, PARTY_COOLDOWN_LENGTH_MAX))

	var/area/area_to_spawn_in = pick(GLOB.bar_areas)
	var/turf/T = pick(area_to_spawn_in.contents)

	var/obj/structure/closet/supplypod/centcompod/toLaunch = new()
	var/obj/item/pizzabox/pizza_to_spawn = pick(list(/obj/item/pizzabox/margherita, /obj/item/pizzabox/mushroom, /obj/item/pizzabox/meat, /obj/item/pizzabox/vegetable, /obj/item/pizzabox/pineapple))
	new pizza_to_spawn(toLaunch)
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/food/drinks/beer(toLaunch)
	new /obj/effect/pod_landingzone(T, toLaunch)

/datum/station_trait/galactic_grant
	name = "Галактический грант"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Ваша станция была выбрана для получения специального гранта. Вашему грузовому отделу были предоставлены дополнительные средства."

/datum/station_trait/galactic_grant/on_round_start()
	var/datum/bank_account/cargo_bank = SSeconomy.get_dep_account(ACCOUNT_CAR)
	cargo_bank.adjust_money(rand(2000, 5000))

/datum/station_trait/premium_internals_box
	name = "Коробки с оборудованием для дыхания премиум-класса"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 10
	show_in_report = TRUE
	report_message = "Вашему персоналу были выданы коробки с оборудованием для дыхания премиум-класса"
	trait_to_give = STATION_TRAIT_PREMIUM_INTERNALS

/datum/station_trait/bountiful_bounties
	name = "Щедрые баунти"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Похоже, коллекционеры в этой системе очень заинтересованы в баунти и будут платить больше, чтобы увидеть их завершение."

/datum/station_trait/bountiful_bounties/on_round_start()
	SSeconomy.bounty_modifier *= 1.2

/datum/station_trait/strong_supply_lines
	name = "Сильные линии снабжения"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Цены низкие в этой системе, ПОКУПАТЬ ПОКУПАТЬ ПОКУПАТЬ!"
	blacklist = list(/datum/station_trait/distant_supply_lines)


/datum/station_trait/strong_supply_lines/on_round_start()
	SSeconomy.pack_price_modifier *= 0.8

/datum/station_trait/scarves
	name = "Шарфы"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	var/list/scarves

/datum/station_trait/scarves/New()
	. = ..()
	report_message = pick(
		"Нанотразен экспериментирует с тем, чтобы увидеть, улучшает ли тепло шеи моральный дух сотрудников.",
		"После Недели космической моды шарфы - это новый модный аксессуар.",
		"Все одновременно немного замерзли, когда собирались на станцию.",
		"Станция определенно не подвергается атакам пришельцев знающих приём удушения, которые маскируются под шерсть. Точно нет.",
		"Вы все получаете бесплатные шарфы. Не спрашивайте почему.",
		"На станцию доставили партию шарфов.",
	)
	scarves = typesof(/obj/item/clothing/neck/scarf) + list(
		/obj/item/clothing/neck/stripedredscarf,
		/obj/item/clothing/neck/stripedgreenscarf,
		/obj/item/clothing/neck/stripedbluescarf,
	)

	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)

/datum/station_trait/scarves/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/living_mob, mob/M, joined_late)
	SIGNAL_HANDLER
	var/scarf_type = pick(scarves)

	living_mob.equip_to_slot_or_del(new scarf_type(living_mob), ITEM_SLOT_NECK, initial = FALSE)

/datum/station_trait/filled_maint
	name = "Заполненные теха"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Наши рабочие случайно забыли больше своих личных вещей в зонах технического обслуживания."
	blacklist = list(/datum/station_trait/empty_maint)
	trait_to_give = STATION_TRAIT_FILLED_MAINT

/datum/station_trait/quick_shuttle
	name = "Быстрый шаттл"
	trait_type = STATION_TRAIT_POSITIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Благодаря близости к нашей станции снабжения грузовой шаттл будет иметь более быстрое время полета до вашего отдела карго."
	blacklist = list(/datum/station_trait/slow_shuttle)

/datum/station_trait/quick_shuttle/on_round_start()
	. = ..()
	SSshuttle.supply.callTime *= 0.5

/datum/station_trait/deathrattle_department
	name = "deathrattled department"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	trait_flags = STATION_TRAIT_ABSTRACT
	blacklist = list(/datum/station_trait/deathrattle_all)

	var/department_to_apply_to
	var/department_name = "department"
	var/datum/deathrattle_group/deathrattle_group

/datum/station_trait/deathrattle_department/New()
	. = ..()
	deathrattle_group = new("группа [department_name]")
	blacklist += subtypesof(/datum/station_trait/deathrattle_department) - type //All but ourselves
	name = "Имплант предспертного хрипа в [department_name]"
	report_message = "Все члены [department_name] получили имплантат, чтобы уведомлять друг друга, если один из них умрет. Это должно помочь улучшить безопасность труда!"
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)

/datum/station_trait/deathrattle_department/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/living_mob, mob/M, joined_late)
	SIGNAL_HANDLER

	if(!(job.departments & department_to_apply_to))
		return

	var/obj/item/implant/deathrattle/implant_to_give = new()
	deathrattle_group.register(implant_to_give)
	implant_to_give.implant(living_mob, living_mob, TRUE, TRUE)


/datum/station_trait/deathrattle_department/service
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_SERVICE
	department_name = "Сервиса"

/datum/station_trait/deathrattle_department/cargo
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_CARGO
	department_name = "Карго"

/datum/station_trait/deathrattle_department/engineering
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_ENGINEERING
	department_name = "Инжинерного отдела"

/datum/station_trait/deathrattle_department/command
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_COMMAND
	department_name = "Командования"

/datum/station_trait/deathrattle_department/science
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_SCIENCE
	department_name = "Научного отдела"

/datum/station_trait/deathrattle_department/security
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_SECURITY
	department_name = "Отдела безопасности"

/datum/station_trait/deathrattle_department/medical
	trait_flags = NONE
	weight = 1
	department_to_apply_to = DEPARTMENT_MEDICAL
	department_name = "Медицинского отдела"

/datum/station_trait/deathrattle_all
	name = "Имплант предсмертного хрипа"
	trait_type = STATION_TRAIT_POSITIVE
	show_in_report = TRUE
	weight = 1
	report_message = "Все члены станции получили имплант, чтобы уведомить друг друга, если один из них умирает. Это должно помочь повысить безопасность труда!"
	var/datum/deathrattle_group/deathrattle_group


/datum/station_trait/deathrattle_all/New()
	. = ..()
	deathrattle_group = new("Станционная группа")
	blacklist = subtypesof(/datum/station_trait/deathrattle_department)
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)

/datum/station_trait/deathrattle_all/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/living_mob, mob/M, joined_late)
	SIGNAL_HANDLER

	var/obj/item/implant/deathrattle/implant_to_give = new()
	deathrattle_group.register(implant_to_give)
	implant_to_give.implant(living_mob, living_mob, TRUE, TRUE)
