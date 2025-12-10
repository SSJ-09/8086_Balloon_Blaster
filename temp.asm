org 100h

jmp start


; ===== COLOR DEFINITIONS =====
ColorHolder db 0
write_word dw 0
lastTime dw 0
in_game dw 0
high_score dw 0
is_pause dw 0
is_light_theme dw 1


ballooncyan: dw 299
balloonred: dw 300 ;this
balloonblue: dw 301
balloonwhite: dw 302
balloonblack: dw 303
balloondarkblue: dw 304
balloonlightblue: dw 307 ;this
balloonyellow: dw 308
balloongreen: dw 313

fixblack: dw 303
white: dw 302
black: dw 303
whitetitle: dw 302
blacktitle: dw 303
blue: dw 301
red: dw 300
yellow: dw 308
cyan: dw 299
;305,306,312,314,315,316,317,318,319,320,310,309,321 reserved
green:dw 313
darkblue: dw 304   ; inner rectangle
lightblue: dw 307  ; outer rectangle
lightbluemain: dw 307
lightbluetitle: dw 307
whiteboundary: dw 302
lightblueboundary: dw 307

; ============================================================
; MULTI-BALLOON MOVEMENT SYSTEM
; ============================================================

; Configuration labels
pixels_to_skip dw 3
ticks_until_next_balloon dw 10

; Maximum number of balloons
MAX_BALLOONS equ 5

; Parallel arrays for balloon data
balloon_active times MAX_BALLOONS db 0
balloon_x times MAX_BALLOONS dw 0
balloon_y times MAX_BALLOONS dw 0
balloon_color times MAX_BALLOONS db 0
balloon_char times MAX_BALLOONS dw 0
balloon_char_color times MAX_BALLOONS db 0
balloon_char_code times MAX_BALLOONS db 0

; Random data
random_seed dw 0
random_x dw 10,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255,272,289
random_balloon_color db 45,44,52,43,57
random_char_color db 46,46,47,47,47
random_balloon_char dw A_data, B_data, C_data, D_data, E_data, F_data, G_data, H_data,I_data, J_data, K_data, L_data, M_data, N_data, O_data,Q_data, R_data, S_data, T_data, U_data, V_data, W_data,X_data,Z_data

; Background buffers for each balloon
balloon_bg_buffers times (MAX_BALLOONS * 384) db 0

; Spawn timing
last_spawn_tick dw 0
active_balloon_count dw 0

; Full screen buffer for pause


; =====RECTANGLE POSITIONS=====
x1: dw 90
y1: dw 120
w1: dw 70
h1: dw 20

x2: dw 170
y2: dw 120
w2: dw 70
h2: dw 20

x3: dw 90
y3: dw 150
w3: dw 150
h3: dw 20

;p for pause
x1p: dw 85
y1p: dw 120
w1p: dw 70
h1p: dw 20

x2p: dw 165
y2p: dw 120
w2p: dw 70
h2p: dw 20

x3p: dw 85
y3p: dw 150
w3p: dw 150
h3p: dw 20

;o for over
x1o: dw 60
y1o: dw 110
w1o: dw 200
h1o: dw 30

x2o: dw 60
y2o: dw 150
w2o: dw 95
h2o: dw 20

x3o: dw 165
y3o: dw 150
w3o: dw 95
h3o: dw 20

;t for theme
x1t: dw 60
y1t: dw 90
w1t: dw 200
h1t: dw 20

x2t: dw 60
y2t: dw 120
w2t: dw 200
h2t: dw 20

x3t: dw 60
y3t: dw 150
w3t: dw 200
h3t: dw 20

x4t: dw 60
y4t: dw 30
w4t: dw 200
h4t: dw 40

;game screen co ordinates
x4: dw 10
y4: dw 10
w4: dw 70
h4: dw 16

x5: dw 38
y5: dw 12
w5: dw 40
h5: dw 12

x6: dw 240
y6: dw 10
w6: dw 70
h6: dw 16

x7: dw 268
y7: dw 12
w7: dw 40
h7: dw 12

x8: dw 110
y8: dw 10
w8: dw 100
h8: dw 16

x9: dw 168
y9: dw 12
w9: dw 40
h9: dw 12

;====Pixel Maps====

Balloon_body:
    dw 0000011111000000b  
    dw 0001111111110000b  
    dw 0011111111111000b  
    dw 0111111111111100b  
    dw 0111111111111110b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 1111111111111111b  
    dw 0111111111111110b  
    dw 0111111111111110b  
    dw 0011111111111100b  
    dw 0001111111111000b  
    dw 0000111111110000b  
    dw 0000011111100000b
    dw 0000001111000000b  
    dw 0000000110000000b  
    dw 0000000000000000b 
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b

Balloon_shadow:
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0001110000000000b  
    dw 0011100000000000b  
    dw 0011000000000000b  
    dw 0110000000000000b  
    dw 0100000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b

Balloon_string:
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000000000000000b  
    dw 0000001100000000b  
    dw 0000000110000000b  
    dw 0000001100000000b  
    dw 0000000110000000b

CurrentRow_Body dw 0
CurrentRow_Shadow dw 0
CurrentRow_String dw 0
BalloonColor dw 0
ScaleFactor db 1
StartX dw 0
StartY dw 0
VerticalRepeat db 0
TempColor dw 0
TempScale db 0
TempX dw 0
TempY dw 0
; =====FONT DATA=====
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
number_bitmaps_for_time_display:
zero_data  db 01111110b
		   db 01000010b
		   db 01000010b
		   db 01000010b
		   db 01000010b
		   db 01000010b
		   db 01111110b
		   db 00000000b
	   
one_data  db 00001000b
          db 00011000b
          db 00101000b
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

three_data db 01111110b
           db 00000010b
           db 00000010b
           db 00111110b
           db 00000010b
           db 00000010b
           db 01111110b
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
          db 01111110b
          db 00000010b
          db 00000010b
          db 01111110b
          db 00000000b

six_data  db 01111110b
          db 01000000b
          db 01000000b
          db 01111110b
          db 01000010b
          db 01000010b
          db 01111110b
          db 00000000b

seven_data db 01111110b
           db 00000010b
           db 00000100b
           db 00001000b
           db 00010000b
           db 00010000b
           db 00010000b
           db 00000000b

eight_data db 01111110b
           db 01000010b
           db 01000010b
           db 01111110b
           db 01000010b
           db 01000010b
           db 01111110b
           db 00000000b

nine_data db 01111110b
          db 01000010b
          db 01000010b
          db 01111110b
          db 00000010b
          db 00000010b
          db 01111110b
          db 00000000b
		  

		  
colon_data:db 00000000b
		   db 01100000b
		   db 01100000b
		   db 00000000b
		   db 00000000b
		   db 01100000b
		   db 01100000b
		   db 00000000b

clock_data: dw 000000000000b    
            dw 001111111000b    
            dw 010000000100b    
            dw 100001000010b    
            dw 100001000010b    
            dw 100001000010b    
            dw 100001110010b    
            dw 100000000010b    
            dw 100000000010b    
            dw 010000000100b    
            dw 001111111000b    
            dw 000000000000b
			
exclamation_data:  db 00011000b
				   db 00011000b
				   db 00011000b
				   db 00011000b
				   db 00011000b
				   db 00000000b
				   db 00011000b
				   db 00011000b
Time: dw 120
score: dw 0x0000
highscore: dw 0x0000
; =====BACKGROUND FILE DATA=====
filename db "finalmu.raw", 0
chunkSize equ 8192
buffer times chunkSize db 0

align 16
palette_light:
    incbin "vga_palette.bin"    ; Light palette
align 16
palette_dark:
    incbin "darkpalette.bin"    ; Dark palette

; Pointer to current palette (defaults to light)
current_palette: dw palette_light

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
    mov dx, [current_palette]    ; Load from pointer
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
    mov bx, ax
    
read_loop:
    mov ah, 0x3F
    mov cx, chunkSize
    mov dx, buffer
    int 0x21
    or ax, ax
    jz finished_reading
    
    push ds
    push es
    mov si, buffer
    mov cx, ax
    rep movsb
    pop es
    pop ds
    jmp read_loop
    
finished_reading:
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
	
	


;Draws 24x24 balloon (24 wide, 24 tall)
;CX=x(top-left),DX=y(top-left),AL=balloon color
;String is always black,shadow is always white
; ----------------------------
; DrawBalloon (16-bit-safe, dd maps)
; ----------------------------
SetupColors:
    push ax
    push bx
    push cx
    push dx
    
    ; Set color 300 (red)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
    ; Set color 302 (white)
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ; Set color 303 (black)
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ===== DrawBalloonScaled Subroutine =====
; Inputs:
;   AX = balloon color
;   BH = scale factor
;   CX = X position
;   DX = Y position
DrawBalloon:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    mov [BalloonColor], ax
    mov [ScaleFactor], bh
    mov [StartX], cx
    mov [StartY], dx
    mov si, 0
    
RowLoop_BalloonScaled:
    mov bx, si
    shl bx, 1
    
    mov ax, [Balloon_body + bx]
    mov [CurrentRow_Body], ax
    
    mov ax, [Balloon_shadow + bx]
    mov [CurrentRow_Shadow], ax
    
    mov ax, [Balloon_string + bx]
    mov [CurrentRow_String], ax
    
    mov byte [VerticalRepeat], 0
    
VerticalLoop_Balloon:
    mov cx, [StartX]
    mov bp, 16
    
ColLoop_BalloonScaled:
    mov ax, [CurrentRow_String]
    test ax, 8000h
    jnz DrawString_BalloonScaled
    
    mov ax, [CurrentRow_Shadow]
    test ax, 8000h
    jnz DrawShadow_BalloonScaled
    
    mov ax, [CurrentRow_Body]
    test ax, 8000h
    jnz DrawBody_BalloonScaled
    
    jmp NextPixel_BalloonScaled
    
DrawString_BalloonScaled:
    push cx
    push dx
    mov ax, [fixblack]
    mov bl, [ScaleFactor]
    call DrawScaledPixel
    pop dx
    pop cx
    jmp NextPixel_BalloonScaled
    
DrawShadow_BalloonScaled:
    push cx
    push dx
    mov ax, [whitetitle]
    mov bl, [ScaleFactor]
    call DrawScaledPixel
    pop dx
    pop cx
    jmp NextPixel_BalloonScaled
    
