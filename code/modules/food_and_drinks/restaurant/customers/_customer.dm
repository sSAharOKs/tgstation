/datum/customer_data
	///Name of the robot's origin
	var/nationality = "Generic"
	///The types of food this robot likes in a assoc list of venue type | weighted list. does NOT include subtypes.
	var/list/orderable_objects = list()
	///The amount a robot pays for each food he likes in an assoc list type | payment
	var/list/order_prices = list()
	///Datum AI used for the robot. Should almost never be overwritten unless theyre subtypes of ai_controller/robot_customer
	var/datum/ai_controller/ai_controller_used = /datum/ai_controller/robot_customer
	///Patience of the AI, how long they will wait for their meal.
	var/total_patience = 600 SECONDS
	///Lines the robot says when it finds a seat
	var/list/found_seat_lines = list("Я нашел место")
	///Lines the robot says when it can't find a seat
	var/list/cant_find_seat_lines = list("Я не нашел места")
	///Lines the robot says when leaving without food
	var/list/leave_mad_lines = list("Уходя без еды")
	///Lines the robot says when leaving with food
	var/list/leave_happy_lines = list("Уходя с едой")
	///Lines the robot says when leaving waiting for food
	var/list/wait_for_food_lines = list("Я все еще жду еды")
	///Clothing sets to pick from when dressing the robot.
	var/list/clothing_sets = list("amerifat_clothes")
	///List of prefixes for our robots name
	var/list/name_prefixes
	///Prefix file to uise
	var/prefix_file = "strings/names/american_prefix.txt"
	///Base icon for the customer
	var/base_icon = "amerifat"
	///Sound to use when this robot type speaks
	var/speech_sound = 'sound/creatures/tourist/tourist_talk.ogg'

/datum/customer_data/New()
	. = ..()
	name_prefixes = world.file2list(prefix_file)

/datum/customer_data/proc/get_overlays(mob/living/simple_animal/robot_customer/customer)
	return

/datum/customer_data/american
	nationality = "Space-American"
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/burger/plain = 25, /obj/item/food/burger/cheese = 15, /obj/item/food/burger/superbite = 1, /obj/item/food/fries = 10, /obj/item/food/cheesyfries = 6, /obj/item/food/pie/applepie = 4, /obj/item/food/pie/pumpkinpie = 2, /obj/item/food/hotdog = 8, /obj/item/food/pizza/pineapple = 1, /obj/item/food/burger/baconburger = 10, /obj/item/food/pancakes = 4),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/b52 = 6, /datum/reagent/consumable/ethanol/manhattan = 3, /datum/reagent/consumable/ethanol/atomicbomb = 1, /datum/reagent/consumable/ethanol/beer = 25))


	found_seat_lines = list("Я надеюсь, что есть сиденье, которое выдержит мой вес.", "Я надеюсь, что смогу принести сюда свой пистолет.", "Надеюсь, у вас есть тройной роскошный жирный бургер.", "Мне просто здесь нравится.")
	cant_find_seat_lines = list("Я так устала стоять...", "У меня хроническая боль в спине, пожалуйста, поторопитесь и усадите меня!", "Я не собираюсь давать чаевые, если не сяду.")
	leave_mad_lines = list("НИКАКИХ СОВЕТОВ ДЛЯ ВАС. ПРОЩАЙ!", "По крайней мере, в SpaceDonalds еду подают БЫСТРО!", "Это ужасное место!", "Я поговорю с вашим менеджером!", "Я обязательно оставлю плохой отзыв о Yelp.")
	leave_happy_lines = list("Дополнительный совет для тебя, мой друг.", "Спасибо за отличную еду!", "Диабет - это все равно миф!")
	wait_for_food_lines = list("Послушай, дружище, я очень нетерпеливый!", "Я жду целую вечность...")


