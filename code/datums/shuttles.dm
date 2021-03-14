/datum/map_template/shuttle
	name = "Base Shuttle Template"
	var/prefix = "_maps/shuttles/"
	var/suffix
	var/port_id
	var/shuttle_id

	var/description
	var/prerequisites
	var/admin_notes
	/// How much does this shuttle cost the cargo budget to purchase? Put in terms of CARGO_CRATE_VALUE to properly scale the cost with the current balance of cargo's income.
	var/credit_cost = INFINITY
	/// Can the  be legitimately purchased by the station? Used by hardcoded or pre-mapped shuttles like the lavaland or cargo shuttle.
	var/can_be_bought = TRUE
	/// If set, overrides default movement_force on shuttle
	var/list/movement_force

	var/port_x_offset
	var/port_y_offset
	var/extra_desc = ""

/datum/map_template/shuttle/proc/prerequisites_met()
	return TRUE

/datum/map_template/shuttle/New()
	shuttle_id = "[port_id]_[suffix]"
	mappath = "[prefix][shuttle_id].dmm"
	. = ..()

/datum/map_template/shuttle/preload_size(path, cache)
	. = ..(path, TRUE) // Done this way because we still want to know if someone actualy wanted to cache the map
	if(!cached_map)
		return

	discover_port_offset()

	if(!cache)
		cached_map = null

/datum/map_template/shuttle/proc/discover_port_offset()
	var/key
	var/list/models = cached_map.grid_models
	for(key in models)
		if(findtext(models[key], "[/obj/docking_port/mobile]")) // Yay compile time checks
			break // This works by assuming there will ever only be one mobile dock in a template at most

	for(var/i in cached_map.gridSets)
		var/datum/grid_set/gset = i
		var/ycrd = gset.ycrd
		for(var/line in gset.gridLines)
			var/xcrd = gset.xcrd
			for(var/j in 1 to length(line) step cached_map.key_len)
				if(key == copytext(line, j, j + cached_map.key_len))
					port_x_offset = xcrd
					port_y_offset = ycrd
					return
				++xcrd
			--ycrd

/datum/map_template/shuttle/load(turf/T, centered, register=TRUE)
	. = ..()
	if(!.)
		return
	var/list/turfs = block( locate(.[MAP_MINX], .[MAP_MINY], .[MAP_MINZ]),
							locate(.[MAP_MAXX], .[MAP_MAXY], .[MAP_MAXZ]))
	for(var/i in 1 to turfs.len)
		var/turf/place = turfs[i]
		if(istype(place, /turf/open/space)) // This assumes all shuttles are loaded in a single spot then moved to their real destination.
			continue
		if(length(place.baseturfs) < 2) // Some snowflake shuttle shit
			continue
		var/list/sanity = place.baseturfs.Copy()
		sanity.Insert(3, /turf/baseturf_skipover/shuttle)
		place.baseturfs = baseturfs_string_list(sanity, place)

		for(var/obj/docking_port/mobile/port in place)
			if(register)
				port.register()
			if(isnull(port_x_offset))
				continue
			switch(port.dir) // Yeah this looks a little ugly but mappers had to do this in their head before
				if(NORTH)
					port.width = width
					port.height = height
					port.dwidth = port_x_offset - 1
					port.dheight = port_y_offset - 1
				if(EAST)
					port.width = height
					port.height = width
					port.dwidth = height - port_y_offset
					port.dheight = port_x_offset - 1
				if(SOUTH)
					port.width = width
					port.height = height
					port.dwidth = width - port_x_offset
					port.dheight = height - port_y_offset
				if(WEST)
					port.width = height
					port.height = width
					port.dwidth = port_y_offset - 1
					port.dheight = width - port_x_offset

//Whatever special stuff you want
/datum/map_template/shuttle/post_load(obj/docking_port/mobile/M)
	if(movement_force)
		M.movement_force = movement_force.Copy()
	M.linkup()

/datum/map_template/shuttle/emergency
	port_id = "emergency"
	name = "Base Shuttle Template (Emergency)"

