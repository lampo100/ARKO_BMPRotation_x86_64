section .data
pixelx             dq 1
pixely             dq 1
width              dq 0
height             dq 0
input              dq 0
output             dq 0
destposition       dd 0
rgba               times 4 db 0

section .text
global rotateR
rotateR:
push                rbp
mov                 rbp, rsp


mov                 [output], rsi
mov                 [input], rdi
mov                 [width], rdx
mov                 [height], rcx
mov                 rax, rcx
imul                rax, [width]
lea                 rax, [rax*4]
mov                 rcx, rax                ; Ustawiamy licznik (width*height*4)

for:
# Obrót o 90 stopni w lewo wyszukuje piksel źródłowy na pozycji (x,y)  x: <1;nowa_wysokość> y: <1;nowa_szerokość>
# Wyrażone jest to wzorem P(x,y) = Szerokość*y - x + 1  gdzie Wysokość i Szerokość są to wymiary źródła

# push               eax                       ;Zwalniamy sobie rejestry do wykonania obliczeń
# push               ebx
# push               ecx
# push               esi
# push
# mov                eax, [pixelx]
# mov                ebx, [pixely]
# mov                ecx, [destposition]
# mov
; mov                ebx, dword [height]
pocz:
 mov                rax, [height]
 mov                rbx,[pixelx]
 sub                rax, rbx                 ;w eax jest (wysokość - y)(NIE PIXELY, POZYCJA Y W MACIERZY)
 mov                rbx, [width]
 mul                rbx                      ; w eax jest (Wysokość - y)*Szerokość
 mov                rbx, [pixely]
 add                rax, rbx                 ; w eax jest (Wysokość - y)*Szerokość + x

docelowy:
 mov                rbx, 4
 mul                rbx                     ; w eax jest docelowy_piksel * 4
 sub                rax, 4                  ; wskazujemy na docelowy_piksel
 add                rdi, rax                ;
tutaj:
 mov                dl, byte [rdi]          ; Ładuję do dl pierwszy pixel
 mov                byte [rgba], dl         ; składuję pierwszy pixel

 mov                dl, byte [rdi+1]        ; Ładuję do dl drugi pixel
 mov                byte [rgba + 1], dl     ; Składuję drugi pixel

 mov                dl, byte [rdi + 2]      ; Ładuję do dl trzeci pixel
 mov                byte [rgba + 2], dl     ; Składuję trzeci pixel

 mov                byte [rgba + 3], 0xFF    ; Skłdauję 0 jako alfę

 mov                al, byte [rgba]         ; Ładuję pierwszy pixel do al
 mov                byte [rsi], al          ; Zapisuję do obrazka docelowego

 mov                al, byte [rgba + 1]     ; Ładuję drugi pixel do al
 mov                byte [rsi + 1], al          ; Zapisuję do obrazka docelowego

 mov                al, byte [rgba + 2]     ; Ładuję trzeci pixel do al
 mov                byte [rsi + 2], al          ; Zapisuję do obrazka docelowego

 mov                al, byte [rgba + 3]     ; Ładuję alfę do al
 mov                byte [rsi + 3], al          ; Zapisuję do obrazka docelowego


 mov                rbx, [pixelx]
 mov                rax, [height]
 cmp                rbx, rax                ; sprawdzamy czy doszliśmy do końca wiersza w nowym obrazku
 jne                continuex
zerox:
 mov                qword [pixelx], 1       ; zerujemy numer pixela w wierszu
 mov                rbx, qword [pixely]     ; zwiększamy numer wiersza
 inc                rbx
 mov                qword [pixely], rbx
 jmp                next

continuex:
 mov                rbx, qword [pixelx]
 inc                rbx
 mov                qword [pixelx], rbx
next:
 mov                rdi, [input]
 add                rsi, 4
 sub                rcx, 4
 jnz                for
end:
mov                 rsi, [output]
mov                 rdi, [input]
mov                 rdx, [width]
mov                 rcx, [height]
# Przywracamy esp
mov                 rsp, rbp
pop                 rbp
ret
