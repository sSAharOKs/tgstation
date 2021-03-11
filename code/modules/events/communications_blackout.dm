/datum/round_event_control/communications_blackout
	name = "Communications Blackout"
	typepath = /datum/round_event/communications_blackout
	weight = 30

/datum/round_event/communications_blackout
	announceWhen = 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick( "Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с вашим*%ин 00)`5 ер-BZzZT", \
						"Обнаружены ионосферные аномалии. Временный телекоммуникационный сбой*3Пжз;b4;'1v-BzZZT", \
						"Обнаружены ионосферные аномалии. Временные телек#МУн46:5.;@63-BZZZZT", \
						"Ионосферные аномалии обна'зу\\ен5_0-BZZZZZT", \
						"Ионосферн:%$ аОвЗ^j<.3-BZZZZZZT", \
						"#4Ио%;с4ть,>£%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in GLOB.ai_list) //AIs are always aware of communication blackouts.
		to_chat(A, "<br><span class='warning'><b>[alert]</b></span><br>")

	if(prob(30) || fake) //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert)


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		T.emp_act(EMP_HEAVY)
