;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <section 1001>
;  Assignment: <assignment number 2>
;  Description: <Program to find min, median, max, sum, & integer average>


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
lst		dd	 4224, -1116,  1542,  1240,  1677
		dd	-1635,  2420,  1820,  1246,  -333 
		dd	 2315,  -215,  2726,  1140,  2565
		dd	 2871,  1614,  2418,  2513,  1422 
		dd	 -119,  1215, -1525,  -712,  1441
		dd	-3622,  -731, -1729,  1615,  2724 
		dd	 1217,  -224,  1580,  1147,  2324
		dd	 1425,  1816,  1262, -2718,  1192 
		dd	-1435,   235,  2764, -1615,  1310
		dd	 1765,  1954,  -967,  1515,  1556 
		dd	 1342,  7321,  1556,  2727,  1227
		dd	-1927,  1382,  1465,  3955,  1435 
		dd	 -225, -2419, -2534, -1345,  2467
		dd	 1615,  1959,  1335,  2856,  2553 
		dd	-1035,  1833,  1464,  1915, -1810
		dd	 1465,  1554,  -267,  1615,  1656 
		dd	 2192,  -825,  1925,  2312,  1725
		dd	-2517,  1498,  -677,  1475,  2034 
		dd	 1223,  1883, -1173,  1350,  2415
		dd	 -335,  1125,  1118,  1713,  3025
length		dd	100

lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

negCnt		dd	0
negSum		dd	0
negAve		dd	0

sixCnt		dd	0
sixSum		dd	0
sixAve		dd	0



; ----------------------------------------------
;  Uninitialized Static Data Declarations.

section	.bss

;	Place data declarations for uninitialized data here...
;	(i.e., large arrays that are not initialized)


; *****************************************************************

section	.text
global _start
_start:
; ******** CODE BELOW ********

;Find the Minimum 

;initialize min to lst[0]
;loop
; if lst[i] < lstMin: lstMin = lst[i]

mov eax, dword [lst] ; place lst in eax
mov dword [lstMin], eax ; initializes first item in list to lstMin
mov rsi, 0 ; set index counter to zero
mov ecx, dword [length] ; set ecx length to use loop instruction to count down

minLoop:

    mov eax, dword [lst + rsi*4] ; gets lst[i] 
    cmp eax, dword [lstMin] ; compare lstMin & lst[i]
    jg minDone ;            lst[i] < lst[lstMin] only jumps if greater
    mov dword [lstMin], eax ; overwrite current lstMin 

minDone:

    inc rsi ; increment rsi+=1
    loop minLoop 



; *****************************
; Estimated median value

; Median: lst[len/2] + lst[len/2 -1]+ lst[0] + lst[len-1] / 4

;len/2 

mov eax, dword [length]
mov r8d, 2
mov rdx, 0
div r8d     ; eax = len/2
mov rdi, 0  ; first bits are 0 cuz positive?
mov edi, eax   ;rdi = len/2

mov eax, dword [lst] ; lst[0]
add eax, dword [lst + (rdi * 4)] ; lst[len/2 ]
add eax, dword [lst + (rdi - 1)*4] ; lst[len/2 -1]
add eax, dword [lst + ((rdi * 2)*4)-4 ] ; ; lst[len -1] ; lst[lst+4len-4]
cdq
mov r11d, 4 ; store our four here
idiv r11d    ; div by 4
mov dword [estMed], eax


; Maximum
mov eax, dword [lst] ; place lst in eax
mov dword [lstMax], eax ; initializes first item in list to lstMax
mov rsi, 0 ; set index counter to zero
mov ecx, dword [length] ; set ecx length to use loop instruction to count down

maxLoop:

    mov eax, dword [lst + rsi*4] ; gets lst[i] 
    ; Get sum within max loop
    add dword [lstSum], eax
    cmp eax, dword [lstMax] ; compare lstMax & lst[i]... if statement
    jl maxDone ; if statement only jumps if less than 
    mov dword [lstMax], eax ; if lst[i] > lstMax: lstMax = lst[i]
    
maxDone:
    inc rsi ; increment rsi+= 1
    loop maxLoop
    ;loop equiv to:
    ; dec rcx
    ; cmp rcx, 0
    ;jne maxLoop



;********************************
; integer average of a list of numbers

; lstAve = lstSum / len
; signed dword division

mov eax, dword [lstSum]
cdq                     ; signed extension edx:eax
idiv dword [length]
mov dword [lstAve], eax
; **************************
;   Negative Stuff

; negative count 

mov eax, dword [lst] ; place lst in eax
mov rsi, 0 ; set index counter to zero
mov ecx, dword [length] ; set ecx length to use loop instruction to count down

negLoop:

    mov eax, dword [lst + rsi*4] ; gets lst[i] 
    ; if lst[i] < 0
    ;       negCnt += 1
    ;       negSum += lst[i]
    cmp eax , 0 ; comparison 
    jge negDone ;will jump if less than 0
    ;want it to be less than
    ;Negative Number
    add dword [negSum], eax ; negSum += lst[i]
    inc dword [negCnt] ; increment count
    ; negNum:
    ;     ;Negative Number
    ;     add dword [negSum], eax ; negSum += lst[i]
    ;     inc dword [negCnt] ; increment count
    ;     jmp negDone
    
negDone:
    inc rsi ; increment rsi+= 1
    loop negLoop

; negative average doesnt need to be in loop
; negAve = negSum / negCnt
; signed dword division

mov eax, dword [negSum]
cdq                     ; signed extension edx:eax
idiv dword [negCnt]
mov dword [negAve], eax


; **************************
;Numbers divisible by 6:
; only focus on remainder ah, ax, edx, rdx
; add<sumSix> + originalNumber not eax

mov eax, dword [lst] ; place lst in eax
mov rsi, 0 ; set index counter to zero
mov ecx, dword [length] ; set ecx length to use loop instruction to count down

sixLoop:

    mov eax, dword [lst + rsi*4] ; gets lst[i] 
    ; if lst[i] % 6 == 0
    ;       sixCnt += 1
    ;       sixSum += lst[i]
    cdq 
    mov r13d, 6
    idiv r13d
    cmp edx , 0 ; comparison 
    jne sixDone ;will jump if not equal to zero
    ;want it to be equal to
    ;divisible by 6 Number below
    mov eax, dword[lst + rsi*4]
    add dword [sixSum], eax; sixSum += lst[i]
    inc dword [sixCnt] ; increment count

    
sixDone:
    inc rsi ; increment rsi+= 1
    loop sixLoop
; sum

; count 

; integer average
mov eax, dword [sixSum]
cdq                     ; signed extension edx:eax
idiv dword [sixCnt]
mov dword [sixAve], eax

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
