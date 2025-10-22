org 100h
; ------------------------------
; Balloon Popping Game - Main Menu
; Combined background + menu items
; ------------------------------
jmp main_menu

; ===== COLOR DEFINITIONS =====
ColorHolder db 0
write_word dw 0

white: dw 302
blue: dw 301
red: dw 300
black: dw 303

; ===== RECTANGLE POSITIONS =====
x1: dw 60
y1: dw 50
w1: dw 200
h1: dw 20

x2: dw 60
y2: dw 100
w2: dw 200
h2: dw 20

x3: dw 60
y3: dw 150
w3: dw 200
h3: dw 20


; -------------------------------------
; Balloon bitmap data (16x24 pixels)
; Three separate bitmaps for layers
; -------------------------------------
Balloon_body:
    dw 0000011111000000b  ; row 0 - top of balloon
    dw 0001111111110000b  ; row 1
    dw 0011111111111000b  ; row 2
    dw 0111111111111100b  ; row 3
    dw 0111111111111110b  ; row 4
    dw 1111111111111111b  ; row 5
    dw 1111111111111111b  ; row 6 - widest part
    dw 1111111111111111b  ; row 7
    dw 1111111111111111b  ; row 8
    dw 1111111111111111b  ; row 9
    dw 1111111111111111b  ; row 10
    dw 1111111111111111b  ; row 11
    dw 0111111111111110b  ; row 12 - narrowing
    dw 0111111111111110b  ; row 13
    dw 0011111111111100b  ; row 14
    dw 0001111111111000b  ; row 15
    dw 0000111111110000b  ; row 16
    dw 0000011111100000b  ; row 17 - bottom of balloon
    dw 0000000110000000b  ; row 18 - tie/knot
    dw 0000000110000000b  ; row 19
    dw 0000000000000000b  ; row 20 - string area (body layer empty)
    dw 0000000000000000b  ; row 21
    dw 0000000000000000b  ; row 22
    dw 0000000000000000b  ; row 23

Balloon_shadow:
    dw 0000000000000000b  ; row 0
    dw 0000000000000000b  ; row 1
    dw 0001110000000000b  ; row 2 - highlight starts
    dw 0011100000000000b  ; row 3
    dw 0011000000000000b  ; row 4
    dw 0110000000000000b  ; row 5
    dw 0100000000000000b  ; row 6
    dw 0000000000000000b  ; row 7
    dw 0000000000000000b  ; row 8
    dw 0000000000000000b  ; row 9
    dw 0000000000000000b  ; row 10
    dw 0000000000000000b  ; row 11
    dw 0000000000000000b  ; row 12
    dw 0000000000000000b  ; row 13
    dw 0000000000000000b  ; row 14
    dw 0000000000000000b  ; row 15
    dw 0000000000000000b  ; row 16
    dw 0000000000000000b  ; row 17
    dw 0000000000000000b  ; row 18
    dw 0000000000000000b  ; row 19
    dw 0000000000000000b  ; row 20
    dw 0000000000000000b  ; row 21
    dw 0000000000000000b  ; row 22
    dw 0000000000000000b  ; row 23

Balloon_string:
    dw 0000000000000000b  ; row 0
    dw 0000000000000000b  ; row 1
    dw 0000000000000000b  ; row 2
    dw 0000000000000000b  ; row 3
    dw 0000000000000000b  ; row 4
    dw 0000000000000000b  ; row 5
    dw 0000000000000000b  ; row 6
    dw 0000000000000000b  ; row 7
    dw 0000000000000000b  ; row 8
    dw 0000000000000000b  ; row 9
    dw 0000000000000000b  ; row 10
    dw 0000000000000000b  ; row 11
    dw 0000000000000000b  ; row 12
    dw 0000000000000000b  ; row 13
    dw 0000000000000000b  ; row 14
    dw 0000000000000000b  ; row 15
    dw 0000000000000000b  ; row 16
    dw 0000000000000000b  ; row 17
    dw 0000000000000000b  ; row 18
    dw 0000000000000000b  ; row 19
    dw 0000001100000000b  ; row 20 - string curves
    dw 0000000110000000b  ; row 21
    dw 0000001100000000b  ; row 22
    dw 0000000110000000b  ; row 23

; Temporary storage for current row being drawn
CurrentRow_Body dw 0
CurrentRow_Shadow dw 0
CurrentRow_String dw 0
BalloonColor db 0
; ===== FONT DATA (8x8 BITMAPS) =====
A_data db 00011000b, 00100100b, 01000010b, 01111110b
       db 01000010b, 01000010b, 00000000b, 00000000b

