;*****************************************************************************
;* NAME:             sinal.asm
;*-----------------------------------------------------------------------------
;* AUTOR:            GESIEL ANTÔNIO MARTIS
;* ESPECIALIZAÇÃO:   TÉCNICO EM ELETRÔNICA       
;* DATA:             05/05/2003
;*-----------------------------------------------------------------------------
;* ANOTAÇÕES:      SISTEMA AUTOMÁTICO DE TOQUE DO SINAL ESCOLAR
;*                   - DOAÇÃO DE GESIEL ANTÔNIO MARTINS PARA A ESCOLA BÁSICA 
;*                   MUNICIPAL ABILIO CESAR BORGES
;******************************************************************************

;******* Declaração de equ's ***************

	Hora1     equ 30h;07:40(inicio horário matutino)
	Min1      equ 31h
	Hora2     equ 32h;08:25
	Min2      equ 33h
	Hora3     equ 34h;09:10 
	Min3      equ 35h 
	Hora4     equ 36h;09:55(recreio) 
	Min4      equ 37h
	Hora5     equ 38h;10:05
	Min5      equ 39h  
	Hora6     equ 3Ah;10:55 
	Min6      equ 3Bh
	Hora7     equ 3Ch;11:40
	Min7      equ 3Dh
	Hora8     equ 3Eh;00:00(via programação)
	Min8      equ 3Fh
	Hora9     equ 40h;13:00(inicio horário vespertino)
	Min9      equ 41h
	Hora10    equ 42h;13:45 
	Min10     equ 43h
	Hora11    equ 44h;14:30 
	Min11     equ 45h
	Hora12    equ 46h;15:15(recreio) 
	Min12     equ 47h
	Hora13    equ 48h;15:25
	Min13     equ 49h
	Hora14    equ 4Ah;16:15
	Min14     equ 4Bh
	Hora15    equ 4Ch;17:00
	Min15     equ 4Dh
	Hora16    equ 4Eh;00:00(via programação) 
	Min16     equ 4Fh
	Hora17    equ 50h;19:00(inicio horário noturno)
	Min17     equ 51h
	Hora18    equ 52h;19:40 
	Min18     equ 53h 
	Hora19    equ 54h;20:20 
	Min19     equ 55h
	Hora20    equ 56h;21:00(recreio)
	Min20     equ 57h
	Hora21    equ 58h;21:10 
	Min21     equ 59h
	Hora22    equ 5Ah;21:50
	Min22     equ 5Bh
	Hora23    equ 5Ch;22:30 
	Min23     equ 5Dh
	Hora24    equ 5Eh;00:00(via programação)  
	Min24     equ 5Fh
     	;registradores
	HrSeg1      equ 60h ;Programando o Horario nos dias da semana, escolhe qual será usado entre vários
	HrSeg2      equ 61h
	HrSeg3      equ 62h
	HrTer1      equ 63h
	HrTer2      equ 64h
	HrTer3      equ 65h
	HrQua1      equ 66h
	HrQua2      equ 67h
	HrQua3      equ 68h
	HrQui1      equ 69h
	HrQui2      equ 6AH
	HrQui3      equ 6BH
	HrSex1      equ 6CH
	HrSex2      equ 6DH
	HrSex3      equ 6Eh
	x20	    equ r0	;20 vezes para dar um segundo
	SegAtual    equ r7
	MinAtual    equ r2
	HoraAtual   equ r3
	DiaAtual    equ r4
	ParametroAtual equ r5	;indica o Parametro Atual
	ValorLR     equ r6	;indica qual display está piscando
	;           equ r1 está sendo usado no toca sirene
	HoraAtualizada equ 6fh	;valor da Hora modificada na programação
	MinAtualizado  equ 70h 	;valor do Minuto modificado na programação
	g71	       equ 71h  ;está sendo usado no toca sirene
	g72	       equ 72h  ;está sendo usado 
	g73	       equ 73h  ;está sendo usado incrementa e p00
	g74	       equ 74h  ;está sendo usado perde tempo
	g75	       equ 75h  ;está sendo usado perde tempo
	g76	       equ 76h  ;está sendo usado tocasirene0000000
	g77	       equ 77h  ;está sendo usado 
	g78	       equ 78h  ;está sendo usado {após 15 min zera o parametro 18}
;******* Declaração de bit's **********************************************************

	BtProg   bit p1.4  ;Entra no modo de programação e confirma as mudanças 
        BtEsc    bit p1.3  ;sai do modo de programação
	BtUp     bit p1.0  ;incrementa
	BtDown   bit p1.1  ;decrementa
	BtLR     bit p1.2  ;(Botao para selecionar a hora ou o minuto)
	LedNor   bit p3.4  ;Modo Normal fica ligado 	
	LedProg  bit p3.3  ;Modo de programação fica piscando 
	LedHab   bit p3.2  ;Indica se estána hora de bater o sinal
	Bip      bit p3.0  ;gera som quando um botão é clicado 
	sirene   bit p3.1  ;Liga relé 
	LedSeg   bit p3.5  ;(pisca conforme os segundos)
	HabLt1   bit p2.0  ;(Habilita Latch 1)
	HabLt2   bit p2.1  ;(Habilita Latch 2)
	HabD1    bit p2.3  ;(Habilita display 1)
	HabD2    bit p2.2  ;(Habilita display 2)
	HabD3    bit p2.5  ;(Habilita display 3)
	HabD4    bit p2.4  ;(Habilita display 4)
	BitHab	 bit 00h   ;bit de proteção
	SirHab	 bit 05h   ;habilita sirene
	AtuaDis  bit 01h   ;Atualiza a cada minuto(atualiza em zero)
	flag1	 bit 02h   ;está sendo usado 
	flag2	 bit 03h   ;está sendo usado 
