SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	wait = 10 MINUTES

	var/nightshift_active = FALSE
	var/nightshift_start_time = 702000 //7:30 PM, station time
	var/nightshift_end_time = 270000 //7:30 AM, station time
	var/nightshift_first_check = 30 SECONDS

	var/high_security_mode = FALSE
	var/list/currentrun

/datum/controller/subsystem/nightshift/Initialize()
	if(!CONFIG_GET(flag/enable_night_shifts))
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(resumed)
		update_nightshift(resumed = TRUE)
		return
	if(world.time - SSticker.round_start_time < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	priority_announce(message, sound='sound/misc/notice2.ogg', sender_override="Автоматическая Система Освещения")

/datum/controller/subsystem/nightshift/proc/check_nightshift()
	var/emergency = GLOB.security_level >= SEC_LEVEL_RED
	var/announcing = TRUE
	var/time = station_time()
	var/night_time = (time < nightshift_end_time) || (time > nightshift_start_time)
	if(high_security_mode != emergency)
		high_security_mode = emergency
		if(night_time)
			announcing = FALSE
			if(!emergency)
				announce("Восстановление нормальной работы конфигурации ночного освещения.")
			else
				announce("Отключение ночного освещения: Станция находится в режиме черезвычайной ситуации.")
	if(emergency)
		night_time = FALSE
	if(nightshift_active != night_time)
		update_nightshift(night_time, announcing)

/datum/controller/subsystem/nightshift/proc/update_nightshift(active, announce = TRUE, resumed = FALSE)
	if(!resumed)
		currentrun = GLOB.apcs_list.Copy()
		nightshift_active = active
		if(announce)
			if (active)
				announce("Добрый вечер, экипаж. Чтобы уменьшить потребление энергии и стимулировать циркадные ритмы некоторых видов, весь свет на борту станции был приглушен на ночь.")
			else
				announce("Доброе утро, экипаж. Поскольку сейчас день, весь свет на борту станции вернулся к своей прежней яркости.")
	for(var/obj/machinery/power/apc/APC as anything in currentrun)
		currentrun -= APC
		if (APC.area && (APC.area.type in GLOB.the_station_areas))
			APC.set_nightshift(active)
		if(MC_TICK_CHECK)
			return
