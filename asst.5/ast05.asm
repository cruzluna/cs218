
;  Assignment: <assignment number 5>
;  Description: <Calculate geometric info>


; *****************************************************************
;  Static Data Declarations (initialized)

section	.data


; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Initialized Static Data Declarations.

;	Place data declarations here...

; Below
aSides		db	   10,    14,    13,    37,    54
		db	   31,    13,    20,    61,    36
		db	   14,    53,    44,    19,    42
		db	   27,    41,    53,    62,    10
		db	   19,    28,    14,    10,    15
		db	   15,    11,    22,    33,    70
		db	   15,    23,    15,    63,    26
		db	   24,    33,    10,    61,    15
		db	   14,    34,    13,    71,    81
		db	   38,    73,    29,    17

cSides		dd	 1145,  1135,  1123,  1123,  1123
		dd	 1254,  1454,  1152,  1164,  1542
		dd	 1353,  1457,  1182,  1142,  1354
		dd	 1364,  1134,  1154,  1344,  1142
		dd	 1173,  1543,  1151,  1352,  1434
		dd	 1355,  1037,  1123,  1024,  1453
		dd	 1134,  2134,  1156,  1134,  1142
		dd	 1267,  1104,  1134,  1246,  1123
		dd	 1134,  1161,  1176,  1157,  1142
		dd	 1153,  1193,  1184,  1142

pSides		dw	  133,   114,   173,   131,   115
		dw	  164,   173,   174,   123,   156
		dw	  144,   152,   131,   142,   156
		dw	  115,   124,   136,   175,   146
		dw	  113,   123,   153,   167,   135
		dw	  114,   129,   164,   167,   134
		dw	  116,   113,   164,   153,   165
		dw	  126,   112,   157,   167,   134
		dw	  117,   114,   117,   125,   153
		dw	  123,   173,   115,   106

qSides		dd	 2183,  2372,  3231,  3121,  2153
		dd	 3254,  1342,  5341,  4158,  1523
		dd	 2125,  3133,  7384,  2274,  2114
		dd	 5645,  1371,  3123,  3317,  1923
		dd	 1634,  2334,  1156,  4164,  2742
		dd	 3453,  4153,  2284,  2142,  3144
		dd	 5345,  5130,  1423,  2113,  4123
		dd	 2434,  1334,  3056,  3184,  1242
		dd	 2353,  2153,  2284,  1142,  2334
		dd	 3145,  1934,  2123,  4113

length		dd	49

aMin		dd	0
aeMed		dd	0
aMax		dd	0
aSum		dd	0
aAve		dd	0

pMin		dd	0
peMed		dd	0
pMax		dd	0
pSum		dd	0
pAve		dd	0


; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)
kiteAreas	resd	49
kitePerims	resd	49

; *****************************************************************

section	.text
global _start
_start:
; ******** CODE BELOW ********
; AREA
; kiteAreas[i] = (psides[i]*qsides[i])/2
; UNSIGNED DATA

mov ecx, dword [length] ; initialize our length
mov dword [aSum], 0     ; initialize sum to 0
mov rsi, 0              ; counter (index)

kiteAreasLoop:
    mov eax, 0  ; set eax register to 0
    mov ebx, 2  ; set ebx register to 2
    mov ax, word [pSides + rsi * 2] ; rsi * 2 b/c skip two bytes word takes 2 bytes (word)
    mul dword [qSides + rsi * 4]    ; *4 b/c dd takes up 4 bytes (double word)
    ;mov dword [kiteAreas + rsi * 4], eax ; store area  DOESNT WORK HERE
    ; Need to divide eax / 2
    div ebx  
    mov dword [kiteAreas + rsi * 4], eax ; store area 
    add dword [aSum], eax
    inc rsi
    loop kiteAreasLoop
;   dec rcx
;   cmp rcx, 0
;   jne kiteAreasLooop

; Area average = aSum / length
; unsigned dword division
mov eax, [aSum] ; place sum into eax register
mov edx, 0 
div dword [length]    ; eax = aSum/length
mov [aAve], eax

; ESTIMATED MEDIAN
; first = arr[0]
; last = arr[length-1]
; middle = arr[len/2]
; median = (first + middle + last)/3

