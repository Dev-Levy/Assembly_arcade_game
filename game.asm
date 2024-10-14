
Code	Segment
	assume CS:Code, DS:Data, SS:Stack

TITLE1 DB "Is Sysiphus happy?$"
TITLE2 DB "He isn't pushing boulders, but the boulders pushing him$"

PLAYER DB "P$"
playerX DB 1
playerY DB 12

OBSTACLE DB "O$"
; obstacleX DB 50
; obstacleY DB 10

PLAY_AREA DB "________________________________________________________________________________$"
topBorder DB 5
bottomBorder DB 19

VEGE DB "Sysiphus died! :($"

Start:
	mov	ax, Code
	mov	DS, AX

MainLoop:
	CALL ClearScreen
	CALL DrawTitle
	CALL DrawPlayArea
	Call DrawObstacles
	; CALL MoveObstacles

	CALL DrawPlayer

	CALL MovePlayer
	CALL CheckCollision

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

CheckCollision:

	mov ah, 02h ;Set cursor position
	mov bh, 0
	mov dh, [playerY]
	mov dl, [playerX]
	int 10h

	mov ah, 08h ;Read character at cursor
    xor bh, bh       
    int 10h

	cmp al, [OBSTACLE]; character is obstacle
	JZ JATEK_VEGE

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
	MOV DX, OFFSET TITLE1
	INT 21H

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH,2
	MOV DL,20
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


DrawObstacles:

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, 8
	MOV DL, 35
	INT 10H
	CALL DrawObstacle

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, 15
	MOV DL, 50
	INT 10H
	CALL DrawObstacle

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, 7
	MOV DL, 20
	INT 10H
	CALL DrawObstacle

	MOV AH,2 ; SET CURSOR POSITION
	XOR BH,BH
	MOV DH, 17
	MOV DL, 10
	INT 10H
	CALL DrawObstacle

	RET


MoveObstacles:
	; MOV DH, 10
	; MOV DL, 40
	; XOR BH,BH
	; CALL MoveObstacle

	; MOV DH, 11
	; MOV DL, 41
	; XOR BH,BH
	; CALL MoveObstacle

	; MOV DH, 12
	; MOV DL, 42
	; XOR BH,BH
	; CALL MoveObstacle

	MOV DH, 13
	MOV DL, 43
	XOR BH,BH
	CALL MoveObstacle

	RET

MoveObstacle:
	MOV AH, 02h ; Set cursor position
	INT 10h
	CALL DrawObstacle
	CALL wait_1_sec
	; Erase the current character by printing a space
    mov ah, 09h        ; BIOS function 09h - Write character and attribute
    mov al, ' '        ; Print space to "erase" the character
    mov bl, 07h        ; White on black attribute
    mov cx, 1          ; Print one space
    int 10h            ; Call BIOS to erase character

    ; Move left by decreasing the column (dl)
    dec dl             ; Decrement column to move left
    cmp dl, 0          ; Check if we've reached the leftmost column
    jl done            ; If dl < 0, end the program
	jmp MoveObstacle

	done:
		RET

wait_1_sec:
	mov ah, 00h        ; Get system time
	int 1Ah            ; BIOS timer interrupt
	mov dx, bx         ; Store current time
	add dx, 18         ; Add 18 ticks (~1 second delay)
wait_loop:
	mov ah, 00h        ; Get system time again
	int 1Ah            ; BIOS timer interrupt
	cmp bx, dx         ; Compare current tick count with target
	jb wait_loop       ; If not reached target, keep waiting
RET

DrawObstacle:
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
