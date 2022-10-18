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
CURSOR		    EQU     FFFCh	; Insere o cursos na janela de texto, controla onde será inserido próximo caracter
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
COLUMN_JUMP		EQU		51h		; Distância até chegar ao caractér imediamente superior ou inferior

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

Pac_Move_Top	WORD	OFF		;Comando para mover para cima
Pac_Move_Right	WORD	OFF		;Comando para mover para direita
Pac_Move_Bottom	WORD	OFF		;Comando para mover para baixo
Pac_Move_Left	WORD	OFF		;Comando para mover para esquerda

LINHA1NIVEL     STR 	'################################################################################', FIM_TEXTO
LINHA2NIVEL     STR 	'#=-=-=-=-=-=-PLACAR:00=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=VIDAS:00=-=-=-=-=-=-#', FIM_TEXTO
LINHA3NIVEL     STR 	'################################################################################', FIM_TEXTO
LINHA4NIVEL 	STR 	'#..............###########....................####.....###.....................#', FIM_TEXTO
LINHA5NIVEL 	STR 	'#..............###########....................####.....###.....................#', FIM_TEXTO
LINHA6NIVEL 	STR 	'#....######....##.......##....................####.............###.....###.....#', FIM_TEXTO
LINHA7NIVEL 	STR 	'#....######....##.......##...##############...####.............###.....###.....#', FIM_TEXTO
LINHA8NIVEL 	STR 	'#....######....#####.#####...##|zacharos|##...#########...########.....#########', FIM_TEXTO
LINHA9NIVEL 	STR 	'#....######....#####.#####...##############...#########...##...###.....###.....#', FIM_TEXTO
LINHA10NIVEL 	STR 	'#....######..................#####....#####...............##...###.....###.....#', FIM_TEXTO
LINHA11NIVEL 	STR 	'#....######....................................................###.............#', FIM_TEXTO
LINHA12NIVEL 	STR 	'#....######..................#####....#####....................###.............#', FIM_TEXTO
LINHA13NIVEL 	STR 	'#....######....#########################################.###...########...######', FIM_TEXTO
LINHA14NIVEL 	STR 	'#....######....#########################################.###...########...######', FIM_TEXTO
LINHA15NIVEL 	STR 	'#........................................................###...########...######', FIM_TEXTO
LINHA16NIVEL 	STR 	'#..............##############################.##########.###...................#', FIM_TEXTO
LINHA17NIVEL 	STR 	'###########....##############################.##########.###...................#', FIM_TEXTO
LINHA18NIVEL 	STR 	'###########....##############################.##########.###...................#', FIM_TEXTO
LINHA19NIVEL 	STR 	'#....................................................###.##############...######', FIM_TEXTO
LINHA20NIVEL 	STR 	'#......####....#######################...####.####...###.##############...######', FIM_TEXTO
LINHA21NIVEL 	STR 	'#......####....#######.........#######...##.....##...###.##########..........###', FIM_TEXTO
LINHA22NIVEL 	STR 	'#......####..............................##.....##...........................###', FIM_TEXTO
LINHA23NIVEL 	STR 	'#......####..............###.............##.....###################..........###', FIM_TEXTO
LINHA24NIVEL 	STR 	'################################################################################', FIM_TEXTO


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
; Rotina de Interrupção WriteCharacter
;------------------------------------------------------------------------------
;WriteCharacter: 
;				PUSH R1
;				PUSH R2
;
;
;
;				MOV		R1, 12d				;R1 = 12 = 00000000|00001100
;				SHL		R1, 8d				;R1 = shiftleft 8 = 00001100|00000000
;				MOV		R2, 40d				;R2 = 40 = 00000000|00101000
;				OR 		R1, R2				;R1 or R2 = 00001100|00000000 OR 00000000|00101000 = 00001100|00101000
;	
;				MOV M[CURSOR], R1			;M[CURSOR] = Endereço do cursos recebe = 00001100|00101000 = cursor agora está na coluna 40, linha 12.
;				MOV R1, 'A'					;R1 = 'A'
;				MOV M[IO_WRITE], R1			;M[IO_WRITE] = R1 = 'A'
;
;				POP  R2
;				POP  R1
;				RTI
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
				SHL 	R1, 8d
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

				CALL 	PrintString			;	Chama a função que imprime a string
				INC 	R2						;Acrescenta o contador em 1
				INC 	M[TextIndex]			;Acrescenta a posição da string em 1 (vai para a prox string)
				JMP 	WTELA					;Retorna para a comparação

	EWTELA: 	POP 	R2
				POP 	R1
				RET

;------------------------------------------------------------------------------
; Função SetPacman
;------------------------------------------------------------------------------
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
; Encerramento 	             ;
;----------------------------;
				POP 	R2
				POP 	R1
				RET

;------------------------------------------------------------------------------
; Função Score
;------------------------------------------------------------------------------
Score:			PUSH	R1
				
				MOV		R1, M[ScorePoint]
				INC		R1
				
				POP		R1
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
				SUB  	R1, COLUMN_JUMP			;Subtrai o suficiente na memória para checar a posição superir
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	UpBlock					;Se for, não iremos realizar nenhuma alteração

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				ADD 	R1, COLUMN_JUMP			;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				SUB		R1, COLUMN_JUMP			;Retorna o R1 para a posição futura
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
				ADD  	R1, COLUMN_JUMP			;Subtrai o suficiente na memória para checar a posição superir
				
				MOV 	R2, M[R1]				;R2 recebe o Caractér no endereço R1
				CMP		R2, '#'					;Verifica se R2 é o Caractér "#", que representa a parede
				JMP.Z 	BottomBlck				;Se for, não iremos realizar nenhuma alteração

				CMP		R2, '.'					;Verifica se o caractér é '.'
				CALL.Z	Score					;Se for, Marca um ponto

				;--------------------;
				; Modificar Endereço ;
				;--------------------;

				SUB 	R1, COLUMN_JUMP			;Retorna R1 ao endereço original
				MOV		R2, ' '					;Define R2 = ' '
				MOV		M[R1], R2				;"Valor" de R1 recebe "Valor" de R2, o ' ' no caso.
				ADD		R1, COLUMN_JUMP			;Retorna o R1 para a posição futura
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

				MOV 	R1, M[Pac_Move_Top]		;Guarda em R1 o valor se sinal da Variável que diz se o PacMan move-se ou não.
				CMP 	R1, ON					;Compara para checar se o valor está ligado
				CALL.Z 	MoveTop					;Caso esteja, executa a função de movimentação

				MOV 	R1, M[Pac_Move_Right]
				CMP 	R1, ON
				CALL.Z 	MoveRight

				MOV 	R1, M[Pac_Move_Left]
				CMP 	R1, ON
				CALL.Z 	MoveBottom

				MOV 	R1, M[Pac_Move_Bottom]
				CMP 	R1, ON
				CALL.Z 	MoveLeft

				CALL 	StartTimer				;"Dispara" o tempo para acontecer um ciclo 

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
				CALL 	SetPacman
				CALL	StartTimer

				
Cycle: 			BR		Cycle
Halt:           BR		Halt
 