; calc len/2
mov eax, dword [length]
mov r8d , 2     
mov rdx, 0      ; b/c unsigned
div r8d         ; eax = len/2
mov rdi , 0
mov edi, eax    ; rdi = len / 2

; calc len-1
mov rsi, 0 
mov esi, dword [length]
dec rsi         ; rsi = len -1

; aeMed
mov eax, dword [kiteAreas]          ; first
add eax, dword [kiteAreas + rdi * 4]    ; middle
add eax, dword [kiteAreas + rsi * 4]    ; last
mov rdx, 0
mov r11d, 3
div r11d                ; eax = median
mov dword [aeMed] , eax


; MINIMUM   
mov eax, [kiteAreas]
mov dword [aMin], eax 
mov rsi, 0 ; set counter to 0
mov ecx, dword [length]

minLoop:
    mov eax, dword [kiteAreas + rsi * 4] ; kiteAreas[i]
    cmp eax, dword [aMin] 
    jge minDone     ; jumps if KA[i] >= aMin
    mov dword [aMin], eax   ; overwrite aMin with new min val
minDone:
    inc rsi
    loop minLoop

; MAXIMUM 
mov eax, [kiteAreas]
mov dword [aMax], eax 
mov rsi, 0 ; set counter to 0
mov ecx, dword [length]

maxLoop:
    mov eax, dword [kiteAreas + rsi * 4] ; kiteAreas[i]
    cmp eax, dword [aMax] 
    jbe maxDone     ; jumps if KA[i] <= aMin
    mov dword [aMax], eax   ; overwrite aMin with new min val
maxDone:
    inc rsi
    loop maxLoop


; *****PERIMETER*****
; kitePerims[i] = 2 * aSides[i] * cSides[i]
mov ecx, dword [length] ; initialize our length
mov dword [pSum], 0     ; initialize sum to 0
mov rsi, 0              ; counter (index)

kitePerimeterLoop:
    mov eax, 0 ; set eax to 0
    
    mov al, byte [aSides + rsi] ; rsi * 1 
    mov edx, 0
    mul dword [cSides + rsi * 4]  
    mov r9d, 2
    mul r9d 
    mov dword [kitePerims + rsi * 4], eax ; store kPerims 
    add dword [pSum], eax
    inc rsi
    loop kitePerimeterLoop

; Perimeter average = pSum / length
; unsigned dword division
mov eax, [pSum] ; place sum into eax register
mov edx, 0 
div dword [length]    ; eax = aSum/length
mov [pAve], eax

; ESTIMATED MEDIAN
; first = arr[0]
; last = arr[length-1]
; middle = arr[len/2]
; median = (first + middle + last)/3

; calc len/2
mov eax, dword [length]
mov r8d , 2     
mov rdx, 0      ; b/c unsigned
div r8d         ; eax = len/2
mov rdi , 0
mov edi, eax    ; rdi = len / 2

; calc len-1
mov rsi, 0 
mov esi, dword [length]
dec rsi         ; rsi = len -1

; peMed
mov eax, dword [kitePerims]          ; first
add eax, dword [kitePerims + rdi * 4]    ; middle
add eax, dword [kitePerims + rsi * 4]    ; last
mov rdx, 0
mov r11d, 3
div r11d                ; eax = median
mov dword [peMed] , eax


; MINIMUM   
mov eax, [kitePerims]
mov dword [pMin], eax 
mov rsi, 0 ; set counter to 0
mov ecx, dword [length]

pminLoop:
    mov eax, dword [kitePerims + rsi * 4] ; kitePerims[i]
    cmp eax, dword [pMin] 
    jge pminDone     ; jumps if KP[i] >= pMin
    mov dword [pMin], eax   ; overwrite pMin with new min val
pminDone:
    inc rsi
    loop pminLoop

; MAXIMUM 
mov eax, [kitePerims]
mov dword [pMax], eax 
mov rsi, 0 ; set counter to 0
mov ecx, dword [length]

pmaxLoop:
    mov eax, dword [kitePerims + rsi * 4] ; kiteAreas[i]
    cmp eax, dword [pMax] 
    jbe pmaxDone     ; jumps if KA[i] <= pMin
    mov dword [pMax], eax   ; overwrite pMin with new min val
pmaxDone:
    inc rsi
    loop pmaxLoop
; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
