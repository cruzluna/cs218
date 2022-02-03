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

; Below



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



; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rdi, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
