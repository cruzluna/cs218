;  CS 218 - Assignment #11
;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <1002>
;  Assignment: 11
;  Description: < file stuff>
;  Provided Template

;  getFileDescriptors()
;    Get command line arguments, check for errors, open
;    files (one read, one write), and return file descriptors.

;  getLine()
;    Return a single line of input.
;    All file buffering handled within this function.
;    Must verify line is < limit.

;  addLineNumber()
;    Add base-13 line number to input line.

;  cvtint2B13()
;    Convert integer into ASCII/Base-13 string.

;  writeNewLine()
;    Write a line to the output file.


;----------------------------------------------------------------------------

section	.data

; -----
;  Define standard constants.

LF			equ	10			; line feed
NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

BUFFSIZE	equ	500000

; -----
;  Variables for getFileDescriptors()

usageMsg	db	"Usage: ./addlines -i <inputFile> -o <outputFile>"
		db	LF, NULL

errMany		db	"Error, too many characters on the "
		db	"command line.", LF, NULL

errFew		db	"Error, too few characters on the "
		db	"command line.", LF, NULL

errSpec		db	"Error, invalid file specifier."
		db	LF, NULL

errOpenIn	db	"Error, can not open input file."
		db	LF, NULL

errOpenOut	db	"Error, can not open output file."
		db	LF, NULL

errWriteFail	db	"Error, write fail.  Program terminated."
		db	LF, NULL

; -----
;  Variables for getLine()

bfMax		dq	BUFFSIZE
curr		dq	BUFFSIZE

wasEOF		db	FALSE

errFileRead	db	"Error reading input file."
		db	LF, NULL

; -----
;  Variables for getLine()

;errFileWrite	db	"Error writting output file."
;		db	LF, NULL

; -------------------------------------------------------

section	.bss
buff		resb	BUFFSIZE+1

; -------------------------------------------------------

section	.text

; -------------------------------------------------------
;  Get command line arguments.
;  Assignment #11 requires input and output file names.

;  Value returning function (TRUE/FALSE)

;  Examples:	./addLineNumbers -i <infile> -o <outfile>
;		./addLineNumbers -o <outfile> -i <infile>
;			0			  1    2       3   4	
; -----
;  HLL Call:
;	getFileDescriptors(argc, argv, &inFile, &outFile)

; -----
;  Arguments passed:
;	- argc	rdi
;	- argv	rsi
;	- address for file descriptor, input file	rdx
;	- address for file descriptor, output file	rcx

global getFileDescriptors
getFileDescriptors:
	push rbp
	mov rbp, rsp
	push r12 
	push r13

	push r14
	push r15
	
	mov r14, rdx ; r14 => input file desc
	mov r15, rcx ; r15 => output file dec


	; if argc == 0: jmp usageMsg
	cmp rdi, 1
	jbe usageError

	; if argc < 5: jmp errFew
	cmp rdi, 5
	jb fewError
	; if argc > 5: jmp errMany
	cmp rdi, 5
	ja manyError

	; Check for -i and -o
	; r12 = read  r13 = write
	mov rbx, qword [rsi + 8]	; argv[1]
	mov al, byte [rbx]	; check '-'
	cmp al, '-'
	jne errorSpec

	mov al, byte [rbx + 1]

	cmp al, 'i'
	je case1

	cmp al, 'o'
	je case2

	;if neither i or o, jmp to error
	jmp errorSpec

	; case 1:
	;	-i argv[1] -o argv[3]
	; 	argv[2] = read  argv[4] = write
	case1:
		; i is already checked
		; check o
		mov rbx, qword [rsi + 24]	; expect - o
		mov al, byte [rbx]	; check '-'
		cmp al, '-'
		jne errorSpec
		mov al, byte [rbx + 1]
		cmp al, 'o'
		jne errorSpec

		mov r12, qword [rsi + 16]	; input
		mov r13, qword [rsi + 32]	; output
		jmp openInputFile

	; case 2:
	;	-o argv[1] -i argv[3]	
	case2: 
		; o is already checked
		; check i
		mov rbx, qword [rsi + 24]	; expect - i
		mov al, byte [rbx]	; check '-'
		cmp al, '-'
		jne errorSpec
		mov al, byte [rbx + 1]
		cmp al, 'i'
		jne errorSpec

		mov r12, qword [rsi + 32]	; input
		mov r13, qword [rsi + 16]	; output

	; open
	; 	check rax
	openInputFile:
		mov rax, SYS_open	; file open
		mov rdi, r12		; file name string
		mov rsi, O_RDONLY	; read only
		syscall				; call the kernel
		cmp rax, 0			; check for success
		jl inFileOpenError

		; save input file descriptor
		mov qword [r14], rax	; return file descriptor by reference


	; read
	; 	check rax
	outPutFile:
		mov rax, SYS_creat
		mov rdi, r13
		mov rsi, S_IRUSR | S_IWUSR
		syscall
		cmp rax, 0
		jl outFileOpenError

		;save output file descriptor
		mov qword [r15], rax 	; return output file desc by ref


	; if made it here,no errors
	mov rax, TRUE
	jmp Done
	
	; errors 

	usageError:
		mov rdi, usageMsg
		call printString
		mov rax, FALSE
		jmp Done

	fewError:
		mov rdi, errFew
		call printString
		mov rax, FALSE
		jmp Done
	
	manyError:
		mov rdi, errMany
		call printString
		mov rax, FALSE
		jmp Done

	errorSpec:
		mov rdi, errSpec
		call printString
		mov rax, FALSE
		jmp Done

	inFileOpenError: 
		mov rdi, errOpenIn
		call printString
		mov rax, FALSE
		jmp Done

	outFileOpenError:
		mov rdi, errOpenOut
		call printString
		mov rax, FALSE
		jmp Done

	Done:
		; clear stack
		pop r15
		pop r14
		pop r13
		pop r12
		mov rsp, rbp
		pop rbp

		ret





