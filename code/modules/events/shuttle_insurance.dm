

/datum/round_event_control/shuttle_insurance
	name = "Shuttle Insurance"
	typepath = /datum/round_event/shuttle_insurance
	weight = 200 //you're basically bound to get it
	max_occurrences = 1

/datum/round_event_control/shuttle_insurance/canSpawnEvent(players, gamemode)
	if(!SSeconomy.get_dep_account(ACCOUNT_CAR))
		return FALSE //They can't pay?
	if(SSshuttle.shuttle_purchased != SHUTTLEPURCHASE_FORCED)
		return FALSE //don't do it if there's nothing to insure
	if(EMERGENCY_AT_LEAST_DOCKED)
		return FALSE //catastrophes won't trigger so no point
	return ..()

/datum/round_event/shuttle_insurance
	var/ship_name = "\"Сомнительный момент\""
	var/datum/comm_message/insurance_message
	var/insurance_evaluation = 0

/datum/round_event/shuttle_insurance/announce(fake)
	priority_announce("Входящая субпространственная связь. На всех консолях связи открыт защищенный канал.", "Входящее Сообщение", SSstation.announcer.get_rand_report_sound())

/datum/round_event/shuttle_insurance/setup()
	ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))
	for(var/shuttle_id in SSmapping.shuttle_templates)
		var/datum/map_template/shuttle/template = SSmapping.shuttle_templates[shuttle_id]
		if(template.name == SSshuttle.emergency.name) //found you slackin
			insurance_evaluation = template.credit_cost/2
			break
	if(!insurance_evaluation)
		insurance_evaluation = 5000 //gee i dunno

/datum/round_event/shuttle_insurance/start()
	insurance_message = new("Страхование шаттлов", "Эй, приятель, это тот самый [ship_name]. Не могу не заметить, что ты покачиваешь там дикий и безумный шаттл без СТРАХОВКИ!Псих.А что, если с ним что-нибудь случится?! Мы провели быструю оценку ваших ставок в этом секторе и предлагаем [insurance_evaluation], чтобы покрыть ваш шаттл в случае какой-либо катастрофы.", list("Купить Страховку","Отклонить предложение."))
	insurance_message.answer_callback = CALLBACK(src,.proc/answered)
	SScommunications.send_message(insurance_message, unique = TRUE)

/datum/round_event/shuttle_insurance/proc/answered()
	if(EMERGENCY_AT_LEAST_DOCKED)
		priority_announce("Вы определенно опоздали в приобретении страховки, друзья мои. Наши агенты не работают на месте.",sender_override = ship_name)
	if(insurance_message && insurance_message.answered == 1)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(!station_balance?.adjust_money(-insurance_evaluation))
			priority_announce("Вы не прислали нам достаточно денег на страховку шаттла. Это, с точки зрения космического дилетанта, считается мошенничеством. Мы забираем ваши деньги, мошенники!",sender_override = ship_name)
			return
		priority_announce("Благодарим вас за покупку страховки шаттла!",sender_override = ship_name)
		SSshuttle.shuttle_insurance = TRUE
