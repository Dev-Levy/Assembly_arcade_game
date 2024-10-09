
Code	Segment
	assume CS:Code, DS:Data, SS:Stack

UNDERTALE db "Long ago, two races$"
UNDERTALE2 db "ruled over Earth:$"
UNDERTALE3 db "HUMANS and MONSTERS.$"

PLAYER DB "P$"
playerX DB 1
playerY DB 15

OBSTACLE DB "O$"
obstacleX DB 10
obstacleY DB 17

PLAY_AREA DB "________________________________________________________________________________"
playarea2 DB ,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,
playarea3 DB "_______________________________________________________________________________$"

VEGE DB "THE END! :($"

Start:
	mov	ax, Code
	mov	DS, AX

MainLoop:
	CALL ClearScreen

	CALL DrawTitle
	CALL DrawPlayArea
	CALL DrawPlayer
	; CALL DrawObstacle

	CALL MovePlayer

	JMP MainLoop

ClearScreen:
	MOV AX, 3
	INT 10H
	RET

MovePlayer:
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
	JE JATEK_VEGE

	JMP MovePlayer
	
MOZGAS_FEL:
	MOV AL, [playerY] 
	DEC AL
	MOV [playerY], AL
	JMP MovePlayerEnd


MOZGAS_LE:
	MOV AL, [playerY] 
	INC AL
	MOV [playerY], AL

	JMP MovePlayerEnd

MOZGAS_BALRA:
	MOV AL, [playerX] 
	DEC AL
	MOV [playerX], AL
	JMP MovePlayerEnd

MOZGAS_JOBBRA:
	MOV AL, [playerX] 
	INC AL
	MOV [playerX], AL
	JMP MovePlayerEnd

MovePlayerEnd:
	RET

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

	XOR AH, AH
	INT 16H

	jmp Program_Vege

DrawTitle:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,1
	MOV DL,30
	INT 10H

	MOV AH,9
	MOV DX, OFFSET UNDERTALE
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,2
	MOV DL,30
	INT 10H

	MOV AH,9
	MOV DX, OFFSET UNDERTALE2
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,3
	MOV DL,30
	INT 10H

	MOV AH,9
	MOV DX, OFFSET UNDERTALE3
	INT 21H
	RET


DrawPLayArea:
	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,5
	MOV DL,0
	INT 10H

	MOV AH,9
	MOV DX, OFFSET PLAY_AREA
	INT 21H
	RET

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

DrawObstacle:

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,[obstacleY]
	MOV DL,[obstacleX]
	INT 10H
	MOV AH,9
	MOV DX, OFFSET OBSTACLE
	INT 21H
	RET

Program_Vege:
	mov	ax, 4c00h
	int	21h


Code	Ends

Data	Segment

Data	Ends

Stack	Segment

Stack	Ends
	End	Start
