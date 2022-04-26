; *****************************************************************
;  Name: Cruz Luna
;  NSHE ID: 2001582775
;  Section: 1002
;  Assignment: 12
;  Description: Threading

;  CS 218 - Assignment #12
;  Happy/Sad Numbers Program
;  Provided template

; -----
;  Results:
;	Count of happy/sad numbers between 1 and 1000 (5bc, b-13): 
;		Happy Numbers: 143
;		Sad Numbers:   857

;	Count of happy/sad numbers between 1 and 40000000 (8396851, b-13):
;		Happy Count: 5577647
;		Sad Count:   34422353

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
ESC		equ	27			; escape key

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

; -----
;  Variables/constants for thread function.

msgThread1	db	"    ...Thread starting...", LF, NULL
spc		db	"   ", NULL

idxCounter	dq	1
myLock		dq	0

COUNT_SET	equ	100

; -----
;  Variables for printMessageValue

newLine		db	LF, NULL

; -----
;  Variables/constants for getCommandLineArgs function

THREAD_MIN	equ	1
THREAD_MAX	equ	4

LIMIT_MIN	equ	10
LIMIT_MAX	equ	4000000000

errUsage	db	"Usgae: ./happyNums -t<1|2|3|4> ",
		db	"-lm <base13Number>", LF, NULL
errOptions	db	"Error, invalid command line options."
		db	LF, NULL
errTSpec	db	"Error, invalid thread count specifier."
		db	LF, NULL
errLMSpec	db	"Error, invalid limit specifier."
		db	LF, NULL
errLMValue	db	"Error, limit invalid."
		db	LF, NULL

tmpNum	dd	0

; Variables used for base13toint()
dNum 		dd 	13
rSum 		dd	0

;  Uninitialized data
section 	.bss 

iNum1 		resd	1


; ***************************************************************

section	.text

; ******************************************************************
;  Function getCommandLineArgs()
;	Get, check, convert, verify range, and return the
;	sequential/parallel option and the limit.

;  Example HLL call:
;	bool = getCommandLineArgs(argc, argv, &thdConut, &numberLimit)

;  This routine performs all error checking, conversion of
;  ASCII/base-13 to integer, verifies legal range.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;./happyNums -t<1|2|3|4> -lm <base13Number>
; 

; -----
;  Arguments:
;	1) ARGC, value ---> rdi
;	2) ARGV, address ---> rsi
;	3) thread count (dword), address ---> rdx
;	4) limit (qword), address ---> rcx

global getCommandLineArgs
getCommandLineArgs:
	push rbx
	push r12
	push r13
	;push r14
	;push r15
	mov r12, rcx	; preserve limi address
	mov r13, rdx ; preserve thread count address

	cmp rdi, 1
	jbe usageError
	cmp rdi, 2
	jbe optionError
	
	cmp rdi, 4
	ja optionError

	cmp rdi, 4
	jb usageError

	; Thread Specifier check
	mov rbx, qword [rsi + 8] ; argv[1]
	mov al, byte [rbx]	; check '-'
	cmp al, '-'
	jne errorTSpec

	mov al, byte [rbx + 1] ; check for t
	cmp al, 't' 
	jne errorTSpec

	mov al, byte [rbx + 3] ; check for null
	cmp al, NULL
	jne errorTSpec

	mov al, byte [rbx + 2]	; check for thread count
	sub al, '0'
	; check if 1<= t <= 4
	cmp al, THREAD_MIN
	jb errorTSpec
	cmp al, THREAD_MAX
	ja errorTSpec
	; store thread count 
	mov dword[rdx], eax 

	; Limit Specifier check
	mov rbx, qword [rsi + 16]
	mov al, byte [rbx] ; check -
	cmp al, '-'
	jne errorLMSpec

	mov al, byte [rbx + 1] ; check for l
	cmp al, 'l'
	jne errorLMSpec

	mov al, byte [rbx + 2] ; check for m
	cmp al, 'm'
	jne errorLMSpec
	
	mov al, byte [rbx + 3]	; check for null
	cmp al, NULL
	jne errorLMSpec
	
	mov rbx, qword [rsi + 24] ; <Base13Number>
	; move number to a tmpNum
	;mov dword[tmpNum], ebx
	mov esi, dword[iNum1] ; move integer number to rsi

	mov rdi, rbx ; base13str
	; call base13toint() 
	call cvtB132int
	; check if T/F
	cmp rax, FALSE
	je errorLMValue
	; check Limit min and max

	cmp dword[iNum1], LIMIT_MIN
	jb errorLMValue

	cmp dword[iNum1], LIMIT_MAX
	ja errorLMValue


	; save limit specifier
	mov r8d, dword [iNum1]
	mov qword [r12], r8

	mov rax, TRUE
	jmp Done


