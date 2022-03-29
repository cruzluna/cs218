; *****************************************************************
;  Name: <your name>
;  NSHE ID: <your id>
;  Section: <section>
;  Assignment: 10
;  Description: <description here>

;  Functions Template.

; -----
;  Function getParams()
;	Gets, checks, converts, and returns command line arguments.

;  Function drawCircle()
;	Plots provided function

; ---------------------------------------------------------

;	MACROS (if any) GO HERE
; 	tri2int
;  Arguments
;	%1 -> string address (reg)
;	%2 -> integer number 

%macro tri2int 2

	;need to check character

	; code below should be good 
	;	YOUR CODE GOES HERE
	push r15
	push r12 
	push r13 


	mov r15, 0
	mov r12, %1 ; place string into r12 (preserved)
	;mov r13, %2	; place value in r13

	mov r9 , 0 		; index
	mov dword [rSum], 0


	;---------------------------------------
	; Char base 13 check
	%%chkValid:
	; get str[i]
	; check if upper
	; check if lower
	; if not, jmp error notValid

	; unsigned char c = str[i];
	; bool valid;
	; c -= '0';
	; if (c > 'C' - '0') c -= 'a' - 'A';
	; if (c <= 9 || ('A' - '0' <= c && c <= 'C' - '0')) vaild = true;
	; else vaild = false;

	; valid -> jmp to valid and reinitialize r9 (index)
	mov al, byte [r12 + r9]  ; str[i]
	cmp al, '0'		; if char < '0' : invalid
	jb %%notValid

	sub al, '0'	; convert char-> (char - 48) = int value
	cmp al, 51
	ja %%check
	jmp %%resumeCheck

	%%check:
		; c -= 'a' - 'A'
		sub al, 32
		jmp %%resumeCheck


	%%resumeCheck:
    ;if (c <= 9 || ('A' - '0' <= c && c <= 'C' - '0')) vaild = true;
    ;else vaild = false;	
	cmp al, 9
	jbe %%validChar

	cmp al, 17	; 'A' - '0'  = 17
	jae %%lastCheck

	;if it didnt meet condition, jmp error
	jmp %%notValid

	%%lastCheck:
		cmp al, 19 ; 'C' - '0' = 19
		jbe %%validChar	; if <= 19: jmp to valid
		;else: jmp invalid
		jmp %%notValid


	%%validChar:
		;reset index 
		mov r9, 0
		jmp %%isBlk

	;----------------------------------------
	;skip blanks
	%%isBlk:
	; get str[i]
	; if str[i] != NULL -> go to different loop instructions
	; else: incr index
	; jmp isBlk

		mov al, byte [r12 + r9]  ; str[i]
		cmp al, " " 
		jne %%nxtChr 	; jumps to next set of instructions
		inc r9		; increment index if str[i] is blank
		jmp %%isBlk 

		

	;mov r15d, 0

	%%nxtChr:
	;Algo
	; get char
	; if char is NULL -> exit  ; terminate instruction here
	; convert char to int
	; rsum = (rsum * 13) + int (currentIndex value)
	; goto nxtChr ; unconditinoal loop 


		mov r15b, byte [r12 + r9]
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
			mov dword[%2], eax	; place rSum+int into iNum1

			;mov dword [%2], eax 	; place rSum+int into iNum1
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

	
	%%notValid:
		;mov r13, -1
		mov dword [%2], -1
		jmp %%Done

	%%Done:
		; terminate
		; Two lines below are producing errors: 
		;mov %2, r13d	; place result into parameter
		;mov %2, r13

		pop r13
		
		pop r12
		
		pop r15

%endmacro

; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program constants.

SP_MIN		equ	1
SP_MAX		equ	1000

DC_MIN		equ	0
DC_MAX		equ	16777215		; 0x00ffffff

BK_MIN		equ	0
BK_MAX		equ	16777215		; 0x00ffffff

dNum 		dd 	13
rSum 		dd	0


; -----
;  Local variables for getParams procedure.

STR_LENGTH	equ	12

ddThirteen	dd	13

errUsage	db	"Usage: circles -sp <tridecimalNum> -dc <tridecimalNum> "
		db	"-bk <tridecimalNum>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL

errSPsp		db	"Error, speed specifier incorrect."
		db	LF, NULL
errSPvalue	db	"Error, speed value must be between 1 and 5BC(13)."
		db	LF, NULL

errDCsp		db	"Error, draw color specifier incorrect."
		db	LF, NULL
errDCvalue	db	"Error, draw color value must be between "
		db	"0 and 3625560(13)."
		db	LF, NULL