B_data db 01111100b, 01000010b, 01111100b, 01000010b
       db 01000010b, 01111100b, 00000000b, 00000000b

C_data db 00111110b, 01000000b, 01000000b, 01000000b
       db 01000000b, 00111110b, 00000000b, 00000000b

D_data db 01111100b, 01000010b, 01000010b, 01000010b
       db 01000010b, 01111100b, 00000000b, 00000000b

E_data db 01111110b, 01000000b, 01111100b, 01000000b
       db 01000000b, 01111110b, 00000000b, 00000000b

F_data db 01111110b, 01000000b, 01111100b, 01000000b
       db 01000000b, 01000000b, 00000000b, 00000000b

G_data db 00111110b, 01000000b, 01001110b, 01000010b
       db 01000010b, 00111100b, 00000000b, 00000000b

H_data db 01000010b, 01000010b, 01111110b, 01000010b
       db 01000010b, 01000010b, 00000000b, 00000000b

I_data db 00111100b, 00010000b, 00010000b, 00010000b
       db 00010000b, 00111100b, 00000000b, 00000000b

J_data db 00011110b, 00001000b, 00001000b, 01001000b
       db 01001000b, 00110000b, 00000000b, 00000000b

K_data db 01000010b, 01000100b, 01111000b, 01001000b
       db 01000100b, 01000010b, 00000000b, 00000000b

L_data db 01000000b, 01000000b, 01000000b, 01000000b
       db 01000000b, 01111110b, 00000000b, 00000000b

M_data db 01000010b, 01100110b, 01011010b, 01000010b
       db 01000010b, 01000010b, 00000000b, 00000000b

N_data db 01000010b, 01100010b, 01010010b, 01001010b
       db 01000110b, 01000010b, 00000000b, 00000000b

O_data db 00111100b, 01000010b, 01000010b, 01000010b
       db 01000010b, 00111100b, 00000000b, 00000000b

P_data db 01111100b, 01000010b, 01000010b, 01111100b
       db 01000000b, 01000000b, 00000000b, 00000000b

Q_data db 00111100b, 01000010b, 01000010b, 01000010b
       db 01000010b, 00111110b, 00000001b, 00000000b

R_data db 01111100b, 01000010b, 01111100b, 01001000b
       db 01000100b, 01000010b, 00000000b, 00000000b

S_data db 00111110b, 01000000b, 00111100b, 00000010b
       db 00000010b, 01111100b, 00000000b, 00000000b

T_data db 01111110b, 00010000b, 00010000b, 00010000b
       db 00010000b, 00010000b, 00000000b, 00000000b

U_data db 01000010b, 01000010b, 01000010b, 01000010b
       db 01000010b, 00111100b, 00000000b, 00000000b

V_data db 01000010b, 01000010b, 01000010b, 00100100b
       db 00100100b, 00011000b, 00000000b, 00000000b

W_data db 01000010b, 01000010b, 01000010b, 01011010b
       db 01100110b, 01000010b, 00000000b, 00000000b

X_data db 01000010b, 00100100b, 00011000b, 00011000b
       db 00100100b, 01000010b, 00000000b, 00000000b

Y_data db 01000001b, 00100010b, 00010100b, 00001000b
       db 00001000b, 00001000b, 00000000b, 00000000b

Z_data db 00111100b, 00000100b, 00001000b, 00010000b
       db 00100000b, 00111100b, 00000000b, 00000000b
	   
one_data  db 00001000b
          db 00011000b
          db 00001000b
          db 00001000b
          db 00001000b
          db 00001000b
          db 00111110b
          db 00000000b

two_data  db 00111100b
          db 01000010b
          db 00000010b
          db 00001100b
          db 00110000b
          db 01000000b
          db 01111110b
          db 00000000b

three_data db 01111100b
           db 00000010b
           db 00000010b
           db 00111100b
           db 00000010b
           db 00000010b
           db 01111100b
           db 00000000b

four_data db 01000100b
          db 01000100b
          db 01000100b
          db 01111110b
          db 00000100b
          db 00000100b
          db 00000100b
          db 00000000b

five_data db 01111110b
          db 01000000b
          db 01000000b
          db 01111100b
          db 00000010b
          db 00000010b
          db 01111100b
          db 00000000b

six_data  db 00111100b
          db 01000000b
          db 01000000b
          db 01111100b
          db 01000010b
          db 01000010b
          db 00111100b
          db 00000000b

