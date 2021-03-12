/datum/round_event_control/meteor_wave/major_dust
	name = "Major Space Dust"
	typepath = /datum/round_event/meteor_wave/major_dust
	weight = 8

/datum/round_event/meteor_wave/major_dust
	wave_name = "space dust"

/datum/round_event/meteor_wave/major_dust/announce(fake)
	var/reason = pick(
		"Станция проходит через облако обломков, ожидаются незначительные повреждения \
		к внешним деталям и приспособлениям.",
		"Подразделение супероружия Нанотрасен тестирует новый прототип \
		[pick("field","projection","nova","super-colliding","reactive")] \
		[pick("cannon","artillery","tank","cruiser","\[REDACTED\]")], \
		ожидается небольшой мусор.",
		"Соседняя станция бросает в вас камни. (Возможно, они \
		устали от ваших сообщений.)")
	priority_announce(pick(reason), "Предупреждение о столкновении")