; -------------------------------------------------------
;  Get a single line of text and return.
;  Value returning function (TRUE/FALSE)

;  A "line" is considered all characters until a LF.
;  The function must terminate string with a NULL.

;  This routine handles the I/O buffer manipulation.
;    1) if buffer is empty, get more chars from file
;    2) return line and update buffer pointers

; -----
;  HLL Call:
;	getLine(&inFile, currLine, MAX_LINE_LEN, &OverLineLimit)

; -----
;  Arguments passed:
;	- input file descriptor, value	rdi
;	- line buffer currLine, address			rsi
;	- line buffer limit (inc NULL), value	rdx
;	- bool for limit excceded, addr		rcx

global getLine
getLine:
	push rbp
	mov rbp, rsp

	push rbx 	; max_line_len - 2
	push r12
	push r13
	push r14
	push r15

	;preserve passed args
	mov r12, rdi	; r12 => input File Descriptor
	mov r13, rsi	; r13 => currLine (will need to iterate through this)
	mov r14, rdx	; r14 => MAX_LINE_LEN
	mov r15, rcx	; r15 => OVERLINELIMIT
	mov byte [r15], FALSE

	mov rbx, rdx	; rbx => max_line_len - 2
	sub rbx, 2

	
	mov r8, 0 	;i = 0
	mov r9, qword [bfMax]
	;mov r10 , r9	; r10 => currIdx set it bfMax to read chars the 1st time
	mov r10, qword[curr];curr => currIdx

	;getNextChr:
	updateBuffer:
;---------IF----------------------------------
	;if(currIdx > = bfMax)	
	; curridx is greater, time to put more chars into buffer
		cmp r10, r9 
		jb currLineProcess	; if currIdx < bfMax, process what is in buff
		; reset currIdx if greater than (line 387)

	;	if eof == True : return FALSE
		cmp byte[wasEOF], TRUE
		je endFile
	;	else: 

		; System Service - Read
		; rax = SYS_read
		; rdi = file descriptor
		; rsi = address of where to place data
		; rdx = count of characters to read

	;		read file (BUFFSIZE CHARS)
		mov rax, SYS_read
		mov rdi, r12 	; input file descriptor
		mov rsi, buff 	; fill buffer (address)
		mov rdx, BUFFSIZE	
		syscall

	; 		check for read error
		cmp rax, 0
		jl errorOnRead


	; 		if readError:
	;		display Error msg
	;		return False jmp done

		mov r10, 0	;currIdx = 0 
		mov qword [curr], r10
	;if (actualRead < requestRead): 
		; actual read = rax
		; requestRead = BUFFSIZE
		cmp rax, BUFFSIZE
		jl endOfFile
		;else: jmp out
		jmp currLineProcess
		
		endOfFile:
		;	eof = TRUE
		;	buffMax = actualRead
		; 	dont terminate program
			mov byte [wasEOF], TRUE
			mov qword [bfMax], rax 
			jmp currLineProcess



	;currIdx = 0 