/datum/map_template/shuttle/cargo
	port_id = "cargo"
	name = "Base Shuttle Template (Cargo)"
	can_be_bought = FALSE

/datum/map_template/shuttle/ferry
	port_id = "ferry"
	name = "Base Shuttle Template (Ferry)"

/datum/map_template/shuttle/whiteship
	port_id = "whiteship"

/datum/map_template/shuttle/labour
	port_id = "labour"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining
	port_id = "mining"
	can_be_bought = FALSE

/datum/map_template/shuttle/mining_common
	port_id = "mining_common"
	can_be_bought = FALSE

/datum/map_template/shuttle/arrival
	port_id = "arrival"
	can_be_bought = FALSE

/datum/map_template/shuttle/infiltrator
	port_id = "infiltrator"
	can_be_bought = FALSE

/datum/map_template/shuttle/aux_base
	port_id = "aux_base"
	can_be_bought = FALSE

/datum/map_template/shuttle/escape_pod
	port_id = "escape_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/assault_pod
	port_id = "assault_pod"
	can_be_bought = FALSE

/datum/map_template/shuttle/pirate
	port_id = "pirate"
	can_be_bought = FALSE

/datum/map_template/shuttle/hunter
	port_id = "hunter"
	can_be_bought = FALSE

/datum/map_template/shuttle/ruin //For random shuttles in ruins
	port_id = "ruin"
	can_be_bought = FALSE

/datum/map_template/shuttle/snowdin
	port_id = "snowdin"
	can_be_bought = FALSE

// Shuttles start here:
// Полностью переведённые шаттлы от SAharOK
/datum/map_template/shuttle/emergency/backup
	suffix = "backup"
	name = "Запасной шаттл"
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/construction
	suffix = "construction"
	name = "Набор 'собери свой собственный шаттл'"
	description = "Для предприимчивого инженера шаттлов! Шасси будет состыковано при покупке, но запуск должен быть разрешен, как обычно, с помощью вызова шаттла. Поставляется с запасом строительных материалов. Открывает возможность покупать ящики с двигателями шаттла в карго."
	admin_notes = "No brig, no medical facilities, no shuttle console."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/airless/post_load()
	. = ..()
	//enable buying engines from cargo
	var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/shuttle_engine]
	P.special_enabled = TRUE


/datum/map_template/shuttle/emergency/asteroid
	suffix = "asteroid"
	name = "Шаттл астеройд"
	description = "Шаттл среднего размера, который впервые увидел потребитель, перевозит экипаж к и от встроенных объектов в пояса астероидов."
	credit_cost = CARGO_CRATE_VALUE * 6

/datum/map_template/shuttle/emergency/bar
	suffix = "bar"
	name = "Аварийный бар"
	description = "Особенности: включают в себя разумный персонал бара (барный дрон и Барменша), ванную комнату, качественную гостиную для руководителей и большой стол для сбора гостей."
	admin_notes = "Bardrone and Barmaid are GODMODE, will be automatically sentienced by the fun balloon at 60 seconds before arrival. \
	Has medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 10

/datum/map_template/shuttle/emergency/pod
	suffix = "pod"
	name = "Эвакуационная капсула"
	description = "Мы не ожидали такой быстрой эвакуации. Все, что у нас есть - это две спасательные капсулы."
	admin_notes = "For player punishment."
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/russiafightpit
	suffix = "russiafightpit"
	name = "Матушка Россия Истекает кровью"
	description = "Это высококачественный шаттл, да. Много сидений, много места, все оборудование присутствует! Он даже включает в себя развлечения! Например, можно много выпить и выйти на арену, чтобы весело провести время! Если арена недостаточно веселая, просто нажмите кнопку освобождения медведей. Не волнуйтесь, медведи обучены не вырываться из бойцовой ямы, поэтому они совершенно безопасны до тех пор, пока никто не глуп или не пьян настолько, чтобы оставить дверь открытой. Постарайтесь не позволить Азимову бэби-зэку испортить удовольствие!"
	admin_notes = "Includes a small variety of weapons. And bears. Only captain-access can release the bears. Bears won't smash the windows themselves, but they can escape if someone lets them."
	credit_cost = CARGO_CRATE_VALUE * 10 // While the shuttle is rusted and poorly maintained, trained bears are costly.

