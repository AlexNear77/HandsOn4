(defglobal ?*plan_de_accion* = (create$))

(defrule r1
    (paciente listo) 
    (paciente enQuirofano)
    (enfermera listo)
    (enfermera enQuirofano)
    (anestesiologo listo)
    (anestesiologo enQuirofano)
    (cirujanoJ listo)
    (cirujanoJ enQuirofano)
    (cirujano2 listo)
    (cirujano2 enQuirofano)
    ?fact1 <- (cirujanoJ listo)
    => 
    (printout t "Puede comenzar la intervencion CirujanoJ" crlf)
    (assert (cirujanoJ comienzaIntervencion))
    (retract ?fact1)
    (bind ?*plan_de_accion* (create$ "CirujanoJ comienza la intervencion"))
)

(defrule r2
    (cirujanoJ comienzaIntervencion)
    ?fact1 <- (anestesiologo listo)
    =>
    (printout t " Anestesiólogo confirma el cálculo del anestésico y lo aplica al Paciente" crlf)
    (assert (anestesiologo aplicandoAnestecia))
    (retract ?fact1)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Anestesiólogo aplica anestésico al Paciente"))
)

(defrule r3 
    (anestesiologo aplicandoAnestecia)
    ?fact1 <- (paciente listo)
    =>
    (printout t "CirujanoJ el paciente está sedado" crlf)
    (assert (paciente sedado))
    (retract ?fact1)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Paciente sedado"))
)

(defrule r4
    (paciente sedado)
    ?fact1 <- (cirujano2 listo)
    =>
    (printout t "Cirujano2 Comienza la intervencion" crlf)
    (assert (cirujano2 interviniendo))
    (retract ?fact1)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Cirujano2 comienza la intervencion"))
)

(defrule r5 
    (cirujano2 interviniendo)
    =>
    (printout t "Cirujano2 solicitando instrumentos para la intervencion" crlf)
    (assert (cirujano2 solicitandoInstrumentos))
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Cirujano2 solicita instrumentos"))
)

(defrule r6
    (cirujano2 interviniendo)
    (cirujano2 solicitandoInstrumentos)
    ?fact1 <- (enfermera listo)
    ?fact2 <- (cirujano2 solicitandoInstrumentos)
    =>
    (printout t "Enfermera provee material e instrumentos" crlf)
    (assert (enfermera gestionandoInstrumentos))
    (retract ?fact1)
    (retract ?fact2)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Enfermera provee material e instrumentos"))
)

(defrule r7 
    (cirujano2 interviniendo)
    (enfermera gestionandoInstrumentos)
    ?fact1 <- (cirujano2 interviniendo)
    ?fact2 <- (enfermera gestionandoInstrumentos)
    =>
    (printout t "Intervencion realizada" crlf)
    (assert (cirujano2 finalizoIntervencion))
    (assert (enfermera libre))
    (retract ?fact1)
    (retract ?fact2)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Intervencion realizada"))
)

(defrule r8
    (cirujano2 finalizoIntervencion)
    =>
    (printout t "CirujanoJ se ha realizado la intervencion" crlf)
    (assert (cirujanoJ notificado))
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "CirujanoJ notificado"))
)

(defrule r9
    (cirujanoJ notificado)
    (enfermera libre)
    ?fact1 <- (paciente enQuirofano)
    ?fact2 <- (enfermera enQuirofano)
    =>
    (printout t "Enfermera mandando al paciente a la sala de recuperacion!" crlf)
    (assert (enfermera ocupada))
    (assert (enfermera enSalaDeRecuperacion))
    (assert (paciente enSalaDeRecuperacion))
    (retract ?fact1)
    (retract ?fact2)
    (bind ?*plan_de_accion* (create$ ?*plan_de_accion* "Enfermera lleva al paciente a la sala de recuperacion"))
)

