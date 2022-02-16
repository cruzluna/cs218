; ****************************************************************************
;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <section 1002>
;  Assignment: 6
;  Description:	Simple assembly language program to convert
;		integers to tridecimal/ASCII charatcers and output
;		the tridecimal/ASCII strings to the screen (using the
;		provided routine).


; ****************************************************************************
;  STEP #2
;  Macro, "tri2int", to convert a tridecimal/ASCII string
;  into an integer.  The macro reads the ASCII string (byte-size,
;  NULL terminated) and converts to a doubleword sized integer.
;	- Accepts both 'A' and 'a' (which are treated as the same thing).
;	- Accepts both 'B' and 'b' (which are treated as the same thing).
;	- Accepts both 'C' and 'c' (which are treated as the same thing).
;	- Assumes valid/correct data, no error checking is performed.
;  Skips any leading blanks.

;  Example:  given the ASCII string: " 01aB", NULL
;  The is,  " " (blank) followed by "0" followeed by "1" followed
;  by "a" followed by "B" and NULL would be converted to integer 310.

; -----
;  Arguments
;	%1 -> string address (reg)
;	%2 -> integer number (destination address)

; -----
; Algorithm:
;	YOUR ALGORITHM GOES HERE

%macro	tri2int	2

;	YOUR CODE GOES HERE
mov r8, %1 ; place string into r8
mov r9 , 0 		; index
mov dword [rSum], 0
;skip blanks
%%isBlk:
; get str[i]
; if str[i] != NULL -> go to different loop instructions
; else: incr index
; jmp isBlk

	mov al, byte [r8 + r9]  ; str[i]
	cmp al, " " 
	jne %%nxtChr 	; jumps to next set of instructions
	inc r9		; increment index if str[i] is blank
	jmp %%isBlk 

	

mov r15d, 0

%%nxtChr:
;Algo
; get char
; if char is NULL -> exit  ; terminate instruction here
; convert char to int
; rsum = (rsum * 13) + int (currentIndex value)
; goto nxtChr ; unconditinoal loop 


	mov r15b, byte [r8 + r9]
	cmp r15b, NULL
	je %%Done		; terminates
	;convert to char
	sub r15b, '0' ; convert char to int

	; if x <= 9: dont need to process
	; if r15b > 49: lowercase (subtract 39)
	; if r15b > 17: upper case (subtract 7)
	cmp r15b, 9
	jle %%resume

	cmp r15b, 49 ; '1' == 49
	jge %%lowercase

	cmp r15b, 17 
	jge %%uppercase
	
	%%resume:
		; rsum * 13 
		mov eax, [rSum] ; move rSum into register
		;mov r10d, eax ; save the value from eax  b/c muliply overwrites eax
		mul dword [dNum]		; multiply by 13 (dNum = 13)
		add eax, r15d ; adds the int saved in lower r15

		mov dword [%2], eax 	; place rSum+int into iNum1
		mov dword [rSum] , eax		; update rSum

		inc r9		; increment 
		jmp %%nxtChr

%%lowercase:
	; process lowercase
	sub r15b, 39

	jmp %%resume

%%uppercase:
	; process uppercase
	sub r15b, 7

	jmp %%resume


%%Done:
	; Do nothing 
	;mov spl, 0
	

%endmacro

; --------------------------------------------------------------

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
;  Variables and constants.

MAX_STR_SIZE	equ	10

; -----
;  Misc. data definitions (if any).
dNum 		dd 	13
rSum 		dd	0
; -----
;  Assignment #6 Provided Data:

dStr1		db	"    12a4B", NULL
iNum1		dd	0

dStrLst1	db	"     1a9C", NULL, "      3Ab", NULL, "    1cA92", NULL
		db	"    82bAc", NULL, "      bac", NULL
len1		dd	5
sum1		dd	0

dStrLst2	db	"      3A8", NULL, "    A6791", NULL, "    193b0", NULL
		db	"    250b0", NULL, "   a13081", NULL, "    14b21", NULL
		db	"    224A2", NULL, "    11010", NULL, "    11201", NULL
		db	"     10C0", NULL, "        B", NULL, "       c6", NULL
		db	"      7b1", NULL, "     C009", NULL, "    19a45", NULL
		db	"    15557", NULL, "     23a9", NULL, "    189c0", NULL
		db	"    A12a4", NULL, "    11c11", NULL, "    12a2c", NULL
		db	"    11B92", NULL, "    15a10", NULL, "    1b667", NULL
		db	"     B726", NULL, "     B312", NULL, "      420", NULL
		db	"     55C2", NULL, "    26516", NULL, "     5182", NULL
		db	"      192", NULL, "    21a44", NULL, "     18c4", NULL
		db	"     79a6", NULL, "    24c12", NULL, "     a231", NULL
		db	"     97B5", NULL, "    17312", NULL, "      812", NULL
		db	"      7c4", NULL, "    123A4", NULL, "    278b1", NULL
		db	"        7", NULL, "        c", NULL, "    B1512", NULL
		db	"     7c52", NULL, "    11b44", NULL, "    10134", NULL
		db	"     7a64", NULL, "     4b71", NULL, "     2c44", NULL
		db	"      2b4", NULL, "    112c2", NULL, "    11aa5", NULL
		db	"     2012", NULL, "    22a30", NULL, "     7164", NULL
		db	"     1067", NULL, "    117b1", NULL, "    21000", NULL
		db	"     2b74", NULL, "     2127", NULL, "    23212", NULL
		db	"      117", NULL, "    20c63", NULL, "    b2112", NULL
		db	"    11C45", NULL, "    11064", NULL, "    11B21", NULL
		db	"    260a0", NULL, "    23A75", NULL, "    c3725", NULL
		db	"     3A10", NULL, "      120", NULL, "    13332", NULL
		db	"    10C22", NULL, "     7B60", NULL, "    a2313", NULL
		db	"    11c60", NULL, "     4312", NULL, "    17b65", NULL
		db	"    23241", NULL, "    27C31", NULL, "      730", NULL
		db	"     4313", NULL, "    30233", NULL, "    13657", NULL
		db	"    31113", NULL, "     1661", NULL, "    11312", NULL
		db	"    17A55", NULL, "    12241", NULL, "    13C31", NULL
		db	"     3270", NULL, "     7a53", NULL, "    15127", NULL
		db	"       A5", NULL, "    7a3b1", NULL, "   AbCaBc", NULL
		db	"     1b9c", NULL