;******* Inicio do programa **************************************************************
	ORG 00h
	LJMP Iniciando
	;ORG 0003h ;Endereço da interrupção /INT0
	;nop
	;reti
	ORG 000Bh ;Endereço da interrupção Timer_0
	clr tr0
	mov th0,#high(65535-49991)
	mov tl0,#low(65535-49991)
	nop
	setb tr0
	ljmp Tempo
	;ORG 0013h ;Endereço da interrupção /INT1
	;reti
	;ORG 001Bh ;Endereço da interrupção Timer_1
	;reti
	;ORG 0023h ;Endereço da interrupção SERIAL
	;reti
	ORG 30h
Iniciando:
	mov p3,#00h
	mov tmod,#00000001b 	;configuração do TIMER_1 e TIMER_0 --> | GATE | C/T | M1 | M0 |
	mov ie,#10000010b 	;Abilita interrupção do TIMER_0
	mov HoraAtual,#00d	;zera a hora atual
	mov MinAtual,#00d	;zera o minuto atual
	mov SegAtual,#00d	;zera o segundo atual
	mov DiaAtual,#02d	;zera dia atual
	mov r0,#20d  			;carrega r0 com 20
	clr tf0				;carrega  o TIMER_0 pela primeira vez 
	mov th0,#high(65535-49997)	;e depois ele faz isso 
	mov tl0,#low(65535-49997)	;automaticamente
	setb tr0			;liga TIMER_0
	setb LedNor 		;seta led que indica modo normal			
	clr LedProg 		;apaga led que indica modo de programação
	lcall TurnoAtual	;carrega os turnos
	lcall MudaHorario
	mov valorlr,#00d	;começa desabilitado {sequencia que faz fiscar os displays}
	setb BitHab		;a proteção começa habilitada
	setb SirHab		;Habilita sirene
	mov 76h,#00d
	clr flag2
	mov 78h,#00h
INICIO:	mov MinAtualizado,MinAtual
	Mov HoraAtualizada,HoraAtual
	lcall AtualizaDisplay
;****************** Clicando no botão prog ***********************************************
	jb   BtProg,inicio  	;if botão prog não for pressionado pula para inicio
	mov  b,#03h		;faz esperar 3 segundos 
	mov  a,segAtual		;com o botão (BtProg) ligado para 
	add  a,b		;entrar no modo de programação
	mov  b,a
J1:	mov  a,b
	subb a,segAtual		;usado em função da proxima instrução
	cjne a,#0h,J2		;compara se já passou os 3s / se nao for igual a 3s ele pula para J2
	jnb  BtProg,$ 		;espera que o botão seja solto
	lcall perdetempo
	acall modoprog
J2:	jnb  BtProg,J1		;se esta pressionando pula para J1
	jb   BtProg,inicio	;volta para inicio se o botão for solto antes de 3s
;********** Modo de programação ********************************************************************
ModoProg:
	mov  ParametroAtual,#00h ;começa no parametro 00h (HoraAtual)
	lcall mostraparametro
	clr LedNor		;apaga led que indica posição normal
	setb ledseg		;apaga ledseg (lógica inversa)
	setb ledprog
;{-------entra no parametro escolhido----------------------}
J42:	jb BtProg,J3	;entra no parametro escolhido
	jnb BtProg,$
	lcall perdetempo
	ajmp analizaparametros
volta:	mov 72h,#01d
	mov a,parametroatual
J10:	cjne a,72h,J8
	mov a,#5Fh
	mov b,72h
	add a,b
	mov r1,a
	mov horaAtualizada,@r1
	lcall mostradados
	ajmp J9
J8:	inc 72h	
	ajmp J10
	;-----------------------
J9:	jb BtProg,J11
	jnb BtProg,$
	lcall perdetempo
	jb bithab,J99
	mov @r1,HoraAtualizada
J99:	lcall mudahorario	
J102:	lcall mostraparametro
	ajmp J3
	;-----------------------
J11:	jb BtUp,J12	;incrementa valor do display  selecionado
	jnb BtUp,$
	lcall perdetempo
	inc horaatualizada
	mov a,HoraAtualizada
        cjne a,#03d,J13
	mov horaatualizada,#01d
J13:	lcall mostraDados
	;-----------------------
J12:	jb BtDown,J15	;decrementa valor do display selecionado
	jnb BtDown,$
	lcall perdetempo
	mov a,horaAtualizada
	cjne a,#01h,J14
	mov horaatualizada,#03d
