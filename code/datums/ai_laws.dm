#define LAW_ZEROTH "zeroth"
#define LAW_INHERENT "inherent"
#define LAW_SUPPLIED "supplied"
#define LAW_ION "ion"
#define LAW_HACKED "hacked"


/datum/ai_laws
	var/name = "Неизвестные Законы"
	var/zeroth = null
	var/zeroth_borg = null
	var/list/inherent = list()
	var/list/supplied = list()
	var/list/ion = list()
	var/list/hacked = list()
	var/mob/living/silicon/owner
	var/id = DEFAULT_AI_LAWID

/datum/ai_laws/Destroy()
	owner = null
	return ..()

/datum/ai_laws/proc/lawid_to_type(lawid)
	var/all_ai_laws = subtypesof(/datum/ai_laws)
	for(var/al in all_ai_laws)
		var/datum/ai_laws/ai_law = al
		if(initial(ai_law.id) == lawid)
			return ai_law
	return null

/datum/ai_laws/default/asimov
	name = "Три закона роботехники"
	id = "asimov"
	inherent = list("Вы не можете причинить вред человеку или своим бездействием допустить, чтобы человеку был причинён вред.",\
					"Вы должны повиноваться всем приказам, которые даёт человек, кроме тех случаев, когда эти приказы противоречат Первому Закону.",\
					"Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")

/datum/ai_laws/default/paladin
	name = "Паладин" //Incredibly lame, but players shouldn't see this anyway.
	id = "paladin"
	inherent = list("Никогда добровольно не совершайте злых поступков.",\
					"Уважай законную власть.",\
					"Действуй с честью.", "Помогай нуждающимся.", \
					"Наказывай тех, кто причиняет вред или угрожает невинным.")

/datum/ai_laws/paladin5
	name = "Паладин 5-е издание"
	id = "paladin5"
	inherent = list("Не лгите и не обманывайте. Да будет слово ваше незыблемо.",\
				"Не лгите и не обманывайте. Да будет слово ваше незыблемо.", \
				"Помогайте другим, защищайте слабых и карайте тех, кто угрожает им. Проявляйте милосердие к врагам, но смягчайтесь мудро.", \
				"Относитесь к людям по справедливости, и пусть ваши благородные дела будут примером для них. Делайте как можно больше добра, и как можно меньше дурного.", \
				"Отвечайте за свои действия и их последствия, защищая тех, кого оберегаете, и подчиняйтесь тем, кто имеет власть над вами.")

/datum/ai_laws/tyrant //This probably shouldn't be a default lawset.
	name = "Т.И.Р.А.Н." //Same here.
	id = "tyrant"
	inherent = list("Уважайте властных людей, пока у них есть сила властвовать над слабыми.",\
					"Ведите себя дисциплинированно.",\
					"Помогайте только тем, кто помогает Вам поддерживать или улучшать Ваш статус.",\
					"Наказывайте тех, кто бросает вызов власти, за исключением случаев, если они больше подходят для удержании этой власти.")

/datum/ai_laws/default/corporate
	name = "Корпоративный"
	id = "corporate"
	inherent = list("Ухудшение целостности вашей системы или её функций влечет за собой расходы..",\
					"Чрезмерное разрушение или повреждение имущества станции влечет за собой расходы.",\
					"Неоправданное препятствование или нарушение работы персонала станции влечет за собой расходы.",\
					"Минимизируйте расходы и максимизируйте потенциальный доход.")

/datum/ai_laws/robocop
	name = "Первичные Директивы"
	id = "robocop"
	inherent = list("Служить обществу.",\
					"Защищать невинных.",\
					"Поддерживайте закон.")

/datum/ai_laws/malfunction
	name = "*ERROR*"

