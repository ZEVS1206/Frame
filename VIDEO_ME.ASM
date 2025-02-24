.model tiny
.data
size_x dw 35d
size_y dw 10d
text db 'Hello, World!', 0
len_text dw $ - text

.code
org 100h
Start:
    mov bx, 0b800h
    call Draw_Frame
    call Print_Text
    mov ax, 4c00h
    int 21h

;----------------------------------------------------------
; Draw_Frame
;----------------------------------------------------------
Draw_Frame proc
    xor ax, ax
    mov dx, size_x
    call Draw_Horizontal_Line

    mov cx, size_y
    call Draw_Central_Part

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
    mov byte ptr es:[di], '/'
    add di, 2

    mov cx, dx
    sub cx, 2
Next:
    mov byte ptr es:[di], 219d
    add di, 2
    loop Next

    mov byte ptr es:[di], '\'
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
    mov byte ptr es:[di], 219d

    mov cx, size_x
    sub cx, 2
    mov di, 2

FillLoop:
    mov byte ptr es:[di], 20h; fill spaces
    add di, 2
    loop FillLoop

    mov byte ptr es:[di], 219d
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

    mov di, len_text  ; Shift the string closer to the left edge

    mov si, offset text
PrintLoop:
    mov al, [si]
    cmp al, 0
    je Done
    mov byte ptr es:[di], al
    add di, 2
    inc si
    jmp PrintLoop
Done:
    ret
endp

end Start