J14:	dec horaatualizada 
	lcall mostraDados
	;-----------------------
J15:	jb BtEsc,J9	;sai do modo de programaçõa
	jnb BtEsc,$
	lcall perdetempo
	lcall MostraParametro
;{-------incrementa parametro atual------------------------}
J3:	jb BtUp,J4	
	jnb BtUp,$
	lcall perdetempo
	inc parametroAtual
	cjne parametroatual,#19d,J7
	mov parametroatual,#00h
J7:	lcall mostraparametro
;{---------decrementa parametro atual----------------------}
J4:	jb BtDown,J5
	jnb BtDown,$
	lcall perdetempo
	cjne parametroatual,#0h,J6
	mov parametroatual,#19d
J6:	dec parametroatual	
	lcall mostraparametro
;{------sai do modo de programação--------------------------}
J5:	jb BtEsc,J16
	setb LedNor 		;indica modo normal			
	clr LedProg 
	lcall atualizadisplay
	ljmp inicio
J16:	ajmp J42
;-----------------------------------------------------------
analizaparametros:
	cjne parametroatual,#00d,J21
	lcall P00
	ajmp J102
J21:	cjne parametroatual,#16d,J70
	lcall P16
	ajmp J102
J70:	cjne parametroatual,#17d,J71
	lcall P17
	ajmp J102
J71:	cjne parametroatual,#18d,J72
	lcall P18
	ajmp J102
J72:	ajmp volta
;************************************************************************************************
;{subrotina}
MostraParametro:
	mov p2,#00110000b	
	mov a,ParametroAtual ;mostra a hora no display 3 e 4
	mov b,#10d
	div ab
	swap a
	orl a,b
	mov p0,a
	setb p2.1
	clr  p2.1
	ret
;*********** Mostra Hora no Display *******************************************************
;{subrotina}
AtualizaDisplay: ;mostra hora se o usuario nao estiver na programaçao
	mov p2,#00111100b  ;os latch's não aceitam dados do uC e os decodificadores recebem os dados atuais dos latch's
	mov a,HoraAtualizada    	;algoritimo para mostrar a hora no display 3 e 4
	mov b,#10d		;
	div ab			;
	swap a			;
	orl a,b			;
	mov p0,a		;
	setb p2.1	;essas duas instruções geram um pulso no p2.1 para 
	clr  p2.1	;que o latch receba a hora no display
	mov a,MinAtualizado 		;mostra o Minuto no display 1 e 2
	mov b,#10d
	div ab
	swap a
	orl a,b
	mov p0,a
	setb p2.0
	clr  p2.0
	ret
;************************************************************************************************
;{subrotina} Mostra os dados dos parametros 01 à 15 nos dois primeiros display's
MostraDados:
	mov p2,#00001100b	
	mov a,HoraAtualizada ;mostra a hora no display 3 e 4
	mov b,#10d
	div ab
	swap a
	orl a,b
	mov p0,a
	setb p2.0
	clr  p2.0
	ret
;************** incrementa ***********************************************************
Incrementa:
	mov b,#10d
	div ab
	inc b
	mov 73h,b
	mov b,#10d
	mul ab
	add a,73h
	ret
;*********** perde tempo *************************************************************
PerdeTempo:	;44 45
	mov 74h,#0FFh	;#255d
J44:	mov 75h,#013h
	djnz 75h,$
	djnz 74h,J44
	ret
;****** Parametro 00h *****************************************************************
;{subrotina}Hora Atual
P00:	mov valorlr,#01d		;permite que o primeiro display fique piscando
	mov HoraAtualizada,HoraAtual	;mov a HoraAtual para HoraAtualizada
	mov MinAtualizado,MinAtual	;mov o MinAtual para MinAtualizado
	lcall AtualizaDisplay		;coloca a hora no display
	clr ledseg			;faz o led que indica os segundos ficar ligado (lógica inversa)
;{----------------------------------------------------------}
J29:	jb BtProg,J22	;confirma as mudanças de parametro da hora
	jnb BtProg,$
	lcall perdetempo
	jb bithab,J100
	mov HoraAtual,HoraAtualizada
	mov MinAtual,MinAtualizado
	mov segatual,#00d
	mov 76h,#00d
J100:	ljmp J30
;{----------------------------------------------------------}	
J22:	jb BtUp,J23	;incrementa valor do display  selecionado
	jnb BtUp,$	;espera tirar o dedo do botão
	lcall perdetempo
;-----------algoritimo para incrementar o digito do display 01---------------------
	cjne valorlr,#01d,J31 
	mov a,MinAtualizado
	mov b,#10d
	div ab
	mov 73h,a
	mov a,b
	inc a
	cjne a,#10d,J32		;zera o digito se passar de 9
	mov a,#00d
J32:	mov b,a 
	mov a,73h
	lcall atualizaMin
	ajmp J31
J23: 	ajmp J24
;---------------algoritimo para incrementar o digito do display 02-----------------------
J31:	cjne valorlr,#02d,J33 
	mov a,MinAtualizado
	mov b,#10d
	div ab
	inc a
	cjne a,#06,J34	;zera o digito se for maior que 5
	mov a,#00d