/datum/map_template/shuttle/emergency/meteor
	suffix = "meteor"
	name = "Астероид с привязанными к нему двигателями"
	description = "Выдолбленный астероид с привязанными к нему двигателями, процедура выдолбления делает его очень трудным для захвата, но очень дорогим. Из-за своих размеров и сложности управления он может повредить стыковочную зону."
	admin_notes = "This shuttle will likely crush escape, killing anyone there."
	credit_cost = CARGO_CRATE_VALUE * 30
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/monastery
	suffix = "monastery"
	name = "Великий Корпоративный монастырь"
	description = "Первоначально построеный для станции, это грандиозное религиозное сооружение, но из-за сокращения бюджета, теперь он доступен в качестве спасательного челнока для правильного... пожертвования. Из-за своих больших размеров и бессердечных владельцев этот челнок может нанести побочный ущерб."
	admin_notes = "WARNING: This shuttle WILL destroy a fourth of the station, likely picking up a lot of objects with it."
	credit_cost = CARGO_CRATE_VALUE * 250
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 5)

/datum/map_template/shuttle/emergency/luxury
	suffix = "luxury"
	name = "Роскошный шаттл"
	description = "Роскошный золотой шаттл с крытым бассейном. Каждый член экипажа, желающий подняться на борт, должен принести с собой 500 кредитов, оплачиваемых наличными или картой."
	extra_desc = "This shuttle costs 500 credits to board."
	admin_notes = "Due to the limited space for non paying crew, this shuttle may cause a riot."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/medisim
	suffix = "medisim"
	name = "Купол Моделирования Средневековой Реальности"
	description = "Современный имитационный купол, загруженный на этот шаттл! Смотрите и смейтесь над тем, каким ничтожным было человечество до того, как оно достигло звезд. Гарантированная историческая точность не менее 40%."
	admin_notes = "Ghosts can spawn in and fight as knights or archers. The CTF auto restarts, so no admin intervention necessary."
	credit_cost = 20000

/datum/map_template/shuttle/emergency/medisim/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_MEDISIM]

/datum/map_template/shuttle/emergency/discoinferno
	suffix = "discoinferno"
	name = "Дискотека Инферно"
	description = "Славные результаты многовековых исследований плазмы, проведенных сотрудниками Нанотразен. Это то почему вы здесь. Давай, танцуй, как будто ты в огне, гори, детка, ГОРИ!"
	admin_notes = "Flaming hot. The main area has a dance machine as well as plasma floor tiles that will be ignited by players every single time."
	credit_cost = CARGO_CRATE_VALUE * 20
	can_be_bought = FALSE

/datum/map_template/shuttle/emergency/arena
	suffix = "arena"
	name = "Арена"
	description = "Экипаж должен пройти через потустороннюю арену, чтобы сесть на этот шаттл. Ожидайте больших потерь. Источник Кровавого Сигнала должен быть выслежен и уничтожен, чтобы разблокировать этот шаттл."
	admin_notes = "RIP AND TEAR."
	credit_cost = CARGO_CRATE_VALUE * 20
	/// Whether the arena z-level has been created
	var/arena_loaded = FALSE

/datum/map_template/shuttle/emergency/arena/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_BUBBLEGUM]

/datum/map_template/shuttle/emergency/arena/post_load(obj/docking_port/mobile/M)
	. = ..()
	if(!arena_loaded)
		arena_loaded = TRUE
		var/datum/map_template/arena/arena_template = new()
		arena_template.load_new_z()

/datum/map_template/arena
	name = "The Arena"
	mappath = "_maps/templates/the_arena.dmm"

