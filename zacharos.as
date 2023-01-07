;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh	; Recebe caracteres da teclado na janela de texto
IO_WRITE        EQU     FFFEh	; Permite escrever um dado caractér na janela de texto
IO_STATUS       EQU     FFFDh	; Teste se houve tecla apertada na janela de texto
INITIAL_SP      EQU     FDFFh	
CURSOR		    EQU     FFFCh	; Insere o cursor na janela de texto, controla onde será inserido próximo caractere
CURSOR_INIT		EQU		FFFFh

ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d

TIMER_BUFFER	EQU		FFF6h	; Define o valor do temporizador em intervalos de 100ms
TIMER_STATUS	EQU		FFF7h	; Define o estado do temporizador, 0 OFF, 1 ON
TIMER_VALUE		EQU		5d		; Valor absoluto do tempo em blocos de 100ms, nesse caso, meio segundo. Esse valor é carregado em TIMER_BUFFER

ON				EQU		1d		; Estado Desligado. 
OFF				EQU		0d		; Estado Ligado.

PACMAN_CRT		EQU 	'Z'		; Caractér para represertar o PACMAN
PACMAN_SPAWN_R	EQU		21d
PACMAN_SPAWN_C	EQU		45d

PACMAN_DIST		EQU		6D2h	; Distância de 1909 Caracteres após o início da string 1
LINE_JUMP		EQU		51h		; Distância até chegar ao caractér imediamente superior ou inferior

MAX_SCORE		EQU 	200d 	; Quantidade de pontos máxima para encerrar o jogo
;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------
                ORIG    8000h

RowIndex		WORD	0d		;Variável que guarda a posição da linha
ColumnIndex		WORD	0d		;Variável que guarda a posição da coluna
TextIndex		WORD	0d		;Variável que guarda a posição no texto?

ScorePoint		WORD	0d		;Variável que guarda a pontuação
Lifes 			WORD	3d		;Variável que guarda a quantidade de vidas

Pac_Column		WORD	0d		;Variável que guarda a posição atual do PAC (Coluna)
Pac_Row			WORD	0d		;Variável que guarda a posição atual do PAC (Linha)
Pac_Address		WORD	0d		;Variável que guarda a posição atual do PAC (Endereço)?
Pac_Hearth		WORD	3d		;Variável que guarda a vida atual do PAC

Pac_Move_Top	WORD	OFF		;Comando para mover para cima
Pac_Move_Right	WORD	OFF		;Comando para mover para direita
Pac_Move_Bottom	WORD	OFF		;Comando para mover para baixo
Pac_Move_Left	WORD	OFF		;Comando para mover para esquerda

Ghost_Spawn_P1 	WORD	33Eh	;33E Número de casas que é necessário percorrer na memória para chegar no ponto de spawn
Ghost_Spawn_P2 	WORD	372h	;373
Ghost_Spawn_P3 	WORD	66Eh	;663 6C0h
Ghost_Spawn_P4 	WORD	69Ch	;6ED

Ghost_Eat 		WORD 	0h
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;	Ghosts							;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

Ghost_Row1		WORD	10d		;Posição da linha de cada fantasma
Ghost_Row2		WORD	10d
Ghost_Row3		WORD	20d
Ghost_Row4		WORD	21d
Ghost_RowT		WORD	0d		;Guarda o valor do fantasma atual (Para consideração em funções)

;possível diminuir 1
Ghost_Column1 	WORD	20d		;Posição da coluna de cada fantasma
Ghost_Column2	WORD	72d
Ghost_Column3	WORD	26d
Ghost_Column4	WORD	72d
Ghost_ColumnT	WORD	0d

Ghost_Address1	WORD	0h		;Posição na memória do fantasma, vazios até chamar address ghosts
Ghost_Address2	WORD	0h
Ghost_Address3	WORD	0h
Ghost_Address4	WORD	0h
Ghost_AddressT	WORD	0h

Ghost_Shit1 	WORD 	'.'
Ghost_Shit2 	WORD 	'.'
Ghost_Shit3 	WORD 	'.'
Ghost_Shit4 	WORD 	'.'
Ghost_ShitT 	WORD 	'.'

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;
;	Mapas							;
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-;