J34:	lcall atualizaMin
;--------algoritimo para incrementar o digito do display 03-------------------------
J33:	cjne valorlr,#03d,J35 
	mov a,HoraAtualizada
	mov b,#10d
	div ab
	mov 73h,a
	cjne a,#02d,J36		;compara se são mais que 20 horas 
	mov a,b			;caso seja verdadeiro 
	inc a
	cjne a,#04d,J37		;o digito pode ter somente os seguintes valores {0,1,2,3,4=0}
	mov a,#00d
	ajmp J37	
J36:	mov a,b
	inc a 
	cjne a,#10d,J37;zera o digito se passar de 9
	mov a,#00d 
J37:	mov b,a
	mov a,73h
	lcall atualizahora
;------algoritimo para incrementar o digito do display 04--------------------
J35:	cjne valorlr,#04d,J24 
	mov a,HoraAtualizada
	mov b,#10d
	div ab
	inc a
	cjne a,#03d,J38
	mov a,#00d	
J38:	cjne a,#02d,J39 ; algoritimo: faz com que a hora não seja maior que 24h
	mov 73h,a
	mov a,b
	mov b,#04d
J41:	cjne a,b,J40
	mov b,#00d
	mov a,73h
	ajmp J39
J40:	inc b
	mov r1,b
	cjne r1,#10d,J41
	mov b,a
	mov a,73h
J39:	lcall atualizahora
;{---------------------------------------------------------------------------}
J24:	jb BtDown,J25	;decrementa valor do display selecionado
	jnb BtDown,$
	lcall perdetempo
;---------algoritimo para decrementar o digito do display 01---------------------
	cjne valorlr,#01d,J46
	mov a,MinAtualizado
	mov b ,#10d
	div ab
	mov 73h,a
	mov a,b
	cjne a,#00d,J47	;se decrementar o zero, ele passa para 9
	mov a,#10d
J47:	dec a
	mov b,a 
	mov a,73h
	lcall atualizaMin
	ajmp J46
J25:	ljmp J26
;----------algoritimo para decrementar o digito do display 02-------------------
J46:	cjne valorlr,#02d,J48 
	mov a,MinAtualizado
	mov b,#10d
	div ab
	cjne a,#00d,J49  	;se decrementar o zero, ele passa para 5
	mov a,#06d
J49:	dec a
	lcall atualizaMin
;------------algoritimo para decrementar o digito do display 03--------------------
J48:	cjne valorlr,#03d,J50 
	mov a,HoraAtualizada
	mov b,#10d
	div ab
	mov 73h,a		;armazena o dado em um flag
	cjne a,#02d,J51		;compara se são mais que 20 horas 
	mov a,b		
	cjne a,#00d,J51		;se decrementar o zero, ele passa para 3
	mov b,#04d
	ajmp J200
J51:	mov a,b
	cjne a,#00d,J201
	mov b,#10d
J201:	mov a,73h
J200:	dec b
	lcall atualizahora
;---------algoritimo para decrementar o digito do display 04------------------
J50:	cjne valorlr,#04d,J26 
	mov a,HoraAtualizada
	mov b,#10d
	div ab
	cjne a,#00d,J52
	mov a,#03d
J52:	dec a
	mov 73h,a
	cjne a,#02d,J53		; algoritimo: faz com que a hora não seja maior que 24h
	mov a,b 
	mov b,#04d
J55:	cjne a,b,J54 
	mov b,#00d
	mov a,73h
	ajmp J53
J54:	inc b
	mov r1,b
	cjne r1,#10d,J55
	mov b,a
	mov a,73h
J53:	lcall atualizahora
;{-----------------------------------------------------}
J26:	jb Btlr,J27	;rotaciona para direita
	jnb Btlr,$
	lcall perdetempo
	inc valorlr
	cjne valorlr,#05d,J27
	mov valorlr,#01d
;{-----------------------------------------------------}
J27:	jb BtEsc,J28	;sai do modo de programaçõa
	jnb BtEsc,$
	lcall perdetempo
J30:	mov valorlr,#00h
	setb ledseg
	lcall mostraparametro
	ret
J28:	ljmp J29
;**********************************************************************************************
AtualizaHora:
	mov 73h,b ;mov os dados do registrador B
	mov b,#10d
	mul ab
	add a,73h
	mov HoraAtualizada,a
	lcall atualizadisplay
	ret
;**********************************************************************************************
AtualizaMin:
	mov 73h,b ;mov os dados do registrador B
	mov b,#10d
	mul ab
	add a,73h
	mov MinAtualizado,a
	lcall atualizadisplay
	ret
;**********************************************************************************************
P16: ;{dia da semana}
	mov horaatualizada,diaatual
	lcall mostradados
J93:	jb BtProg,J73	;confirma as mudanças de parametro da hora
	jnb BtProg,$
	lcall perdetempo
	jb bithab,J101
	mov diaatual,horaatualizada