/datum/map_template/shuttle/emergency/birdboat
	suffix = "birdboat"
	name = "Байдарка"
	description = "Она очень маленькая - это большее, что можно сказать о модели станции, для которой этот шаттл был заказан."
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/box
	suffix = "box"
	name = "Эвакуационный шаттл Box station"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "Золотой стандарт в аварийной эксфильтрации, этот испытанный и верный дизайн оснащен всем необходимым для безопасного полета домой."

/datum/map_template/shuttle/emergency/donut
	suffix = "donut"
	name = "Эвакуационный шаттл Donut station"
	description = "Идеальный наконечник для любой грубой шутки, связанной с формой станции, этот шаттл поддерживает отдельную камеру для заключенных и компактное медицинское крыло."
	admin_notes = "Has airlocks on both sides of the shuttle and will probably intersect near the front on some stations that build past departures."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/clown
	suffix = "clown"
	name = "Snap pop(tm)!"
	description = "Эй, дети и взрослые! \
	Вам надоели СКУЧНЫЕ и УТОМИТЕЛЬНЫЕ шаттлы после того, как вы эвакуируетесь по, вероятно, СКУЧНЫМ причинам. Ну тогда закажите Snap pop(tm) сегодня! \
	У нас есть веселые развлечения для всех, кокпит с полным доступом и никакого скучного брига безопасности! Бу! Играйте в одевалки со своими друзьями! \
	Соберите все простыни, прежде чем это сделает ваш сосед! Проверьте, наблюдает ли за вами ИИ с помощью нашего патента 'Детектор ИИ мистера пипина' или сокращенно PEEEEEETURBATOR. \
	Веселой вам поездки!"
	admin_notes = "Brig is replaced by anchored greentext book surrounded by lavaland chasms, stationside door has been removed to prevent accidental dropping. No brig."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/cramped
	suffix = "cramped"
	name = "Безопасное Транспортное судно 5 (БТС 5)"
	description = "Ну, похоже, что у Центкома был только этот корабль в этом районе, они, вероятно, не ожидали, что вам понадобится эвакуация в это время. \
	Вероятно, будет лучше, если вы не будете стрелять в то оборудование, которое они перевозили. Я надеюсь, что вы дружны со своими коллегами, потому что в этой штуке очень мало места.\n\
	\n\
	Содержит контрабандные оружейные пушки, награбленное техническое оборудование и брошенные ящики!"
	admin_notes = "Due to origin as a solo piloted secure vessel, has an active GPS onboard labeled STV5. Has roughly as much space as Hi Daniel, except with explosive crates."

/datum/map_template/shuttle/emergency/meta
	suffix = "meta"
	name = "Эвакуационный шаттл Meta Station"
	credit_cost = CARGO_CRATE_VALUE * 8
	description = "Довольно стандартный шаттл, хотя и больше и немного лучше оборудован, чем вариант с box station."

/datum/map_template/shuttle/emergency/kilo
	suffix = "kilo"
	name = "Эвакуационный шаттл Kilo Station"
	credit_cost = CARGO_CRATE_VALUE * 10
	description = "Полностью функциональный транспортник, включающий в себя полный лазарет, складские помещения и обычные удобства."

/datum/map_template/shuttle/emergency/mini
	suffix = "mini"
	name = "Эвакуационный шаттл Mini Station"
	credit_cost = CARGO_CRATE_VALUE * 2
	description = "Несмотря на свое название, этот шаттл на самом деле лишь немного меньше стандартного, и все еще укомплектован бригом и медотсеком."