errBKsp		db	"Error, background color specifier incorrect."
		db	LF, NULL
errBKvalue	db	"Error, background color value must be between "
		db	"0 and 3625560(13)."
		db	LF, NULL

errDCBKsame	db	"Error, draw color and background color can "
		db	"not be the same."
		db	LF, NULL

; -----
;  Local variables for draw circles routine.

red		dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255

sCount		dq	0			; current s iterations
sMax		dq	0			; s iterations

pi		dq	3.14159265358979	; constant
fltZero		dq	0.0
fltOne		dq	1.0
fltTwo		dq	2.0

t		dq	0.0			; loop variable
tStep		dq	0.001			; t step
x		dq	0.0			; current x
y		dq	0.0			; current y
sStep		dq	0.0			; circle deformation speed
s		dq	0.0
scale		dq	10000.0			; scale factor for speed

tmp1		dq	0.0
tmp2		dq	0.0
; -------------------------------------------------------------
; Uninitialized Data
tempNum 	resd 	1

; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

extern	cos, sin


; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx
	push	rsi
	push	rdi
	push	rdx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rdx
	pop	rdi
	pop	rsi
	pop	rbx
	ret

; ******************************************************************
;  Value returning function getParams()
;	Gets draw speed, draw color code, and background color code
;	from the line argument.

;	Performs error checking, converts ASCII/Tridecimal to integer.
;	Command line format (fixed order):
;	  "-sp <trideciamlNum> -dc <trideciamlNum> -bk <trideciamlNum>"

;	Return true/false

; -----
;  Arguments:
;	1) ARGC, double-word, value rdi
;	2) ARGV, double-word, address rsi -> r12
;	3) speed, double-word, address rdx -> r13
;	4) draw color, double-word, address rcx -> r14
;	5) background color, double-word, address r8 -> r15

global getParams
getParams:
	push rbp
	mov rbp, rsp 

	push r12
	push r13
	push r14
	push r15

	; preserve parameters
	mov r12, rsi 		; argv
	mov r13, rdx		; sStep
	mov r14, rcx		; draw color
	mov r15, r8			; background color

	; ./circles -sp 1 -dc 360178b -bk 0
	;    0       1  2  3  4        5  6    argv[i]
	; Command Line error checking

	;if argc == 0; jmp usageMsg (only ./circles)
	cmp rdi, 1
	jle usageMsg
	; if argc != 7 jmp error
	cmp rdi, 7
	jne badCL
	; if argv[1] != '-sp' NULL, jmp error
	mov rbx, qword[r12 + 8]	
	mov al, byte [rbx]		; check '-'
	cmp al, '-'
	jne errSPspec

	mov al, byte [rbx + 1]
	cmp al, 's'		; check 's'
	jne errSPspec

	mov al, byte [rbx + 2]
	cmp al, 'p'		; check 'p'
	jne errSPspec

	mov al, byte [rbx + 3]
	cmp al, NULL	; check null
	jne errSPspec

	; if it made it here, continue 


	; if argv[2] != check/convert jmp error
	mov rax, 0		; clear rax register

	mov rdi, qword [r12 + 16]
	tri2int rdi, tempNum ; rdi -> string addresss operand 2, value
	mov eax, dword [tempNum]
	cmp eax, 0		; if x < 0: error
	jl errSPval	
		; if -1 , jmp error
		;if Valid 
		; if x < min || x > max
			;jmp error
	cmp eax, SP_MIN
	jb errSPval		; x < min : error

	cmp eax, SP_MAX
	ja errSPval
	;save speed into r13
	mov dword [r13], eax

	; continute if made it here

	; if argv[3] != '-dc' NULL, jmp error
	mov rbx, qword[r12 + 24]	
	mov al, byte [rbx]		; check '-'
	cmp al, '-'
	jne errDCspec

	mov al, byte [rbx + 1]
	cmp al, 'd'		; check 'd'
	jne errDCspec

	mov al, byte [rbx + 2]
	cmp al, 'c'		; check 'c'
	jne errDCspec

	mov al, byte [rbx + 3]
	cmp al, NULL	; check null
	jne errDCspec
	; continue if good


	; if argv[4] != check/convert jmp error
	mov rdi, qword [r12 + 32]
	tri2int rdi, tempNum ; rdi -> string addresss operand 2, value
	mov eax, dword [tempNum]
	; tri2int rdi, rax ; rdi -> string addresss rax -> register for result
	cmp eax, 0		; if x < 0: error
	jl errDCval	
		; if -1 , jmp error
		;if Valid 
		; if x < min || x > max
			;jmp error
	cmp eax, DC_MIN
	jb errDCval		; x < min : error

	cmp eax, DC_MAX
	ja errDCval
	;save DC into r14
	mov dword [r14], eax
		
	
	; if argv[5] != '-bk' NULL, jmp error
	mov rbx, qword[r12 + 40]	
	mov al, byte [rbx]		; check '-'
	cmp al, '-'
	jne errBKspec

	mov al, byte [rbx + 1]
	cmp al, 'b'		; check 'b'
	jne errBKspec

	mov al, byte [rbx + 2]
	cmp al, 'k'		; check 'k'
	jne errBKspec

	mov al, byte [rbx + 3]
	cmp al, NULL	; check null
	jne errBKspec

	; if argv[6] != check/convert jmp error
		;if Valid 
		; if x < min || x > max
			;jmp error
	mov rdi, qword [r12 + 48]
	tri2int rdi, tempNum ; rdi -> string addresss operand 2, value
	mov eax, dword [tempNum]

	;tri2int rdi, rax ; rdi -> string addresss rax -> register for result
	
	cmp eax, 0		; if x < 0: error
	jl errBKval	
		; if -1 , jmp error
		;if Valid 
		; if x < min || x > max
			;jmp error
	cmp eax, BK_MIN
	jb errBKval		; x < min : error

	cmp eax, BK_MAX
	ja errBKval
	;save BK into r14
	mov dword [r15], eax

	; if dc == bk: error
	; r14 == r15
	cmp r14, r15
	je	errDCBK

	;error checking complte
	mov rax, TRUE
	jmp Done

	usageMsg:
		lea rdi, [errUsage]
		call printString
		mov rax, FALSE
		jmp Done

	badCL:
		lea rdi, [errBadCL]
		call printString
		mov rax, FALSE
		jmp Done	

	errSPspec:
		lea rdi, [errSPsp]
		call printString
		mov rax, FALSE
		jmp Done		

	errSPval:
		lea rdi, [errSPvalue]
		call printString
		mov rax, FALSE
		jmp Done

	errDCspec:
		lea rdi, [errDCsp]
		call printString
		mov rax, FALSE
		jmp Done
	errDCval:
		lea rdi, [errDCvalue]
		call printString
		mov rax, FALSE
		jmp Done
	
	errBKspec:
		lea rdi, [errBKsp]
		call printString
		mov rax, FALSE
		jmp Done
	
	errBKval:
		lea rdi, [errBKvalue]
		call printString
		mov rax, FALSE
		jmp Done	
	errDCBK:
		lea rdi, [errDCBKsame]
		call printString
		mov rax, FALSE
		jmp Done		

	Done:
		; terminate
			pop r15
			pop r14
			pop r13
			pop r12

			mov rsp, rbp 
			pop rbp
			ret


