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

ON				EQU		0d		; Estado Desligado. 
OFF				EQU		1d		; Estado Ligado.

PACMAN_CRT		EQU 	'Z'		; Caractér para represertar o PACMAN
PACMAN_SPAWN	EQU		5D9h	; 
COLUMN_JUMP		EQU		51h		;

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

Score			WORD	0d		;Variável que guarda a pontuação
Lifes 			WORD	3d		;Variável que guarda a quantidade de vidas

Pac_Column		WORD	0d		;Variável que guarda a posição atual do PAC (Coluna)
Pac_Row			WORD	0d		;Variável que guarda a posição atual do PAC (Linha)
Pac_Address		WORD	0d		;Variável que guarda a posição atual do PAC (Endereço)?

Pac_Move_Top	WORD	OFF		;Comando para mover para cima
Pac_Move_Right	WORD	OFF		;Comando para mover para direita
Pac_Move_Bottom	WORD	OFF		;Comando para mover para baixo
Pac_Move_Left	WORD	OFF		;;Comando para mover para esquerda

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
INT0           	WORD	Key_Pressed_Top
INT1			WORD	Key_Pressed_Right
INT2			WORD	Key_Pressed_Bottom
INT3			WORD	Key_Pressed_Left

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
PrintString:	PUSH R1
				PUSH R2
	
	WSTRING:	MOV R1, M[TextIndex]		;R1 = Pos de onde parou no texto
				MOV R1, M[R1]				;R1 = CHAR -> Posição do char no texto base

				CMP R1, FIM_TEXTO			;Se R1 == FIM_TEXTO ('@'), Fim da String, pula para EWSTRING
				JMP.Z EWSTRING				
				MOV M[IO_WRITE], R1			;Caso não, move para IO_WRITE o caracter que queremos escrever

				INC M[ColumnIndex]			;Adiciona + 1 na coordenada de colunas do cursor
				INC M[TextIndex]			;Passa o marcador para a próxima letra

				MOV R1, M[RowIndex]			;Redefinindo o cursor -> Definindo parte esquerda (linha)
				SHL R1, ROW_SHIFT			;Formatando parte esquerda
				MOV R2, M[ColumnIndex]		;definindo parte direita (coluna)
				OR R1, R2					;juntando ambas as partes

				MOV M[CURSOR], R1			;Define cursos como o "frame" que queremos inserir
				JMP WSTRING					;Retorna para repetir o processo até o fim de linha

	EWSTRING:	INC M[RowIndex]
				MOV R1, 0d
				MOV M[ColumnIndex], R1
				MOV R1, M[RowIndex]
				SHL R1, 8d
				MOV M[CURSOR], R1
				
				POP R2
				POP R1
				RET
;------------------------------------------------------------------------------
; Função PrintTela
;------------------------------------------------------------------------------
PrintTela: 		PUSH R1						
				PUSH R2						
				MOV R1, LINHA1NIVEL			;R1 recebe a string da primeira linha da Tela
				MOV M[TextIndex], R1		;Guarda a primeira posição da primeira string
				MOV R2, 0d 					;R2 = 0 para contar quantas strings imprimiremos

	WTELA:		CMP R2, 24d					;Compara R2 com 24, quando for 24, todas as strings estarão na tela
				JMP.Z EWTELA				;Pula para o fim caso a comparão acima dê TRUE

				CALL PrintString			;Chama a função que imprime a string
				INC R2						;Acrescenta o contador em 1
				INC M[TextIndex]			;Acrescenta a posição da string em 1 (vai para a prox string)
				JMP WTELA					;Retorna para a comparação

	EWTELA: 	POP R2
				POP R1
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

				
Cycle: 			BR		Cycle
Halt:           BR		Halt
 