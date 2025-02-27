.model tiny
.data
size_x dw 35d
size_y dw 10d
;text db 'Hello, World!', 0
;len_text dw $ - text
frame_color db 01100111b
text_color  db 01011010b
symbol_for_central_part db 21d
buffer_for_text db 20 dup(0)

.code
org 100h
Start:
    call Read_the_text
    mov bx, 0b800h
    call Draw_Frame
    call Print_Text
    mov ax, 4c00h
    int 21h

;----------------------------------------------------------
;Read_the_text
;----------------------------------------------------------
Read_the_text proc
    xor cx, cx
    mov si, offset buffer_for_text
InputLoop:
    mov ah, 00h
    int 16h
    cmp al, 0Dh
    je Finish

    cmp al, 08h  ; Backspace?
    je Backspace

    mov ah, 0Eh
    int 10h

    mov [si], al
    inc si
    inc cx
    cmp cx, 20
    jl InputLoop
Backspace:
    cmp cx, 0
    je Finish

    dec si
    dec cx

    mov ah, 0Eh
    mov al, 08h; Delete symbol
    int 10h
    mov al, ' '
    int 10h
    mov al, 08h
    int 10h
    jmp InputLoop

Finish:
    mov byte ptr [si], 0
    ret
endp
;----------------------------------------------------------
; Draw_Frame
;----------------------------------------------------------
Draw_Frame proc
    xor ax, ax
    mov dx, size_x
    call Draw_Horizontal_Line

    mov cx, size_y
    call Draw_Central_Part
    xor ax, ax
    mov dx, size_y
    dec dx
    mul dx
    add bx, ax
    mov dx, size_x
    call Draw_Horizontal_Line
    ret
endp

;----------------------------------------------------------
; Draw Horizontal line
; Entry: DX - size_x
;----------------------------------------------------------
Draw_Horizontal_Line proc
    mov es, bx
    mov di, 0
    mov ah, frame_color
    mov al, '/'
    mov word ptr es:[di], ax
    add di, 2

    mov cx, dx
    sub cx, 2
Next:
    mov al, symbol_for_central_part  ; Заполняем середину
    mov word ptr es:[di], ax
    add di, 2
    loop Next

    mov ah, frame_color
    mov al, '\'
    mov word ptr es:[di], ax
    ret
endp

;----------------------------------------------------------
; Draw Central Part of frame
; Entry: CX - size_y
;----------------------------------------------------------
Draw_Central_Part proc
    mov si, cx
    dec si
    dec si
Cycle:
    add bx, 10d
    mov es, bx
    mov di, 0
    mov ah, frame_color
    mov al, symbol_for_central_part
    mov word ptr es:[di], ax
    ;mov word ptr es:[di], 0E219h ;219d

    mov cx, size_x
    sub cx, 2
    mov di, 2

FillLoop:
    mov byte ptr es:[di], 20h; fill spaces
    add di, 2
    loop FillLoop

    mov al, symbol_for_central_part
    mov word ptr es:[di], ax
    ;mov word ptr es:[di], 0E219h ;219d
    dec si
    jnz Cycle
    ret
endp

;----------------------------------------------------------
; Print str in videomem
;----------------------------------------------------------
Print_Text proc
    mov ax, size_y
    shr ax, 1
    mov bx, 0b800h
    mov dx, ax
    mov ax, 10d
    mul dx
    add bx, ax
    mov es, bx

    mov di, 8  ; Shift the string closer to the left edge

    mov si, offset buffer_for_text
    mov ah, text_color
PrintLoop:
    mov al, [si]
    cmp al, 0
    je Done
    mov word ptr es:[di], ax
    add di, 2
    inc si
    jmp PrintLoop
Done:
    ret
endp

end Start