seven_data db 01111110b
           db 00000010b
           db 00000100b
           db 00001000b
           db 00010000b
           db 00010000b
           db 00010000b
           db 00000000b

eight_data db 00111100b
           db 01000010b
           db 01000010b
           db 00111100b
           db 01000010b
           db 01000010b
           db 00111100b
           db 00000000b

nine_data db 00111100b
          db 01000010b
          db 01000010b
          db 00111110b
          db 00000010b
          db 00000010b
          db 00111100b
          db 00000000b

; ===== BACKGROUND FILE DATA =====
filename db "finalmu.raw", 0
chunkSize equ 8192
buffer times chunkSize db 0

align 16
palette:
    incbin "vga_palette.bin"   ; 768 bytes (256*3)

drawBackground:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es

    ; --- Load VGA palette ---
    xor bx, bx
    mov cx, 256
    push cs
    pop es
    mov dx, palette
    mov ax, 0x1012
    int 0x10

    ; --- Set ES to video memory ---
    mov ax, 0xA000
    mov es, ax
    xor di, di

    ; --- Open file ---
    mov dx, filename
    mov ah, 0x3D
    xor al, al
    int 0x21
    jc file_error
    mov bx, ax          ; BX = file handle

read_loop:
    ; Read chunk
    mov ah, 0x3F
    mov cx, chunkSize
    mov dx, buffer
    int 0x21
    or ax, ax
    jz finished_reading ; EOF reached

    ; Copy AX bytes from DS:buffer to ES:DI
    push ds
    push es
    mov si, buffer
    mov cx, ax
    rep movsb
    pop es
    pop ds
    jmp read_loop

finished_reading:
    ; Close file
    mov ah, 0x3E
    int 0x21

file_error:
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
	
	
	; -------------------------------------
; DrawBalloon
; Draws 16x24 balloon sprite (16 wide, 24 tall)
; Call convention:
;   CX = x (top-left), DX = y (top-left), AL = balloon color
; String is always black (0), shadow is always white (15)
; -------------------------------------
DrawBalloon:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    mov [BalloonColor], al  ; save balloon color
    mov si, 0               ; SI = row index (0-23)
    
RowLoop_Balloon:
    ; Get bitmap words for this row
    mov bx, si
    shl bx, 1               ; multiply by 2 (each row is 2 bytes)
    
    ; Get balloon body bitmap
    mov ax, [Balloon_body + bx]
    mov [CurrentRow_Body], ax
    
    ; Get shadow bitmap
    mov ax, [Balloon_shadow + bx]
    mov [CurrentRow_Shadow], ax
    
    ; Get string bitmap
    mov ax, [Balloon_string + bx]
    mov [CurrentRow_String], ax
    
    push cx                 ; save start X for this row
    mov bp, 16              ; BP = bit counter (16 bits per row)
    
ColLoop_Balloon:
    ; Check string first (highest priority - black)
    mov ax, [CurrentRow_String]
    test ax, 8000h          ; check MSB
    jnz DrawString_Balloon
    
    ; Check shadow (white)
    mov ax, [CurrentRow_Shadow]
    test ax, 8000h
    jnz DrawShadow_Balloon
    
    ; Check balloon body (colored)
    mov ax, [CurrentRow_Body]
    test ax, 8000h
    jnz DrawBody_Balloon
    
    ; If none, skip (transparent)
    jmp NextPixel_Balloon
    
DrawString_Balloon:
    push cx
    push dx
    mov al, [black]               ; black color for string
    call DrawPixel
    pop dx
    pop cx
    jmp NextPixel_Balloon
    
DrawShadow_Balloon:
    push cx
    push dx
    mov al, [white]              ; white color for shadow
    call DrawPixel
    pop dx
    pop cx
    jmp NextPixel_Balloon
    
DrawBody_Balloon:
    push cx
    push dx
    mov al, [BalloonColor]  ; use balloon color
    call DrawPixel
    pop dx
    pop cx
    
NextPixel_Balloon:
    ; Shift all bitmaps left for next pixel
    shl word [CurrentRow_Body], 1
    shl word [CurrentRow_Shadow], 1
    shl word [CurrentRow_String], 1
    
    inc cx                  ; move to next X
    dec bp
    jnz ColLoop_Balloon
    
    pop cx                  ; restore start X
    inc dx                  ; move to next Y (row)
    inc si                  ; next row index
    cmp si, 24              ; done all 24 rows?
    jl RowLoop_Balloon
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; -------------------------------------
; DrawPixel
; Draw single pixel at (CX, DX) with color AL
; -------------------------------------
DrawPixel:
    push ax
    push bx
    push cx
    push dx
    push di
    
    push ax                 ; save color (AL)
    
    ; Calculate offset: y * 320 + x
    mov ax, dx              ; AX = y
    mov bx, 320
    mul bx                  ; DX:AX = y * 320
    add ax, cx              ; AX = y * 320 + x
    mov di, ax              ; DI = offset
    
    pop ax                  ; restore color
    mov byte [es:di], al    ; write pixel
    
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

