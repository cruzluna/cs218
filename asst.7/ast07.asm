; *****************************************************************
;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <section 1002>
;  Assignment: 7
;  Description:	Simple assembly language program to sort
;		a list of integers using the provided gnome
;		sort algorithm.


;  Write a simple assembly language program to sort
;  a list of integers using the provided gnome sort algorithm.

; -----
;  GNOME Sort Algorithm:
;	function gnomeSort(a[0..size-1]) {
;		i := 1
;		j := 2
;		while (i < size)
;			if (a[i-1] <= a[i])
;				i := j
;				j := j + 1 
;		else
;			swap a[i-1] and a[i]
;			i := i - 1
;			if (i = 0) i := 1
;		}

; *****************************************************************************
;  Macros to find the statistical information.
;	findSumAve - calculate sum and average
;	findMinMax - calculate minimum and maximum
;	findMid - calculate middle value

; -----
;  findSumAve	sepIntArr, len, sum, ave

%macro	findSumAve	4

;	YOUR CODE GOES HERE
; %1 -> lst
; %2 -> length of array
; %3 -> sum (initialized to zero)
; %4 -> lst average (initialized to zero)

; place lst in register
; place length in register
; intialize sum 
; intizlize average
; initialize a counter 

mov eax, dword [%1]
mov ecx, dword [%2]	; initialize length in ecx 
mov rsi , 0

%%sumLoop: 
	mov eax, dword [%1 + rsi * 4]
	add dword [%3], eax
	inc rsi
	loop %%sumLoop

mov eax, dword [%3] ; place sum in eax register
mov edx, 0
div dword [%2]		; eax = sum/length
mov dword [%4], eax



%endmacro


; -----
;  findMinMax	sepIntArr, len, min, max

%macro	findMinMax	4

; %1 -> lst
; %2 -> length of array
; %3 -> min
; %4 -> max

;	YOUR CODE GOES HERE

;place lst in register
; place length in registyer
; intialize a counter
mov eax, dword [%1]	; lst
mov dword [%3], eax
mov ecx, dword [%2]	; length

mov rsi, 0 			; counter

%%minLoop:

	; iterate through list
	; update min 

	; if end of list, done
	mov eax, dword [%1 + rsi * 4]

	;process min 
	cmp eax, dword [%3]
	jge %%minDone
	mov dword[%3], eax ; update min

%%minDone:
	inc rsi
	loop %%minLoop


mov eax, dword [%1]	; lst
mov ecx, dword [%2]	; length
mov rsi, 0 			; counter

%%maxLoop:

	; iterate through list
	; update max
	; if end of list, done
	mov eax, dword [%1 + rsi * 4]

	;process MAX 
	cmp eax, dword [%3]
	jl %%maxDone
	mov dword[%4], eax	; update max

%%maxDone:
	inc rsi
	loop %%maxLoop

%endmacro


; -----
;  findSumAve	sepIntArr, len, mid

%macro	findMid		3

;	YOUR CODE GOES HERE
; %1 -> list
; %2 -> length
; %3 -> median

; check if length is odd or even
; data is only for odd so should be fine

; len / 2
mov edi, dword [%1]
mov eax, dword [%2]
mov edx, 0
mov r10d, 2
div r10d	; eax = len/2

;mov r11,0 
;mov r11d, r10d 	; r11 = len/2
dec eax

mov r13d , dword [%1 + eax * 4] ; list[middle] into r13d
mov dword [%3], r13d ; mid 

%endmacro


; *****************************************************************************

section	.data


; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----

