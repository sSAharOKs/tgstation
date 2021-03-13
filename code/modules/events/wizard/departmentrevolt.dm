/datum/round_event_control/wizard/deprevolt //stationwide!
	name = "Departmental Uprising"
	weight = 0 //An order that requires order in a round of chaos was maybe not the best idea. Requiescat in pace departmental uprising August 2014 - March 2015 //hello motherfucker i fixed your shit in 2021
	typepath = /datum/round_event/wizard/deprevolt
	max_occurrences = 1
	earliest_start = 0 MINUTES

	var/picked_department
	var/announce = FALSE
	var/dangerous_nation = TRUE

/datum/round_event_control/wizard/deprevolt/admin_setup()
	if(!check_rights(R_FUN))
		return
	var/list/options = list("Random", "Uprising of Assistants", "Medical", "Engineering", "Science", "Supply", "Service", "Security")
	picked_department = input(usr,"Which department should revolt?","Select a department") as null|anything in options

	var/announce_question = alert(usr, "Announce This New Independent State?", "Secession", "Announce", "No Announcement")
	if(announce_question == "Announce")
		announce = TRUE

	var/dangerous_question = alert(usr, "Dangerous Nation? This means they will fight other nations.", "Conquest", "Yes", "No")
	if(dangerous_question == "No")
		dangerous_nation = FALSE

	//this is down here to allow the random system to pick a department whilst considering other independent departments
	if(!picked_department || picked_department == "Random")
		picked_department = null
		return

/datum/round_event/wizard/deprevolt/start()

	var/datum/round_event_control/wizard/deprevolt/event_control = control

	var/list/independent_departments = list() ///departments that are already independent, these will be disallowed to be randomly picked
	var/list/cannot_pick = list() ///departments that are already independent, these will be disallowed to be randomly picked
	for(var/datum/antagonist/separatist/separatist_datum in GLOB.antagonists)
		if(!separatist_datum.nation)
			continue
		independent_departments |= separatist_datum.nation
		cannot_pick |= separatist_datum.nation.nation_department

	var/announcement = event_control.announce
	var/dangerous = event_control.dangerous_nation
	var/department
	if(event_control.picked_department)
		department = event_control.picked_department
		event_control.picked_department = null
	else
		department = pick(list("Ассистентский", "Медицинский", "Инженерный", "Научный", "Карго", "Сервисный", "Охранный") - cannot_pick)
		if(!department)
			message_admins("Department Revolt could not create a nation, as all the departments are independent! You have created nations, you madman!")
	var/list/jobs_to_revolt = list()
	var/nation_name
	var/list/citizens = list()

	switch(department)
		if("Ассистентский") //God help you
			jobs_to_revolt = list("Ассистенты")
			nation_name = pick("тулбоксо", "техтонель", "тунельщи", "Грю", "Грей тайд", "Лиа", "Гриджио", "Ассит", "Асси")
		if("Медицинский")
			jobs_to_revolt = GLOB.medical_positions
			nation_name = pick("Меди", "Здоровь", "Рекова", "Хими", "Виро", "Психо")
		if("Инженерный")
			jobs_to_revolt = GLOB.engineering_positions
			nation_name = pick("Атмо", "Энджиро", "Электро", "Телеко")
		if("Научный")
			jobs_to_revolt = GLOB.science_positions
			nation_name = pick("Науч", "Гриффа", "Генетик", "Взрыво", "Меха", "Ксено", "Нанит", "Цито")
		if("Карго")
			jobs_to_revolt = GLOB.supply_positions
			nation_name = pick("Карго", "Гуна", "Снабжэ", "Мулэ", "Ящико", "Рудно", "Мини", "Шахтно")
		if("Сервисный") //the few, the proud, the technically aligned
			jobs_to_revolt = GLOB.service_positions.Copy() - list("Assistant", "Prisoner")
			nation_name = pick("Хонка", "Выпико", "Тофу", "Утко", "Мини", "Библио", "Уборщико", "Религи")
		if("Охранный")
			jobs_to_revolt = GLOB.security_positions
			nation_name = pick("Охрано", "бипски", "Сщиткьюри", "Комунно", "Станба", "Флешбен", "Флешко", "Перма")

	nation_name += pick("стан", "топия", "лэнд", "ния", "това", "дор", "тор", "тия", "сиа", "дия", "тика", "тайд", "сцист", "мармэ", "ко", "тиадов", "славия", "стотца")
	if(department == "Ассистентский")
		var/prefix = pick("бродячий клан", "варварское племя", "тулбоксоносцы", "бандитское царство", "общество", "клан мародёров", "орда")
		nation_name = " [prefix] [nation_name]"

	var/datum/team/nation/nation = new(null, jobs_to_revolt, department)
	nation.name = nation_name
	var/datum/team/department_target //dodges unfortunate runtime
	if(independent_departments.len)
		department_target = pick(independent_departments)
	nation.generate_nation_objectives(dangerous, department_target)

	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/possible_separatist = i
		if(!possible_separatist.mind)
			continue
		var/datum/mind/separatist_mind = possible_separatist.mind
		if(!separatist_mind.assigned_role)
			continue
		for(var/job in jobs_to_revolt)
			if(separatist_mind.assigned_role == job)
				citizens += possible_separatist
				separatist_mind.add_antag_datum(/datum/antagonist/separatist, nation, department)
				nation.add_member(separatist_mind)
				possible_separatist.log_message("Was made into a separatist, long live [nation_name]!", LOG_ATTACK, color="red")

	if(citizens.len)
		var/jobs_english_list = english_list(jobs_to_revolt)
		message_admins("Нация [nation_name] была сформирована. Затронут(ы) [jobs_english_list] отдел(ы). Любые новые члены экипажа с этими должностями присоединятся к отделению.")
		if(announcement)
			var/announce_text = "Новое независимое государство [nation_name]. Бывший [department] отдел!"
			if(department == "Ассистентов") //the text didn't really work otherwise
				announce_text = "Ассистенты восстали, чтобы сформировать новое независимое государство под именем [nation_name]!"
			priority_announce(announce_text, "Отделы на [GLOB.station_name]",  has_important_message = TRUE)
	else
		message_admins("Нация [nation_name] не имела достаточного количества потенциальных членов для создания.")
		qdel(nation)