DrawBlock:
    push ax
    push bx
    push cx
    push dx
    push di
    push bp
    
    mov al, [ColorHolder]
    mov bp, si
    
    mov bx, 0
RowLoop_DB:
    push ax
    mov ax, dx
    add ax, bx
    push dx
    mov dx, 320
    mul dx
    pop dx
    add ax, cx
    mov di, ax
    pop ax
    
    push bx
    mov bx, bp
ColLoop_DB:
    mov byte [es:di], al
    inc di
    dec bx
    jnz ColLoop_DB
    
    pop bx
    inc bx
    cmp bx, bp
    jl RowLoop_DB
    
    pop bp
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; -------------------------------------
; DrawA
; Draws 8x8 bitmap scaled by SI
; -------------------------------------
DrawA:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    mov bp, si
    mov si, 0
    
RowLoop_DA:
    mov bx, [write_word]
    add bx, si
    mov al, [bx]
    
    mov bl, 8
    push cx
    
ColLoop_DA:
    test al, 10000000b
    jz SkipPixel_DA
    
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, bp
    call DrawBlock
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
SkipPixel_DA:
    shl al, 1
    add cx, bp
    dec bl
    jnz ColLoop_DA
    
    pop cx
    add dx, bp
    inc si
    cmp si, 8
    jl RowLoop_DA
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; -------------------------------------
; clearScreen
; -------------------------------------
clearScreen:
    xor ax, ax
    mov di, 0
    mov cx, 320*200
    rep stosb
    ret

; -------------------------------------
; drawRectangle
; bp + 4 = height, bp + 6 = width
; bp + 8 = y, bp + 10 = x, bp + 12 = color
; -------------------------------------
drawRectangle:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ax, [bp + 8]
    mov bx, 320
    mul bx
    add ax, [bp + 10]
    mov si, ax
    mov cx, ax
    
    mov di, ax
    add di, [bp + 6]
    
    mov ax, [bp + 8]
    add ax, [bp + 4]
    mul bx
    add ax, [bp + 10]
    
    mov dl, [bp + 12]
Top_Left_to_Top_Right:
    mov [es:si], dl
    inc si
    cmp si, di
    jbe Top_Left_to_Top_Right
    add cx, 320
    mov si, cx
    add di, 320
    cmp si, ax
    jbe Top_Left_to_Top_Right
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 10

drawBoundary:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push di
	push si
	
	; bp + 4 = h
	; bp + 6 = w
	; bp + 8 = y
	; bp + 10 = x
	; bp + 12 = color
	
	mov ax, 0xa000
	mov es, ax
	mov dx, [bp + 12]
	
	mov ax, [bp + 8]
    mov bx, 320
    mul bx
    add ax, [bp + 10]
    mov si, ax                ; si at its start point
    mov cx, ax                ; storing si in cx for later use
    
    mov ax, [bp + 4]
	add ax, [bp + 8]
	mul bx
	add ax, [bp + 10]
	mov di, ax                ; si at its start point
	
	add ax, [bp + 6]

	mov bx, CX
	add bx, [bp + 6]
	
	
	
loop_b1:
	mov [es:si], dx
	mov [es:di], dx
	
	add si, 1
	add di, 1
	
	cmp si, bx
	jbe loop_b1
	cmp di, ax
	jbe loop_b1
	
	
	mov si, CX       ; si back at its start 
	mov di, bx       ; di at its new start
	
	mov bx, ax
	sub bx, [bp + 6]
	
	

loop_b2:
	mov [es:si], dx
	mov [es:di], dx
	
	add si, 320
	add di, 320
	
	cmp si, bx
	jbe loop_b2
	cmp di, ax
	jbe loop_b2
	
	
	
	pop si
	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	mov sp, bp
	pop bp
	ret 10

; -------------------------------------
; Bubble Font Data (18 rows, varying widths)
; For "BALLOON BLASTER"
; Left-aligned in 16-bit words
; -------------------------------------


