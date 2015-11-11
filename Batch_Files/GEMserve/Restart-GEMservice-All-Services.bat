net stop "GEM Commander" && net start "GEM Commander"

ping 127.0.0.1 -n 3

net stop "HL7 Processor 4" && net stop "Corepoint Integration Engine" && net stop "Corepoint Integration Engine
Assured Availability" && net stop "Message Queuing"

ping 127.0.0.1 -n 3

net start "Message Queuing" && net start "Corepoint Integration Engine Assured Availability" && net start
"Corepoint Integration Engine" && net start "HL7 Processor 4"