J101:	ajmp J76
J73:	jb BtUp,J74	;incrementa valor do display  selecionado
	jnb BtUp,$	;espera tirar o dedo do botão
	lcall perdetempo
	inc horaatualizada
	mov a,horaatualizada
	cjne a,#08d,J86
	mov horaatualizada,#01d
J86:	lcall mostradados
J74:	jb BtDown,J75	;decrementa valor do display selecionado
	jnb BtDown,$
	lcall perdetempo
	mov a,horaatualizada
	cjne a,#01d,J85
	mov horaatualizada,#08d
J85:	dec horaatualizada
	lcall mostradados
J75:	jb BtEsc,J93	;sai do modo de programaçõa
	jnb BtEsc,$
	lcall perdetempo
J76:	lcall mostraparametro
	ret
;**********************************************************************************************
P17: ;{Bit de programação}
	mov horaatualizada,#01d
	jb bithab,J88
	mov horaatualizada,#00d
J88:	lcall mostradados
J92:	jb BtProg,J77	;confirma as mudanças de parametro da hora
	jnb BtProg,$
	lcall perdetempo
	setb BitHab
	mov a,horaatualizada
	cjne a,#00d,J91
	clr bithab
	mov 78h,#15d
J91:	ajmp J80
J77:	jb BtUp,J78	;incrementa valor do display  selecionado
	jnb BtUp,$	;espera tirar o dedo do botão
	lcall perdetempo
	inc horaatualizada
	mov a,horaatualizada
	cjne a,#02d,J89
	mov horaatualizada,#00d
J89:	lcall mostradados
J78:	jb BtDown,J79	;decrementa valor do display selecionado
	jnb BtDown,$
	lcall perdetempo
	mov a,horaatualizada
	cjne a,#00d,J90
	mov horaatualizada,#02d
J90:	dec horaatualizada
	lcall mostradados
J79:	jb BtEsc,J92	;sai do modo de programaçõa
	jnb BtEsc,$
	lcall perdetempo
J80:	lcall mostraparametro
	ret
;**********************************************************************************************
P18: ;{Habilita sirene}
	mov horaatualizada,#01d
	jb sirhab,J95
	mov horaatualizada,#00d
J95:	lcall mostradados
J94:	jb BtProg,J81	;confirma as mudanças de parametro da hora
	jnb BtProg,$
	lcall perdetempo
	jb bithab,J96
	setb SirHab
	mov a,horaatualizada
	cjne a,#00d,J96
	clr Sirhab
J96:	ajmp J84
J81:	jb BtUp,J82	;incrementa valor do display  selecionado
	jnb BtUp,$	;espera tirar o dedo do botão
	lcall perdetempo
	inc horaatualizada
	mov a,horaatualizada
	cjne a,#02d,J97
	mov horaatualizada,#00d
J97:	lcall mostradados
J82:	jb BtDown,J83	;decrementa valor do display selecionado
	jnb BtDown,$
	lcall perdetempo
	mov a,horaatualizada
	cjne a,#00d,J98
	mov horaatualizada,#02d
J98:	dec horaatualizada
	lcall mostradados
J83:	jb BtEsc,J94	;sai do modo de programaçõa
	jnb BtEsc,$
	lcall perdetempo
J84:	lcall mostraparametro
	ret
;**********************************************************************************************
MudaHorario:
	cjne DiaAtual,#02d,J113		;compara se é segunda
	mov a,HrSeg1
	cjne a,#01d,J114		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino1
J114:	cjne a,#02d,J115		;compara se foi escolhido o horário 2 do periodo matutino
	lcall matutino2
J115:	mov a,HrSeg2
	cjne a,#01d,J116		;compara se foi escolhido o horário 1 do periodo vespertino
	lcall vespertino1
J116:	cjne a,#02d,J117		;compara se foi escolhido o horário 2 do periodo vespertino
	lcall vespertino2
J117:	mov a,HrSeg3
	cjne a,#01d,J118		;compara se foi escolhido o horário 1 do periodo noturno
	lcall noturno1
J118:	cjne a,#02d,J113		;compara se foi escolhido o horário 2 do periodo noturno
	lcall noturno1
J113:	cjne DiaAtual,#03d,J119		;compara se é terça
	mov a,HrTer1
	cjne a,#01d,J120		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino1
J120:	cjne a,#02d,J121		;compara se foi escolhido o horário 2 do periodo matutino
	lcall matutino2
J121:	mov a,HrTer2
	cjne a,#01d,J122		;compara se foi escolhido o horário 1 do periodo vespertino
	lcall vespertino1
J122:	cjne a,#02d,J123		;compara se foi escolhido o horário 2 do periodo vespertino
	lcall vespertino2
J123:	mov a,HrTer3
	cjne a,#01d,J124		;compara se foi escolhido o horário 1 do periodo noturno
	lcall noturno1
J124:	cjne a,#02d,J119		;compara se foi escolhido o horário 2 do periodo noturno
	lcall noturno1
J119:	cjne DiaAtual,#04d,J125		;compara se é quarta
	mov a,HrQua1
	cjne a,#01d,J126		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino1
J126:	cjne a,#02d,J127		;compara se foi escolhido o horário 2 do periodo matutino
	lcall matutino2