; =====================================================
; MAIN START
; =====================================================
main_menu:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	; --- Fix specific colors for menu ---
    ; Set color 4 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	; Set color 303 black = RGB(0, 0, 0)
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ; Set color 9 (bright blue) = RGB(0, 0, 63)
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ; Set color 15 (white) = RGB(63, 63, 63)
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
    
	
  
	; Example: Draw balloons
	
    mov cx, 41            ; X position
    mov dx, 30            ; Y position
    mov al, [red]            ; color (light red)
    call DrawBalloon
	
    

    mov cx, 100           ; X position
    mov dx, 95            ; Y position
    mov al, [blue]             ; color (light blue)
    call DrawBalloon
    
    mov cx, 270          ; X position
    mov dx, 55            ; Y position
    mov al, [white]            ; color (light green)
    call DrawBalloon
	
	
    ; Now draw rectangles and text on top
    ; Rectangle 1
    mov ax, [white]
    push ax
    mov ax, [x1]
    push ax
    mov ax, [y1]
    push ax
    mov ax, [w1]
    push ax
    mov ax, [h1]
    push ax
    call drawRectangle
	mov ax, [blue]
    push ax
    mov ax, [x1]
    push ax
    mov ax, [y1]
    push ax
    mov ax, [w1]
    push ax
    mov ax, [h1]
    push ax
	call drawBoundary
    
    ; Rectangle 2
    mov ax, [white]
    push ax
    mov ax, [x2]
    push ax
    mov ax, [y2]
    push ax
    mov ax, [w2]
    push ax
    mov ax, [h2]
    push ax
    call drawRectangle
	mov ax, [blue]
    push ax
    mov ax, [x2]
    push ax
    mov ax, [y2]
    push ax
    mov ax, [w2]
    push ax
    mov ax, [h2]
    push ax
	call drawBoundary
	
    
    ; Rectangle 3
    mov ax, [white]
    push ax
    mov ax, [x3]
    push ax
    mov ax, [y3]
    push ax
    mov ax, [w3]
    push ax
    mov ax, [h3]
    push ax
    call drawRectangle
	mov ax, [blue]
    push ax
    mov ax, [x3]
    push ax
    mov ax, [y3]
    push ax
    mov ax, [w3]
    push ax
    mov ax, [h3]
    push ax
	call drawBoundary
    
    ; ===== DRAW TEXT: "PRESS S TO START GAME" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 70
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 78
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 86
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 94
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 102
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; S (in red)
mov dx, S_data
mov [write_word], dx
mov cx, 120
mov dx, 57
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

; TO
mov dx, T_data
mov [write_word], dx
mov cx, 138
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 146
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; START
mov dx, S_data
mov [write_word], dx
mov cx, 164
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 172
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 180
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 188
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 196
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; GAME
mov dx, G_data
mov [write_word], dx
mov cx, 214
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 222
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 230
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 238
mov dx, 57
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; ===== DRAW TEXT: "PRESS T TO CHANGE THEME" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 70
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 78
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 86
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 94
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 102
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; T (in red)
mov dx, T_data
mov [write_word], dx
mov cx, 116
mov dx, 107
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

; TO
mov dx, T_data
mov [write_word], dx
mov cx, 130
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 138
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; CHANGE
mov dx, C_data
mov [write_word], dx
mov cx, 150
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, H_data
mov [write_word], dx
mov cx, 158
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 166
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, N_data
mov [write_word], dx
mov cx, 174
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, G_data
mov [write_word], dx
mov cx, 182
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 190
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; THEME
mov dx, T_data
mov [write_word], dx
mov cx, 208
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, H_data
mov [write_word], dx
mov cx, 216
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 224
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 232
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 240
mov dx, 107
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; ===== DRAW TEXT: "PRESS E TO EXIT GAME" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 70
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 78
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 86
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 94
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 102
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; E (in red)
mov dx, E_data
mov [write_word], dx
mov cx, 122
mov dx, 157
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

; TO
mov dx, T_data
mov [write_word], dx
mov cx, 140
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 148
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; EXIT
mov dx, E_data
mov [write_word], dx
mov cx, 168
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, X_data
mov [write_word], dx
mov cx, 176
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, I_data
mov [write_word], dx
mov cx, 184
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 192
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

; GAME
mov dx, G_data
mov [write_word], dx
mov cx, 214
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 222
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 230
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 238
mov dx, 157
mov si, 1
mov al, [blue]
mov [ColorHolder], al
call DrawA



	
	
	
; Wait for keypress
mov ah, 0
int 16h

; Restore text mode
mov ax, 3
int 10h
ret