; -------- Errors ---------
	usageError:
	mov rdi, errUsage
	call printString
	mov rax, FALSE
	jmp Done

	optionError:
	mov rdi, errOptions
	call printString
	mov rax, FALSE
	jmp Done

	errorTSpec:
	mov rdi, errTSpec
	call printString
	mov rax, FALSE
	jmp Done

	errorLMSpec: 
	mov rdi, errLMSpec
	call printString
	mov rax, FALSE
	jmp Done

	errorLMValue:
	mov rdi, errLMValue
	call printString
	mov rax, FALSE
	jmp Done
; ----------------

	Done:

		pop r13
		pop r12
		pop rbx
		ret











; ******************************************************************
;  Function: Check and convert ASCII/base13 string
;  		to integer.

;  Example HLL Call:
;	bool = cvtB132int(base13Str, &num);
; Arguments:
;	1) base13str - string address rdi
;	2) &num -> integer number rsi
; Return: 
; 	bool
global cvtB132int
cvtB132int:

	push r12
	push r15

	mov r15, 0
	mov r12, rdi	; preserve addresss of string
	
	mov r9, 0 ; index
	mov dword [rSum], 0 ; reset sum 

;----------------------------
	; char base 13 check
	chkValid:
	; unsigned char c = str[i];
	; bool valid;
	; c -= '0';
	; if (c > 'C' - '0') c -= 'a' - 'A';
	; if (c <= 9 || ('A' - '0' <= c && c <= 'C' - '0')) vaild = true;
	; else vaild = false;	
	
	; get char from base13str (passed arg)
	mov al, byte [r12 + r9] ; str[i]
	cmp al, '0'		; if char < '0' : invalid
	jb notValid
	
	; cmp al, 'd'
	; jae notValid

	; cmp al, '9'
	; jbe validChar

	; ;cmp al, 'x' 
	; ;je notValid 

	; cmp al, 'A'
	; jb notValid

	; cmp al, 'C'
	; jbe validChar

	; cmp al, 'a'
	; jb notValid

	; cmp al, 'c' 
	; jbe validChar


	sub al, '0'	; convert char-> (char - 48) = int value

	
	cmp al, 51
	ja check

	jmp resumeCheck

	check:
		; c -= 'a' - 'A'
		sub al, 32
		jmp resumeCheck


	resumeCheck:
    ;if (c <= 9 || ('A' - '0' <= c && c <= 'C' - '0')) vaild = true;
    ;else vaild = false;	
	cmp al, 9
	jbe validChar

	cmp al, 17	; 'A' - '0'  = 17
	jae lastCheck

	;if it didnt meet condition, jmp error
	jmp notValid

	lastCheck:
		cmp al, 19 ; 'C' - '0' = 19
		jbe validChar	; if <= 19: jmp to valid
		;else: jmp invalid
		jmp notValid


	validChar:
		;reset index 
		;mov r9, 0
		inc r9
		mov al, byte [r12 + r9]
		cmp al, NULL
		je isBlkbefore
		jmp chkValid
		;jmp isBlkbefore
	;----------------------------------------
	;skip blanks
	isBlkbefore:
		mov r9, 0 ; reset index
	isBlk:
	; get str[i]
	; if str[i] != NULL -> go to different loop instructions
	; else: incr index
	; jmp isBlk

		mov al, byte [r12 + r9]  ; str[i]
		cmp al, " " 
		jne nxtChr 	; jumps to next set of instructions
		inc r9		; increment index if str[i] is blank
		jmp isBlk 

		

	

	nxtChr:
	;Algo
	; get char
	; if char is NULL -> exit  ; terminate instruction here
	; convert char to int
	; rsum = (rsum * 13) + int (currentIndex value)
	; goto nxtChr ; unconditinoal loop 


		mov r15b, byte [r12 + r9]
		cmp r15b, NULL
		je DoneSucess		; terminates
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
			
			mul dword [dNum]		; multiply by 13 (dNum = 13)
			add eax, r15d ; adds the int saved in lower r15
			mov dword[iNum1], eax	; place rSum+int into iNum1 (&num)

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

	
	notValid:
		mov rax, FALSE
		jmp Done2
	DoneSucess:
		mov rax, TRUE
		

	Done2:
		; terminate
		pop r15
		pop r12
		ret






; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	- address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
; Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret




; ******************************************************************
;  Thread function, findHappyNumbers()
;	Find happy numbers.

; -----
;  Global variables accessed.

common	numberLimit	1:8
common	happyCount	1:8
common	sadCount	1:8

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)

global findHappyNumbers
findHappyNumbers:
	push rbx
	push r12 ; sum of squares
	;push r14 ; 
	push r13 ; 
	push r15; number limt

	mov r12, 0
	;mov r14, 0
	mov r15, qword [numberLimit]

	; print start message
	mov rdi, msgThread1
	call printString

	; while true
	loopTrue:
	; 	get set of #'s to work open
		call spinLock
		mov rbx, qword [idxCounter]
		add qword [idxCounter], COUNT_SET
		call spinUnlock

	; 	if currentN > limit: exit
		;cmp qword[idxCounter], r15
		cmp rbx, r15
		ja loopDone

	; check if endNumber is less than COUNT_SET, if so use that for endNumber
	; else: only do 100 iterations as endNumber
	cmp qword[numberLimit], COUNT_SET
	jb alterEndNumber
	;else
	mov rcx, COUNT_SET
	jmp after

	alterEndNumber:
		mov rcx, qword [numberLimit]
	
	after:
	; 	for(i = startN; i < endN; i++)
		;mov rcx, 99	; only want 100 iterations
		;mov rcx, qword [idxCounter] ; updated count
		;sub rcx, rbx ; rbx => startNumber
		; start Number would be rbx
		mov r8, rbx ; save startNumber
		mov r11, rbx
		forLoop:
	; 		compute Happy/sad
			mov r8, r11
			cmp r8, 1
			je happy
			cmp r8, 7
			je happy
			; the rest of happy numbers are two digits

			; reset sum 
			mov r12, 0 ; r12 => sum
			; while n > 0
			whileLoop:
				mov rax, r8	 ; start number goes into r8

				mov rdx, 0
				mov r9, 10
				div r9 ; <op64>	
				; save quotient
				mov r10, rax ; r10=> quotient

				; sum += (remainder**2)

				mov rax, rdx
				mul rax 	; rem**2
				add r12, rax	; sum += (r^2)

				; check if quotient is zero
				; if !quot: jmp out
				cmp r10, 0 ; if quot > 0: go to whileLoop
				je exitWhile
				mov r8, r10 ; move digit into n to keep process
				jmp whileLoop

			; OUT OF WHILE LOOP
			exitWhile:
			; if sum == 1 or sum == 4:
			;		sad/happy
				
				cmp r12, 4
				je sad
				cmp r12, 1
				je happy
			; else:
			; 	move sum back into r8 (number to be processed)
			;	reset sum
			;	jmp back into whileloop
				;cmp r12, 9
				;jbe sad ; if sum <= 9: sad
				mov r8, r12
				mov r12, 0	; reset sum
				jmp whileLoop

			happy:
	; 		if happy:
	; 			happy++
				lock inc qword [happyCount]
				;inc qword [happyCount]
				jmp resume2

			sad:
	; 		else:
	; 			sad ++
				lock inc qword [sadCount]
				;inc qword [sadCount]
			resume2:
			;mov r8, r11 ; preserved number
			;inc r8 ; increment number
			inc r11
			loop forLoop

		jmp loopTrue
	
	loopDone:
		pop r15
		pop r13
		pop r12
		pop rbx
		ret






; ******************************************************************
;  Mutex lock
;	checks lock (shared gloabl variable)
;		if unlocked, sets lock
;		if locked, lops to recheck until lock is free

global	spinLock
spinLock:
	mov	rax, 1			; Set the RAX register to 1.

lock	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
					; This will always store 1 to the lock, leaving
					;  the previous value in the RAX register.

	test	rax, rax	        ; Test RAX with itself. Among other things, this will
					;  set the processor's Zero Flag if RAX is 0.
					; If RAX is 0, then the lock was unlocked and
					;  we just locked it.
					; Otherwise, RAX is 1 and we didn't acquire the lock.

	jnz	spinLock		; Jump back to the MOV instruction if the Zero Flag is
					;  not set; the lock was previously locked, and so
					; we need to spin until it becomes unlocked.
	ret

; ******************************************************************
;  Mutex unlock
;	unlock the lock (shared global variable)

global	spinUnlock
spinUnlock:
	mov	rax, 0			; Set the RAX register to 0.

	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
	ret

; ******************************************************************

