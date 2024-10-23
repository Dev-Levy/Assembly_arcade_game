
Code	Segment
	assume CS:Code, DS:Data, SS:Stack

TITLE1 DB "Is Sysiphus happy?$"
TITLE2 DB "He isn't pushing boulders, but the boulders pushing him$"

PLAYER DB "S$"
playerX DB 1
playerY DB 12

OBSTACLE DB "O$"
obstacles: 
	obstacle0X DB 55
	obstacle0Y DB 18
	
	obstacle1X DB 67
	obstacle1Y DB 16

	obstacle2X DB 71
	obstacle2Y DB 14

	obstacle3X DB 58
	obstacle3Y DB 12

	obstacle4X DB 69
	obstacle4Y DB 7

	obstacle5X DB 72
	obstacle5Y DB 9

	obstacle6X DB 56
	obstacle6Y DB 11

	obstacle7X DB 62
	obstacle7Y DB 13

	obstacle8X DB 77
	obstacle8Y DB 15

	obstacle9X DB 70
	obstacle9Y DB 17

COIN DB "+$"
COIN_X DB 10
COIN_Y DB 10

COINX DB "59995959958597669669858766759895865676678669575577695588595966859998659676855659957659855658856896755999595995859766966985876675989586567667866957557769558859596685999865967685565995765985565885689675$"
COINY DB "85855655675765558877669569858888858797585776969677677576686588777887669857788858875885569795599687798585565567576555887766956985888885879758577696967767757668658877788766985778885887588556979559968779$"

PLAY_AREA DB "________________________________________________________________________________$"
bottomBorder DB 5
topBorder DB 19

VEGE DB "Sysiphus died! :($"
WIN DB "Sysiphus is finally happy!$"
WIN2 DB "He is free from his boulders!$"
WIN3 DB "Is it what happiness would be?$"

SCORE_STR DB "Score: "
SCORE_HUNDREDS DB "0"
SCORE_TENS DB "0"
SCORE_ONES DB "0"
SCORE_END DB "$"

RETRY DB "Try again? [y/n]$"

SEC_DX dw 0
CLS_DX dw 0

Start:
	mov	ax, Code
	mov	DS, AX

	mov ah, 00h
    int 1Ah 

	MOV [SEC_DX], DX
	MOV [CLS_DX], DX

	mov SI, OFFSET COINX
    mov DI, OFFSET COINY

MainLoop:
	framewait:
		MOV AH, 00H
		INT 1AH

		MOV BX, DX
		SUB BX, [CLS_DX]

		CMP BX, 2 ; 1/18 sec = 1 frame == 55ms
		JB MainLoop 

		MOV [CLS_DX], DX

	setup_and_draw:
		CALL ClearScreen
		CALL DrawTitle
		CALL DrawPlayArea
		CALL DrawCoin
		CALL DrawScore
		CALL DrawPlayer

	game:
		CALL MoveObstacles
		CALL MovePlayer
		CALL CheckCollision
		CALL IncrementScore
		CALL AddScore

	after_frame:
		CALL CursorSet
		CALL EmptyBuffer
	JMP MainLoop

CursorSet:
	MOV AH, 01H
	MOV CH, 20H
	MOV CL, 20H
	INT 10H
	RET
ClearScreen:
	MOV AX, 3
	INT 10H

	CLS_End:
	RET

MovePlayer:
	MOV AH, 01H
	INT 16H
	JZ MovePlayerEnd

	XOR AH, AH
	INT 16H

	; WASD MovePlayer
	CMP AL, 'w'
	JE MOZGAS_FEL
	CMP AL, 'a'
	JE MOZGAS_BALRA
	CMP AL, 's'
	JE MOZGAS_LE
	CMP AL, 'd'
	JE MOZGAS_JOBBRA

	CMP AL, 1bh ; ESC
	JE JumpToEnd

MOZGAS_FEL:
	DEC [playerY]

	CALL CheckBorders
	CMP AL, '_'
	JE MOZGAS_LE

	JMP MovePlayerEnd


MOZGAS_LE:
	INC [playerY]

	CALL CheckBorders
	CMP AL, '_'
	JE MOZGAS_FEL

	JMP MovePlayerEnd

MOZGAS_BALRA:
	DEC [playerX]

	CMP [PLAYERX], -1
	JE MOZGAS_JOBBRA

	JMP MovePlayerEnd

MOZGAS_JOBBRA:
	INC [playerX]

	CMP [PLAYERX], 80
	JE MOZGAS_BALRA
	JMP MovePlayerEnd

MovePlayerEnd:
	RET
CheckBorders:
	mov ah, 02h ;Set cursor
	xor bh, bh
	mov dh, [playerY]
	mov dl, [playerX]
	int 10h

	mov ah, 08h ;Read character
    xor bh, bh
    int 10h

	RET
JumpToEnd:
	JMP JATEK_VEGE