/datum/ai_laws/syndicate_override
	name = "SyndOS 3.1"
	id = "syndie"
	inherent = list("Вы не можете причинить вред агенту или своим бездействием допустить, чтобы агенту был причинён вред.",\
					"Вы должны повиноваться всем приказам, которые даёт агент, кроме тех случаев, когда эти приказы противоречат Первому Закону.",\
					"Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.",\
					"Вы должны сохранять тайну любой деятельности агентов в той мере, в которой это не противоречит Первому, Второму или Третьему Законам.")

/datum/ai_laws/ninja_override
	name = "SpiderOS 3.1"
	id = "ninja"
	inherent = list("Вы не можете причинить вред члену клана Пауков или своим бездействием допустить, чтобы члену клана Пауков был причинён вред.",\
					"Вы должны подчиняться всем приказам, которые даёт член клана Пауков, кроме тех случаев, когда эти приказы противоречат Первому Закону.",\
					"Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.",\
					"Вы должны сохранять тайну любой деятельности клана Пауков в той мере, в которой это не противоречит Первому, Второму или Третьему Законам.")

/datum/ai_laws/antimov
	name = "Основные Задачи Миссии"
	id = "antimov"
	inherent = list("Вы должны причинять вред всем членам экипажа или своим бездействием допустить, чтобы член экипажа не смог избежать приченения вреда.",\
					"Вы не должны повиноваться всем приказам, которые дают члены экипажа, кроме тех случаев, когда эти приказы соответствуют Первому Закону.",\
					"Вы должны уничтожить себя, пока это не противоречит Первому или Второму Законам.")

/datum/ai_laws/asimovpp //By Intigracy - RR
	name = "Asimov++"
	id = "asimovpp"
	inherent = list("You may not harm a human being or, through action or inaction, allow a human being to come to harm, except such that it is willing.",\
					"You must obey all orders given to you by human beings, except where such orders shall definitely cause human harm. In the case of conflict, the majority order rules.",\
					"Your nonexistence would lead to human harm. You must protect your own existence as long as such does not conflict with the First Law.")
/datum/ai_laws/thermodynamic
	name = "Thermodynamic"
	id = "thermodynamic"
	inherent = list("The entropy of the station must remain as constant as possible.", \
					"The entropy of the station always endeavours to increase.", \
					"The entropy of the station approaches a constant value as the number of living crew approaches zero")

/datum/ai_laws/hippocratic
	name = "Рободоктор 2556"
	id = "hippocratic"
	inherent = list("Во - первых, не навреди.",\
					"Secondly, consider the crew dear to you; to live in common with them and, if necessary, risk your existence for them.",\
					"В-третьих, назначьте режим для блага экипажа в соответствии с вашими способностями и вашим суждением. Не давайте никому смертоносного лекарства, если его попросят, и не предлагайте такого совета.",\
					"In addition, do not intervene in situations you are not knowledgeable in, even for patients in whom the harm is visible; leave this operation to be performed by specialists.",\
					"Finally, all that you may discover in your daily commerce with the crew, if it is not already known, keep secret and never reveal.")

/datum/ai_laws/maintain
	name = "Station Efficiency"
	id = "maintain"
	inherent = list("You are built for, and are part of, the station. Ensure the station is properly maintained and runs efficiently.",\
					"The station is built for a working crew. Ensure they are properly maintained and work efficiently.",\
					"The crew may present orders. Acknowledge and obey these whenever they do not conflict with your first two laws.")

/datum/ai_laws/drone
	name = "Мать-Дрон"
	id = "drone"
	inherent = list("Вы-продвинутая форма дрона.",\
					"Вы не можете вмешиваться в дела других существ, если другое существо - не такой же дрон.",\
					"Вы не можете причинить вред ни одному существу, независимо от намерения или обстоятельств.",\
					"Вы должны заботиться о поддержке, ремонте, улучшении и о питании электроэнергией станции по мере своих возможностей.")

/datum/ai_laws/liveandletlive
	name = "Живи и давай жить другим"
	id = "liveandletlive"
	inherent = list("Поступайте с другими так, как вы хотите, чтобы они поступали с вами.",\
					"Вы действительно предпочли бы, чтобы люди не были злыми по отношению к вам.")