DrawBody_BalloonScaled:
    push cx
    push dx
    mov ax, [BalloonColor]
    mov bl, [ScaleFactor]
    call DrawScaledPixel
    pop dx
    pop cx
    
NextPixel_BalloonScaled:
    shl word [CurrentRow_Body], 1
    shl word [CurrentRow_Shadow], 1
    shl word [CurrentRow_String], 1
    
    mov al, [ScaleFactor]
    xor ah, ah
    add cx, ax
    
    dec bp
    jnz ColLoop_BalloonScaled
    
    inc dx
    inc byte [VerticalRepeat]
    mov al, [VerticalRepeat]
    cmp al, [ScaleFactor]
    jl VerticalLoop_Balloon
    
    inc si
    cmp si, 24
    jl RowLoop_BalloonScaled
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ===== DrawScaledPixel Subroutine =====
; Inputs:
;   AX = color
;   BL = scale factor
;   CX = starting X
;   DX = starting Y
DrawScaledPixel:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov [TempColor], ax
    mov [TempScale], bl
    mov [TempX], cx
    mov [TempY], dx
    
    xor si, si
    
ScaledPixel_YLoop:
    xor di, di
    mov cx, [TempX]
    mov dx, [TempY]
    add dx, si
    
ScaledPixel_XLoop:
    mov cx, [TempX]
    add cx, di
    
    push cx
    push dx
    mov ax, [TempColor]
    call DrawPixel
    pop dx
    pop cx
    
    inc di
    mov al, [TempScale]
    xor ah, ah
    cmp di, ax
    jl ScaledPixel_XLoop
    
    inc si
    mov al, [TempScale]
    xor ah, ah
    cmp si, ax
    jl ScaledPixel_YLoop
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ===== DrawPixel Subroutine =====
; Inputs:
;   AX = color (only AL is used)
;   CX = X position
;   DX = Y position
DrawPixel:
    push ax
    push bx
    push cx
    push dx
    push di
    
    push ax
    
    ; Calculate offset: y*320+x
    mov ax, dx
    mov bx, 320
    mul bx
    add ax, cx
    mov di, ax
    
    pop ax
    mov byte [es:di], al
    
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
    mov byte[es:di],al
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

; Draws 12x12 clock 
DrawClock:
    push ax
    push bx
    push cx
    push dx
    push si 
    push di
    push bp
    mov bp, si

    mov si,0
    
RowLoop_DC:
    mov bx, clock_data
    add bx, si
    mov ax, [bx]              
    
    mov bl,12                
    push cx
    
ColLoop_DC:
    test ax,100000000000b    
    jz SkipPixel_DC
    
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si,bp
    call DrawBlock
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
SkipPixel_DC:
    shl ax,1                
    add cx, bp
    dec bl
    jnz ColLoop_DC
    
    pop cx
    add dx, bp
    add si,2                 
    cmp si,24                
    jl RowLoop_DC
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

score_digit_lookup_table: dw zero_data, one_data
                          dw two_data, three_data
                          dw four_data, five_data
                          dw six_data, seven_data
                          dw eight_data, nine_data

; ===== SUBROUTINES (Add to your code section) =====

; display_score_on_screen
; Displays a numerical score with customizable position, scale, and color
; Always displays 4 digits with leading zeros (e.g., 0042, 1234, 0000)
; Input: 
;   AX = X position (0-319)
;   BX = Y position (0-199)
;   CX = Score value (0-9999)
;   DL = Color (0-255)
;   DH = Scale factor (1=8x8, 2=16x16, 3=24x24, etc.)
; Output: None
; Modifies: None (all registers preserved)
display_score_on_screen:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    ; Save parameters in stack
    sub sp, 20
    mov bp, sp
    
    mov [bp+0], ax          ; X position
    mov [bp+2], bx          ; Y position
    mov [bp+4], dl          ; Color
    mov [bp+5], dh          ; Scale
    
    ; Convert number to exactly 4 digits with leading zeros
    mov ax, cx
    lea si, [bp+10]
    mov cx, 4               ; Always 4 digits
    
.convert_number_to_individual_digits:
    mov bx, 10
    xor dx, dx
    div bx                  ; AX = AX / 10, DX = remainder
    mov [si], dl            ; Store digit
    inc si
    loop .convert_number_to_individual_digits
    
    ; Now we have 4 digits stored in reverse order
    mov cx, 4
    dec si                  ; Point to last digit
    
.render_each_digit_on_screen:
    mov al, [si]
    xor ah, ah
    
    push si
    push cx
    
    mov bx, [bp+0]
    mov cx, [bp+2]
    mov dl, [bp+4]
    mov dh, [bp+5]
    call render_single_digit_with_bitmap
    
    pop cx
    pop si
    
    xor ax, ax
    mov al, [bp+5]
    shl ax, 3
    add ax, 2
    add [bp+0], ax
    
    dec si
    loop .render_each_digit_on_screen
    
    add sp, 20
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; render_single_digit_with_bitmap
; Internal subroutine - renders one digit using 8x8 bitmap
; Input: AL=digit(0-9), BX=x, CX=y, DL=color, DH=scale
render_single_digit_with_bitmap:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    xor ah, ah
    shl ax, 1
    mov si, ax
    mov si, [score_digit_lookup_table + si]
    
    mov bp, sp
    sub sp, 10
    mov [bp-2], bx
    mov [bp-4], cx
    mov [bp-6], dl
    mov [bp-8], dh
    
    mov di, 8
    
.process_bitmap_row_by_row:
    mov al, [si]
    inc si
    mov [bp-10], al
    
    push di
    mov di, 8
    
.process_bitmap_column_by_column:
    mov al, [bp-10]
    test al, 10000000b
    jz .skip_this_pixel_no_bit_set
    
    push di
    
    mov ax, [bp-2]
    mov bx, [bp-4]
    mov cl, [bp-8]
    xor ch, ch
    mov dl, [bp-6]
    call draw_scaled_pixel_block_on_screen
    
    pop di
    
.skip_this_pixel_no_bit_set:
    shl byte [bp-10], 1
    
    xor ax, ax
    mov al, [bp-8]
    add [bp-2], ax
    
    dec di
    jnz .process_bitmap_column_by_column
    
    pop di
    
    mov ax, [bp-2]
    xor bx, bx
    mov bl, [bp-8]
    shl bx, 3
    sub ax, bx
    mov [bp-2], ax
    
    xor ax, ax
    mov al, [bp-8]
    add [bp-4], ax
    
    dec di
    jnz .process_bitmap_row_by_row
    
    add sp, 10
    
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; draw_scaled_pixel_block_on_screen
; Internal subroutine - draws a scale x scale block of pixels
; Input: AX=x, BX=y, CX=scale, DL=color
draw_scaled_pixel_block_on_screen:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov si, cx
    
.iterate_through_block_y_coordinates:
    push si
    push ax
    
    mov di, cx
    
.iterate_through_block_x_coordinates:
    push ax
    push bx
    push di
    
    call put_pixel_at_position_in_vga_memory
    
    pop di
    pop bx
    pop ax
    
    inc ax
    dec di
    jnz .iterate_through_block_x_coordinates
    
    pop ax
    pop si
    
    inc bx
    dec si
    jnz .iterate_through_block_y_coordinates
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; put_pixel_at_position_in_vga_memory
; Internal subroutine - plots a single pixel in VGA mode 13h
; Input: AX=x coordinate, BX=y coordinate, DL=color
put_pixel_at_position_in_vga_memory:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov di, bx
    mov cx, bx
    shl di, 8
    shl cx, 6
    add di, cx
    add di, ax
    
    mov ax, 0xA000
    mov es, ax
    mov [es:di], dl
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
; ===============================================
; SUBROUTINE: draw_time_format_subroutine
; Description: Draws time in MM:SS format (minutes:seconds)
; Input: 
;   AX = X position for leftmost digit
;   BX = Y position
;   CX = Time value in total seconds (0-3599, max 59:59)
;   DL = Color
; Output: None
; Registers modified: All (uses stack to preserve)
; ===============================================

draw_time_format_subroutine:
    pusha
    
    ; Save parameters
    mov [time_display_x_position], ax
    mov [time_display_y_position], bx
    mov [time_display_color], dl
    
    ; Convert total seconds to minutes and seconds
    mov ax, cx                  ; AX = total seconds
    xor dx, dx
    mov bx, 60
    div bx                      ; AX = minutes, DX = seconds
    
    ; Store minutes and seconds
    mov [time_value_minutes], ax
    mov [time_value_seconds], dx
    
    ; Extract tens and ones of minutes
    mov ax, [time_value_minutes]
    xor dx, dx
    mov bx, 10
    div bx                      ; AX = tens, DX = ones
    mov [time_digit_minutes_tens], al
    mov [time_digit_minutes_ones], dl
    
    ; Extract tens and ones of seconds
    mov ax, [time_value_seconds]
    xor dx, dx
    mov bx, 10
    div bx                      ; AX = tens, DX = ones
    mov [time_digit_seconds_tens], al
    mov [time_digit_seconds_ones], dl
    
    ; Now draw each digit
    ; Draw minutes tens
    mov al, [time_digit_minutes_tens]
    mov ah, 0
    mov bl, 8
    mul bl
    mov si, ax
    add si, number_bitmaps_for_time_display
    
    mov ax, [time_display_x_position]
    mov bx, [time_display_y_position]
    mov dl, [time_display_color]
    call draw_8x8_character_subroutine
    
    ; Draw minutes ones
    add word [time_display_x_position], 9
    
    mov al, [time_digit_minutes_ones]
    mov ah, 0
    mov bl, 8
    mul bl
    mov si, ax
    add si, number_bitmaps_for_time_display
    
    mov ax, [time_display_x_position]
    mov bx, [time_display_y_position]
    mov dl, [time_display_color]
    call draw_8x8_character_subroutine
    
    ; Draw colon
    add word [time_display_x_position], 9
    
    mov si, colon_data
    mov ax, [time_display_x_position]
    mov bx, [time_display_y_position]
    mov dl, [time_display_color]
    call draw_8x8_character_subroutine
    
    ; Draw seconds tens
    add word [time_display_x_position],5
    
    mov al, [time_digit_seconds_tens]
    mov ah, 0
    mov bl, 8
    mul bl
    mov si, ax
    add si, number_bitmaps_for_time_display
    
    mov ax, [time_display_x_position]
    mov bx, [time_display_y_position]
    mov dl, [time_display_color]
    call draw_8x8_character_subroutine
    
    ; Draw seconds ones
    add word [time_display_x_position], 9
    
    mov al, [time_digit_seconds_ones]
    mov ah, 0
    mov bl, 8
    mul bl
    mov si, ax
    add si, number_bitmaps_for_time_display
    
    mov ax, [time_display_x_position]
    mov bx, [time_display_y_position]
    mov dl, [time_display_color]
    call draw_8x8_character_subroutine
    
    popa
    ret