/datum/customer_data/italian
	nationality = "Space-Italian"
	prefix_file = "strings/names/italian_prefix.txt"
	base_icon = "italian"
	clothing_sets = list("italian_pison", "italian_godfather")

	found_seat_lines = list("Какое чудесное место, чтобы посидеть.", "Я надеюсь, что здесь обслуживают так же, как моя мама.")
	cant_find_seat_lines = list("Mamma mia! Я просто хочу сесть!!", "Почему ты заставляешь меня стоять здесь?")
	leave_mad_lines = list("Я не видел такого неуважения за долгие годы!", "Какое-ужасное заведение!")
	leave_happy_lines = list("Это любовь!", "Так же, как это делала мама!")
	wait_for_food_lines = list("Я так голоден...")
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/spaghetti/pastatomato = 20, /obj/item/food/spaghetti/copypasta = 6, /obj/item/food/spaghetti/meatballspaghetti = 4, /obj/item/food/pizza/vegetable = 2, /obj/item/food/pizza/mushroom = 2, /obj/item/food/pizza/meat = 2, /obj/item/food/pizza/margherita = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/fanciulli = 5, /datum/reagent/consumable/ethanol/branca_menta = 3, /datum/reagent/consumable/ethanol/beer = 10, /datum/reagent/consumable/lemonade = 8, /datum/reagent/consumable/ethanol/godfather = 5))


/datum/customer_data/french
	nationality = "Space-French"
	prefix_file = "strings/names/french_prefix.txt"
	base_icon = "french"
	clothing_sets = list("french_fit")
	found_seat_lines = list("Хон Хон Хон", "Это не Эйфелева башня, но подойдет.", "Фух, думаю, с меня хватит.")
	cant_find_seat_lines = list("Заставить кого-то вроде меня стоять? Как ты смеешь.", "Какое грязное помещение!")
	leave_mad_lines = list("Sacre bleu!", "Merde! Это место хреново, чем Рейн!")
	leave_happy_lines = list("Хон Хон Хон.", "Хорошее усилие.")
	wait_for_food_lines = list("Хон Хон Хон")
	speech_sound = 'sound/creatures/tourist/tourist_talk_french.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/baguette = 20, /obj/item/food/garlicbread = 5, /obj/item/food/soup/onion = 4, /obj/item/food/pie/berryclafoutis = 2, /obj/item/food/omelette = 15),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/champagne = 15, /datum/reagent/consumable/ethanol/mojito = 5, /datum/reagent/consumable/ethanol/sidecar = 5, /datum/reagent/consumable/ethanol/between_the_sheets = 4, /datum/reagent/consumable/ethanol/beer = 10))

/datum/customer_data/french/get_overlays(mob/living/simple_animal/robot_customer/customer)
	if(customer.ai_controller.blackboard[BB_CUSTOMER_LEAVING])
		var/mutable_appearance/flag = mutable_appearance(customer.icon, "french_flag")
		flag.appearance_flags = RESET_COLOR
		return flag



/datum/customer_data/japanese
	nationality = "Space-Japanese"
	prefix_file = "strings/names/japanese_prefix.txt"
	base_icon = "japanese"
	clothing_sets = list("japanese_animes")

	found_seat_lines = list("Konnichiwa!", "Arigato gozaimasuuu~", "Надеюсь, у вас есть бефстроганов...")
	cant_find_seat_lines = list("Я уже хочу посидеть под вишневым деревом, сэмпай!", "Дайте мне место, пока моя Цундере не превратилась в Яндере!", "В этом месте меньше сидячих мест, чем в капсульном отеле!", "Негде сесть? Этот Шокунин такой холодный...")
	leave_mad_lines = list("Не могу поверить, что ты это сделал! ВАААААААААААААХ!!", "Не то чтобы я когда-либо хотел твою еду! Б-бака...", "Я собирался дать вам мой совет!")
	leave_happy_lines = list("О ПОСТАВЩИК ПИТАНИЯ! Это самый счастливый день в моей жизни. Я тебя люблю!", "Я беру чипсы .... И СЪЕМ ИХ!", "Itadakimasuuu~", "Спасибо за еду!")
	wait_for_food_lines = list("Еды еще нет? Думаю, тут ничего не поделаешь.", "Я не могу дождаться встречи с вами, burger-sama...", "Где мой заказ, скупердяй!")
	speech_sound = 'sound/creatures/tourist/tourist_talk_japanese1.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/tofu = 5, /obj/item/food/breadslice/plain = 5, /obj/item/food/soup/milo = 10, /obj/item/food/soup/vegetable = 4, /obj/item/food/sashimi = 4, /obj/item/food/chawanmushi = 4, /obj/item/food/muffin/berry = 2, /obj/item/food/beef_stroganoff = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/sake = 8, /datum/reagent/consumable/cafe_latte = 6, /datum/reagent/consumable/ethanol/aloe = 6, /datum/reagent/consumable/chocolatepudding = 4, /datum/reagent/consumable/tea = 4, /datum/reagent/consumable/cherryshake = 1, /datum/reagent/consumable/ethanol/bastion_bourbon = 1))