;---------END IF -----------------------------
	currLineProcess:
	; Use what is in buffer and overwrite currLine

	; r8 => index (i)
	; r10 => currIdx
	; r13 => currLine
	; get the Char from buffer and place into currLine
	
	mov r11b, byte [buff + r10] ;chr = buffer[currIdx]

	;increment index of buffer
	inc r10 	;currIdx += 1
	mov qword [curr], r10 	; save currIdx to variable

	; overwrite currLine[i] with char
	mov byte[r13 + r8], r11b ; currLine[i] = chr	
	;i ++   increment index
	inc r8
	
	;if i >=  MAX_LINE_LEN - 2:
	; rbx => MAX_LINE_LEN - 2
	cmp r8, rbx
	jae currFull 

	jmp notFull

	currFull:

	;	overLineLimit = true
		mov byte [r15], TRUE
		

	;	add LINE FEED & a NULL
	; currLine[i] = LF
		mov byte [r13 + r8], LF
	; currLIne[i+1] = NULL
		inc r8
		mov byte [r13 + r8], NULL
		mov rax, TRUE
		; add loop
		; read characters in buffer , use currIdx
		
		findEndofFeed:
			; deals when line is very long
			; and it is truncated
			mov r11b, byte [buff + r10]	; chr = buffer [currIdx]
			inc r10; update to buffsize + 1
			mov qword [curr], r10
			cmp r11b, LF

			je done 	; when null is found, end
			;else: keep iterating
			jmp findEndofFeed
			;load fileBuffer index
			


		;mov rax, TRUE
	;	jmp Done
		;jmp done
		

	notFull:

	; if (chr != LF):
		cmp r11b, LF
		jne updateBuffer
	; 	jmp UpdateBuff

	;else: add a null to currLine
	; currLine[i] = NULL
	mov byte [r13 + r8], NULL

	; return TRUE
	mov rax, TRUE
	jmp done

	endFile:
		; return false no more characters
		mov rax, FALSE
		jmp done

	errorOnRead:
		mov rdi, errFileRead
		call printString
		mov rax, FALSE
		jmp done

	done:
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		mov rsp, rbp
		pop rbp

		ret






; -------------------------------------------------------
;  Add line number to text line.
;  Void function.

; -----
;  HLL Call:
;	addLineNumber(lineNumber, currLine, newLine,
;			MAX_LINE_LEN, MAX_BASE36_LEN);

; -----
;  Arguments passed:
;	- line number, value rdi	
;	- input line buffer, address	rsi currLine
;	- output line buffer, address	rdx	
;	- buffer size (current line), value	rcx
;	- buffer size (new line), value	r8

global addLineNumber
addLineNumber:
	push rbp
	
	push rbx

	push r12
	push r13
	push r14
	push r15

	; Preserve passed arguments
	mov r12, rsi 	; input line buffer (currLine)
	mov r13, rdx 	; output line buff (currNewLine)
	mov r14, rcx 	; MAX_LINE_LEN
	mov r15, r8		; BASE_13_str_LEN

	mov rsi, rdx	;rsi should be currNewLine
	; convert Line Number to b13 
	; 	Line Number rdi 1st arg
	; 	currNewLine  rsi	  2nd  arg holds string of converted number
	; 	base_13 	rdx	  3rd arg
	mov rdx, r8 
	call cvtint2B13
	; issue! -> overwritting currLine because currLine is rsi 
	;			but rsi is passed as currNewLine in cvtint2B13

	; place converted Line # into currNewLine
	; loop them into currNewLine
	

	;mov rcx, r15	; base_13_str_len-2
	;sub rcx, 2		; this is because pdf shows line Number length=> 8
	mov r9 , 8		; i (index)
	
	; copyInteger:
	; 	; r13 => currNewLine
	; 	; rsi => currLine

	; 	mov r10b, byte[rsi + r9] 	; chr = currLine[i]
	; 	mov byte [r13 + r9], r10b	; currNewLine[i] = chr
	; 	inc r9

	; 	loop copyInteger		

	;add ':' and ' '
	; currNewLine[i] = ':'
	mov byte [r13 + r9], ':'
	inc r9
	;currNewLine[i + 1] = ' ' 
	mov byte [r13 + r9], ' '
	inc r9 ; increment index for the currLine chars

	;copy chars from currLine to the end of currNewLine
	; newLine[(BASE_13_STR_LEN + 2) + i]
	
	mov rcx, r14	; MAX_LINE_LEN
	; for(i= 0; i < MAX_LINE_LEN;i++)
	;  newLine[BASE_13_STR_LEN + i] = currLine[i]
	; currline -> r12
	
	;maybe do check if line is blank to skip copyLoop
	mov r10, 0 ; clear out register
	mov rbx, 0; index for currLine after len 10
	copyLoop:
		;chars are a byte

		;currLine[i] -> r12b
		;r13 => currNewLine 
		
		;newLine[BASE_13_STR_LEN + i] = currLine[i]

		mov r10b, byte [r12 + rbx]	; temp var => r10
		inc rbx	; increment currline Index

		mov byte [r13 + r9], r10b
		; stop copying at NULL
		cmp r10b, NULL
		je endcurrLine 
		; need to copy null into it


		inc r9
		loop copyLoop
	
	endcurrLine:

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	; done
	ret