lst	dd	123,  42, 146,  76, 120,  56, 164,  65, 155,  57
	dd	111, 188,  33,  05,  27, 101, 115, 108,  13, 115
	dd	 17,  26, 129, 117, 107, 105, 109,  30, 150,  14
	dd	147, 123,  45,  40,  65,  11,  54,  28,  13,  22
	dd	 69,  26,  71, 147,  28,  27,  90, 177,  75,  14
	dd	181,  25,  15,  22,  17,   1,  10, 129,  12, 134
	dd	 61,  34, 151,  32,  12,  29, 114,  22,  13, 131
	dd	127,  64,  40, 172,  24, 125,  16,  62,   8,  92
	dd	111, 183, 133,  50,   2,  19,  15,  18, 113,  15
	dd	 29, 126,  62,  17, 127,  77,  89,  79,  75,  14
	dd	114,  25,  84,  43,  76, 134,  26, 100,  56,  63
	dd	 24,  16,  17, 183,  12,  81, 320,  67,  59, 190
	dd	193, 132, 146, 186, 191, 186, 134, 125,  15,  76
	dd	 67, 183,   7, 114,  15,  11,  24, 128, 113, 112
	dd	 24,  16,  17, 183,  12, 121, 320,  40,  19,  90
	dd	135, 126, 122, 117, 127,  27,  19, 127, 125, 184
	dd	 97,  74, 190,   3,  24, 125, 116, 126,   4,  29
	dd	104, 124, 112, 143, 176,  34, 126, 112, 156, 103
	dd	 69,  26,  71, 147,  28,  27,  39, 177,  75,  14
	dd	153, 172, 146, 176, 170, 156, 164, 165, 155, 156
	dd	 94,  25,  84,  43,  76,  34,  26,  13,  56,  63
	dd	147, 153, 143, 140, 165, 191, 154, 168, 143, 162
	dd	 11,  83, 133,  50,  25,  21,  15,  88,  13,  15
	dd	169, 146, 162, 147, 157, 167, 169, 177, 175, 144
	dd	 27,  64,  30, 172,  24,  25,  16,  62,  28,  92
	dd	181, 155, 145, 132, 167, 185, 150, 149, 182,  34
	dd	 81,  25,  15,   9,  17,  25,  37, 129,  12, 134
	dd	177, 164, 160, 172, 184, 175, 166,  62, 158,  72
	dd	 61,  83, 133, 150, 135,  31, 185, 178, 197, 185
	dd	147, 123,  45,  40,  66,  11,  54,  28,  13,  22
	dd	 49,   6, 162, 167, 167, 177, 169, 177, 175, 164
	dd	161, 122, 151,  32,  70,  29,  14,  22,  13, 131
	dd	 84, 179, 117, 183, 190, 100, 112, 123, 122, 131
	dd	123,  42, 146,  76,  20,  56,  64,  66, 155,  57
	dd	 39, 126,  62,  41, 127,  77, 199,  79, 175,  14
len	dd	350

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0


; --------------------------------------------------------------

section	.text
global	_start
_start:

; -----
;  GNOME Sort Algorithm:
;	function gnomeSort(a[0..size-1]) {
;		i := 1
;		j := 2
;		while (i < size)
;			if (a[i-1] <= a[i])
;				i := j
;				j := j + 1 
;			else
;				swap a[i-1] and a[i]
;				i := i - 1
;				if (i = 0) i := 1
;		}

; initialize list
; place size value in register
; Set counters i & j
mov rcx, 0 			; cleary garbage data

mov eax, dword [lst]
mov ecx, dword [len] ; length in eax 
mov rsi, 1 ; i = 1
mov rdi, 2 ; j = 2

; while loop
whileLoop:
	
	;check if i< size
	;cmp i, size
	;jge exitWhile
	cmp rsi , rcx
	jge exitWhile

	;if (a[i-1] <= a[i])
	; comparison
	;if less than or equal, keep moving along
	;jg jump to else

	mov eax, dword [lst + rsi * 4]; lst[i]
	;temp variable to hold i-1
	;mov ebp, dword [rsi]
	;dec ebp
	;sub rbp, 4
	mov r8d, dword [lst + (rsi * 4) - 4] ;lst[i-1]
	
	cmp eax, r8d
	;cmp r8d, eax
	jl elseLoop	; need to swap if lst[i-1]> lst[i] 

	; less than , continue & dont swap
	; wrong ->mov rsi, qword [rdi] ; i = j
	mov rsi, rdi 		; i = j
	inc rdi ; j += 1
	jmp whileLoop		; jump back to while Loop
	
	elseLoop: 

	;else loop
		;swap values 
		
		; SWAP:
		; r8d == lst[i-1]
		; eax == lst [i]
		mov dword [lst + (rsi * 4) - 4], eax
		mov dword [lst + rsi * 4], r8d


		
		; decrement i
		; cmp i , 0
		; not equal jump back to while loop (jne)
		;else overwrite i

		dec rsi ; i-=1
		cmp rsi, 0
		jne whileLoop
		mov rsi, 1 ; i = 1
		jmp whileLoop


; exit while loop
exitWhile:
	; do nothing
	;loop is terminated
; -----
;  Sort numbers via gnome sort.


;	YOUR CODE GOES HERE




; -----
;  Use macros to find stats

	findSumAve	lst, len, sum, avg
	findMinMax	lst, len, min, max
	findMid		lst, len, med


; ******************************
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, SUCCESS
	syscall