len2		dd	100
sum2		dd	0

; ****************************************************************************

section	.bss

iLst1		resd	5
iLst2		resd	100

tempNum		resd	1

; ****************************************************************************

section	.text
global	_start
_start:

; ==================================================
;  Main program
;	perform conversion (non-macro)
;	calls the macro on various data items

; -----
;  STEP #1
;	Convert tridecimal/ASCII NULL terminated string at 'dStr1'
;	into an integer which should be placed into 'iNum1'
;	Note, 12A4B (base-13) = 34,708 (base-10)
;	DO NOT USE MACRO HERE!!
; 



; Algorithm 
; " _ _ _ 1AB", NULL
;   ^start----->^end

; Registers
; r8 => address of string
; r9 => i = 0 index: [r8+r9]
mov r8, dStr1 ; place string into r8
mov r9 , 0 		; index

;skip blanks
isBlk:
; get str[i]
; if str[i] != NULL -> go to different loop instructions
; else: incr index
; jmp isBlk

; string == bytes!!

	mov al, byte [r8 + r9]  ; str[i]
	cmp al, " " 
	jne nxtChr 	; jumps to next set of instructions
	inc r9		; increment index if str[i] is blank
	jmp isBlk 

	

mov r15d, 0

nxtChr:
;Algo
; get char
; if char is NULL -> exit  ; terminate instruction here
; convert char to int
; rsum = (rsum * 13) + int (currentIndex value)
; goto nxtChr ; unconditinoal loop 


	mov r15b, byte [r8 + r9]
	cmp r15b, NULL
	je Done		; terminates
	;convert to char
	sub r15b, '0' ; convert char to int

	; if x <= 9: dont need to process
	; if r15b > 49: lowercase (subtract 39)
	; if r15b > 17: upper case (subtract 7)
	cmp r15b, 9
	jle resume

	cmp r15b, 49 ; '1' == 49
	jge lowercase

	cmp r15b, 17 
	jge uppercase
	
	resume:
		; rsum * 13 
		mov eax, [rSum] ; move rSum into register
		;mov r10d, eax ; save the value from eax  b/c muliply overwrites eax
		mul dword [dNum]		; multiply by 13 (dNum = 13)
		add eax, r15d ; adds the int saved in lower r15

		mov dword [iNum1], eax 	; place rSum+int into iNum1
		mov dword [rSum] , eax		; update rSum

		inc r9		; increment 
		jmp nxtChr

lowercase:
	; process lowercase
	sub r15b, 39

	jmp resume

uppercase:
	; process uppercase
	sub r15b, 7

	jmp resume


Done:
	; Do nothing 


;	YOUR CODE GOES HERE
; ***** END *****
; -----
;  Perform (iNum1 * 4) operation.
;	Note, 34,708 (base-10) * 4 (base-10) = 138,832 (base-10)

	mov	eax, dword [iNum1]
	mov	ebx, 4
	mul	ebx
	mov	dword [iNum1], eax

; ==================================================
;  Next, repeatedly call the macro on each value in an array.

;  Data Set #1 (short list)

	mov	ecx, dword [len1]		; length
	mov	rbx, iLst1			; starting index of integer list
	mov	rdi, dStrLst1			; address of string

cvtLoop1:
	push	rcx				; preserver registers
	push	rdi				; so macro can alter them
	push	rbx

	tri2int	rdi, tempNum

	mov	eax, dword [tempNum]
	add	dword [sum1], eax

	pop	rbx
	mov	dword [rbx], eax
	add	rbx, 4

	pop	rdi
	add	rdi, MAX_STR_SIZE

	pop	rcx
	dec	rcx				; check length
	cmp	rcx, 0
	ja	cvtLoop1

; ==================================================
;  Data Set #2 (long list)

	mov	rcx, [len2]			; length
	mov	rbx, iLst2			; starting index of integer list
	mov	rdi, dStrLst2			; address of string

cvtLoop2:
	push	rcx				; preserver registers
	push	rdi				; so macro can alter them
	push	rbx

	tri2int	rdi, tempNum

	mov	eax, dword [tempNum]
	add	dword [sum2], eax

	pop	rbx
	mov	dword [rbx], eax
	add	rbx, 4

	pop	rdi
	add	rdi, MAX_STR_SIZE

	pop	rcx
	dec	rcx				; check length
	cmp	rcx, 0
	ja	cvtLoop2

; ==================================================
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, SUCCESS
	syscall

; ****************************************************************************