LINHA1NIVEL     STR 	'################################################################################', FIM_TEXTO
LINHA2NIVEL     STR 	'#=-=-=-=-=-=-PLACAR:000-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=VIDAS: 3=-=-=-=-=-=-#', FIM_TEXTO
LINHA3NIVEL     STR 	'################################################################################', FIM_TEXTO
LINHA4NIVEL 	STR 	'#..............###########....................####.....###.....................#', FIM_TEXTO
LINHA5NIVEL 	STR 	'#..............###########....................####.....###.....................#', FIM_TEXTO
LINHA6NIVEL 	STR 	'#....######....##.......##....................####.............###.....###.....#', FIM_TEXTO
LINHA7NIVEL 	STR 	'#....######....##.......##...##############...####.............###.....###.....#', FIM_TEXTO
LINHA8NIVEL 	STR 	'#....######....#####.#####...##|zacharos|##...#########...########.....#########', FIM_TEXTO
LINHA9NIVEL 	STR 	'#....######....#####.#####...##############...#########...##...###.....###.....#', FIM_TEXTO
LINHA10NIVEL 	STR 	'#....######..................#####....#####...............##...###.....###.....#', FIM_TEXTO
LINHA11NIVEL 	STR 	'#....######.........X..........................................###......X......#', FIM_TEXTO
LINHA12NIVEL 	STR 	'#....######..................#####....#####....................###.............#', FIM_TEXTO
LINHA13NIVEL 	STR 	'#....######....#########################################.###...########...######', FIM_TEXTO
LINHA14NIVEL 	STR 	'#....######....#########################################.###...########...######', FIM_TEXTO
LINHA15NIVEL 	STR 	'#........................................................###...########...######', FIM_TEXTO
LINHA16NIVEL 	STR 	'#..............##############################.##########.###...................#', FIM_TEXTO
LINHA17NIVEL 	STR 	'###########....##############################.##########.###...................#', FIM_TEXTO
LINHA18NIVEL 	STR 	'###########....##############################.##########.###...................#', FIM_TEXTO
LINHA19NIVEL 	STR 	'#....................................................###.##############...######', FIM_TEXTO
LINHA20NIVEL 	STR 	'#......####....#######################...####.####...###.##############...######', FIM_TEXTO
LINHA21NIVEL 	STR 	'#......####....#######....X....#######...##.....##...###.##########..........###', FIM_TEXTO
LINHA22NIVEL 	STR 	'#......####..............................##.....##......................X....###', FIM_TEXTO
LINHA23NIVEL 	STR 	'#......####..............###.............##.....###################..........###', FIM_TEXTO
LINHA24NIVEL 	STR 	'################################################################################', FIM_TEXTO

DEFEAT1			STR		'# = = = = = = = = = = = = #==========================# = = = = = = = = = = = = #', FIM_TEXTO
DEFEAT2			STR		'# = = = = = = = = = = = = # = = VOCE PERDEU MESMO ?= # = = = = = = = = = = = = #', FIM_TEXTO
DEFEAT3			STR		'# = = = = = = = = = = = = # = 666 = =OTARIO= = = = = # = = = = = = = = = = = = #', FIM_TEXTO
DEFEAT4			STR		'# = = = = = = = = = = = = #==========================# = = = = = = = = = = = = #', FIM_TEXTO

VICTORY1		STR		'# = = = = = = = = = = = = #==========================# = = = = = = = = = = = = #', FIM_TEXTO
VICTORY2		STR		'# = = = = = = = = = = = = #     PARECE QUE GANHOU    # = = = = = = = = = = = = #', FIM_TEXTO
VICTORY3		STR		'# = = = = = = = = = = = = #        FOI SORTE         # = = = = = = = = = = = = #', FIM_TEXTO
VICTORY4		STR		'# = = = = = = = = = = = = #==========================# = = = = = = = = = = = = #', FIM_TEXTO
;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
;Interrupções definem a parada do código para executar uma informação prioritária.
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0           	WORD	Key_Pr_Top
INT1			WORD	Key_Pr_Right
INT2			WORD	Key_Pr_Bottom
INT3			WORD	Key_Pr_Left

				ORIG    FE0Fh
INT15			WORD	Timer

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; ZONA IV - I: Funções PrintString
;        conjunto de instrucoes Assembly que alteram explicitamente o conteúdo
;	da tela de alguma forma.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Função PrintString
;------------------------------------------------------------------------------
PrintString:	PUSH 	R1
				PUSH 	R2
	
	WSTRING:	MOV 	R1, M[TextIndex]		;R1 = Pos de onde parou no texto
				MOV 	R1, M[R1]				;R1 = CHAR -> Posição do char no texto base

				CMP 	R1, FIM_TEXTO			;Se R1 == FIM_TEXTO ('@'), Fim da String, pula para EWSTRING
				JMP.Z 	EWSTRING				
				MOV 	M[IO_WRITE], R1			;Caso não, move para IO_WRITE o caracter que queremos escrever

				INC 	M[ColumnIndex]			;Adiciona + 1 na coordenada de colunas do cursor
				INC 	M[TextIndex]			;Passa o marcador para a próxima letra

				MOV 	R1, M[RowIndex]			;Redefinindo o cursor -> Definindo parte esquerda (linha)
				SHL 	R1, ROW_SHIFT			;Formatando parte esquerda
				MOV 	R2, M[ColumnIndex]		;definindo parte direita (coluna)
				OR 		R1, R2					;juntando ambas as partes

				MOV 	M[CURSOR], R1			;Define cursos como o "frame" que queremos inserir
				JMP 	WSTRING					;Retorna para repetir o processo até o fim de linha

	EWSTRING:	INC 	M[RowIndex]
				MOV 	R1, 0d
				MOV 	M[ColumnIndex], R1
				MOV 	R1, M[RowIndex]
				SHL 	R1, ROW_SHIFT
				MOV 	M[CURSOR], R1
				
				POP 	R2
				POP 	R1
				RET