J127:	mov a,HrQua2
	cjne a,#01d,J128		;compara se foi escolhido o horário 1 do periodo vespertino
	lcall vespertino1
J128:	cjne a,#02d,J129		;compara se foi escolhido o horário 2 do periodo vespertino
	lcall vespertino2
J129:	mov a,HrQua3
	cjne a,#01d,J130		;compara se foi escolhido o horário 1 do periodo noturno
	lcall noturno1
J130:	cjne a,#02d,J125		;compara se foi escolhido o horário 2 do periodo noturno
	lcall noturno1
J125:	cjne DiaAtual,#05d,J131		;compara se é quinta
	mov a,HrQui1
	cjne a,#01d,J132		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino1
J132:	cjne a,#02d,J133		;compara se foi escolhido o horário 2 do periodo matutino
	lcall matutino2
J133:	mov a,HrQui2
	cjne a,#01d,J134		;compara se foi escolhido o horário 1 do periodo vespertino
	lcall vespertino1
J134:	cjne a,#02d,J135		;compara se foi escolhido o horário 2 do periodo vespertino
	lcall vespertino2
J135:	mov a,HrQui3
	cjne a,#01d,J136		;compara se foi escolhido o horário 1 do periodo noturno
	lcall noturno1
J136:	cjne a,#02d,J131		;compara se foi escolhido o horário 2 do periodo noturno
	lcall noturno1
J131:	cjne DiaAtual,#06d,J137		;compara se é sexta
	mov a,HrSex1
	cjne a,#01d,J138		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino1
J138:	cjne a,#02d,J139		;compara se foi escolhido o horário 1 do periodo matutino
	lcall matutino2	
J139:	mov a,HrSex2
	cjne a,#01d,J140		;compara se foi escolhido o horário 1 do periodo vespertino
	lcall vespertino1
J140:	cjne a,#02d,J141		;compara se foi escolhido o horário 2 do periodo vespertino
	lcall vespertino2
J141:	mov a,HrSex3
	cjne a,#01d,J142		;compara se foi escolhido o horário 1 do periodo noturno
	lcall noturno1
J142:	cjne a,#02d,J137		;compara se foi escolhido o horário 2 do periodo noturno
	lcall noturno1
J137:	ret
;*********** Chamada da interrupção do TIMER_0 *************************************************	
TEMPO:	dec r0
	cjne r0,#00h,pulo1 	;compara se SegAtual não for zero 	orl c,	orl c,p1.2p1.2
	mov r0,#20d  	  ;carrega r0 com 20, pois ele conta 20 vezes 50000 us (microsegundos) para dar 1segundo
	inc SegAtual
	jnb flag2,pulo1
	push acc
	mov a,76h
	cjne a,#04d,pulo21
	mov b,#04d
	mov a,segatual
	div ab
	mov a,b
	jnz pulo21
	cpl ledhab
pulo21:	mov a,76h
	cjne a,#03d,pulo22
	mov b,#03d
	mov a,segatual
	div ab
	mov a,b
	jnz pulo22
	cpl ledhab
pulo22:	mov a,76h
	cjne a,#02d,pulo23
	mov b,#02d
	mov a,segatual
	div ab
	mov a,b
	jnz pulo23
	cpl ledhab
pulo23:	mov a,76h
	cjne a,#01d,pulo24
	cpl ledHab
pulo24:	pop acc
pulo1:	cjne r0,#20d,pulo2 	;compara para fazer o led do display 3 ligar por 0.5s 
	jnb lednor,pulo18	;ledseg somente pisca se estiverem modo normal
	clr ledseg
pulo18:	cjne valorlr,#01d,pulo12	;compara se esta no modo de programação para piscar o display1
	cpl habd1
	setb habd2		;faz com que os outros display's não apaguem
	setb habd3
	setb habd4
pulo12:	cjne valorlr,#02d,pulo13	;compara se esta no modo de programação para piscar o display2
	cpl habd2
	setb habd1		;faz com que os outros display's não apaguem
	setb habd3
	setb habd4
pulo13:	cjne valorlr,#03d,pulo14	;compara se esta no modo de programação para piscar o display3
	cpl habd3
	setb habd1		;faz com que os outros display's não apaguem
	setb habd2
	setb habd4
pulo14: cjne valorlr,#04d,pulo2	;compara se esta no modo de programação para piscar o display4
	cpl habd4
	setb habd1		;faz com que os outros display's não apaguem
	setb habd2
	setb habd3
pulo2:	cjne r0,#10d,pulo3 	;compara para fazer o led do display 3 desligar por 0.5s 
	jnb lednor,pulo19	;ledseg somente pisca se estiverem modo normal 
	setb ledseg         	;(ledseg)-> para dar a ilusão da comtagem dos segundos
pulo19:	cjne valorlr,#01d,pulo15	;compara se esta no modo de programação para piscar o display1
	cpl habd1
	setb habd2		;faz com que os outros display's não apaguem
	setb habd3
	setb habd4
pulo15:	cjne valorlr,#02d,pulo16	;compara se esta no modo de programação para piscar o display2
	cpl habd2
	setb habd1		;faz com que os outros display's não apaguem
	setb habd3
	setb habd4
