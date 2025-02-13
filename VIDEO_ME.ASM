.model tiny
.code
org 100h
Start:
        mov bx, 0b800h
;        mov ah, 0h
        mov cx, 010d
        mov dx, cx
        call Draw_a_line
        mov cx, dx
        call Draw_a_central_part
        mov cx, dx
        call Draw_a_line
;        mov es, bx
;        mov bx, 0
;        mov byte ptr es:[bx], 'A'
;        mov byte ptr es:[bx + 1], 11011010b
;        int 21h
        mov ax, 4c00h
        int 21h

;----------------------------------------------------------|
;Draw a line:                                              |
;Entry: CX - len                                           |
;       ES:DI - line begining addr                         |
;----------------------------------------------------------|
Draw_a_line     proc
        mov es, bx
        mov di, 0
        mov byte ptr es:[di], '/'
        add di, 2

Next:   mov byte ptr es:[di], '_'
        add di, 2
        loop Next

        mov byte ptr es:[di], '\'
        ret
        endp


;----------------------------------------------------------|
;Draw a central part:                                      |
;Entry: CX - len                                           |
;       ES:DI - line begining addr                         |
;----------------------------------------------------------|
Draw_a_central_part     proc

Cycle:  add bx, 010d
        mov es, bx
        mov di, 0
        mov byte ptr es:[di], '|'
        add di, dx
        add di, dx
        add di, 2
        mov byte ptr es:[di], '|'
        loop Cycle
        ret
        endp

end     Start
