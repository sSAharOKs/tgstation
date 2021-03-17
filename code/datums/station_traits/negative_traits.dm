/datum/station_trait/carp_infestation
	name = "Нашествие карпов"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 5
	show_in_report = TRUE
	report_message = "В районе станции присутствует опасная фауна."
	trait_to_give = STATION_TRAIT_CARP_INFESTATION

/datum/station_trait/distant_supply_lines
	name = "Дальне удалённые линии снабжения"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 3
	show_in_report = TRUE
	report_message = "Из-за удаленности от наших обычных линий снабжения заказы на грузы обходятся дороже."
	blacklist = list(/datum/station_trait/strong_supply_lines)

/datum/station_trait/distant_supply_lines/on_round_start()
	SSeconomy.pack_price_modifier *= 1.2

/datum/station_trait/late_arrivals
	name = "Опаздывающие шаттлы прибытия"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	show_in_report = TRUE
	report_message = "Извините за это, мы не ожидали, что влетим в этого блюющего гуся, пока везем вас на новую станцию."
	trait_to_give = STATION_TRAIT_LATE_ARRIVALS
	blacklist = list(/datum/station_trait/random_spawns, /datum/station_trait/hangover)

/datum/station_trait/random_spawns
	name = "Водитель проехал мимо станции"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	show_in_report = TRUE
	report_message = "Извините за это, мы пропустили вашу станцию на несколько миль, поэтому мы просто запустили вас к вашей станции в капсулах. Надеюсь, вы не возражаете?"
	trait_to_give = STATION_TRAIT_RANDOM_ARRIVALS
	blacklist = list(/datum/station_trait/late_arrivals, /datum/station_trait/hangover)

/datum/station_trait/hangover
	name = "Hangover"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 2
	show_in_report = TRUE
	report_message = "Ох...Блин....Тот обязательный копоратив с прошлой смены...Боже, это было потрясающе..Я проснулся в каком-то случайном туалете в 3 секторах отсюда..."
	trait_to_give = STATION_TRAIT_HANGOVER
	blacklist = list(/datum/station_trait/late_arrivals, /datum/station_trait/random_spawns)

/datum/station_trait/hangover/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, .proc/on_job_after_spawn)

/datum/station_trait/hangover/proc/on_job_after_spawn(datum/source, datum/job/job, mob/living/living_mob, mob/spawned_mob, joined_late)
	SIGNAL_HANDLER

	if(joined_late)
		return
	if(prob(35))
		var/obj/item/hat = pick(list(/obj/item/clothing/head/sombrero, /obj/item/clothing/head/fedora, /obj/item/clothing/mask/balaclava, /obj/item/clothing/head/ushanka, /obj/item/clothing/head/cardborg, /obj/item/clothing/head/pirate, /obj/item/clothing/head/cone))
		hat = new hat(spawned_mob)
		spawned_mob.equip_to_slot(hat, ITEM_SLOT_HEAD)

/datum/station_trait/blackout
	name = "Тьма-тьмущая"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 3
	show_in_report = TRUE
	report_message = "Свет на станции, кажется, поврежден, будьте в осторожны, начиная свою смену сегодня."

/datum/station_trait/blackout/on_round_start()
	. = ..()
	for(var/a in GLOB.apcs_list)
		var/obj/machinery/power/apc/current_apc = a
		if(prob(60))
			current_apc.overload_lighting()

/datum/station_trait/empty_maint
	name = "Вычищенные теха"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 5
	show_in_report = TRUE
	report_message = "Наши рабочие вычистили большую часть мусора в зонах технического обслуживания."
	blacklist = list(/datum/station_trait/filled_maint)
	trait_to_give = STATION_TRAIT_EMPTY_MAINT


/datum/station_trait/overflow_job_bureacracy
	name = "Бюрократическая ошибка"
	trait_type = STATION_TRAIT_NEGATIVE
	weight = 5
	show_in_report = TRUE
	var/list/jobs_to_use = list("клоунов", "барменов", "поваров", "ботаников", "карго техников", "мимов", "уборщиков", "зеков")
	var/chosen_job

/datum/station_trait/overflow_job_bureacracy/New()
	. = ..()
	chosen_job = pick(jobs_to_use)
	RegisterSignal(SSjob, COMSIG_SUBSYSTEM_POST_INITIALIZE, .proc/set_overflow_job_override)

/datum/station_trait/overflow_job_bureacracy/get_report()
	return "Походу произошла [name]. Список вакансий на эту смену немного неправильный...Я надеюсь, вам понравится куча [chosen_job]."

/datum/station_trait/overflow_job_bureacracy/proc/set_overflow_job_override(datum/source, new_overflow_role)
	SIGNAL_HANDLER
	SSjob.set_overflow_role(chosen_job)

/datum/station_trait/slow_shuttle
	name = "Медленный шаттл"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 5
	show_in_report = TRUE
	report_message = "Из-за расстояния до нашей станции снабжения грузовой шаттл будет иметь более медленное время полета до вашего отдела карго."
	blacklist = list(/datum/station_trait/quick_shuttle)

/datum/station_trait/slow_shuttle/on_round_start()
	. = ..()
	SSshuttle.supply.callTime *= 1.5