pulo16:	cjne valorlr,#03d,pulo17	;compara se esta no modo de programação para piscar o display3
	cpl habd3
	setb habd1		;faz com que os outros display's não apaguem
	setb habd2
	setb habd4
pulo17: cjne valorlr,#04d,pulo3	;compara se esta no modo de programação para piscar o display4
	cpl habd4
	setb habd1		;faz com que os outros display's não apaguem
	setb habd2
	setb habd3
pulo3:	jnb sirene,pulo20	  ;compara se a sirene está ligada,	
	cjne SegAtual,#6d,pulo20  ;e faz a sirene tocar por 5 segundos
	clr sirene		  ;depois desliga a sirene
	clr ledhab		  ;desliga led amarelo
	mov 76h,#00h	;indica que o sinal já bateu 
pulo20:	cjne SegAtual,#60d,pulo5 	;Se der 60 segundos
	mov SegAtual,#00h        	;zera Segundo Atual
	inc MinAtual			;incrementa Minuto Atual
	;---------
	cjne MinAtual,#60d,pulo4 	;Se der 60 minutos
	mov MinAtual,#00h        	;zera Minuto Atual
	inc HoraAtual			;incrementa Hora Atual
	;---
pulo4:	jb bithab,pulo25	;para abilitar o parametro 17
	djnz 78h,pulo25		;
	setb bithab		;
pulo25:	lcall tocasirene
	;cjne MinAtual,#60d,pulo5 	;Se der 60 minutos
	;mov MinAtual,#00h        	;zera Minuto Atual
	;inc HoraAtual			;incrementa Hora Atual
pulo5:	cjne HoraAtual,#24,pulo6 	;Se der 24 Horas
	mov HoraAtual,#00h        	;zera Hora Atual
	inc DiaAtual			;incrementa Dia Atual
	lcall mudahorario
	;{}
pulo6:	cjne DiaAtual,#08d,pulo7 	;Se der 7 dias
	mov DiaAtual,#01h        	;zera Dia Atual
pulo7:	jb LedNor,pulo11		;if (LedNor = 0) then [LedProg fica pisacando em 0.25s]
	cjne r0,#20d,pulo8 		;liga ledProg
	setb LedProg
pulo8: 	cjne r0,#15d,pulo9 		;apaga LedProg 
	clr LedProg
pulo9:	cjne r0,#10d,pulo10 		;liga ledProg
	setb LedProg
pulo10:	cjne r0,#05d,pulo11 		;apaga LedProg 
	clr LedProg
pulo11:	reti
;**********************************************************************************************
tocasirene:	
	push acc  	;armazena o valor atual do acumulador
	push 01h  	;armazena o valor atual do R1
	push b
	mov a,diaatual	;mov para o acc o valor do dia atual
	cjne a,#01d,J56	;compara se o dia for 01 (domingo)pula para J17
	ajmp J17
J56:	cjne a,#07d,J57	;compara se o dia for 07 (sábado) pula para J17
	ajmp J17
J57:	mov a,horaatual	;mov para o acc o valor da hora atual
	cjne a,#00h,J43	;pula para J17 se for 00:xx Horas 
	ajmp J17
J43:	acall IndicaSirene
	mov a,horaatual	;mov para o acc o valor da hora atual
	mov r1,#30h	;r1 = 30h (de 30h a 5Eh são as posições de mem. que contém o valor das horas) 
J19:	mov 71h,@r1	;mov para a pos. de mem. 71h o valor da pos. de mem. apontado por r1
	cjne a,71h,J18	;comp. c a horaatual(acc) é igual a hora da pos. de mem. 30h que foi movida para 71h
	mov a,Minatual	;mov para o acc o valor do minuto atual
	inc r1		;incrementa r1 para indicar a pos. do minuto
	mov 71h,@r1	;mov para a pos. de mem. 71h o valor da pos. de mem. apontado por r1
	cjne a,71h,J2_0	;comp. c o minatual(acc) é igual o min da pos. de mem. 30h que foi movida para 71h
	jnb Sirhab,J20	;comp. se a sirene está habilitada
	setb sirene	;se a hora e o min forem verdadeiros a sirene e tocada
	mov 76h,#00h	;indica que o sinal já bateu 
	clr flag2	; e desliga o ledhab
	clr ledhab
J20:	ajmp J17	;pula para J17 
J18:	inc r1		;incrementa 2x r1 para indicar o valor da pos. de mem. que contém a hora
	inc r1
	cjne r1,#60h,J19 ;compara se passou todas as horas
J17:	pop b
	pop 01h		;restaura o valor do R1
	pop acc  	;restaura o valor do acc
	ret
J2_0:	dec r1
	mov a,horaatual
	ajmp J18
;********** Indica que a sirene vai tocar ******************************************************
IndicaSirene: ;76h
	mov r1,#31h	
J67:	clr flag1
	mov 71h,@r1
	mov a,minatual
	inc a
	cjne a,#60d,J58
	setb flag1
	mov a,#00d	; se passar de 60 min