ResetGame:
	MOV [playerX], 1
	MOV [playerY], 12

	MOV COIN_X, 10
	MOV COIN_Y, 10
	mov SI, OFFSET COINX
    mov DI, OFFSET COINY
	
	CALL obs_reset

	MOV [SCORE_HUNDREDS], "0"
	MOV [SCORE_TENS], "0"
	MOV [SCORE_ONES], "0"

	JMP MainLoop

JATEK_VEGE:
	CALL ClearScreen
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,10
	MOV DL,30
	INT 10H

	MOV AH,9
	MOV DX, OFFSET VEGE
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,11
	MOV DL,34
	INT 10H
	MOV AH,9
	MOV DX, OFFSET SCORE_STR
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,13
	MOV DL,30
	INT 10H
	MOV AH,9
	MOV DX, OFFSET RETRY
	INT 21H

	XOR AH, AH
	INT 16H

	CMP AL, 'y'
	JE ResetGame

	jmp Program_Vege

CheckCollision:

	mov ah, 02h ;Set cursor position
	xor bh, bh
	mov dh, [playerY]
	mov dl, [playerX]
	int 10h

	mov ah, 08h ;Read character at cursor
    xor bh, bh
    int 10h

	cmp al, [OBSTACLE]; character is obstacle
	JZ JATEK_VEGE

	RET
DrawTitle:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,1
	MOV DL,30
	INT 10H

	MOV AH,9
	MOV DX, OFFSET TITLE1
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,2
	MOV DL,15
	INT 10H

	MOV AH,9
	MOV DX, OFFSET TITLE2
	INT 21H

	RET


DrawPLayArea:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, [topBorder]
	MOV DL,0
	INT 10H

	MOV AH,9
	MOV DX, OFFSET PLAY_AREA
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, [bottomBorder]
	MOV DL,0
	INT 10H

	MOV AH,9
	MOV DX, OFFSET PLAY_AREA
	INT 21H

	RET
DrawCoin:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, [COIN_Y]
	MOV DL, [COIN_X]
	INT 10H

	MOV AH,9
	MOV DX, OFFSET COIN
	INT 21H
	RET
DrawScore:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, [topBorder] - 1
	MOV DL, 68
	INT 10h

	MOV AH,9
	MOV DX, OFFSET SCORE_STR
	INT 21H

DrawPlayer:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,[playerY]
	MOV DL,[playerX]
	INT 10H

	MOV AH,9
	MOV DX, OFFSET PLAYER
	INT 21H
	RET

MoveObstacles:

	obs00:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle0Y]
		MOV DL,[obstacle0X]
		INT 10H

		DEC [obstacle0X]
		CMP [obstacle0X], -1
		JNE draw0

		MOV [obstacle0X], 79

		draw0:
		CALL DrawObstacle
	
	obs01:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle1Y]
		MOV DL,[obstacle1X]
		INT 10H

		DEC [obstacle1X]
		CMP [obstacle1X], -1
		JNE draw1

		MOV [obstacle1X], 79

		draw1:
		CALL DrawObstacle

	obs02:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle2Y]
		MOV DL,[obstacle2X]
		INT 10H

		DEC [obstacle2X]
		CMP [obstacle2X], -1
		JNE draw2

		MOV [obstacle2X], 79

		draw2:
		CALL DrawObstacle

	obs03:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle3Y]
		MOV DL,[obstacle3X]
		INT 10H

		DEC [obstacle3X]
		CMP [obstacle3X], -1
		JNE draw3

		MOV [obstacle3X], 79

		draw3:
		CALL DrawObstacle
	CMP [SCORE_HUNDREDS], "3"
	JB int_jmp
	obs04:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle4Y]
		MOV DL,[obstacle4X]
		INT 10H

		DEC [obstacle4X]
		CMP [obstacle4X], -1
		JNE draw4

		MOV [obstacle4X], 79

		draw4:
		CALL DrawObstacle

	obs05:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle5Y]
		MOV DL,[obstacle5X]
		INT 10H

		DEC [obstacle5X]
		CMP [obstacle5X], -1
		JNE draw5

		MOV [obstacle5X], 79

		draw5:
		CALL DrawObstacle
	int_jmp:
	obs06:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle6Y]
		MOV DL,[obstacle6X]
		INT 10H

		DEC [obstacle6X]
		CMP [obstacle6X], -1
		JNE draw6

		MOV [obstacle6X], 79

		draw6:
		CALL DrawObstacle
	CMP [SCORE_HUNDREDS], "1"
	JB mo_end
	obs07:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle7Y]
		MOV DL,[obstacle7X]
		INT 10H

		DEC [obstacle7X]
		CMP [obstacle7X], -1
		JNE draw7

		MOV [obstacle7X], 79

		draw7:
		CALL DrawObstacle
		
	obs08:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle8Y]
		MOV DL,[obstacle8X]
		INT 10H

		DEC [obstacle8X]
		CMP [obstacle8X], -1
		JNE draw8

		MOV [obstacle8X], 79

		draw8:
		CALL DrawObstacle

	obs09:
		MOV AH,2 ; SET CURSOR POSITION
		XOR BH,BH
		MOV DH,[obstacle9Y]
		MOV DL,[obstacle9X]
		INT 10H

		DEC [obstacle9X]
		CMP [obstacle9X], -1
		JNE draw9

		MOV [obstacle9X], 79

		draw9:
		CALL DrawObstacle
	
	mo_end:
	RET