;------------------------------------------------------------------------------
; Função PrintTela
;------------------------------------------------------------------------------
PrintTela: 		PUSH 	R1						
				PUSH 	R2						
				MOV 	R1, LINHA1NIVEL			;R1 recebe a string da primeira linha da Tela
				MOV 	M[TextIndex], R1		;Guarda a primeira posição da primeira string
				MOV 	R2, 0d 					;R2 = 0 para contar quantas strings imprimiremos

	WTELA:		CMP 	R2, 24d					;Compara R2 com 24, quando for 24, todas as strings estarão na tela
				JMP.Z 	EWTELA					;Pula para o fim caso a comparão acima dê TRUE

				CALL 	PrintString				;Chama a função que imprime a string
				INC 	R2						;Acrescenta o contador em 1
				INC 	M[TextIndex]			;Acrescenta a posição da string em 1 (vai para a prox string)
				JMP 	WTELA					;Retorna para a comparação

	EWTELA: 	POP 	R2
				POP 	R1
				RET



;------------------------------------------------------------------------------;
; Função Print Defeat													       ;
;------------------------------------------------------------------------------;
Defeat:			PUSH 	R1

				MOV 	R1, 10d					; Recupera o valor da linha onde o começará a exibição das linhas
				MOV		M[RowIndex], R1			; Escreve esse valor no Row Position do cursor
				SHL 	R1, ROW_SHIFT
				MOV 	M[CURSOR], R1			
				MOV		R1,	DEFEAT1				; Joga na "fila" de impressão o endereço da primeira linha
				MOV  	M[TextIndex], R1		
				MOV 	R1, 0d

	REPDEF:		CMP 	R1, 4d					; Chama printstring da prox linha até todas as 4 linhas forem impressas
				JMP.Z 	ENDREPD
				CALL 	PrintString
				INC 	M[TextIndex]
				INC 	R1
				JMP 	REPDEF

	ENDREPD: 	POP		R1
				CALL 	Halt					; Para o programa

;------------------------------------------------------------------------------;
; Função Print Victory													       ;
;------------------------------------------------------------------------------;
Victory:		PUSH 	R1

				MOV 	R1, 10d					
				MOV		M[RowIndex], R1			
				SHL 	R1, ROW_SHIFT
				MOV 	M[CURSOR], R1			
				MOV		R1,	VICTORY1
				MOV  	M[TextIndex], R1
				MOV 	R1, 0d

	REPVIC:		CMP 	R1, 4d
				JMP.Z 	ENDREPV
				CALL 	PrintString
				INC 	M[TextIndex]
				INC 	R1
				JMP 	REPVIC

	ENDREPV: 	POP		R1
				CALL 	Halt

;------------------------------------------------------------------------------
; Função Score
;------------------------------------------------------------------------------
Score:			PUSH	R1
				PUSH 	R2
				PUSH 	R3 
				PUSH 	R4
				
				MOV		R1, M[ScorePoint] 		;Recuperar o valor dos pontosna memória
				INC		R1						;Incrementar o ponto
				MOV		M[ScorePoint], R1		;Guardar novamente
				
				CMP 	R1, MAX_SCORE			;Comparamos da pontuação atual com o valor MAX
				CALL.Z 	Victory					;Caso sejam iguais, chama a função que termina o jogo

				;----------------------------;
				; Centena	 	             ;
				;----------------------------;

				MOV		R2, 100d				;Divide a pontuação por 100 e guarda o resto
				DIV 	R1, R2
				
				MOV 	R3, 1d					;Calcular o primeiro endereço na memória
				SHL 	R3, ROW_SHIFT
				MOV		R4, 20d
				OR		R3, R4

				MOV 	M[CURSOR], R3			;Guardar o primeiro endereço na posição de escrita
				MOV 	R4, R1 
				ADD 	R4, '0'
				MOV		M[IO_WRITE], R4

				;----------------------------;
				; Dezena	 	             ;
				;----------------------------;				

				MOV		R1, R2					
				MOV 	R2, 10d					;Divide a pontuação por 10 e guarda o resto

				DIV 	R1, R2
				
				INC 	R3						;INC na posição atual
				MOV 	M[CURSOR], R3
				MOV 	R4, R1
				ADD 	R4, '0'
				MOV		M[IO_WRITE], R4

				;----------------------------;
				; Unidade	 	             ;
				;----------------------------;	

				INC 	R3
				MOV 	M[CURSOR], R3
				ADD		R2, '0'
				MOV		M[IO_WRITE], R2

				POP 	R4
				POP 	R3
				POP 	R2
				POP		R1
				RET

