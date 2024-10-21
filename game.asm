
Code	Segment
	assume CS:Code, DS:Data, SS:Stack

TITLE1 DB "Is Sysiphus happy?$"
TITLE2 DB "He isn't pushing boulders, but the boulders pushing him$"

PLAYER DB "P$"
playerX DB 1
playerY DB 12

OBSTACLE DB "O$"
obstacleX DB 50
obstacleY DB 10

PLAY_AREA DB "________________________________________________________________________________$"
bottomBorder DB 5
topBorder DB 19

VEGE DB "Sysiphus died! :($"
WIN DB "Sysiphus is finally happy!$"

SCORE_STR DB "Score: "
SCORE_HUNDREDS DB "0"
SCORE_TENS DB "0"
SCORE_ONES DB "0"
SCORE_END DB "$"

RETRY DB "Try again? [y/n]$"

TICKS DW 0
TICKS2 DW 0

Start:
	mov	ax, Code
	mov	DS, AX

MainLoop:
	CALL GetTicks
	CALL ClearScreen
	CALL DrawTitle
	CALL DrawPlayArea
	CALL DrawScore

	CALL MoveObstacle
	CALL DrawObstacle

	CALL DrawPlayer

	CALL MovePlayer
	CALL CheckCollision
	CALL IncrementScore
	; CALL OneSecDelay
	JMP MainLoop

GetTicks:
	MOV AH, 0
	INT 1AH
	MOV [TICKS], CX
	MOV [TICKS2], DX
	RET

ClearScreen:
	MOV AX, 3
	INT 10H
	RET

MovePlayer:
	; MOV AH, 01H
	; INT 16H
	; JZ MovePlayerEnd

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
	MOV [obstacleX], 50
	MOV [obstacleY], 10
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

MoveObstacle:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,[obstacleY]
	MOV DL,[obstacleX]
	INT 10H

	DEC [obstacleX]
	CMP [obstacleX], -1
	JNE M_O_END

	MOV [obstacleX], 80

	M_O_END:
	RET
DrawObstacle:
	MOV AH,9
	MOV DX, OFFSET OBSTACLE
	INT 21H
	RET

IncrementScore:
	
	CMP [SCORE_HUNDREDS], "9"
	JNE S_S_continue
	CMP [SCORE_TENS], "9"
	JNE S_S_continue
	CMP [SCORE_ONES], "9"
	JNE S_S_continue
	;mindhárom 999
	;JMP WinScene
	
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

OneSecDelay:
	; MOV AH, 00H
	; INT 1AH
	; CMP DX, [TICKS2] + 18
	; JB OneSecDelay
	; RET

WinScene:
	CALL ClearScreen

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,12
	MOV DL,27
	INT 10H

	MOV AH,9
	MOV DX, OFFSET WIN
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