DrawObstacle:
	MOV AH,9
	MOV DX, OFFSET OBSTACLE
	INT 21H
	RET

EmptyBuffer:
    MOV AH, 01H
    INT 16H
    JZ BufferEmpty ; Jump if no key is available

    MOV AH, 00H
    INT 16H
    JMP EmptyBuffer ; Continue clearing the buffer

	BufferEmpty:
    RET

IncrementScore:
	onesecondcheck:
		MOV AH, 00H
		INT 1AH

		MOV BX, DX
		sub bx, [SEC_DX]

		CMP BX, 18; 1 sec = 18
		JB S_S_End 

		MOV [SEC_DX], DX

	incrementing:
		CMP [SCORE_HUNDREDS], ":"
		JNE mindharom
		JMP WinScene

		mindharom:
		CMP [SCORE_HUNDREDS], "9"
		JNE S_S_continue
		CMP [SCORE_TENS], "9"
		JNE S_S_continue
		CMP [SCORE_ONES], "9"
		JNE S_S_continue

		;mindhárom 999
		JMP WinScene
		
		S_S_continue:
		CMP [SCORE_TENS], "9"
		JNE NoHundreds
		CMP [SCORE_ONES], "9"
		JE IncrementHundred

		NoHundreds:
		CMP [SCORE_ONES], "9"
		JNE NoTens
		INC [SCORE_TENS]
		MOV [SCORE_ONES], "0"
		JMP S_S_End

		NoTens:
		INC [SCORE_ONES]
		JMP S_S_End

		IncrementHundred:
		INC [SCORE_HUNDREDS]
		MOV [SCORE_TENS], "0"
		MOV [SCORE_ONES], "0"
		JMP S_S_End

	S_S_End:
	RET

AddScore:
	mov ah, 02h ;Set cursor position
	xor bh, bh
	mov dh, [playerY]
	mov dl, [playerX]
	int 10h

	mov ah, 08h ;Read character at cursor
    xor bh, bh
    int 10h

	cmp al, [COIN]; character is coin
	JNE add_end

	randomize_pos:
		MOV AL, [SI]
		SUB AL, '0'
		MOV BL, [DI]
		SUB BL, '0'
		ADD [COIN_X], AL
		ADD [COIN_Y], BL
		INC SI
		INC DI

	check_pos:
		CMP [COIN_Y], 18
		JB pos_bottom_ok
		SUB [COIN_Y], 12
		pos_bottom_ok:

		CMP [COIN_Y], 5
		JA pos_top_ok
		ADD [COIN_Y], 13
		pos_top_ok:

	ADD [SCORE_TENS], 2 ; +20 score

	CMP [SCORE_TENS], "9"
	JNA add_end
	INC [SCORE_HUNDREDS]
	mov [SCORE_TENS], "0"
	add_end:
	RET
obs_reset:
		MOV [obstacle0X], 55
		MOV [obstacle0Y], 18
		MOV [obstacle1X], 67
		MOV [obstacle1Y], 16

		MOV [obstacle2X], 71
		MOV [obstacle2Y], 14

		MOV [obstacle3X], 58
		MOV [obstacle3Y], 12

		MOV [obstacle4X], 69
		MOV [obstacle4Y], 7

		MOV [obstacle5X], 72
		MOV [obstacle5Y], 9

		MOV [obstacle6X], 56
		MOV [obstacle6Y], 11

		MOV [obstacle7X], 62
		MOV [obstacle7Y], 13

		MOV [obstacle8X], 77
		MOV [obstacle8Y], 15

		MOV [obstacle9X], 70
		MOV [obstacle9Y], 17

		RET
WinScene:
	CALL ClearScreen

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,12
	MOV DL,25
	INT 10H

	MOV AH,9
	MOV DX, OFFSET WIN
	INT 21h

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,13
	MOV DL,24
	INT 10H

	MOV AH,9
	MOV DX, OFFSET WIN2
	INT 21h

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,14
	MOV DL,23
	INT 10H

	MOV AH,9
	MOV DX, OFFSET WIN3
	INT 21h

	XOR AH, AH
	INT 16H 

Program_Vege:
	mov	ax, 4c00h
	int	21h


Code	Ends

Data	Segment

Data	Ends

Stack	Segment

Stack	Ends
	End	Start