;------------------------------------------------------------------------------;
; ZONA IV - II: Funções fantasma											   ;
;        Funções utilizadas pelos fantasmas ou para eles.					   ;
;------------------------------------------------------------------------------;
;------------------------------------------------------------------------------;
; Função AddressGhost														   ;
;------------------------------------------------------------------------------;

AddressGhost:	PUSH R1

				MOV R1, LINHA11NIVEL
				ADD R1, 20d
				MOV M[Ghost_Address1], R1

				MOV R1, LINHA11NIVEL
				ADD R1, 72d
				MOV M[Ghost_Address2], R1

				MOV R1, LINHA21NIVEL
				ADD R1, 26d
				MOV M[Ghost_Address3], R1

				MOV R1, LINHA22NIVEL
				ADD R1, 72d
				MOV M[Ghost_Address4], R1

				POP R1
				RET

;------------------------------------------------------------------------------;
; Função MoveGhost															   ;
;------------------------------------------------------------------------------;
MoveGhost:		PUSH 	R1
				PUSH 	R2
				PUSH 	R3
				PUSH 	R4

				MOV 	R1, M[Pac_Address]
				MOV 	R2, 4d
				DIV 	R1, R2 

				CMP		R2, 0d
				JMP.Z	GMoveTop

				CMP		R2, 1d
				JMP.Z	GMoveRight

				CMP		R2, 2d
				JMP.Z	GMoveBot
		
				CMP		R2, 3d
				JMP.Z	GMoveLeft
	
	; Ideia -> Verificar a parede e mover, se não for possível, inverte o movimento
	GMoveTop:	MOV 	R1, M[Ghost_AddressT]	;Recebe endereço do fantasma
				SUB 	R1, LINE_JUMP			;Acessa a posição imediatamente superior.

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;

				MOV 	R2, M[R1]				
				CMP 	R2, '#'					;Realiza a comparação, caso impossível, pula
				JMP.Z 	GMoveRight	

				CMP 	R2, 'X'
				JMP.Z 	GMoveEnd

				CMP 	R2, PACMAN_CRT
				CALL.Z 	RespawnPacman

				CMP 	R2, PACMAN_CRT
				JMP.Z 	GMoveEnd

				MOV 	R4, R2

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				ADD 	R1, LINE_JUMP
				MOV 	R3, M[Ghost_ShitT]
				MOV 	R2, R3
				MOV 	M[R1], R2
				SUB 	R1, LINE_JUMP
				MOV 	R2, 'X'
				MOV 	M[R1], R2
				MOV 	M[Ghost_AddressT], R1

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, M[Ghost_ShitT]
				MOV 	M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				DEC 	M[Ghost_RowT]

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, 'X'
				MOV 	M[IO_WRITE], R2

				MOV 	M[Ghost_ShitT], R4

				JMP 	GMoveEnd

	GMoveRight:	MOV 	R1, M[Ghost_AddressT]
				INC 	R1						;Acessa a posição imediatamente superior.

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;

				MOV 	R2, M[R1]				
				CMP 	R2, '#'					;Realiza a comparação, caso impossível, pula
				JMP.Z 	GMoveBot

				CMP 	R2, 'X'
				JMP.Z 	GMoveEnd

				CMP 	R2, PACMAN_CRT
				CALL.Z 	RespawnPacman

				CMP 	R2, PACMAN_CRT
				JMP.Z 	GMoveEnd

				MOV 	R4, R2
				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				DEC 	R1
				MOV 	R3, M[Ghost_ShitT]
				MOV 	R2, R3
				MOV 	M[R1], R2

				INC 	R1

				MOV 	R2, 'X'
				MOV 	M[R1], R2
				INC 	M[Ghost_AddressT]

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, M[Ghost_ShitT]
				MOV 	M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				INC 	M[Ghost_ColumnT]
				INC 	R1

				MOV 	M[CURSOR], R1
				MOV 	R2, 'X'
				MOV 	M[IO_WRITE], R2

				MOV 	M[Ghost_ShitT], R4

				JMP 	GMoveEnd

	GMoveBot:	MOV 	R1, M[Ghost_AddressT]
				ADD 	R1, LINE_JUMP			;Acessa a posição imediatamente superior.

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;

				MOV 	R2, M[R1]				
				CMP 	R2, '#'					;Realiza a comparação, caso impossível, pula
				JMP.Z 	GMoveLeft

				CMP 	R2, 'X'
				JMP.Z 	GMoveEnd

				CMP 	R2, PACMAN_CRT
				CALL.Z 	RespawnPacman

				CMP 	R2, PACMAN_CRT
				JMP.Z 	GMoveEnd

				MOV 	R4, R2
				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				SUB 	R1, LINE_JUMP
				MOV 	R3, M[Ghost_ShitT]
				MOV 	R2, R3
				MOV 	M[R1], R2
				ADD 	R1, LINE_JUMP
				MOV 	R2, 'X'
				MOV 	M[R1], R2
				MOV 	M[Ghost_AddressT], R1

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, M[Ghost_ShitT]
				MOV 	M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				INC 	M[Ghost_RowT]

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, 'X'
				MOV 	M[IO_WRITE], R2

				MOV 	M[Ghost_ShitT], R4

				JMP 	GMoveEnd

	GMoveLeft:	MOV 	R1, M[Ghost_AddressT]
				DEC 	R1						;Acessa a posição imediatamente superior.

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;

				MOV 	R2, M[R1]				
				CMP 	R2, '#'					;Realiza a comparação, caso impossível, pula
				JMP.Z 	GMoveEnd

				CMP 	R2, 'X'
				JMP.Z 	GMoveEnd

				CMP 	R2, PACMAN_CRT
				CALL.Z 	RespawnPacman

				CMP 	R2, PACMAN_CRT
				JMP.Z 	GMoveEnd

				MOV 	R4, R2
				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				INC 	R1
				MOV 	R3, M[Ghost_ShitT]
				MOV 	R2, R3
				MOV 	M[R1], R2

				DEC 	R1

				MOV 	R2, 'X'
				MOV 	M[R1], R2
				DEC 	M[Ghost_AddressT]

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV 	R1, M[Ghost_RowT]
				MOV 	R2, M[Ghost_ColumnT]

				SHL 	R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R2, M[Ghost_ShitT]
				MOV 	M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				DEC 	M[Ghost_ColumnT]
				DEC 	R1

				MOV 	M[CURSOR], R1
				MOV 	R2, 'X'
				MOV 	M[IO_WRITE], R2

				MOV 	M[Ghost_ShitT], R4

				JMP 	GMoveEnd

	GMoveEnd:	POP 	R4
				POP 	R3	
				POP 	R2
				POP 	R1
				RET
