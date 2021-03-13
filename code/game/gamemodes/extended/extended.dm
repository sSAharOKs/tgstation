/datum/game_mode/extended
	name = "secret extended"
	config_tag = "secret_extended"
	report_type = "extended"
	false_report_weight = 5
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/generate_report()
	return "The transmission mostly failed to mention your sector. It is possible that there is nothing in the Syndicate that could threaten your station during this shift."

/datum/game_mode/extended/announced
	name = "extended"
	config_tag = "extended"
	false_report_weight = 0

/datum/game_mode/extended/announced/generate_station_goals()
	for(var/T in subtypesof(/datum/station_goal))
		var/datum/station_goal/G = new T
		station_goals += G
		G.on_report()

/datum/game_mode/extended/announced/send_intercept()
	var/greenshift_message = "Благодаря неустанным усилиям наших отделов безопасности и разведки в настоящее время нет никаких достоверных угроз для [station_name()]. Все проекты строительства станции были санкционированы. Обеспечьте себе безопасную смену!"
	. += "<b><i>Сводная информация о состоянии Центрального командования</i></b><hr>"
	. += greenshift_message
	. += generate_station_trait_report()

	print_command_report(., "Central Command Status Summary", announce = FALSE)
	priority_announce(greenshift_message, "Отчет о безопасности", SSstation.announcer.get_rand_report_sound())