; ******************************************************************
;  Draw circles void function.
;  Repeatedly called by OpenGL main loop.

;  Plots the following equations:

;	for (s=0.0; s<=1.0; s+=sStep)
;		calculate (x,y) for a circle
;		for (t=0.0; t<(2*pi); t+=tStep) 
;			x = (1-s)*cos(t+pi*s)+s*cos(2*t)
;			y = (1-s)*sin(t+pi*s)-s*sin(2*t)
;			plot (x,y)
;		exit function

;	the s is changed for the next call (from openGL).

; -----
;  Color Code Conversion:
;	'r' -> red=255, green=0, blue=0
;	'g' -> red=0, green=255, blue=0
;	'b' -> red=0, green=0, blue=255
;	'w' -> red=255, green=255, blue=255

; -----
;  Global variables accessed.

common	drawSpeed	1:4			; speed
common	drawColor	1:4			; draw color
common	backColor	1:4			; background color

global drawCircles
drawCircles:
	push	rbp
	; save other registers as needed...
	push r12
	push r13	; register for counter

	mov r13, 0

; -----
; Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);
	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; -----
;  set draw colors, red, green and blue.
	mov eax, [drawColor]
	mov byte [blue], al 	; lower byte is blue
	ror eax, 8				; need to ror to get middle 2 bytes
	mov byte [green], al	
	ror eax, 8				; upper byte for red
	mov byte[red], al
	;ror eax, 16				;reset eax 
; ----
;  Set openGL drawing color.

	mov	edi, dword [red]
	mov	esi, dword [green]
	mov	edx, dword [blue]
	call	glColor3ub			; call glColor3ub(r,g,b)

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set speed based on user entered drawSpeed
;	sStep speed = drawSpeed / 10000
	cvtsi2sd xmm0, dword[drawSpeed]
	divsd xmm0, qword [scale]
	movsd qword [sStep], xmm0