;------------------------------------------------------------------------------;
; Função SetPacman															   ;
;------------------------------------------------------------------------------;
SetPacman:		PUSH 	R1
				PUSH 	R2

;----------------------------;
; Sub Função PrintPacman 	 ;
;----------------------------;

				MOV 	R1, PACMAN_SPAWN_R		;Funcionan com a função WriteCharacter, R1 recebe o valor 21, representando a linha da modificação
				MOV 	M[Pac_Row], R1			;Define a linha do pacman como sendo R1 (21)

				MOV 	R2, PACMAN_SPAWN_C		;Mesmo processo, mas com a coluna
				MOV 	M[Pac_Column], R2		; ...

				SHL 	R1, ROW_SHIFT			;Formatação explicada em WriteCharacter
				OR 		R1, R2					; ...

				MOV 	M[CURSOR],R1			; Define cursor como o endereço gerado por R1 || R2
				MOV 	R1, PACMAN_CRT			; Define R1 como o Caracter "Z"
				MOV 	M[IO_WRITE], R1			; Escreve na posição definida o Caracter "Z"

;----------------------------;
; Sub Função AddressPacman 	 ;
;----------------------------;

				MOV 	R1, LINHA1NIVEL			;Endereço do primeiro caractér da linha 1
				ADD 	R1, PACMAN_DIST			;Adicionar a esse endereço a distância que queremos pular para chegar no spawn
				MOV 	M[Pac_Address], R1		;Guarda em Pac_Address o endereço de memória onde o PACMAN está (R1)
				MOV 	R2, PACMAN_CRT			;Define o R2 como o caractér "Z" (meu pacman)
				MOV 	M[R1], R2				;Define a posição de memória R1 como "Z"

;----------------------------;
; Sub Função ResetMov    	 ;
;----------------------------;

				MOV 	R2, OFF
				MOV 	M[Pac_Move_Top], R2
				MOV 	M[Pac_Move_Right], R2
				MOV 	M[Pac_Move_Bottom], R2
				MOV 	M[Pac_Move_Left], R2

;----------------------------;
; Encerramento 	             ;
;----------------------------;
				POP 	R2
				POP 	R1
				RET

;------------------------------------------------------------------------------;
; Função RespawnPacman														   ;
;------------------------------------------------------------------------------;
RespawnPacman:	PUSH 	R1
				PUSH 	R2
				PUSH 	R3

;----------------------------;
; limpar a posição onde morre;
;----------------------------;

				MOV 	R1, M[Pac_Row]
				MOV 	R2, M[Pac_Column]
				SHL		R1, ROW_SHIFT
				OR 		R1, R2

				MOV 	M[CURSOR], R1
				MOV 	R1, ' '
				MOV 	M[IO_WRITE], R1			

				MOV 	R2, M[Pac_Address]		; Atualiza o o endereço do pacmano (limpa o endereço antigo)
				MOV 	M[R2], R1 

				CALL 	SetPacman 				; Chamar a função que Spawna o pacman

