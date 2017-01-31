section .data
pixelx             dd 1
pixely             dd 1
destposition       dd 0
rgba               times 4 db 0

section .text
global rotateUD

rotateUD:
push                rbp             ;tut
mov                 rbp, rsp            ;tut

%define             input rdi
%define             output rsi
%define             width rdx
%define             height rcx
mov                 rax, rdx
mul                 rcx                     ;czemu tu jest używane rdx???!!!!
lea                 rax, [rax*4]
mov                 rbx, rax                ; Ustawiamy licznik rbx (width*height*4)
add                 rdi, rbx
sub                 rdi, 4

for:
# Obrót o 90 stopni w lewo wyszukuje piksel źródłowy na pozycji (x,y)  x: <1;nowa_wysokość> y: <1;nowa_szerokość>
# Wyrażone jest to wzorem P(x,y) = Szerokość*y - x + 1  gdzie Wysokość i Szerokość są to wymiary źródła

# push               rax                       ;Zwalniamy sobie rejestry do wykonania obliczeń
# push               rbx
# push               rcx
# push               rsi
# push
# mov                rax, [pixelx]
# mov                rbx, [pixely]
# mov                rcx, [destposition]
# mov
# mov                rbx, dword [height]

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

sub                rdi, 4
add                rsi, 4
sub                rbx, 4
cmp                rbx, 0
jne                for
end:

# Przywracamy esp
mov                 rsp, rbp
pop                 rbp
ret