/datum/customer_data/japanese/get_overlays(mob/living/simple_animal/robot_customer/customer)
	//leaving and eaten
	if(type == /datum/customer_data/japanese && customer.ai_controller.blackboard[BB_CUSTOMER_LEAVING] && customer.ai_controller.blackboard[BB_CUSTOMER_EATING])
		var/mutable_appearance/you_won_my_heart = mutable_appearance('icons/effects/effects.dmi', "love_hearts")
		you_won_my_heart.appearance_flags = RESET_COLOR
		return you_won_my_heart

/datum/customer_data/japanese/salaryman
	clothing_sets = list("japanese_salary")

	found_seat_lines = list("Интересно, нападают ли здесь гигантские монстры?...", "Hajimemashite.", "Konbanwa.", "Где конвейерная лента...")
	cant_find_seat_lines = list("Пожалуйста, присаживайтесь. Я просто хочу сесть.", "Я здесь по расписанию. Где мое место?", "...Теперь я понимаю, почему это место не популярно. Они даже не усадят тебя.")
	leave_mad_lines = list("Это место просто ужасно, и я скажу это своим коллегам.", "Что за трата моего времени.", "Надеюсь, вы не гордитесь своей работой.")
	leave_happy_lines = list("Спасибо за гостеприимство.", "Otsukaresama deshita.", "Деловые звонки.")
	wait_for_food_lines = list("Zzzzzzzzzz...", "Dame da ne~", "Dame yo dame na no yo~")
	speech_sound = 'sound/creatures/tourist/tourist_talk_japanese2.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/tofu = 5, /obj/item/food/soup/milo = 6, /obj/item/food/soup/vegetable = 4, /obj/item/food/sashimi = 4, /obj/item/food/chawanmushi = 4, /obj/item/food/meatbun = 4, /obj/item/food/beef_stroganoff = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/beer = 14, /datum/reagent/consumable/ethanol/sake = 9, /datum/reagent/consumable/cafe_latte = 3, /datum/reagent/consumable/coffee = 3, /datum/reagent/consumable/soy_latte = 3, /datum/reagent/consumable/ethanol/atomicbomb = 1))

/datum/customer_data/mexican
	nationality = "Space-Mexican"
	base_icon = "mexican"
	prefix_file = "strings/names/mexican_prefix.txt"
	speech_sound = 'sound/creatures/tourist/tourist_talk_mexican.ogg'
	clothing_sets = list("mexican_poncho")
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/taco/plain = 25, /obj/item/food/taco = 15 , /obj/item/food/burrito = 15, /obj/item/food/fuegoburrito = 1, /obj/item/food/cheesyburrito = 4, /obj/item/food/nachos = 10, /obj/item/food/cheesynachos = 6, /obj/item/food/pie/dulcedebatata = 2, /obj/item/food/cubannachos = 3, /obj/item/food/stuffedlegion = 1),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/whiskey = 6, /datum/reagent/consumable/ethanol/tequila = 20, /datum/reagent/consumable/ethanol/tequila_sunrise = 1, /datum/reagent/consumable/ethanol/beer = 15, /datum/reagent/consumable/ethanol/patron = 5, /datum/reagent/consumable/ethanol/brave_bull = 5, /datum/reagent/consumable/ethanol/margarita = 8))


	found_seat_lines = list("¿Como te va, space station 13?", "Кто готов к вечеринке!", "Ah, muchas gracias.", "Ааа, пахнет кулинарией mi abuela!")
	cant_find_seat_lines = list("¿En Serio? Серьезно, мест нет?", "Andele! Я хочу стол, чтобы смотреть футбольный матч!", "Ay Caramba...")
	leave_mad_lines = list("Aye dios mio, Я ухожу отсюда", "Esto es ridículo! Я ухожу", "Я видел, как готовят лучше в тако кампана!", "Я думал, это ресторан, pero es porquería!")
	leave_happy_lines = list("Amigo, era delicio. Спасибо!", "Yo tuve el mono, а твой друг? Вы попали в точку.", "Как раз нужное количество острого!")
	wait_for_food_lines = list("Эй, эй, эй, что так долго?...", "Ты уже закончил, амиго?")