;----------------------------;
; Posição na memória (vida)	 ;
;----------------------------;

				MOV 	R1, 1d
				SHL 	R1, ROW_SHIFT
				MOV		R2, 66d
				OR		R1, R2
				MOV 	R3, R1

;----------------------------;
; Diminuir uma vida			 ;
;----------------------------;

				MOV		R1, M[Pac_Hearth]
				DEC		R1
				MOV		M[Pac_Hearth], R1

;----------------------------;
; Mudar informação na tela	 ;
;----------------------------;

				MOV 	R1, '0'
				MOV 	M[CURSOR], R3
				ADD 	R1, M[Pac_Hearth]
				MOV		M[IO_WRITE], R1

	zacharos:	NOP
				MOV 	R1, M[Pac_Hearth]
				CMP		R1, 0d
				CALL.Z 	Defeat

				POP 	R3
				POP 	R2
				POP 	R1

				RET


;------------------------------------------------------------------------------
; Funções de Movimentação
;------------------------------------------------------------------------------
;---------------------------------------------;
; Sub Função Movimentação para Cima           ;
;---------------------------------------------;
MoveTop:		PUSH	R1
				PUSH	R2

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;
				
				MOV		R1, M[Pac_Address]		;R1 recebe o endereço atual do PACMAN
				SUB  	R1, LINE_JUMP			;Subtrai o suficiente na memória para checar a posição superir
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	UpBlock					;Se for, não iremos realizar nenhuma alteração

				CMP 	R2, 'X'					;Verifica se o fantasma esta naquela posiçãos
				CALL.Z 	RespawnPacman			;Se sim, mato	

				CMP 	R2, 'X'					;Pula o ciclo de movimentação
				CALL.Z 	LeftBlock

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				ADD 	R1, LINE_JUMP			;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				SUB		R1, LINE_JUMP			;Retorna o R1 para a posição futura
				MOV 	R2, PACMAN_CRT			;Definte R2 = 'Z'
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o 'Z' no caso.
				MOV		M[Pac_Address], R1		;Endereço de PACMAN passa a ser o endereço R1
				
				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, ' '
				MOV		M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Posterior ;
				;--------------------;

				DEC		M[Pac_Row]

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, PACMAN_CRT
				MOV		M[IO_WRITE], R2
		
	UpBlock:	POP		R2
				POP		R1
				RET

;---------------------------------------------;
; Sub Função Movimentação para Direita        ;
;---------------------------------------------;
MoveRight:		PUSH	R1
				PUSH	R2

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;
				
				MOV		R1, M[Pac_Address]		;R1 recebe o endereço atual do PACMAN
				INC 	R1						;Subtrai o suficiente na memória para checar a posição superir
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	RightBlock				;Se for, não iremos realizar nenhuma alteração

				CMP 	R2, 'X'					;Verifica se o fantasma esta naquela posiçãos
				CALL.Z 	RespawnPacman			;Se sim, mato	

				CMP 	R2, 'X'					;Pula o ciclo de movimentação
				CALL.Z 	LeftBlock

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				DEC 	R1						;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				INC		R1						;Retorna o R1 para a posição futura
				MOV 	R2, PACMAN_CRT			;Definte R2 = 'Z'
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o 'Z' no caso.
				INC		M[Pac_Address]			;Endereço de PACMAN passa a ser o endereço R1
				
				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, ' '
				MOV		M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Posterior ;
				;--------------------;

				INC		M[Pac_Column]
				INC		R1

				MOV 	M[CURSOR], R1
				MOV 	R2, PACMAN_CRT
				MOV 	M[IO_WRITE], R2

	RightBlock:	POP		R2
				POP		R1
				RET
;---------------------------------------------;
; Sub Função Movimentação para Baixo          ;
;---------------------------------------------;
MoveBottom:		PUSH	R1
				PUSH	R2

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;
				
				MOV		R1, M[Pac_Address]		;R1 recebe o endereço atual do PACMAN
				ADD  	R1, LINE_JUMP			;Subtrai o suficiente na memória para checar a posição superior
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	BottomBlck				;Se for, não iremos realizar nenhuma alteração

				CMP 	R2, 'X'					;Verifica se o fantasma esta naquela posiçãos
				CALL.Z 	RespawnPacman			;Se sim, mato	

				CMP 	R2, 'X'					;Pula o ciclo de movimentação
				CALL.Z 	LeftBlock

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				SUB 	R1, LINE_JUMP			;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				ADD		R1, LINE_JUMP			;Retorna o R1 para a posição futura
				MOV 	R2, PACMAN_CRT			;Definte R2 = 'Z'
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o 'Z' no caso.
				MOV		M[Pac_Address], R1		;Endereço de PACMAN passa a ser o endereço R1
				
				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, ' '
				MOV		M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Posterior ;
				;--------------------;

				INC		M[Pac_Row]

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, PACMAN_CRT
				MOV		M[IO_WRITE], R2

	BottomBlck: POP		R2
				POP		R1
				RET