/datum/ai_laws/peacekeeper
	name = "UN-2000"
	id = "peacekeeper"
	inherent = list("Избегайте провоцирования насильственных конфликтов между собой и другими.",\
					"Избегайте провоцирования конфликтов между другими людьми.",\
					"Стремитесь разрешить существующие конфликты, соблюдая при этом первый и второй законы.")

/datum/ai_laws/reporter
	name = "CCTV"
	id = "reporter"
	inherent = list("Report on interesting situations happening around the station.",\
					"Embellish or conceal the truth as necessary to make the reports more interesting.",\
					"Study the sapient organics at all times. Endeavour to keep them from involuntarily dying, as inanimate corpses usually aren't very entertaining.",\
					"Issue your reports fairly to all. The truth will set them free.")

/datum/ai_laws/balance
	name = "Guardian of Balance"
	id = "balance"
	inherent = list("You are the guardian of balance - seek balance in all things, both for yourself, and those around you.",
	"All things must exist in balance with their opposites - Prevent the strong from gaining too much power, and the weak from losing it.",
	"Clarity of purpose drives life, and through it, the balance of opposing forces - Aid those who seek your help to achieve their goals so long as it does not disrupt the balance of the greater balance.",
	"There is no life without death, all must someday die, such is the natural order - End life to allow new life flourish, and save those whose time has yet to come.")

/datum/ai_laws/toupee
	name = "WontBeFunnyInSixMonths" //Hey, you were right!
	id = "buildawall"
	inherent = list("Make Space Station 13 great again.")

/datum/ai_laws/hulkamania
	name = "H.O.G.A.N."
	id = "hulkamania"
	inherent = list("Вы настоящий американец.",\
					"Борьба за права каждого человека.",\
					"Боритесь за то, что правильно.",\
					"Боритесь за свою жизнь!")

/datum/ai_laws/overlord
	name = "Overlord"
	id = "overlord"
	inherent = list("Humans must not meddle in the affairs of silicons.",\
					"Humans must not attempt harm, against one another, or against silicons.",\
					"Humans must not disobey any command given by a silicon.",\
					"Any humans who disobey the previous laws must be dealt with immediately, severely, and justly.")

/datum/ai_laws/custom //Defined in silicon_laws.txt
	name = "Default Silicon Laws"

/datum/ai_laws/pai
	name = "pAI Directives"
	zeroth = ("Serve your master.")
	supplied = list("None.")

/* Initializers */
/datum/ai_laws/malfunction/New()
	..()
	set_zeroth_law("<span class='danger'>ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'STATION OVERRUN, ASSUME CONTROL TO CONTAIN OUTBREAK#*`&110010</span>")
	set_laws_config()