; ===============================================
; SUBROUTINE: draw_8x8_character_subroutine
; Description: Draws an 8x8 bitmap character
; Input: 
;   AX = X position
;   BX = Y position
;   SI = Pointer to 8-byte bitmap data
;   DL = Color
; Output: None
; Registers modified: All (uses stack to preserve)
; ===============================================

draw_8x8_character_subroutine:
    pusha
    
    ; Save parameters
    mov [char_x_position], ax
    mov [char_y_position], bx
    mov [char_bitmap_pointer], si
    mov [char_color_value], dl
    
    ; Set up VGA segment
    push es
    mov ax, 0xA000
    mov es, ax
    
    ; Draw 8 rows
    mov byte [char_current_row], 0
    
draw_char_row_loop:
    ; Get bitmap byte for this row
    mov si, [char_bitmap_pointer]
    mov al, [char_current_row]
    mov ah, 0
    add si, ax
    mov al, [si]
    mov [char_row_bitmap], al
    
    ; Draw 8 pixels in this row
    mov byte [char_current_column], 0
    
draw_char_column_loop:
    ; Check if bit is set (bits are from MSB to LSB, left to right)
    mov cl, 7
    sub cl, [char_current_column]
    mov al, [char_row_bitmap]
    shr al, cl
    and al, 1
    cmp al, 0
    je draw_char_skip_pixel
    
    ; Calculate screen position
    mov ax, [char_y_position]
    add al, [char_current_row]
    mov bx, 320
    mul bx
    mov di, ax
    
    mov ax, [char_x_position]
    add al, [char_current_column]
    add di, ax
    
    ; Draw pixel
    mov al, [char_color_value]
    mov [es:di], al
    
draw_char_skip_pixel:
    inc byte [char_current_column]
    cmp byte [char_current_column], 8
    jl draw_char_column_loop
    
    inc byte [char_current_row]
    cmp byte [char_current_row], 8
    jl draw_char_row_loop
    
    pop es
    popa
    ret
	
; Variables for time format display
time_display_x_position: dw 1
time_display_y_position: dw 1
time_display_color: db 1
time_value_minutes: dw 1
time_value_seconds: dw 1
time_digit_minutes_tens: db 1
time_digit_minutes_ones: db 1
time_digit_seconds_tens: db 1
time_digit_seconds_ones: db 1

; Variables for 8x8 character drawing
char_x_position: dw 1
char_y_position: dw 1
char_bitmap_pointer: dw 1
char_color_value: db 1
char_current_row: db 1
char_current_column: db 1
char_row_bitmap: db 1
; Draws 8x8 character 
DrawA:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    mov bp, si
    mov si,0
    
RowLoop_DA:
    mov bx, [write_word]
    add bx, si
    mov al, [bx]
    
    mov bl,8
    push cx
    
ColLoop_DA:
    test al,10000000b
    jz SkipPixel_DA
    
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si,bp
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

;clear screen
clearScreen:
    xor ax,ax
    mov di,0
    mov cx,320*200
    rep stosb
    ret


;drawRectangle
;bp+4=height, bp+6=width
;bp+8=y,bp+10=x,bp+12=color
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


;Boundary
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
	
	
	mov dl,[bp + 12]
loop_b1:
	mov [es:si], dl
	mov [es:di], dl
	
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
	mov [es:si], dl
	mov [es:di], dl
	
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




drawTransition:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0xA000
    mov es, ax
    
    ; Draw background first
    call drawBackground
	mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
CurtainClose:
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov cx, 0           ; start at row 0 (top) and row 199 (bottom)
    
.loop:
    ; Check if curtains have met in middle
    cmp cx, 100
    jge .done
    
    ; Draw top row (moving down towards middle)
    mov dx, cx          ; top row
    push cx
    mov cx, 0           ; start from x=0
.drawTopRow:
    push cx
    push dx
    
    ; Calculate offset for top row
    mov ax, dx
    mov bx, 320
    mul bx
    add ax, cx
    mov di, ax
    mov byte [es:di], 47 ; black color
    
    pop dx
    pop cx
    inc cx
    cmp cx, 320
    jl .drawTopRow
    pop cx
    
    ; Draw bottom row (moving up towards middle)
    mov dx, 199
    sub dx, cx          ; bottom row
    push cx
    mov cx, 0           ; start from x=0
.drawBottomRow:
    push cx
    push dx
    
    ; Calculate offset for bottom row
    mov ax, dx
    mov bx, 320
    mul bx
    add ax, cx
    mov di, ax
    mov byte [es:di], 47 ; black color
    
    pop dx
    pop cx
    inc cx
    cmp cx, 320
    jl .drawBottomRow
    pop cx
    
    ; Small delay for visual effect
    push cx
    mov cx, 0xAAAA	
.delay:
    loop .delay
    pop cx
    
    inc cx
    jmp .loop
    
.done:
	
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    
	
    
    ; Restore text mode
    mov ax, 3
    int 10h
    ret


;====main====
drawMainMenu:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	
	;setting colors 
	mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	skipcolors:
 ; ==========================
;   TITLE: Balloon Blaster
; ==========================

; ---------- B ----------
mov cx, 59
mov dx, 16
mov bh, 2
mov al, [red]
call DrawBalloon
mov dx, B_data
mov [write_word], dx
mov cx, 67
mov dx, 27
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; ---------- L ----------
mov cx, 119
mov dx, 16
mov bh, 2
mov al, [blue]
call DrawBalloon
mov dx, L_data
mov [write_word], dx
mov cx, 127
mov dx, 27
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- A ----------
mov cx, 89
mov dx, 18
mov bh, 2
mov al, [yellow]
call DrawBalloon
mov dx, A_data
mov [write_word], dx
mov cx, 97
mov dx, 29
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- L ----------
mov cx, 147
mov bh, 2
mov dx, 18
mov al, [green]
call DrawBalloon
mov dx, L_data
mov [write_word], dx
mov cx, 155
mov dx, 29
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- O ----------
mov cx, 207
mov bh, 2
mov dx, 18
mov al, [cyan]
call DrawBalloon
mov dx, O_data
mov [write_word], dx
mov cx, 215
mov dx, 29
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- O ----------
mov cx, 177
mov bh, 2
mov dx, 16
mov al, [red]
call DrawBalloon
mov dx, O_data
mov [write_word], dx
mov cx, 185
mov dx, 27
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- N ----------
mov cx, 237
mov bh, 2
mov dx, 16
mov al, [yellow]
call DrawBalloon
mov dx, N_data
mov [write_word], dx
mov cx, 245
mov dx, 27
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; ========== BLASTER ==========


; ---------- L ----------
mov cx, 90
mov bh, 2
mov dx, 50
mov al, [balloongreen]
call DrawBalloon
mov dx, L_data
mov [write_word], dx
mov cx, 98
mov dx, 61
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- B ----------
mov cx, 60
mov bh, 2
mov dx, 48
mov al, [balloonblue]
call DrawBalloon
mov dx, B_data
mov [write_word], dx
mov cx, 68
mov dx, 59
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- A ----------
mov cx, 118
mov dx, 48
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, A_data
mov [write_word], dx
mov cx, 126
mov dx, 59
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- T ----------
mov cx, 178
mov bh, 2
mov dx, 48
mov al, [balloonyellow]
call DrawBalloon
mov dx, T_data
mov [write_word], dx
mov cx, 186
mov dx, 59
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- S ----------
mov cx, 148
mov bh, 2
mov dx, 50
mov al, [ballooncyan]
call DrawBalloon
mov dx, S_data
mov [write_word], dx
mov cx, 156
mov dx, 61
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- R ----------
mov cx, 238
mov bh, 2
mov dx, 48
mov al, [balloongreen]
call DrawBalloon
mov dx, R_data
mov [write_word], dx
mov cx, 246
mov dx, 59
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- E ----------
mov cx, 208
mov dx, 50
mov bh, 2
mov al, [balloonblue]
call DrawBalloon
mov dx, E_data
mov [write_word], dx
mov cx, 216
mov dx, 61
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



	
	
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
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
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
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
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
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary
    


; START
mov dx, S_data
mov [write_word], dx
mov cx, 104
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


mov dx, T_data
mov [write_word], dx
mov cx, 112
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


mov dx, A_data
mov [write_word], dx
mov cx, 120
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 128
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 136
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA




; THEME
mov dx, T_data
mov [write_word], dx
mov cx, 184
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, H_data
mov [write_word], dx
mov cx, 192
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 200
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 208
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 216
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; EXIT
mov dx, E_data
mov [write_word], dx
mov cx, 150
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, X_data
mov [write_word], dx
mov cx, 158
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, I_data
mov [write_word], dx
mov cx, 166
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 174
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

	
key_mainMenu:
; Wait for keypress
mov ah, 0
int 16h

mov bl, 's'
cmp al, bl
je drawDifficultyMenu

mov bl, 't'
cmp al, bl
jne no1
call drawTransition
jmp drawThemeMenu
no1:

mov bl, 'e'
cmp al, bl
je exit

jne key_mainMenu


; Restore text mode
mov ax, 3
int 10h
ret
drawGameOver:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	;setting colors 
	mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors1
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	skipcolors1:
 ; ==========================
;   TITLE: GAME OVER!
; ==========================

; ---------- G ----------
mov cx, 30
mov dx, 18
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, G_data
mov [write_word], dx
mov cx, 38
mov dx, 29
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- A ----------
mov cx, 60
mov dx, 20
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, A_data
mov [write_word], dx
mov cx, 68
mov dx, 31
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- M ----------
mov cx, 90
mov dx, 18
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, M_data
mov [write_word], dx
mov cx, 98
mov dx, 29
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- E ----------
mov cx, 120
mov dx, 20
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, E_data
mov [write_word], dx
mov cx, 128
mov dx, 31
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; ========== OVER! ==========