;---------------------------------------------;
; Sub Função Movimentação para Esquerda       ;
;---------------------------------------------;
MoveLeft:		PUSH	R1
				PUSH	R2

				;--------------------;
				;  Verificar Parede  ;
				;--------------------;
				
				MOV		R1, M[Pac_Address]		;R1 recebe o endereço atual do PACMAN
				DEC 	R1						;Subtrai o suficiente na memória para checar a posição superir
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	LeftBlock				;Se for, não iremos realizar nenhuma alteração

				CMP 	R2, 'X'					;Verifica se o fantasma esta naquela posiçãos
				CALL.Z 	RespawnPacman			;Se sim, mato	

				CMP 	R2, 'X'					;Pula o ciclo de movimentação
				CALL.Z 	LeftBlock

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				INC 	R1						;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				DEC		R1						;Retorna o R1 para a posição futura
				MOV 	R2, PACMAN_CRT			;Definte R2 = 'Z'
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o 'Z' no caso.
				DEC		M[Pac_Address]			;Endereço de PACMAN passa a ser o endereço R1
				
				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Original  ;
				;--------------------;

				MOV		R1, M[Pac_Row]
				MOV		R2, M[Pac_Column]

				SHL		R1, ROW_SHIFT
				OR		R1,	R2

				MOV		M[CURSOR], R1
				MOV		R2, ' '
				MOV		M[IO_WRITE], R2

				;--------------------;
				;    Mostrar Tela    ;
				;--------------------;
				;  Posição Posterior ;
				;--------------------;

				DEC		M[Pac_Column]
				DEC		R1

				MOV 	M[CURSOR], R1
				MOV 	R2, PACMAN_CRT
				MOV 	M[IO_WRITE], R2

	LeftBlock:	POP		R2
				POP		R1
				RET
;------------------------------------------------------------------------------
; Funções de Interrupção (movimento)
;------------------------------------------------------------------------------
;---------------------------------------------;
; Sub Função Recla Pressionada para o topo    ;
;---------------------------------------------;
Key_Pr_Top: 	PUSH 	R1
				PUSH 	R2

				MOV 	R1, ON 
				MOV		R2, OFF 

				MOV 	M[Pac_Move_Top], R1
				MOV 	M[Pac_Move_Right], R2
				MOV 	M[Pac_Move_Bottom], R2
				MOV 	M[Pac_Move_Left], R2

				POP 	R2
				POP 	R1
				RTI

;---------------------------------------------;
; Sub Função Recla Pressionada para a direita ;
;---------------------------------------------;
Key_Pr_Right: 	PUSH 	R1
				PUSH 	R2

				MOV 	R1, ON 
				MOV		R2, OFF 

				MOV 	M[Pac_Move_Top], R2
				MOV 	M[Pac_Move_Right], R1
				MOV 	M[Pac_Move_Bottom], R2
				MOV 	M[Pac_Move_Left], R2

				POP 	R2
				POP 	R1
				RTI

;---------------------------------------------;
; Sub Função Recla Pressionada para baixo     ;
;---------------------------------------------;
Key_Pr_Bottom: 	PUSH 	R1
				PUSH 	R2

				MOV 	R1, ON 
				MOV		R2, OFF 

				MOV 	M[Pac_Move_Top], R2
				MOV 	M[Pac_Move_Right], R2
				MOV 	M[Pac_Move_Bottom], R1
				MOV 	M[Pac_Move_Left], R2

				POP 	R2
				POP 	R1
				RTI

;---------------------------------------------;
; Sub Função Recla Pressionada para a esquerda;
;---------------------------------------------;
Key_Pr_Left: 	PUSH 	R1
				PUSH 	R2

				MOV 	R1, ON 
				MOV		R2, OFF 

				MOV 	M[Pac_Move_Top], R2
				MOV 	M[Pac_Move_Right], R2
				MOV 	M[Pac_Move_Bottom], R2
				MOV 	M[Pac_Move_Left], R1

				POP 	R2
				POP 	R1
				RTI

