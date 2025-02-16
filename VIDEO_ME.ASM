.model tiny
.data
size_x dw 030d
size_y dw 010d
position_for_phrase_x db ?
position_for_phrase_y db ?
.code
org 100h
Start:
        mov cx, size_x
        mov ax, size_y
        mov bl, 02d
        div bl
        mov position_for_phrase_y, al
        mov ax, size_x
        div bl
        ;div bl
        mov position_for_phrase_x, al

        mov bx, 0b800h
;        call Print_a_phrase
        mov dx, cx
        call Draw_a_line

        mov cx, size_y
        call Draw_a_central_part

        mov cx, size_x
        call Draw_a_line

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

Next:   mov byte ptr es:[di], 219d
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
        mov byte ptr es:[di], 219d
;        add di, 2
        begin_if:
                cmp cx, 06d
                jne else_if
                call Print_a_phrase
                jmp end_if
        else_if:
                add di, dx
                add di, dx
                add di, 2
        end_if:
        mov byte ptr es:[di], 219d
        loop Cycle
        ret
        endp

;----------------------------------------------------------|
;Print a phrase:                                           |
;Entry: BX - position in frame                             |
;----------------------------------------------------------|
Print_a_phrase    proc
        mov es, bx
        mov al, position_for_phrase_x
        cbw
        add di, ax
        add di, 1
        mov byte ptr es:[di], 'H'
        mov byte ptr es:[di + 2], 'e'
        mov byte ptr es:[di + 4], 'l'
        mov byte ptr es:[di + 6], 'l'
        mov byte ptr es:[di + 8], 'o'
        add di, 10
        add di, ax
        add di, ax
        add di, 6
        ret
        endp



end     Start