; Keep track of t iterations
; instead of doing float comparison
; iterations = 2*pi/tStep
	mov r12, 0
	movsd xmm0, qword [fltTwo]
	mulsd xmm0, qword [pi]
	divsd xmm0, qword [tStep]
	cvtsd2si r12, xmm0	

; iterations -> r12



; -----
;  Plot (x,y) based on provided equations
;	x = (1-s)*cos(t+pi*s)+s*cos(2*t)
;	y = (1-s)*sin(t+pi*s)-s*sin(2*t)
;  Loops to plot a circle 

; outer for loop accomplished by openGL
forLoop:
	; calc (x,y) for a circle
	;for (t=0.0; t<(2*pi); t+=tStep)

	; x calculation
	;(1-s)
	movsd xmm1, qword [fltOne]
	subsd xmm1, qword [s]	;xmm1 = 1 - s
	movsd qword [tmp1], xmm1 	; tmp1 = 1-s

	; pi*s + t
	movsd xmm0, qword [pi]
	mulsd xmm0, qword [s] 	; xmm0 = s *pi
	addsd xmm0, qword [t]	; xmm0 = (s*pi)+t
	
	; call cos(pi*s + t)
	call cos
	; (1-s) *cos()
	mulsd xmm0, qword [tmp1]
	movsd qword [tmp1], xmm0	; save left side = (1-s) *cos()
	
	; right side Now
	;(2*t)
	movsd xmm0, qword [t]
	mulsd xmm0, qword [fltTwo]	; xmm1 = 2*t
	call cos
	; call cos(2*t)
	;s * cos()
	mulsd xmm0, qword [s]	; xmm1 = s*cos() rightSide
	
	; xmm1 =  rightSide + leftSide
	addsd xmm0 , qword[tmp1]
	movsd qword [x], xmm0		; x= x calc
	

	; y calculation
	; (1-s)
	movsd xmm1, qword [fltOne]
	subsd xmm1, qword [s]
	movsd qword [tmp2], xmm1 ; tmp2 = (1-s)
	
	; pi*s + t
	movsd xmm0, qword [pi]
	mulsd xmm0, qword [s] 	; xmm0 = s *pi
	addsd xmm0, qword [t]	; xmm0 = (s*pi)+t

	;call sin
	call sin
	;(1-s)*sin()
	mulsd xmm0, qword [tmp2]
	movsd qword [tmp2], xmm0 ; save left side = (1-s)*sin()

	; rightSide now
	;2*t
	movsd xmm0, qword [t]
	mulsd xmm0, qword [fltTwo]	; xmm1 = 2 * t
	call sin; sin(2*t)
	; s * sin
	mulsd xmm0, qword [s]		; xmm1 = s*sin() right side

	;y = leftSide - rightSide
	; xmm1 = leftSide - rightSide
	movsd xmm6, qword [tmp2]
	subsd xmm6, xmm0	; (1-s)*s - s*sin()
	movsd qword [y], xmm6

	; x = xmm0
	; y = xmm1
	
	; plot x,y
	movsd xmm0, qword [x]
	movsd xmm1, qword [y]

	call glVertex2d
	
	inc r13 

	jmp chkLoop




; -----
;  t = t + step
; set t to zero once inner loop is done
	chkLoop:
		; inner loop check
		; r12 -> iteration limit
		; if t >= r12: end of For loop
		; else jmp forLoop

		; t = t + step
		movsd xmm4, qword [t]
		addsd xmm4, qword [tStep]
		movsd qword [t], xmm4 	; t += sStep

		; perform check
		; r12-> t loop max
		; r13-> current count 
		cmp r13, r12	; t count < max
		;jb forLoop	; t < iterationMax : jmp into forLoop
		jl forLoop







; -----
;  End drawing operations and flush unwritten operations.
;  Set-up for next call.

	call	glEnd
	call	glFlush

	call	glutPostRedisplay

; -----
;  Update s for next call.
;  s = sStep + s
;  if (s > 1.0): s = 0.0 
; float comparison
	movsd xmm5, qword [s]
	addsd xmm5, qword [sStep]

	movsd qword [s], xmm5 	; s += sStep
	
	;  if (s > 1.0): s = 0.0 
	; ucomisd xmm5, qword [fltOne]
	; jg setS1

	; setS1:
	; 	movsd xmm6, qword [fltZero]
	; 	movsd qword [s], xmm6
	; 	; set s to 0

	
	pop r13
	pop r12
	pop rbp

	ret


; -----
;  Restore registers and return to main.



; ******************************************************************