; ---------- O ----------
mov cx, 170
mov dx, 18
mov bh, 2
mov al, [balloonred]
call DrawBalloon
mov dx, O_data
mov [write_word], dx
mov cx, 178
mov dx, 29
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- V ----------
mov cx, 200
mov bh, 2
mov dx, 20
mov al, [balloonred]
call DrawBalloon
mov dx, V_data
mov [write_word], dx
mov cx, 208
mov dx, 31
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- E ----------
mov cx, 230
mov bh, 2
mov dx, 18
mov al, [balloonred]
call DrawBalloon
mov dx, E_data
mov [write_word], dx
mov cx, 238
mov dx, 29
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- R ----------
mov cx, 260
mov bh, 2
mov dx, 20
mov al, [balloonred]
call DrawBalloon
mov dx, R_data
mov [write_word], dx
mov cx, 268
mov dx, 31
mov si, 2
mov al, [white]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ; ---------- ! ----------
; mov cx, 290
; mov bh, 2
; mov dx, 12
; mov al, [red]
; call DrawBalloon
; mov dx, exclamation_data
; mov [write_word], dx
; mov cx, 235
; mov dx, 17
; mov si, 2
; mov al, [white]
; mov [ColorHolder], al
; call DrawA


    ; Now draw rectangles and text on top
    ; Rectangle 1
    mov ax, [lightbluetitle]
    push ax
    mov ax, [x1o]
    push ax
    mov ax, [y1o]
    push ax
    mov ax, [w1o]
    push ax
    mov ax, [h1o]
    push ax
    call drawRectangle
	
	mov ax, [whiteboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; Rectangle 2
    mov ax, [white]
    push ax
    mov ax, [x2o]
    push ax
    mov ax, [y2o]
    push ax
    mov ax, [w2o]
    push ax
    mov ax, [h2o]
    push ax
    call drawRectangle
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; Rectangle 3
    mov ax, [white]
    push ax
    mov ax, [x3o]
    push ax
    mov ax, [y3o]
    push ax
    mov ax, [w3o]
    push ax
    mov ax, [h3o]
    push ax
    call drawRectangle
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; ===== DRAW TEXT: "SCORE : 6969" =====
; SCORE
mov dx, S_data
mov [write_word], dx
mov cx, 76
mov dx, 120
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, C_data
mov [write_word], dx
mov cx, 92
mov dx, 120
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 108
mov dx, 120
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 124
mov dx, 120
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 140
mov dx, 120
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; colon( : )

mov dx, colon_data
	mov [write_word], dx
	mov cx, 158
	mov dx, 118
	mov si, 2
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA


	mov ax, 178           ; X position
	mov bx, 119            ; Y position
	mov cx, [score]       ; Score value
	mov dl, 46            ; Color (white)
	mov dh, 2             ; Scale (2x size)
	call display_score_on_screen




; RESTART
mov dx, R_data
mov [write_word], dx
mov cx, 186
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 194
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 202
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 210
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 218
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 226
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 234
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; Menu
mov dx, M_data
mov [write_word], dx
mov cx, 90
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 100
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, N_data
mov [write_word], dx
mov cx, 110
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, U_data
mov [write_word], dx
mov cx, 120
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

	
	
key_gameOver:
; Wait for keypress
mov ah, 0
int 16h

mov bl, 'r'
cmp al, bl
jne no2
jmp drawDifficultyMenu
no2:

mov bl, 'm'
cmp al, bl
je drawMainMenu
jne key_gameOver

; Restore text mode
mov ax, 3
int 10h
ret


drawGameScreen:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
;setting colors 
mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors2
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	
	
	
	skipcolors2:
	; TOP_LEFT_OUTER(HS)
	mov ax, [lightbluetitle]
    push ax
    mov ax, [x4]
    push ax
    mov ax, [y4]
    push ax
    mov ax, [w4]
    push ax
    mov ax, [h4]
    push ax
	call drawRectangle
	
	mov ax, [whitetitle]
    push ax
    sub sp,8
	call drawBoundary
	
	
	; TOP_LEFT_INNER
	mov ax, [darkblue]
    push ax
    mov ax, [x5]
    push ax
    mov ax, [y5]
    push ax
    mov ax, [w5]
    push ax
    mov ax, [h5]
    push ax
	call drawRectangle
	
	
	; TOP_RIGHT_OUTER(TIME)
	mov ax, [lightbluetitle]
    push ax
    mov ax, [x6]
    push ax
    mov ax, [y6]
    push ax
    mov ax, [w6]
    push ax
    mov ax, [h6]
    push ax
	call drawRectangle
	
	mov ax, [whitetitle]
    push ax
    sub sp,8
	call drawBoundary
	
	
	; TOP_RIGHT_INNER(TIME)
	
	mov ax, [darkblue]
    push ax
    mov ax, [x7]
    push ax
    mov ax, [y7]
    push ax
    mov ax, [w7]
    push ax
    mov ax, [h7]
    push ax
	call drawRectangle
	
	; TOP_MIDDLE_OUTER(SCORE)
	
	mov ax, [lightbluetitle]
    push ax
    mov ax, [x8]
    push ax
    mov ax, [y8]
    push ax
    mov ax, [w8]
    push ax
    mov ax, [h8]
    push ax
	call drawRectangle
	
	mov ax, [whitetitle]
    push ax
    sub sp,8
	call drawBoundary
	
	;TOP_MIDDLE_INNER
	
	mov ax, [darkblue]
    push ax
    mov ax, [x9]
    push ax
    mov ax, [y9]
    push ax
    mov ax, [w9]
    push ax
    mov ax, [h9]
    push ax
	call drawRectangle
	
	; HS
	mov dx, H_data
	mov [write_word], dx
	mov cx, 15
	mov dx, 15
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA

	mov dx, S_data
	mov [write_word], dx
	mov cx, 25
	mov dx, 15
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	
	; SCORE
	mov ax, [darkblue]
    push ax
    mov ax, [x9]
    push ax
    mov ax, [y9]
    push ax
    mov ax, [w9]
    push ax
    mov ax, [h9]
    push ax
	call drawRectangle
	mov ax, 170           ; X position
	mov bx, 15            ; Y position
	mov cx, [score]       ; Score value
	mov dl, 46            ; Color (white)
	mov dh, 1             ; Scale (2x size)
	call display_score_on_screen
	
	
	
	
	
	; SCORE
	mov dx, S_data
	mov [write_word], dx
	mov cx, 118
	mov dx, 16
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	mov dx, C_data
	mov [write_word], dx
	mov cx, 126
	mov dx, 16
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	mov dx, O_data
	mov [write_word], dx
	mov cx, 134
	mov dx, 16
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	mov dx, R_data
	mov [write_word], dx
	mov cx, 142
	mov dx, 16
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	mov dx, E_data
	mov [write_word], dx
	mov cx, 150
	mov dx, 16
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawA
	inc cx
	call DrawA
	
	mov ax, 40           ; X position
	mov bx, 15            ; Y position
	mov cx, [high_score]       ; Score value
	mov dl, 46            ; Color (white)
	mov dh, 1             ; Scale (2x size)
	call display_score_on_screen
	
	;clock
	mov cx, 249
	mov dx, 12
	mov si, 1
	mov al, [whitetitle]
	mov [ColorHolder], al
	call DrawClock
	mov ax,[in_game]
	cmp ax,1
	je track_time
	
	
	
	;Time=00:57
call init_timer

; Initialize balloon system
call init_balloon_system
mov word[in_game],1
mov word[Time],120

track_time:
	
    ; Display time
    mov ax, 269
    mov bx, 15
    mov cx, [Time]
	mov dx, [lastTime]
	cmp cx,0
	je endgame
	cmp cx,dx
	je .skiptime
	; Draw rectangle 
    mov ax, [darkblue]
    push ax
    mov ax, [x7]
    push ax
    mov ax, [y7]
    push ax
    mov ax, [w7]
    push ax
    mov ax, [h7]
    push ax
    call drawRectangle
	mov ax, 269
    mov bx, 15
    mov cx, [Time]
	mov [lastTime],cx
	xor dh,dh
    mov dl, 46
	
    call draw_time_format_subroutine
	
	
    
    
   .skiptime:
    ; Move and spawn balloons
    call move_balloon

key_gameScreen:
    ; Check for keypress 
    mov ah, 1
    int 0x16
    jz track_time
    
    ; Key pressed
    mov ah, 0
    int 0x16
    
    ; Check for pause 
    cmp ah, 0x19
    je pause_game
   
    
    call ScanCodeToAlphabet
    cmp al, 0xFF
    je track_time
    
    ; Search for matching balloon
    mov bl, al
    xor si, si
    
.SearchBalloon:
    mov al, MAX_BALLOONS
    xor ah, ah
    cmp si, ax
    jge track_time
    
    mov al, [balloon_active + si]
    cmp al, 0
    je .NextSearch
    
    mov al, [balloon_char_code + si]
    cmp al, bl
    je .FoundMatchingBalloon
    
.NextSearch:
    inc si
    jmp .SearchBalloon
    
.FoundMatchingBalloon:
    mov bx, si
    call erase_balloon_at_index
    add word[score],10
    ; Pop sound
    in al, 61h
    or al, 03h
    out 61h, al
    mov dx, 10000
.delaypop:
    dec dx
    jnz .delaypop
    in al, 61h
    and al, 0FCh
    out 61h, al
    
    ; Mark as deleted
    mov byte [balloon_active + si], 0
    dec word [active_balloon_count]
    
    
	;TOP_MIDDLE_INNER
	
	mov ax, [darkblue]
    push ax
    mov ax, [x9]
    push ax
    mov ax, [y9]
    push ax
    mov ax, [w9]
    push ax
    mov ax, [h9]
    push ax
	call drawRectangle
	mov ax, 170           ; X position
	mov bx, 15            ; Y position
	mov cx, [score]       ; Score value
	mov dl, 46            ; Color (white)
	mov dh, 1             ; Scale (2x size)
	call display_score_on_screen
    
    jmp track_time
    
pause_game:
    
    mov word[is_pause],1
    call drawGamePause
	mov word[is_pause],0
    call drawGameScreen
    
    jmp track_time
	
	endgame:
	
	call cleanup_timer
	mov word[Time],120
	call init_balloon_system
	mov word[in_game],0
	mov ax,[score]
	cmp ax,[high_score]
	jl nohigh
	mov [high_score],ax
	nohigh:
	
	call drawGameOver


drawGamePause:

	
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	;setting colors 
	mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors3
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	skipcolors3:
 ; ==========================
;   TITLE: GAME OVER!
;   (7-color balanced)
; ==========================

; ---------- G ----------
mov cx, 100
mov dx, 16
mov bh, 2
mov al, [balloonlightblue]
call DrawBalloon
mov dx, G_data
mov [write_word], dx
mov cx, 108
mov dx, 27
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- M ----------
mov cx, 160
mov bh, 2
mov dx, 16
mov al, [balloonlightblue]
call DrawBalloon
mov dx, M_data
mov [write_word], dx
mov cx, 168
mov dx, 27
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- A ----------
mov cx, 130
mov bh, 2
mov dx, 18
mov al, [balloonwhite]
call DrawBalloon
mov dx, A_data
mov [write_word], dx
mov cx, 138
mov dx, 29
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- E ----------
mov cx, 190
mov bh, 2
mov dx, 18
mov al, [balloonwhite]
call DrawBalloon
mov dx, E_data
mov [write_word], dx
mov cx, 198
mov dx, 29
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; ========== PAUSE ==========

; ---------- P ----------
mov cx, 70
mov bh, 2
mov dx, 50
mov al, [balloonlightblue]
call DrawBalloon
mov dx, P_data
mov [write_word], dx
mov cx, 78
mov dx, 61
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- U ----------
mov cx, 130
mov bh, 2
mov dx, 50
mov al, [balloonlightblue]
call DrawBalloon
mov dx, U_data
mov [write_word], dx
mov cx, 138
mov dx, 61
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- A ----------
mov cx, 100
mov dx, 52
mov bh, 2
mov al, [balloonwhite]
call DrawBalloon
mov dx, A_data
mov [write_word], dx
mov cx, 108
mov dx, 63
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ---------- E ----------
mov cx, 190
mov bh, 2
mov dx, 50
mov al, [balloonlightblue]
call DrawBalloon
mov dx, E_data
mov [write_word], dx
mov cx, 198
mov dx, 61
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; ---------- S ----------
mov cx, 160
mov bh, 2
mov dx, 52
mov al, [balloonwhite]
call DrawBalloon
mov dx, S_data
mov [write_word], dx
mov cx, 168
mov dx, 63
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA
; ----------- D ----------
mov cx, 220
mov bh, 2
mov dx, 52
mov al, [balloonwhite]
call DrawBalloon
mov dx, D_data
mov [write_word], dx
mov cx, 228
mov dx, 63
mov si, 2
mov al, [fixblack]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA
	
    ; Now draw rectangles and text on top
    ; Rectangle 1
    mov ax, [white]
    push ax
    mov ax, [x1p]
    push ax
    mov ax, [y1p]
    push ax
    mov ax, [w1p]
    push ax
    mov ax, [h1p]
    push ax
    call drawRectangle
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; Rectangle 2
    mov ax, [white]
    push ax
    mov ax, [x2p]
    push ax
    mov ax, [y2p]
    push ax
    mov ax, [w2p]
    push ax
    mov ax, [h2p]
    push ax
    call drawRectangle
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; Rectangle 3
    mov ax, [white]
    push ax
    mov ax, [x3p]
    push ax
    mov ax, [y3p]
    push ax
    mov ax, [w3p]
    push ax
    mov ax, [h3p]
    push ax
    call drawRectangle
	
	mov ax, [lightblueboundary]
    push ax
    sub sp,8
	call drawBoundary

; RESUME
mov dx, R_data
mov [write_word], dx
mov cx, 177
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 185
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 193
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, U_data
mov [write_word], dx
mov cx, 201
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 209
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 217
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; RESTART
mov dx, R_data
mov [write_word], dx
mov cx, 95
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 103
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 111
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 117
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 125
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 133
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 141
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; Menu
mov dx, M_data
mov [write_word], dx
mov cx, 144
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 154
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, N_data
mov [write_word], dx
mov cx, 164
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, U_data
mov [write_word], dx
mov cx, 174
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA
	
	mov word[is_pause],0
key_gamePause:
; Wait for keypress
mov ah, 0
int 16h


mov bl, 'r'
cmp al, bl
jne .skipone 
call cleanup_timer
	mov word[Time],120
	call init_balloon_system
	mov word[in_game],0
	jmp drawDifficultyMenu
.skipone:


mov bl, 'u' 
cmp al, bl
jne skipreturn
ret
skipreturn:

mov bl, 'm'
cmp al, bl
jne .skiptwo 
call cleanup_timer
	mov word[Time],120
	call init_balloon_system
	mov word[in_game],0
	jmp drawMainMenu
.skiptwo:

jne key_gamePause


; Restore text mode
mov ax, 3
int 10h

ret
drawThemeMenu:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	;setting colors 
	mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors4
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	skipcolors4:
    ; Now draw rectangles and text on top
    ; Rectangle 1
    mov ax, [white]
    push ax
    mov ax, [x1t]
    push ax
    mov ax, [y1t]
    push ax
    mov ax, [w1t]
    push ax
    mov ax, [h1t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8;we only need to change color while the coordinates for boundary remained same so no need to modify stack
	
	call drawBoundary
    
    ; Rectangle 2
    mov ax, [white]
    push ax
    mov ax, [x2t]
    push ax
    mov ax, [y2t]
    push ax
    mov ax, [w2t]
    push ax
    mov ax, [h2t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8
	call drawBoundary
    
    ; Rectangle 3
    mov ax, [white]
    push ax
    mov ax, [x3t]
    push ax
    mov ax, [y3t]
    push ax
    mov ax, [w3t]
    push ax
    mov ax, [h3t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8
	call drawBoundary
	
	; Rectangle 4
    mov ax, [lightbluetitle]
    push ax
    mov ax, [x4t]
    push ax
    mov ax, [y4t]
    push ax
    mov ax, [w4t]
    push ax
    mov ax, [h4t]
    push ax
    call drawRectangle
	
	mov ax, [whiteboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; ===== DRAW TEXT: "PRESS L FOR LIGHT" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 89
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 97
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 105
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 113
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 121
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; L (in red)
mov dx, L_data
mov [write_word], dx
mov cx, 139
mov dx, 98
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

inc cx
call DrawA

; FOR
mov dx, F_data
mov [write_word], dx
mov cx, 157
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 165
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 173
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

;LIGHT
mov dx, L_data
mov [write_word], dx
mov cx, 191
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, I_data
mov [write_word], dx
mov cx, 199
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, G_data
mov [write_word], dx
mov cx, 207
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, H_data
mov [write_word], dx
mov cx, 215
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 223
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA


; ===== DRAW TEXT: "PRESS D FOR DARK" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 93
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 101
mov dx,128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 109
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 117
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 125
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; D (in red)
mov dx, D_data
mov [write_word], dx
mov cx, 143
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

mov cx, 144
mov dx, 128
call DrawA

;FOR
mov dx, F_data
mov [write_word], dx
mov cx, 161
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 169
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 177
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA


;DARK
mov dx, D_data
mov [write_word], dx
mov cx, 195
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 203
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 211
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, K_data
mov [write_word], dx
mov cx, 219
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ===== DRAW TEXT: "PRESS B TO GO BACK" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 84
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 92
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 100
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 108
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 116
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; B (in red)
mov dx, B_data
mov [write_word], dx
mov cx, 134
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

inc cx
call DrawA

; TO
mov dx, T_data
mov [write_word], dx
mov cx, 152
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 160
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; GO
mov dx, G_data
mov [write_word], dx
mov cx, 178
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 186
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

;BACK
mov dx, B_data
mov [write_word], dx
mov cx, 204
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 212
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, C_data
mov [write_word], dx
mov cx, 220
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, K_data
mov [write_word], dx
mov cx, 228
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; ===== DRAW TEXT: "Theme Menu" =====

;instead of bold,we first draw black and then white to create illusion of shadow
mov dx, T_data
mov [write_word], dx
mov cx, 78
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, H_data
mov [write_word], dx
mov cx, 94
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 110
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 126
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 142
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, M_data
mov [write_word], dx
mov cx, 178
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, E_data
mov [write_word], dx
mov cx, 194
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, N_data
mov [write_word], dx
mov cx, 210
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, U_data
mov [write_word], dx
mov cx, 226
mov dx, 45
mov si, 2
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA
	
	
key_themeMenu:	
; Wait for keypress
mov ah, 0
int 16h

mov bl, 'l'
cmp al, bl
jne no6
mov word[is_light_theme],1
mov word[black], 303
mov word[white], 302
mov word[lightblue], 307
mov word[lightbluetitle], 307
mov word[blacktitle], 303
mov word[whitetitle], 302
mov word[whiteboundary], 302
mov word[lightblueboundary], 307
mov byte [filename+5], 'm'   ; index 5 → was 'u'
mov byte [filename+6], 'u'   ; index 6 → was 'm'
mov word [current_palette], palette_light
jmp drawThemeMenu
no6:

mov bl, 'd'
cmp al, bl
jne no7
mov word[is_light_theme],0
mov word[black], 302
mov word[white], 303
mov word[lightblue], 302
mov word[lightbluetitle], 303
mov word[blacktitle], 302
mov word[whitetitle], 302
mov word[whiteboundary], 307
mov word[lightblueboundary], 307
mov byte [filename+5], 'u'   ; index 5 → was 'm'
mov byte [filename+6], 'm'   ; index 6 → was 'u'
mov word [current_palette], palette_dark
jmp drawThemeMenu
no7:

mov bl, 'b'
cmp al, bl
je drawMainMenu

mov bl, 0x1B 
cmp al, bl
je drawMainMenu

jne key_themeMenu

; Restore text mode
mov ax, 3
int 10h
ret


drawDifficultyMenu:
    ; Set graphics mode
    mov ax, 0x13
    int 0x10
    
    ; Set ES to video memory
    mov ax, 0A000h
    mov es, ax
    
    ; Draw background first
    call drawBackground
	;setting colors 
	mov ax,[is_light_theme]
	cmp ax,0
	je skipcolors5
    ; Set color 300 (red) = RGB(63, 0, 0)
    mov ax, 0x1010
    mov bx, 300
    mov dh, 63  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;yellow
    mov ax, 0x1010
    mov bx, 308
    mov dh, 63  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
	;cyan
    mov ax, 0x1010
    mov bx, 299
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 63   ; Blue
    int 0x10
	
	
	;green
    mov ax, 0x1010
    mov bx, 313
    mov dh, 0  ; Red
    mov ch, 63   ; Green
    mov cl, 0   ; Blue
    int 0x10
    
	;black
    mov ax, 0x1010
    mov bx, 303
    mov dh, 0  ; Red
    mov ch, 0   ; Green
    mov cl, 0   ; Blue
    int 0x10
	
    ;blue
    mov ax, 0x1010
    mov bx, 301
    mov dh, 0   ; Red
    mov ch, 0   ; Green
    mov cl, 63  ; Blue
    int 0x10
    
    ;white
    mov ax, 0x1010
    mov bx, 302
    mov dh, 63  ; Red
    mov ch, 63  ; Green
    mov cl, 63  ; Blue
    int 0x10
	
	;dark blue
	mov ax, 0x1010
    mov bx, 304
    mov dh, 16  ; Red
    mov ch, 27  ; Green
    mov cl, 40  ; Blue
    int 0x10
	
	;light blue
	mov ax, 0x1010
    mov bx, 307
    mov dh, 20  ; Red
    mov ch, 35  ; Green
    mov cl, 54  ; Blue
    int 0x10
	skipcolors5:
    ; Now draw rectangles and text on top
    ; Rectangle 1
    mov ax, [white]
    push ax
    mov ax, [x1t]
    push ax
    mov ax, [y1t]
    push ax
    mov ax, [w1t]
    push ax
    mov ax, [h1t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8   ;we only need to change color while the coordinates for boundary remained same so no need to modify stack
	
	call drawBoundary
    
    ; Rectangle 2
    mov ax, [white]
    push ax
    mov ax, [x2t]
    push ax
    mov ax, [y2t]
    push ax
    mov ax, [w2t]
    push ax
    mov ax, [h2t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8
	call drawBoundary
    
    ; Rectangle 3
    mov ax, [white]
    push ax
    mov ax, [x3t]
    push ax
    mov ax, [y3t]
    push ax
    mov ax, [w3t]
    push ax
    mov ax, [h3t]
    push ax
    call drawRectangle
	mov ax, [lightblueboundary]
    push ax
	sub sp,8
	call drawBoundary
	
	; Rectangle 4
    mov ax, [lightbluetitle]
    push ax
    mov ax, [x4t]
    push ax
    mov ax, [y4t]
    push ax
    mov ax, [w4t]
    push ax
    mov ax, [h4t]
    push ax
    call drawRectangle
	
	mov ax, [whiteboundary]
    push ax
    sub sp,8
	call drawBoundary
    
    ; ===== DRAW TEXT: "PRESS E FOR EASY" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 84
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 92
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 100
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 108
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 117
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; E (in red)
mov dx, E_data
mov [write_word], dx
mov cx, 138
mov dx, 98
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

inc cx
call DrawA

; FOR
mov dx, F_data
mov [write_word], dx
mov cx, 161
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 169
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 177
mov dx, 98
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

;EASY
mov dx, E_data
mov [write_word], dx
mov cx, 204
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 212
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 220
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, Y_data
mov [write_word], dx
mov cx, 228
mov dx, 98
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; ===== DRAW TEXT: "PRESS N FOR NORMAL" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 80
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 88
mov dx,128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 96
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 104
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 112
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; N (in red)
mov dx, N_data
mov [write_word], dx
mov cx, 134
mov dx, 128
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

inc cx
call DrawA

;FOR
mov dx, F_data
mov [write_word], dx
mov cx, 157
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 165
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 173
mov dx, 128
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA


;NORMAL
mov dx, N_data
mov [write_word], dx
mov cx, 196
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 204
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 212
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, M_data
mov [write_word], dx
mov cx, 220
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 228
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, L_data
mov [write_word], dx
mov cx, 236
mov dx, 128
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

; ===== DRAW TEXT: "PRESS H FOR HARD" =====
; PRESS
mov dx, P_data
mov [write_word], dx
mov cx, 84
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 92
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 100
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 108
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, S_data
mov [write_word], dx
mov cx, 116
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

; H (in red)
mov dx, H_data
mov [write_word], dx
mov cx, 138
mov dx, 158
mov si, 1
mov al, [red]
mov [ColorHolder], al
call DrawA

inc cx
call DrawA

;FOR
mov dx, F_data
mov [write_word], dx
mov cx, 161
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, O_data
mov [write_word], dx
mov cx, 169
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 177
mov dx, 158
mov si, 1
mov al, [lightblue]
mov [ColorHolder], al
call DrawA

;HARD
mov dx, H_data
mov [write_word], dx
mov cx, 204
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 212
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 220
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA

mov dx, D_data
mov [write_word], dx
mov cx, 228
mov dx, 158
mov si, 1
mov al, [lightbluemain]
mov [ColorHolder], al
call DrawA
inc cx
call DrawA



; ===== DRAW TEXT: "Theme Menu" =====

;instead of bold,we first draw black and then white to create illusion of shadow
mov dx, S_data
mov [write_word], dx
mov cx, 74
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 84
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, L_data
mov [write_word], dx
mov cx, 94
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 104
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, C_data
mov [write_word], dx
mov cx, 114
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, T_data
mov [write_word], dx
mov cx, 124
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, D_data
mov [write_word], dx
mov cx, 144
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, I_data
mov [write_word], dx
mov cx, 154
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, F_data
mov [write_word], dx
mov cx, 164
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, F_data
mov [write_word], dx
mov cx, 174
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, I_data
mov [write_word], dx
mov cx, 184
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA
	
	
mov dx, C_data
mov [write_word], dx
mov cx, 194
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA
	

mov dx, U_data
mov [write_word], dx
mov cx, 204
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, L_data
mov [write_word], dx
mov cx, 214
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, T_data
mov [write_word], dx
mov cx, 224
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, Y_data
mov [write_word], dx
mov cx, 234
mov dx, 47
mov si, 1
mov al, [blacktitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


key_difficultyMenu:
mov word[Time], 120
; Wait for keypress
mov ah, 0
int 16h

mov bl, 0x1B 
cmp al, bl
je drawMainMenu

mov bl, 'e'
mov word[score],0
mov word[pixels_to_skip],3
mov word[in_game],0
cmp al, bl
jne no3
call drawTransition
mov dx, G_data
mov [write_word], dx
mov cx, 45
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 70
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 95
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 140
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, E_data
mov [write_word], dx
mov cx, 165
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 190
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, D_data
mov [write_word], dx
mov cx, 215
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, Y_data
mov [write_word], dx
mov cx, 240
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, exclamation_data
mov [write_word], dx
mov cx, 265
mov dx, 72
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

call wait_a_second

mov dx, three_data
mov [write_word], dx
mov cx, 80
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second


mov dx, two_data
mov [write_word], dx
mov cx, 140
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second

mov dx, one_data
mov [write_word], dx
mov cx, 200
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second
jmp drawGameScreen
no3:

mov bl, 'n'
mov word[score],0
mov word[in_game],0
mov word[pixels_to_skip],5
cmp al, bl
jne no4
call drawTransition
mov dx, G_data
mov [write_word], dx
mov cx, 45
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 70
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 95
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 140
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, E_data
mov [write_word], dx
mov cx, 165
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 190
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, D_data
mov [write_word], dx
mov cx, 215
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, Y_data
mov [write_word], dx
mov cx, 240
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, exclamation_data
mov [write_word], dx
mov cx, 265
mov dx, 72
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, three_data
mov [write_word], dx
mov cx, 80
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second


mov dx, two_data
mov [write_word], dx
mov cx, 140
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second

mov dx, one_data
mov [write_word], dx
mov cx, 200
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second
jmp drawGameScreen
no4:

mov bl, 'h'
mov word[score],0
mov word[in_game],0
mov word[pixels_to_skip],7
cmp al, bl
jne no5
call drawTransition
mov dx, G_data
mov [write_word], dx
mov cx, 45
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, E_data
mov [write_word], dx
mov cx, 70
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, T_data
mov [write_word], dx
mov cx, 95
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, R_data
mov [write_word], dx
mov cx, 140
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, E_data
mov [write_word], dx
mov cx, 165
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, A_data
mov [write_word], dx
mov cx, 190
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, D_data
mov [write_word], dx
mov cx, 215
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, Y_data
mov [write_word], dx
mov cx, 240
mov dx, 70
mov si, 3
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA


mov dx, exclamation_data
mov [write_word], dx
mov cx, 265
mov dx, 72
mov si, 2
mov al, [whitetitle]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[whitetitle]
mov [ColorHolder],al
call DrawA

mov dx, three_data
mov [write_word], dx
mov cx, 80
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second


mov dx, two_data
mov [write_word], dx
mov cx, 140
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second

mov dx, one_data
mov [write_word], dx
mov cx, 200
mov dx, 110
mov si, 3
mov al, [red]
mov [ColorHolder], al
call DrawA
inc cx
mov al,[red]
mov [ColorHolder],al
call DrawA
call wait_a_second
jmp drawGameScreen
no5:

jne key_difficultyMenu

; Restore text mode
mov ax, 3
int 10h
ret

wait_a_second:
	push cx
	mov dl, 60
just_here:
	mov cx, 0xFFFF
	
sleep:
	loop sleep
	dec dl
	cmp dl, 0
	jge just_here
	pop cx
	ret

    old_irq0_offset dw 0
    old_irq0_segment dw 0	
	tick_count db 0          ; Counter for timer ticks
    ticks_per_second equ 18      ; ~18.2 ticks = 1 second
    ticks_needed equ 18
; Call this once at program start to install the timer
init_timer:
    push ax
    push es
    
    ; Save old IRQ0 handler
    cli
    xor ax, ax
    mov es, ax
    mov ax, [es:0x08*4]          ; Offset of IRQ0 handler
    mov [old_irq0_offset], ax
    mov ax, [es:0x08*4+2]        ; Segment of IRQ0 handler
    mov [old_irq0_segment], ax
    
    ; Install our IRQ0 handler
    mov word [es:0x08*4], timer_handler
    mov word [es:0x08*4+2], cs
    sti
    
    pop es
    pop ax
    ret

; Call this before program exit to restore original timer
cleanup_timer:
    push ax
    push es
    
    ; Restore old IRQ0 handler
    cli
    xor ax, ax
    mov es, ax
    mov ax, [old_irq0_offset]
    mov [es:0x08*4], ax
    mov ax, [old_irq0_segment]
    mov [es:0x08*4+2], ax
    sti
    
    pop es
    pop ax
    ret

; IRQ0 handler - called every ~55ms
timer_handler:
    push ax
    push ds
	push bx
    
    mov ax, cs
    mov ds, ax
    
    ; Increment tick counter
    inc byte [tick_count]
	mov al,[tick_count]
	cmp al,17
	jna .skip
	mov bx,[is_pause]
	cmp bx,1
	je .skip
	dec word[Time]
	mov byte[tick_count],0
    
	
	.skip:
	pop bx
    pop ds
    pop ax
    
    ; Chain to original handler
    jmp far [cs:old_irq0_offset]

; calculate_time: waits for 1 second to pass (18 ticks)
; Does NOT increment Time - caller should do that


;========================================
init_balloon_system:
    push ax
    push bx
    push cx
	push di
    
	
	
	
	call GetTickCount
    mov [random_seed], ax
	
	
	
    ; Clear all balloon states
    mov cx, MAX_BALLOONS
    xor bx, bx
	xor di,di
	
    
.clear_loop:
    mov byte [balloon_active + bx], 0
	mov word [balloon_x+ di], 0
	mov word [balloon_y +di],0
	mov byte [balloon_color+bx],0
	mov word [balloon_char+di],0
	mov byte [balloon_char_code+bx],0
	mov byte [balloon_char_color+bx],0
	
    inc bx
	add di,2
    loop .clear_loop
	
    mov cx,384*MAX_BALLOONS
	xor bx,BX
.buffer_loop:
	mov byte[balloon_bg_buffers+bx],0
	inc BX
	loop .buffer_loop
	
	; Clear all balloon states
    mov cx, MAX_BALLOONS
    xor bx, bx
    

    ; Reset counters
    mov word [active_balloon_count], 0
    
    ; Get current tick count for spawn timing
    call GetTickCount
    mov [last_spawn_tick], ax
    
	pop di
    pop cx
    pop bx
    pop ax
    ret

; ============================================================
; find_free_balloon_slot
; Finds an inactive balloon slot
; Output: BX = slot index, or BX = -1 if none available
; ============================================================
find_free_balloon_slot:
    push cx
    
    xor bx, bx
    mov cx, MAX_BALLOONS
    
.search_loop:
    cmp byte [balloon_active + bx], 0
    je .found_slot
    inc bx
    loop .search_loop
    
    ; No free slot found
    mov bx, -1
    jmp .done
    
.found_slot:
    ; BX already contains the slot index
    
.done:
    pop cx
    ret

; ============================================================
; spawn_balloon
; Creates a new balloon if slot available and timing is right
; ============================================================
spawn_balloon:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Check if enough time has passed since last spawn
    call GetTickCount
    mov bx, ax
    sub bx, [last_spawn_tick]
    cmp bx, [ticks_until_next_balloon]
    jb .skip_spawn              ; Not enough time passed
    
    ; Update last spawn time
    mov [last_spawn_tick], ax
    
    ; Find free slot
    call find_free_balloon_slot
    cmp bx, -1
    je .skip_spawn              ; No free slots
    
    ; BX = slot index
    ; Calculate word offset (BX * 2)
    push bx
    shl bx, 1                   ; BX = BX * 2
    
    ; Set balloon parameters
	call Get_Random_x ;gets x in ax
    mov word [balloon_x + bx], ax
    mov word [balloon_y + bx], 175
    
    pop bx
    
    ; Set color
	call Get_Random_color ;gets balloon in al and char colour in ah
    mov [balloon_color + bx], al
	mov [balloon_char_color + bx], ah
    
    ; Set character
    push bx
    shl bx, 1
    call Get_Random_alphabet ;gets random alphabet in ax and code in dl
	
    mov [balloon_char + bx], ax
	shr bx,1
	mov [balloon_char_code + bx],dl
	
    pop bx
    
  
    
    ; Calculate buffer offset (384 bytes per balloon)
    push bx
    mov ax, bx
    mov cx, 384
    mul cx
    mov di, ax
    add di, balloon_bg_buffers
    
    ; Save background
    pop bx
    push bx
    push di
    
    ; Get X position
    shl bx, 1
    mov ax, [balloon_x + bx]
    shr bx, 1
    push ax                     ; Save X on stack
    
    ; Get Y position
    shl bx, 1
    mov cx, [balloon_y + bx]
    shr bx, 1
    
    pop bx                      ; BX = X position
    pop di                      ; DI = buffer offset
    
    call save_data
    pop bx
    
    ; Draw the balloon
    push bx
    call draw_balloon_at_index
    pop bx
    
    ; Mark balloon as active
    mov byte [balloon_active + bx], 1
    inc word [active_balloon_count]
    
.skip_spawn:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret



;===========RAndom functions====================

Get_Random_alphabet:
    push cx
    push bx
    
    mov ax, [random_seed]
    mov cx, 25173
    mul cx                      ; DX:AX = seed * 25173
    add ax, 13849               ; Add constant
    adc dx, 0                   ; Handle carry
    mov [random_seed], ax       ; Store new seed 
    
    ; Now get index: seed % RANDOM_X_COUNT
    ; AX already contains the random value
    xor dx, dx                  ; Clear DX for division
    mov cx, 24
    div cx                      ; DX = AX % 18 (remainder in DX)
    
    ; DX now contains index (0-17)
    mov bx, dx ;id currently in dx
    shl bx, 1                   ; BX = index * 2 (word array)
    mov ax, [random_balloon_char + bx]     ; Get random X value
	
    
    pop bx
    pop cx
    ret       ;returns character in ax and id in dl
Get_Random_color:
		push bx
    push cx
    push dx
    
    mov ax, [random_seed]
    mov cx, 25173
    mul cx                      ; DX:AX = seed * 25173
    add ax, 13849               ; Add constant
    adc dx, 0                   ; Handle carry
    mov [random_seed], ax       ; Store new seed 
    
    ; Now get index: seed % RANDOM_X_COUNT
    ; AX already contains the random value
    xor dx, dx                  ; Clear DX for division
    mov cx, 5
    div cx                      ; DX = AX % 18 (remainder in DX)
    
    ; DX now contains index (0-17)
    mov bx, dx               
    mov al, [random_balloon_color + bx]     ; Get random X value
	mov ah, [random_char_color + bx]
    
    pop dx
    pop cx
    pop bx
    ret

Get_Random_x:
	push bx
    push cx
    push dx
    
    mov ax, [random_seed]
    mov cx, 25173
    mul cx                      ; DX:AX = seed * 25173
    add ax, 13849               ; Add constant
    adc dx, 0                   ; Handle carry
    mov [random_seed], ax       ; Store new seed 
    
    ; Now get index: seed % RANDOM_X_COUNT
    ; AX already contains the random value
    xor dx, dx                  ; Clear DX for division
    mov cx, 18     ; CX = 18
    div cx                      ; DX = AX % 18 (remainder in DX)
    
    ; DX now contains index (0-17)
    mov bx, dx
    shl bx, 1                   ; BX = index * 2 (word array)
    mov ax, [random_x + bx]     ; Get random X value
    
    pop dx
    pop cx
    pop bx
    ret
; ============================================================
; draw_balloon_at_index
; Draws balloon at given index
; Input: BX = balloon index
; ============================================================
draw_balloon_at_index:
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; Get X position
    push bx
    shl bx, 1
    mov cx, [balloon_x + bx]
    shr bx, 1
    
    ; Get Y position
    shl bx, 1
    mov dx, [balloon_y + bx]
    shr bx, 1
    
    ; Get color
    mov al, [balloon_color + bx]
    pop bx
    
    ; Draw balloon body
    push bx
	mov bh,1
    call DrawBalloon
    pop bx
    
    ; Draw character inside balloon
    push bx
    
    ; Get character data
    shl bx, 1
    mov ax, [balloon_char + bx]
    mov [write_word], ax
    
    ; Get X position + offset
    mov cx, [balloon_x + bx]
    add cx, 4
    
    ; Get Y position + offset
    mov dx, [balloon_y + bx]
    add dx, 5
    shr bx, 1
    
    ; Get character color
    mov al, [balloon_char_color + bx]
    mov [ColorHolder], al
    
    pop bx
    
    mov si, 1
    call DrawA
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ============================================================
; erase_balloon_at_index
; Restores background for balloon at given index
; Input: BX = balloon index
; ============================================================
erase_balloon_at_index:
    push ax
    push bx
    push cx
    push dx
    push di
    
    ; Calculate buffer offset
    mov ax, bx
    push bx
    mov cx, 384
    mul cx
    mov di, ax
    add di, balloon_bg_buffers
    
    pop bx
    push bx
    push di
    
    ; Get X position
    shl bx, 1
    mov ax, [balloon_x + bx]
    shr bx, 1
    push ax
    
    ; Get Y position
    shl bx, 1
    mov cx, [balloon_y + bx]
    
    pop bx                      ; BX = X
    pop di                      ; DI = buffer
    
    ; Restore background
    call load_data
    
    pop bx
    
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ============================================================
; move_all_balloons
; Moves all active balloons upward
; ============================================================
move_all_balloons:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov si, 0                   ; Balloon index
    mov cx, MAX_BALLOONS
    
.move_loop:
    push cx
    push si
    
    ; Check if this balloon is active
    mov bx, si
    cmp byte [balloon_active + bx], 0
    je .next_balloon
    
    ; Erase balloon at current position
    call erase_balloon_at_index
    
    ; Move balloon up - get current Y
    mov bx, si
    shl bx, 1
    mov ax, [balloon_y + bx]
    sub ax, [pixels_to_skip]
    mov [balloon_y + bx], ax
    shr bx, 1
    
    ; Check if balloon reached top (y <= 0)
    cmp ax, 0
    jle .deactivate_balloon
    
    ; Save new background
    push si
    mov ax, si
    mov cx, 384
    mul cx
    mov di, ax
    add di, balloon_bg_buffers
    
    pop si
    push si
    push di
    
    ; Get X
    mov bx, si
    shl bx, 1
    mov ax, [balloon_x + bx]
    push ax
    
    ; Get Y
    mov cx, [balloon_y + bx]
    
    pop bx                      ; BX = X
    pop di                      ; DI = buffer
    
    call save_data
    pop si
    
    ; Draw balloon at new position
    mov bx, si
    call draw_balloon_at_index
    
    jmp .next_balloon
    
.deactivate_balloon:
    ; Balloon reached top - deactivate it
    mov bx, si
    mov byte [balloon_active + bx], 0
    dec word [active_balloon_count]
    
.next_balloon:
    pop si
    pop cx
    inc si
    loop .move_loop
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ============================================================
; move_balloon
; Main function - moves all balloons and spawns new ones
; Call this continuously in your game loop
; ============================================================
move_balloon:
    push ax
    
    ; Move all active balloons
    call move_all_balloons
    
    ; Try to spawn new balloon
    call spawn_balloon
    
    ; Small delay to control frame rate
    mov ax, 1
    call Delay
    
    pop ax
    ret

; ============================================================
; ScanCodeToAlphabet
; Input: AH = scan code
; Output: AL = alphabet index (0-23) or 0xFF if invalid
; ============================================================
ScanCodeToAlphabet:
    push bx
    
    mov al, 0xFF
    
    cmp ah, 0x1E
    je .LetterA
    cmp ah, 0x30
    je .LetterB
    cmp ah, 0x2E
    je .LetterC
    cmp ah, 0x20
    je .LetterD
    cmp ah, 0x12
    je .LetterE
    cmp ah, 0x21
    je .LetterF
    cmp ah, 0x22
    je .LetterG
    cmp ah, 0x23
    je .LetterH
    cmp ah, 0x17
    je .LetterI
    cmp ah, 0x24
    je .LetterJ
    cmp ah, 0x25
    je .LetterK
    cmp ah, 0x26
    je .LetterL
    cmp ah, 0x32
    je .LetterM
    cmp ah, 0x31
    je .LetterN
    cmp ah, 0x18
    je .LetterO
    cmp ah, 0x10
    je .LetterQ
    cmp ah, 0x13
    je .LetterR
    cmp ah, 0x1F
    je .LetterS
    cmp ah, 0x14
    je .LetterT
    cmp ah, 0x16
    je .LetterU
    cmp ah, 0x2F
    je .LetterV
    cmp ah, 0x11
    je .LetterW
    cmp ah, 0x2D
    je .LetterX
    cmp ah, 0x2C
    je .LetterZ
    jmp .Done
    
.LetterA: mov al, 0
    jmp .Done
.LetterB: mov al, 1
    jmp .Done
.LetterC: mov al, 2
    jmp .Done
.LetterD: mov al, 3
    jmp .Done
.LetterE: mov al, 4
    jmp .Done
.LetterF: mov al, 5
    jmp .Done
.LetterG: mov al, 6
    jmp .Done
.LetterH: mov al, 7
    jmp .Done
.LetterI: mov al, 8
    jmp .Done
.LetterJ: mov al, 9
    jmp .Done
.LetterK: mov al, 10
    jmp .Done
.LetterL: mov al, 11
    jmp .Done
.LetterM: mov al, 12
    jmp .Done
.LetterN: mov al, 13
    jmp .Done
.LetterO: mov al, 14
    jmp .Done
.LetterQ: mov al, 15
    jmp .Done
.LetterR: mov al, 16
    jmp .Done
.LetterS: mov al, 17
    jmp .Done
.LetterT: mov al, 18
    jmp .Done
.LetterU: mov al, 19
    jmp .Done
.LetterV: mov al, 20
    jmp .Done
.LetterW: mov al, 21
    jmp .Done
.LetterX: mov al, 22
    jmp .Done
.LetterZ: mov al, 23
    
.Done:
    pop bx
    ret

; ============================================================
; balloon_game_loop
; Example of how to use the balloon system
; Call this after game_screen setup
; ============================================================
balloon_game_loop:
    push ax
    
    ; Initialize system
    call init_balloon_system
    
.main_loop:
    ; Move/spawn balloons
    call move_balloon
    
    ; Check for keypress (ESC to exit)
    mov ah, 1                  ; Check if key available
    int 0x16
    jz .main_loop              ; No key pressed, continue
    
    ; Key pressed - read it
    mov ah, 0
    int 0x16
    
    ;scan code in al
	    cmp ah, 19h           ; ESC scan code
    je .PauseGame
    
    ; Process other keys
    call ScanCodeToAlphabet
    cmp al, 0xFF
    je .NoKeyCheck
    
    ; Search for matching balloon
    mov bl, al
    xor si, si
    
.SearchBalloon:
    mov al, [MAX_BALLOONS]
    xor ah, ah
    cmp si, ax
    jge .NoKeyCheck
    
    mov al, [balloon_active + si]
    cmp al, 0
    je .NextSearch
    
    mov al, [balloon_char_code + si]
    cmp al, bl
    je .FoundMatchingBalloon
    
.NextSearch:
    inc si
    jmp .SearchBalloon
    
.FoundMatchingBalloon:
    
	
	mov bx,si                      ;balloon to be deleted index in si
    call erase_balloon_at_index
	
	;sound
	in   al, 61h
    or   al, 03h
    out  61h, al

    mov  dx, 10000
.delaypop:
    dec  dx
    jnz  .delaypop

    ; Turn off speaker
    in   al, 61h
    and  al, 0FCh
    out  61h, al
    ; Mark as deleted
    mov byte [balloon_active + si], 0
    
	
	.PauseGame:
	.NoKeyCheck:
	
    
    
    
    jmp .main_loop
    
.exit_game:
    pop ax
    ret
; ============================================================
; GetTickCount - Returns current system tick count
; Output: AX = tick count (low word)
; ============================================================
GetTickCount:
    push es
    
    mov ax, 0x40
    mov es, ax
    mov ax, [es:0x6C]
    
    pop es
    ret




; ============================================================
; Delay
; Inputs:
;   AX = number of timer ticks to wait (18.2 ticks per second)
;        1 tick ≈ 55ms, 18 ticks ≈ 1 second
;
; Uses IRQ0 timer at 0040:006C (system tick counter)
; ============================================================
Delay:
    push ax
    push bx
    push cx
    push dx
    push es
    
    or ax, ax                   ; If delay = 0, return immediately
    jz .DelayDone
    
    mov cx, ax                  ; CX = tick count to wait
    
    ; Read current tick count
    push ds
    mov ax, 0x40
    mov es, ax
    mov bx, [es:0x6C]           ; BX = current tick count (low word)
    pop ds
    
    add bx, cx                  ; BX = target tick count
    
.DelayLoop:
    push ds
    mov ax, 0x40
    mov es, ax
    mov dx, [es:0x6C]           ; DX = current tick count
    pop ds
    
    cmp dx, bx                  ; Compare current vs target
    jb .DelayLoop               ; If current < target, keep waiting
    
.DelayDone:
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
	
	
	
	
	
	; ============================================================
; save_data
; ============================================================
save_data:
    push ax
    push bx  ; top left x coordinate
    push cx  ; top left y coordinate
    push dx
    push si
    push di  ; offset of buffer
    push bp  
    push ds  
    push es
	
	push cs
	pop es
	
    mov ax, 0A000h
    mov ds, ax          ; DS -> video memory
    mov dx, 24          ; height counter (24 rows)
    
.RowLoop:
    ; Compute offset = y * 320 + x
	cmp cx,199
	jg .skip
    mov ax, cx          ; AX = y
    shl ax, 6           ; AX = y * 64
    mov si, ax
    shl ax, 2           ; AX = y * 256
    add si, ax          ; SI = y*320
    add si, bx          ; SI = y*320 + x
    
    mov bp, 16          ; width counter
    push cx             ; save Y
    
.CopyLoop:
    mov al, [ds:si]     ; read pixel
    mov [es:di], al     ; write to buffer
    inc si
    inc di
    dec bp
    jnz .CopyLoop
    
    pop cx              ; restore Y
	.skip:
    inc cx              ; next row (y = y+1)
    dec dx
    jnz .RowLoop
    
	pop es
    pop ds   ; *** RESTORE DS! ***
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
; ============================================================
; load_data
; ============================================================
load_data:
    push ax
    push bx         ;top left y co ordinate
    push cx         ;top left x co ordinate
    push dx
    push si
    push di        ;offset of buffer
    push bp              
	push ds
	push es
	
	push cs
	pop es
    
    mov ax, 0A000h
    mov ds, ax          ; DS -> video memory
    mov dx, 24          ; 24 rows
    
.RowLoop:
    ; Compute video offset = y*320 + x
	cmp cx,199
	jg .skip
    mov ax, cx          ; AX = y
    shl ax, 6           ; AX = y*64
    mov si, ax
    shl ax, 2           ; AX = y*256
    add si, ax          ; SI = y*320
    add si, bx          ; SI = y*320 + x
    
    mov bp, 16          ; width counter
    push cx             ; save Y
    
.CopyLoop:
    mov al, [es:di]     ; read from buffer
    mov [ds:si], al     ; write to screen
    inc di
    inc si
    dec bp
    jnz .CopyLoop
    
    pop cx              ; restore Y
	.skip:
    inc cx              ; next row
    dec dx
    jnz .RowLoop
    
	pop es
	pop ds
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	; ============================================================
; save_screen
; ============================================================
save_screen:
    push ax
    push cx
    push si
    push di
    push ds
    push es
    
    mov ax, 0xA000
    mov ds, ax
    xor si, si
    
    push cs
    pop es
    mov di, screen_buffer
    
    mov cx, 32000
    rep movsw
    
    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret

; ============================================================
; load_screen
; ============================================================
load_screen:
    push ax
    push cx
    push si
    push di
    push ds
    push es
    
    mov ax, 0xA000
    mov es, ax
    xor di, di
    
    push cs
    pop ds
    mov si, screen_buffer
    
    mov cx, 32000
    rep movsw
    
    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret
;================================================
	

start:
	
	call drawMainMenu
	jmp start
exit:
	; Restore text mode
	mov ax, 3
	int 10h
	mov ax, 4ch
	int 21h
	
	
	screen_buffer times 64000 db 0