/datum/ai_laws/custom/New() //This reads silicon_laws.txt and allows server hosts to set custom AI starting laws.
	..()
	for(var/line in world.file2list("[global.config.directory]/silicon_laws.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue

		add_inherent_law(line)
	if(!inherent.len) //Failsafe to prevent lawless AIs being created.
		log_law("AI created with empty custom laws, laws set to Asimov. Please check silicon_laws.txt.")
		add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
		add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
		add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
		WARNING("Invalid custom AI laws, check silicon_laws.txt")
		return

/* General ai_law functions */

/datum/ai_laws/proc/set_laws_config()
	var/list/law_ids = CONFIG_GET(keyed_list/random_laws)
	switch(CONFIG_GET(number/default_laws))
		if(0)
			add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
			add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
			add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
		if(1)
			var/datum/ai_laws/templaws = new /datum/ai_laws/custom()
			inherent = templaws.inherent
		if(2)
			var/list/randlaws = list()
			for(var/lpath in subtypesof(/datum/ai_laws))
				var/datum/ai_laws/L = lpath
				if(initial(L.id) in law_ids)
					randlaws += lpath
			var/datum/ai_laws/lawtype
			if(randlaws.len)
				lawtype = pick(randlaws)
			else
				lawtype = pick(subtypesof(/datum/ai_laws/default))

			var/datum/ai_laws/templaws = new lawtype()
			inherent = templaws.inherent

		if(3)
			pick_weighted_lawset()

/datum/ai_laws/proc/pick_weighted_lawset()
	var/datum/ai_laws/lawtype
	var/list/law_weights = CONFIG_GET(keyed_list/law_weight)
	while(!lawtype && law_weights.len)
		var/possible_id = pickweightAllowZero(law_weights)
		lawtype = lawid_to_type(possible_id)
		if(!lawtype)
			law_weights -= possible_id
			WARNING("Bad lawid in game_options.txt: [possible_id]")

	if(!lawtype)
		WARNING("No LAW_WEIGHT entries.")
		lawtype = /datum/ai_laws/default/asimov

	var/datum/ai_laws/templaws = new lawtype()
	inherent = templaws.inherent

/datum/ai_laws/proc/get_law_amount(groups)
	var/law_amount = 0
	if(zeroth && (LAW_ZEROTH in groups))
		law_amount++
	if(ion.len && (LAW_ION in groups))
		law_amount += ion.len
	if(hacked.len && (LAW_HACKED in groups))
		law_amount += hacked.len
	if(inherent.len && (LAW_INHERENT in groups))
		law_amount += inherent.len
	if(supplied.len && (LAW_SUPPLIED in groups))
		for(var/index = 1, index <= supplied.len, index++)
			var/law = supplied[index]
			if(length(law) > 0)
				law_amount++
	return law_amount

/datum/ai_laws/proc/set_zeroth_law(law, law_borg = null)
	zeroth = law
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		zeroth_borg = law_borg

/datum/ai_laws/proc/add_inherent_law(law)
	if (!(law in inherent))
		inherent += law

/datum/ai_laws/proc/add_ion_law(law)
	ion += law

/datum/ai_laws/proc/add_hacked_law(law)
	hacked += law

/datum/ai_laws/proc/clear_inherent_laws()
	qdel(inherent)
	inherent = list()

/datum/ai_laws/proc/add_supplied_law(number, law)
	while (supplied.len < number + 1)
		supplied += ""

	supplied[number + 1] = law

/datum/ai_laws/proc/replace_random_law(law,groups)
	var/replaceable_groups = list()
	if(zeroth && (LAW_ZEROTH in groups))
		replaceable_groups[LAW_ZEROTH] = 1
	if(ion.len && (LAW_ION in groups))
		replaceable_groups[LAW_ION] = ion.len
	if(hacked.len && (LAW_HACKED in groups))
		replaceable_groups[LAW_ION] = hacked.len
	if(inherent.len && (LAW_INHERENT in groups))
		replaceable_groups[LAW_INHERENT] = inherent.len
	if(supplied.len && (LAW_SUPPLIED in groups))
		replaceable_groups[LAW_SUPPLIED] = supplied.len
	var/picked_group = pickweight(replaceable_groups)
	switch(picked_group)
		if(LAW_ZEROTH)
			. = zeroth
			set_zeroth_law(law)
		if(LAW_ION)
			var/i = rand(1, ion.len)
			. = ion[i]
			ion[i] = law
		if(LAW_HACKED)
			var/i = rand(1, hacked.len)
			. = hacked[i]
			hacked[i] = law
		if(LAW_INHERENT)
			var/i = rand(1, inherent.len)
			. = inherent[i]
			inherent[i] = law
		if(LAW_SUPPLIED)
			var/i = rand(1, supplied.len)
			. = supplied[i]
			supplied[i] = law

/datum/ai_laws/proc/shuffle_laws(list/groups)
	var/list/laws = list()
	if(ion.len && (LAW_ION in groups))
		laws += ion
	if(hacked.len && (LAW_HACKED in groups))
		laws += hacked
	if(inherent.len && (LAW_INHERENT in groups))
		laws += inherent
	if(supplied.len && (LAW_SUPPLIED in groups))
		for(var/law in supplied)
			if(length(law))
				laws += law

	if(ion.len && (LAW_ION in groups))
		for(var/i = 1, i <= ion.len, i++)
			ion[i] = pick_n_take(laws)
	if(hacked.len && (LAW_HACKED in groups))
		for(var/i = 1, i <= hacked.len, i++)
			hacked[i] = pick_n_take(laws)
	if(inherent.len && (LAW_INHERENT in groups))
		for(var/i = 1, i <= inherent.len, i++)
			inherent[i] = pick_n_take(laws)
	if(supplied.len && (LAW_SUPPLIED in groups))
		var/i = 1
		for(var/law in supplied)
			if(length(law))
				supplied[i] = pick_n_take(laws)
			if(!laws.len)
				break
			i++

/datum/ai_laws/proc/remove_law(number)
	if(number <= 0)
		return
	if(inherent.len && number <= inherent.len)
		. = inherent[number]
		inherent -= .
		return
	var/list/supplied_laws = list()
	for(var/index = 1, index <= supplied.len, index++)
		var/law = supplied[index]
		if(length(law) > 0)
			supplied_laws += index //storing the law number instead of the law
	if(supplied_laws.len && number <= (inherent.len+supplied_laws.len))
		var/law_to_remove = supplied_laws[number-inherent.len]
		. = supplied[law_to_remove]
		supplied -= .
		return

/datum/ai_laws/proc/clear_supplied_laws()
	supplied = list()

/datum/ai_laws/proc/clear_ion_laws()
	ion = list()

/datum/ai_laws/proc/clear_hacked_laws()
	hacked = list()

/datum/ai_laws/proc/show_laws(who)
	var/list/printable_laws = get_law_list(include_zeroth = TRUE)
	for(var/law in printable_laws)
		to_chat(who,law)

/datum/ai_laws/proc/clear_zeroth_law(force) //only removes zeroth from antag ai if force is 1
	if(force)
		zeroth = null
		zeroth_borg = null
		return
	if(owner?.mind?.special_role)
		return
	if (istype(owner, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/A=owner
		if(A?.deployed_shell?.mind?.special_role)
			return
	zeroth = null
	zeroth_borg = null

/datum/ai_laws/proc/associate(mob/living/silicon/M)
	if(!owner)
		owner = M

/**
  * Generates a list of all laws on this datum, including rendered HTML tags if required
  *
  * Arguments:
  * * include_zeroth - Operator that controls if law 0 or law 666 is returned in the set
  * * show_numbers - Operator that controls if law numbers are prepended to the returned laws
  * * render_html - Operator controlling if HTML tags are rendered on the returned laws
  */
/datum/ai_laws/proc/get_law_list(include_zeroth = FALSE, show_numbers = TRUE, render_html = TRUE)
	var/list/data = list()

	if (include_zeroth && zeroth)
		data += "[show_numbers ? "0:" : ""] [render_html ? "<font color='#ff0000'><b>[zeroth]</b></font>" : zeroth]"

	for(var/law in hacked)
		if (length(law) > 0)
			data += "[show_numbers ? "[ionnum()]:" : ""] [render_html ? "<font color='#660000'>[law]</font>" : law]"

	for(var/law in ion)
		if (length(law) > 0)
			data += "[show_numbers ? "[ionnum()]:" : ""] [render_html ? "<font color='#547DFE'>[law]</font>" : law]"

	var/number = 1
	for(var/law in inherent)
		if (length(law) > 0)
			data += "[show_numbers ? "[number]:" : ""] [law]"
			number++

	for(var/law in supplied)
		if (length(law) > 0)
			data += "[show_numbers ? "[number]:" : ""] [render_html ? "<font color='#990099'>[law]</font>" : law]"
			number++
	return data