/datum/map_template/shuttle/emergency/scrapheap
	suffix = "scrapheap"
	name = "Резервное Эвакуационное судно \"Мусорное испытание\""
	credit_cost = CARGO_CRATE_VALUE * -2
	description = "Из-за отсутствия функциональных аварийных шаттлов мы купили эту подержанную машину на свалке и ввели ее в эксплуатацию. Пожалуйста, не опирайтесь слишком сильно на наружные окна, они хрупкие."
	admin_notes = "An abomination with no functional medbay, sections missing, and some very fragile windows. Surprisingly airtight."
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/narnar
	suffix = "narnar"
	name = "Шаттл 667"
	description = "Похоже, этот шаттл мог забрести в темноту между звездами по пути к станции. Давайте не будем слишком много думать о том, откуда взялись все тела."
	admin_notes = "Contains real cult ruins, mob eyeballs, and inactive constructs. Cult mobs will automatically be sentienced by fun balloon. \
	Cloning pods in 'medbay' area are showcases and nonfunctional."
	credit_cost = 6667 ///The joke is the number so no defines

/datum/map_template/shuttle/emergency/narnar/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_NARNAR]

/datum/map_template/shuttle/emergency/pubby
	suffix = "pubby"
	name = "Эвакуационный шаттл Pubby Station"
	description = "Поезд но в космосе! В комплекте с первым, вторым классом, бригом и складским помещением."
	admin_notes = "Choo choo motherfucker!"
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/cere
	suffix = "cere"
	name = "Эвакуационный шаттл Cere Station"
	description = "Большая, усиленная версия стандартного шаттла. Включает в себя расширенный бриг, полностью укомплектованный медбей, расширенное хранилище для грузов с зарядными устройствами для мехов, \
	машинное отделение, заполненное различными припасами, может вместить более 80 человек экипажа если постараться. Живи на широкую ногу, живи Здесь."
	admin_notes = "Seriously big, even larger than the Delta shuttle."
	credit_cost = CARGO_CRATE_VALUE * 20

/datum/map_template/shuttle/emergency/supermatter
	suffix = "supermatter"
	name = "Гиперфрактальный Гига шаттл"
	description = "\"Я не знаю, он кажется каким-то излишне сложным\"\n\
	\"Этот шаттл имеет очень высокий рекорд безопасности, по словам Центком,-офицер кадет Инс.\"\n\
	\"Вы уверены?\"\n\
	\"Да, у него есть рекорд безопасности Г-О-С-Т, который, по-видимому, превышает 100%.\""
	admin_notes = "Supermatter that spawns on shuttle is special anchored 'hugbox' supermatter that cannot take damage and does not take in or emit gas. \
	Outside of admin intervention, it cannot explode. \
	It does, however, still dust anything on contact, emits high levels of radiation, and induce hallucinations in anyone looking at it without protective goggles. \
	Emitters spawn powered on, expect admin notices, they are harmless."
	credit_cost = CARGO_CRATE_VALUE * 200
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/imfedupwiththisworld
	suffix = "imfedupwiththisworld"
	name = "О, привет, Дэниел"
	description = "Как сегодня прошла космическая работа? О, довольно хорошо. Мы получили новую космическую станцию, и компания заработает много денег. Какая космическая станция? Я не могу вам сказать, это космическая тайна. \
	О, да ладно тебе. Почему нет? Нет, не могу. В любом случае, как ваша космическая ролевая жизнь?"
	admin_notes = "Tiny, with a single airlock and wooden walls. What could go wrong?"
	can_be_bought = FALSE
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)

/datum/map_template/shuttle/emergency/goon
	suffix = "goon"
	name = "ПАША НТ"
	description = "Порт аварийного шаттла а-ля Нанотразен(сокращенно ПАША) - это шаттл, используемый на других менее известных объектах Нанотразен и имеющий более открытую внутреннюю часть для больших толп, но имеет меньшее количество бортовых объектов и устройств."
	credit_cost = CARGO_CRATE_VALUE

/datum/map_template/shuttle/emergency/rollerdome
	suffix = "rollerdome"
	name = "Роллердом дяди Пита"
	description = "Разработан членом научно-исследовательской группы Нанотразен, который утверждает, что путешествовал с 2028 года. \
	Он говорит, что этот шаттл базируется на старом развлекательном комплексе 1990-х годов, хотя в нашей базе данных нет записей о чем-либо, относящемся к тому десятилетию."
	admin_notes = "ONLY NINETIES KIDS REMEMBER. Uses the fun balloon and drone from the Emergency Bar."
	credit_cost = CARGO_CRATE_VALUE * 5

