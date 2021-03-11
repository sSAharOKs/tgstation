/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomaly: Hyper-Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux

	min_players = 10
	max_occurrences = 5
	weight = 20

/datum/round_event/anomaly/anomaly_flux
	startWhen = 10
	announceWhen = 3
	anomaly_path = /obj/effect/anomaly/flux

/datum/round_event/anomaly/anomaly_flux/announce(fake)
	priority_announce("Локализованна волна гиперэнергетического потока, обнаруженная на сканерах дальнего действия. Ожидаемое местоположение: [impact_area.name].", "Предупреждение об аномалии")