J58:	cjne a,71h,J59
	mov 76h,#01d	;falta 1 min
	ajmp J62
J59:	inc a
	cjne a,#60d,J63
	setb flag1
	mov a,#00d
J63:	cjne a,71h,J60
	mov 76h,#02d	;falta 2 min
	ajmp J62
J60:	inc a
	cjne a,#60d,J64
	setb flag1
	mov a,#00d
J64:	cjne a,71h,J61
	mov 76h,#03d	;falta 3 min
	ajmp J62
J61:	inc a
	cjne a,#60d,J65
	setb flag1
	mov a,#00d
J65:	cjne a,71h,J66
	mov 76h,#04d	;falta 4 min
	ajmp J62
J66:	inc r1
	inc r1
	cjne r1,#61h,J67
	ajmp J68
	;--------------
J62:	mov a,horaatual
;	mov b,71h
	dec r1
	mov 71h,@r1
	jb flag1,J69
	cjne a,71h,J6_8
	;pode piscar
	setb flag2
	ajmp J68
J69:	inc a
	cjne a,71h,J6_8
	;pode piscar
	setb flag2
J68:	ret
J6_8:	inc r1
	ajmp J66
;********** Declarando os valores das Horas e Minutos do periodo MATUTINO **********************
Matutino1:
	mov Hora1,#07d
	mov Min1,#40d
	mov Hora2,#08d
	mov Min2,#25d
	mov Hora3,#09d
	mov Min3,#10d
	mov Hora4,#09d
	mov Min4,#55d
	mov Hora5,#10d
	mov Min5,#05d
	mov Hora6,#10d
	mov Min6,#55d     
	mov Hora7,#11d     
	mov Min7,#40d   
	mov Hora8,#00d     
	mov Min8,#00d
	ret
Matutino2:
	mov Hora1,#07d     
	mov Min1,#40d     
	mov Hora2,#08d    
	mov Min2,#20d  
	mov Hora3,#09d    
	mov Min3,#00d 
	mov Hora4,#09d 
	mov Min4,#40d
	mov Hora5,#09d    
	mov Min5,#50d  
	mov Hora6,#10d   
	mov Min6,#30d     
	mov Hora7,#11d     
	mov Min7,#05d   
	mov Hora8,#11d     
	mov Min8,#40d
	ret
;********** Declarando os valores das Horas e Minutos do periodo VESPERTINO **********************      
Vespertino1:	
	mov Hora9,#13d 
	mov Min9,#00d   
	mov Hora10,#13d    
	mov Min10,#45d  
	mov Hora11,#14d  
	mov Min11,#30d    
	mov Hora12,#15d   
	mov Min12,#15d
	mov Hora13,#15d  
	mov Min13,#25d  
	mov Hora14,#16d    
	mov Min14,#15d    
	mov Hora15,#17d    
	mov Min15,#00d   
	mov Hora16,#00d    
	mov Min16,#00d
	ret
Vespertino2:
	mov Hora9,#13d 
	mov Min9,#00d    
	mov Hora10,#13d    
	mov Min10,#40d  
	mov Hora11,#14d   
	mov Min11,#20d    
	mov Hora12,#15d    
	mov Min12,#00d 
	mov Hora13,#15d  
	mov Min13,#10d   
	mov Hora14,#15d   
	mov Min14,#50d   
	mov Hora15,#16d    
	mov Min15,#25d   
	mov Hora16,#17d    
	mov Min16,#00d
	ret 
;********** Declarando os valores das Horas e Minutos do periodo NOTURNO **********************   
Noturno1:	
	mov Hora17,#19d    
	mov Min17,#00d    
	mov Hora18,#19d    
	mov Min18,#40d   
	mov Hora19,#20d    
	mov Min19,#20d  
	mov Hora20,#21d   
	mov Min20,#00d    
	mov Hora21,#21d    
	mov Min21,#10d   
	mov Hora22,#21d   
	mov Min22,#50d   
	mov Hora23,#22d   
	mov Min23,#30d    
	mov Hora24,#00d     
	mov Min24,#00d  
	ret
;*************** Programação dos turnos ******************************************** 
TurnoAtual:
 	mov HrSeg1,#01d      	;equ 60h    Programando o Horario nos dias da semana, 
	mov HrSeg2,#01d      	;equ 61h    escolhe qual será usado entre vários
	mov HrSeg3,#01d      	;equ 62h
	mov HrTer1,#01d      	;equ 63h
	mov HrTer2,#01d      	;equ 64h
	mov HrTer3,#01d      	;equ 65h
	mov HrQua1,#02d      	;equ 66h
	mov HrQua2,#01d      	;equ 67h
	mov HrQua3,#01d      	;equ 68h
	mov HrQui1,#01d      	;equ 69h
	mov HrQui2,#01d      	;equ 6AH
	mov HrQui3,#01d      	;equ 6BH
	mov HrSex1,#01d      	;equ 6CH
	mov HrSex2,#02d      	;equ 6DH
	mov HrSex3,#01d      	;equ 6Eh
	ret
;************** FIM ****************
end	;J86	pulo19 