/datum/map_template/shuttle/emergency/wabbajack
	suffix = "wabbajack"
	name = "NT Lepton Violet"
	description = "исследовательская группа, базирующаяся на этом судне, однажды пропала без вести, и никакое расследование не смогло выяснить, что с ними случилось. \
	Единственными обитателями были мертвые грызуны, которые, казалось, до смерти вцепились друг в друга когтями. \
	Излишне говорить, что ни одна инженерная команда не хотела приближаться к этой штуке, и она используется только как Аварийный спасательный челнок, потому что там буквально ничего другого нет."
	admin_notes = "If the crew can solve the puzzle, they will wake the wabbajack statue. It will likely not end well. There's a reason it's boarded up. Maybe they should have just left it alone."
	credit_cost = CARGO_CRATE_VALUE * 30

/datum/map_template/shuttle/emergency/omega
	suffix = "omega"
	name = "Эвакуационный шаттл Omega station"
	description = "На меньших размерах с современным дизайном, этот шаттл предназначен для экипажа, который любит уют и в то же время иметь возможность размять ноги."
	credit_cost = CARGO_CRATE_VALUE * 2

/datum/map_template/shuttle/emergency/cruise
	suffix = "cruise"
	name = "НТСС независимость"
	description = "Обычно зарезервированный для специальных мероприятий и тождеств, круизный шаттл Независимость может принести летнее настроение вашей следующей эвакуации со станции за 'скромную' плату!"
	admin_notes = "This motherfucker is BIG. You might need to force dock it."
	credit_cost = CARGO_CRATE_VALUE * 100

/datum/map_template/shuttle/emergency/monkey
	suffix = "nature"
	name = "Динамическое Взаимодействие с Окружающей Средой"
	description = "Большой шаттл с центральным биодомом, который процветает жизнью. Порезвись с обезьянами! (Дополнительные обезьяны содержаться на мостике.)"
	admin_notes = "Pretty freakin' large, almost as big as Raven or Cere. Excercise caution with it."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/ferry/base
	suffix = "base"
	name = "транспортный паром"
	description = "Стандартный паром Box/Metastation."

/datum/map_template/shuttle/ferry/meat
	suffix = "meat"
	name = "\"Мясной\" паром"
	description = "Ахой! У нас тут на корме полно всякого мяса. Мясо от людей растений, тёмных людей, не в расистском смысле, просто они темно-черные. \
О, и мясо ящерицы тоже, оно очень популярное. Определенно 100% свежее, просто спросите этого парня здесь. *человек на мясном шипе стонет* Видишь? \
Определенно высококачественное мясо, ничего 'плохого' в нем нет, ничего 'добавленного', определенно никаких зомбирующих реагентов!"
	admin_notes = "Meat currently contains no zombifying reagents, lizard on meatspike must be spawned in."

/datum/map_template/shuttle/ferry/lighthouse
	suffix = "lighthouse"
	name = "Маяк(?)"
	description = "*помехи*... часть гораздо большего судна, возможно военного происхождения. \
	Маркировка оружия-это не то, что мы видели ...помехи... почти никогда один и тот же человек дважды, неиспользовал хранилище ...помехи... \
	вижу офицеров ЕРТ на борту, но никаких заданий в досье нет ...помехи...помехи...раздражающий звон... только на МАЯКЕ! \
	Удовлетворяет все потребности, о существовании которых вы даже не подозревали. У нас есть ВСЕ, и еще кое-что!"
	admin_notes = "Currently larger than ferry docking port on Box, will not hit anything, but must be force docked. Trader and ERT bodyguards are not included."

/datum/map_template/shuttle/ferry/fancy
	suffix = "fancy"
	name = "причудливый транспортный паром"
	description = "В какой-то момент кто-то модернизировал паром, чтобы нём был более причудливый пол... и меньше мест."