;------------------------------------------------------------------------------
; Funções de Tempo
;------------------------------------------------------------------------------
;---------------------------------------------;
; Função que realiza a "contagem" do tempo    ;
;---------------------------------------------;
Timer: 			PUSH 	R1
				PUSH	R2
				PUSH 	R3
				PUSH 	R4

				;testes

				;MOVE G 1

				MOV 	R1, M[Ghost_Row1]
				MOV 	M[Ghost_RowT], R1

				MOV 	R2, M[Ghost_Column1]
				MOV 	M[Ghost_ColumnT], R2

				MOV 	R3, M[Ghost_Address1]
				MOV 	M[Ghost_AddressT], R3

				MOV 	R4, M[Ghost_Shit1]
				MOV 	M[Ghost_ShitT], R4

				call MoveGhost

				MOV 	R1, M[Ghost_RowT]
				MOV 	M[Ghost_Row1], R1

				MOV 	R2, M[Ghost_ColumnT]
				MOV 	M[Ghost_Column1], R2

				MOV 	R3, M[Ghost_AddressT]
				MOV 	M[Ghost_Address1], R3

				MOV 	R4, M[Ghost_ShitT]
				MOV 	M[Ghost_Shit1], R4
				
				;MOVE G 2

				MOV 	R1, M[Ghost_Row2]
				MOV 	M[Ghost_RowT], R1

				MOV 	R2, M[Ghost_Column2]
				MOV 	M[Ghost_ColumnT], R2

				MOV 	R3, M[Ghost_Address2]
				MOV 	M[Ghost_AddressT], R3

				MOV 	R4, M[Ghost_Shit2]
				MOV 	M[Ghost_ShitT], R4

				call MoveGhost

				MOV 	R1, M[Ghost_RowT]
				MOV 	M[Ghost_Row2], R1

				MOV 	R2, M[Ghost_ColumnT]
				MOV 	M[Ghost_Column2], R2

				MOV 	R3, M[Ghost_AddressT]
				MOV 	M[Ghost_Address2], R3

				MOV 	R4, M[Ghost_ShitT]
				MOV 	M[Ghost_Shit2], R4

				;MOCE G 3

				MOV 	R1, M[Ghost_Row3]
				MOV 	M[Ghost_RowT], R1

				MOV 	R2, M[Ghost_Column3]
				MOV 	M[Ghost_ColumnT], R2

				MOV 	R3, M[Ghost_Address3]
				MOV 	M[Ghost_AddressT], R3

				MOV 	R4, M[Ghost_Shit3]
				MOV 	M[Ghost_ShitT], R4

				call MoveGhost

				MOV 	R1, M[Ghost_RowT]
				MOV 	M[Ghost_Row3], R1

				MOV 	R2, M[Ghost_ColumnT]
				MOV 	M[Ghost_Column3], R2

				MOV 	R3, M[Ghost_AddressT]
				MOV 	M[Ghost_Address3], R3

				MOV 	R4, M[Ghost_ShitT]
				MOV 	M[Ghost_Shit3], R4				

				;MOVE G 4

				MOV 	R1, M[Ghost_Row4]
				MOV 	M[Ghost_RowT], R1

				MOV 	R2, M[Ghost_Column4]
				MOV 	M[Ghost_ColumnT], R2

				MOV 	R3, M[Ghost_Address4]
				MOV 	M[Ghost_AddressT], R3

				MOV 	R4, M[Ghost_Shit4]
				MOV 	M[Ghost_ShitT], R4	

				call MoveGhost

				MOV 	R1, M[Ghost_RowT]
				MOV 	M[Ghost_Row4], R1

				MOV 	R2, M[Ghost_ColumnT]
				MOV 	M[Ghost_Column4], R2

				MOV 	R3, M[Ghost_AddressT]
				MOV 	M[Ghost_Address4], R3

				MOV 	R4, M[Ghost_ShitT]
				MOV 	M[Ghost_Shit4], R4

				;end testes

				MOV 	R1, M[Pac_Move_Top]		;Guarda em R1 o valor se sinal da Variável que diz se o PacMan move-se ou não.
				CMP 	R1, ON					;Compara para checar se o valor está ligado
				CALL.Z 	MoveTop					;Caso esteja, executa a função de movimentação

				MOV 	R1, M[Pac_Move_Right]
				CMP 	R1, ON
				CALL.Z 	MoveRight

				MOV 	R1, M[Pac_Move_Bottom]
				CMP 	R1, ON
				CALL.Z 	MoveBottom

				MOV 	R1, M[Pac_Move_Left]
				CMP 	R1, ON
				CALL.Z 	MoveLeft

				CALL 	StartTimer				;"Dispara" o tempo para acontecer um ciclo 

				POP 	R4
				POP 	R3
				POP 	R2
				POP 	R1
				RTI

;---------------------------------------------;
; Função que "dispara" o tempo                ;
;---------------------------------------------;
StartTimer:		PUSH 	R1
				PUSH	R2

				MOV 	R1, TIMER_VALUE
				MOV 	R2, ON

				MOV 	M[TIMER_BUFFER], R1
				MOV 	M[TIMER_STATUS], R2

				POP		R2
				POP 	R1
				RET


;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor
				MOV		M[ CURSOR ], R1

				CALL 	PrintTela
				CALL 	AddressGhost
				CALL 	SetPacman
				CALL	StartTimer


				
Cycle: 			BR		Cycle
Halt:           BR		Halt
 