; -------------------------------------------------------
;  Convert the passed interger into a base-12 string
;	Note, will be called by addLineNumber

;  cvtint2B13(lineNumber, currLine, BASE13_STR_LEN)
; -----
;  Arguments passed:
;	- LineNumber integer, value		rdi
;	- currline	 string, address	rsi	newChar[i]
;	- BASE_13_STR_LEN , value 		rdx
; Return: 
;	Nothing (void)

global cvtint2B13
cvtint2B13:
	
	push rbp	; prologue
	
	push r12
	push r13
	mov r9, rdx 	; save BASE_13_STR_LEN

	mov r12d, edi	;get integer	
	mov r13d, 13		;<op32>
	mov rcx, rdx 	; BASE_13_STR
	sub rcx, 2
	; loop base13 str len
	pushLoop:
	;	divide N by 13
		mov eax, r12d
		mov edx, 0
		div r13d 	; eax = quotient, edx = remainder
		mov r12d, eax 	; save the quotient for next iteration

	;	push remainder to stack
		push rdx 
		loop pushLoop

	;i = 0
	; loop base_13_str_len
	;	pop
	;	convert integer to char
	;	0-9 -> + '0'
	;	10-12 -> +'A'
	;	place char in to newLine[i]
	mov r8, 0	; i = 0
	mov rcx, r9 	;BASE_13_STR_LEN
	sub rcx, 2	; 8 length
	popLoop:
		pop rax	; get integer

		; Need to convert to char

		; if N <= 9: N +'0'
		;else: (10-12): N + 'A'- 10	
		cmp rax, 9
		jbe nums0
		; else: it is a letter
		add rax, 'A'
		sub rax, 10	
		jmp resume 

		nums0:
			; 0-9
			add rax, '0'

		resume: 
		;place char into newLine[i]
		mov byte [rsi + r8], al

		;increment index
		inc r8
		loop popLoop

	;exit loop
	
	;pop stack 
	pop r13
	pop r12
	
	pop rbp
	
	ret



; -------------------------------------------------------
;  Write the text line to the file.
;	Note, buffering not required here.

;  Value returning function (TRUE/FALSE)

; -----
;  Arguments passed:
;	- output file descriptor, value rdi
;	- line buffer, address			rsi
; 	- MAX_LINE_LEN + BASE13_STR_LEN, value rdx

; Returns: 
; TRUE/FALSE


global writeNewLine
writeNewLine:
	push rbp
	
	push rbx

	push r12
	push r13
	push r14

	mov r12, rdx 	; save maximum length
	mov r13, rdi
	mov r14, rsi	; line buffer

; Count characters to write
	mov rbx, 0

	strCountLoop1:
		cmp	byte [rsi+rbx], NULL
		je	strCountLoopDone1
		inc	rbx
		jmp	strCountLoop1
	strCountLoopDone1:
		cmp	rbx, 0
		je	printStringDone1	; no chars read if 0

	; -----
	;  Call OS to output string.

		
		mov	rax, SYS_write			; system code for write()
		mov	rdi, r13			; file descriptor 
		mov	rsi, r14			; address of characters to write
		mov rdx, rbx 	; mov count into rdx
		syscall					
		cmp rax, 0			; check for writing error
		jl writingError
		; else: 
		mov rax, TRUE
		jmp printStringDone1
	
	writingError: 
		mov rdi, errWriteFail
		call printString
		mov rax, FALSE
		jmp printStringDone1

	
	; -----
	;  String printed, return to calling routine.

	printStringDone1:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret







; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string rdi
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
	je	printStringDone	; no chars read if 0

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