/datum/map_template/shuttle/ferry/kilo
	suffix = "kilo"
	name = "Килло транспортный паром"
	description = "Стандартный выпущеный Центком паром для Килло подобных станций. Включает в себя дополнительное оборудование и зарядные устройства."

/datum/map_template/shuttle/whiteship/box
	suffix = "box"
	name = "Hospital Ship"

/datum/map_template/shuttle/whiteship/meta
	suffix = "meta"
	name = "Salvage Ship"

/datum/map_template/shuttle/whiteship/pubby
	suffix = "pubby"
	name = "NT White UFO"

/datum/map_template/shuttle/whiteship/cere
	suffix = "cere"
	name = "NT Construction Vessel"

/datum/map_template/shuttle/whiteship/kilo
	suffix = "kilo"
	name = "NT Mining Shuttle"

/datum/map_template/shuttle/whiteship/donut
	suffix = "donut"
	name = "NT Long-Distance Bluespace Jumper"

/datum/map_template/shuttle/whiteship/delta
	suffix = "delta"
	name = "NT Frigate"

/datum/map_template/shuttle/whiteship/pod
	suffix = "whiteship_pod"
	name = "Salvage Pod"

/datum/map_template/shuttle/cargo/kilo
	suffix = "kilo"
	name = "supply shuttle (Kilo)"

/datum/map_template/shuttle/cargo/birdboat
	suffix = "birdboat"
	name = "supply shuttle (Birdboat)"

/datum/map_template/shuttle/cargo/donut
	suffix = "donut"
	name = "supply shuttle (Donut)"

/datum/map_template/shuttle/cargo/pubby
	suffix = "pubby"
	name = "supply shuttle (Pubby)"

/datum/map_template/shuttle/emergency/delta
	suffix = "delta"
	name = "Аварийный шаттл Delta Station"
	description = "Большой шаттл для большой станции.. этот шаттл может с комфортом удовлетворить все ваши потребности в перенаселении и скученности. В комплекте со всеми удобствами плюс дополнительное оборудование."
	admin_notes = "Go big or go home."
	credit_cost = CARGO_CRATE_VALUE * 15

/datum/map_template/shuttle/emergency/raven
	suffix = "raven"
	name = "Центком крейсер Рейвен"
	description = "Крейсер Рейвен-это бывшее спасательное судно высокого риска, теперь перепрофилированное в аварийный спасательный челнок. \
	Оказавшись первым на месте происшествия, чтобы обыскать зоны боевых действий в поисках ценных останков, он теперь служит отличным вариантом эвакуации для станций, находящихся под сильным огнем внешних сил. \
	Этот спасательный челнок может похвастаться щитами и многочисленными противопехотными турелями, охраняющими его периметр, чтобы отразить метеориты и попытки абордажа."
	admin_notes = "Comes with turrets that will target anything without the neutral faction (nuke ops, xenos etc, but not pets)."
	credit_cost = CARGO_CRATE_VALUE * 60

/datum/map_template/shuttle/emergency/zeta
	suffix = "zeta"
	name = "Тр%нСп2р& З3Та"
	description = "На вашем мониторе появляется глюк, мелькающий между вариантами, выскакивающими перед вами. \
	Это кажется странным и чуждым, вам может понадобиться специальная технология для доступа к сигналу.."
	admin_notes = "Has alien surgery tools, and a void core that provides unlimited power."
	credit_cost = CARGO_CRATE_VALUE * 16

/datum/map_template/shuttle/emergency/zeta/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_ALIENTECH]

/datum/map_template/shuttle/arrival/box
	suffix = "box"
	name = "arrival shuttle (Box)"

/datum/map_template/shuttle/cargo/box
	suffix = "box"
	name = "cargo ferry (Box)"

/datum/map_template/shuttle/mining/box
	suffix = "box"
	name = "mining shuttle (Box)"

/datum/map_template/shuttle/labour/box
	suffix = "box"
	name = "labour shuttle (Box)"

/datum/map_template/shuttle/arrival/donut
	suffix = "donut"
	name = "arrival shuttle (Donut)"

/datum/map_template/shuttle/infiltrator/basic
	suffix = "basic"
	name = "basic syndicate infiltrator"

/datum/map_template/shuttle/infiltrator/advanced
	suffix = "advanced"
	name = "advanced syndicate infiltrator"

/datum/map_template/shuttle/cargo/delta
	suffix = "delta"
	name = "cargo ferry (Delta)"

/datum/map_template/shuttle/mining/delta
	suffix = "delta"
	name = "mining shuttle (Delta)"

/datum/map_template/shuttle/mining/kilo
	suffix = "kilo"
	name = "mining shuttle (Kilo)"

/datum/map_template/shuttle/mining/large
	suffix = "large"
	name = "mining shuttle (Large)"

/datum/map_template/shuttle/labour/delta
	suffix = "delta"
	name = "labour shuttle (Delta)"

/datum/map_template/shuttle/labour/kilo
	suffix = "kilo"
	name = "labour shuttle (Kilo)"

/datum/map_template/shuttle/mining_common/meta
	suffix = "meta"
	name = "lavaland shuttle (Meta)"

/datum/map_template/shuttle/mining_common/kilo
	suffix = "kilo"
	name = "lavaland shuttle (Kilo)"

/datum/map_template/shuttle/arrival/delta
	suffix = "delta"
	name = "arrival shuttle (Delta)"

/datum/map_template/shuttle/arrival/kilo
	suffix = "kilo"
	name = "arrival shuttle (Kilo)"

/datum/map_template/shuttle/arrival/pubby
	suffix = "pubby"
	name = "arrival shuttle (Pubby)"

/datum/map_template/shuttle/arrival/omega
	suffix = "omega"
	name = "arrival shuttle (Omega)"

/datum/map_template/shuttle/aux_base/default
	suffix = "default"
	name = "auxilliary base (Default)"

/datum/map_template/shuttle/aux_base/small
	suffix = "small"
	name = "auxilliary base (Small)"

/datum/map_template/shuttle/escape_pod/default
	suffix = "default"
	name = "escape pod (Default)"

/datum/map_template/shuttle/escape_pod/large
	suffix = "large"
	name = "escape pod (Large)"

/datum/map_template/shuttle/assault_pod/default
	suffix = "default"
	name = "assault pod (Default)"

/datum/map_template/shuttle/pirate/default
	suffix = "default"
	name = "pirate ship (Default)"

/datum/map_template/shuttle/pirate/silverscale
	suffix = "silverscale"
	name = "pirate ship (Silver Scales)"

/datum/map_template/shuttle/pirate/dutchman
	suffix = "dutchman"
	name = "pirate ship (Flying Dutchman)"

/datum/map_template/shuttle/hunter/space_cop
	suffix = "space_cop"
	name = "Police Spacevan"

/datum/map_template/shuttle/hunter/russian
	suffix = "russian"
	name = "Russian Cargo Ship"

/datum/map_template/shuttle/hunter/bounty
	suffix = "bounty"
	name = "Bounty Hunter Ship"

/datum/map_template/shuttle/ruin/caravan_victim
	suffix = "caravan_victim"
	name = "Small Freighter"

/datum/map_template/shuttle/ruin/pirate_cutter
	suffix = "pirate_cutter"
	name = "Pirate Cutter"

/datum/map_template/shuttle/ruin/syndicate_dropship
	suffix = "syndicate_dropship"
	name = "Syndicate Dropship"

/datum/map_template/shuttle/ruin/syndicate_fighter_shiv
	suffix = "syndicate_fighter_shiv"
	name = "Syndicate Fighter"

/datum/map_template/shuttle/snowdin/mining
	suffix = "mining"
	name = "Snowdin Mining Elevator"

/datum/map_template/shuttle/snowdin/excavation
	suffix = "excavation"
	name = "Snowdin Excavation Elevator"
