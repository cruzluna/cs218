; *****************************************************************
;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <section 1002>
;  Assignment: 9
;  Description: <system call stuff>

;  Functions Template.

; --------------------------------------------------------------------
;  Write four assembly language functions.

;  The void function, gnomeSort(), sorts the numbers into ascending
;  order (small to large).  Uses the gnome sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The void function, basicStats(), finds the minimum, median, and
;  maximum, sum, and average for a list of numbers.
;  The median is determined after the list is sorted by the 
;  using the listMedian function.

;  The value returning function, listMedian(), computes the 
;  median of the list.

;  The  value returning function, corrCoefficient(), computes the
;  correlation coefficient for the two data sets.
;  Note, summation and division performed as integer values.
;  Final result is real in xmm0.

;  NO static variables allowed.
;  Must create stack dynamic locals as neeed.

; ********************************************************************************

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

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
;  Define program specific constants.

SUCCESS 	equ	0
BADNUMBER	equ	1
INPUTOVERFLOW	equ	2
OUTOFRANGE	equ	3
ENDOFINPUT	equ	4

MIN		equ	1
MAX		equ	1000000
BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...

; ********************************************************************************

section	.text

; --------------------------------------------------------
;  Read an ASCII base-13 number from the user

;  Return codes:
;	SUCCESS		Successful conversion
;	BADNUMBER	Invalid input entered
;	INPUTOVERFLOW	User entry character count exceeds maximum length
;	OUTOFRANGE	Valid, but out of required range
;	ENDOFINPUT	End of the input

; -----
;  HLL Call:
;	status = readB13Num(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr - rdi

;  Returns:
;	number read (via reference)
;	status code (as above)



;	YOUR CODE GOES HERE
global readB13Num
readB13Num:
    push rbp
    mov rbp, rsp
    sub rsp, 55        ; 55 bytes for locals
    push rbx
    push r12
    push r13
    
    ; 

    mov dword [rbp - 54], 13    ; ddThirteen
    ;chr 
    ; input buffer
    mov r12, rdi            ; move passed argument to r12
    ; Loop to read user input
    lea rbx, byte [rbp - 50]    ; place address buffer into rbx
    ; equivalent to 
        ;mov rbx, rbp
        ;sub rbx, 55
    mov r13, 0              ; i = 0
    ; getChar loop:
;--------------------start of loop---------
    getChar:
    ;     read char 
        mov rax, SYS_read
        mov rdi, STDIN
        lea rsi, byte [rbp - 55]    ; access str[i]
        mov rdx, 1              ; chars read = 1
        syscall

    ;     if chr = LF (linefeed) -> EXIT loop
        mov al, byte [rbp - 55]     ; checks whats in char on the stack
        cmp al, LF
        je inputDone    ; reached end of string

    ;     if (i < BUFFSIZE -1):
    ;         str[i] = chr
    ;         i+=1     
    ;         jmp getChar
        ;mov r11, BUFFSIZE
        ;dec r11         ; buffsize -1
        cmp r13, BUFFSIZE    ; if # chars >= BUFFER
        ; r13= input , r11 = buffsize-1
        ;ja overFlow1   ; input > buffsize-1
        jae getChar     ; stop placing in buffer

        ; BUFFER is not full therefore store
        mov byte [rbx + r13], al    ; store char in rbx-> str[i] = chr
        inc r13     ;increment index
        jmp getChar
        ;buffFull:
            ;jmp getChar

        ; overFlow1:    
        ;     mov rax, INPUTOVERFLOW
        ;     jmp readFuncDone
;---------------------loop done    
    inputDone: 
    ; loop done, time to check string on stack   

    ; if no characters: set statsus (end of input) -> exit 
        cmp r13, 0
        je noInput  ; no chars, endof inptu


    ; if input > BUFFSIZE: set status & exceed length (input overflow)
        cmp r13, BUFFSIZE   
        jae inputOver
        ;jbe checkInput  ; current index <= BUFFSIZE, jumps if buff size is correct
        ;mov rax, INPUTOVERFLOW
        ;jmp readFuncDone        

        ;after Error checking
        jmp checkInput

    noInput:
        ; empty
        mov rax, ENDOFINPUT
        jmp readFuncDone

    inputOver:
        ; clear chars from input stream
        ;read until line feed

        mov rax, INPUTOVERFLOW
        jmp readFuncDone


    
    checkInput:
    ;    enter NULL to end of string!! set str[i] = NULL
        mov byte [rbx + r13], NULL 
        ; need to start rbp - 50
        ; set an index to zero once
        mov r8, 0 
        lea rbx, byte [rbp - 50]        ;first char entered 
        jmp iterateInput

    iterateInput:

        ;iterate through to check input
        mov r10, 0      ; clear register

        mov r10b, byte [(rbp - 50 ) + r8 ]        ; move char to r10b
        ;       CHECKING  

        ;check for lowercase
        ;cmp r10b, '9'



        ;convert char to int
        sub r10b, '0'
        cmp r10b, 9
        jbe validInput   ; if <= 9, jmp to valid
        ; check abc range: 49-51
        cmp r10b, 51
        ja invalidInput     ; greater than 51, bad Input
        
        cmp r10b, 49
        jae validInput      ; x >= 49, 49-51, jump to valid

        ; check ABC range: 17-19
        cmp r10b, 17
        jb invalidInput ; x < 17, below 17 no good

        cmp r10b, 19
        jbe validInput  ; x<= 19,  17-19, jump to valid


    ; Input is correct length, check if values are valid 
    ; loop to convert / check input 
    

    
    ; check if Valid
    ; verify range:
        ; access chars on stack

    ;     
    ;     0-9
    ;     abc
    ;     ABC 
    ;     set status 
    ;     exit function
    ;  If not valid, set status invalid number (bad number)
    invalidInput
        mov rax, BADNUMBER
        jmp readFuncDone
    
    validInput:

    ; asst. 6 macro 
        ; Algorithm 
        ; " _ _ _ 1AB", NULL
        ;   ^start----->^end

        ; Registers
        ; rbx => address of string
        ; r9 => i = 0 index: [r8+r9]
        ;mov r8, dStr1 ; place string into r8
        
        push r15

        mov r15d, 0
        ;rSum
        mov r10d, 0 ;rSum

        ;iNum1
        mov r11d, 0

        lea rbx, byte [rbp - 50]        ;first char entered 
        mov r9 , 0 		; index

        ;skip blanks
        isBlk:
        ; get str[i]
        ; if str[i] != NULL -> go to different loop instructions
        ; else: incr index
        ; jmp isBlk

        

            mov al, byte [rbx + r9]  ; str[i] 
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


            mov r15b, byte [rbx + r9]
            cmp r15b, NULL
            ;je Done		; terminates
            je verifyRange
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
                ;mov eax, [rSum] ; move rSum into register
                mov eax, r10d
                ;mul dword [dNum]		; multiply by 13 (dNum = 13)
                mul dword [rbp - 54]    ; 13 on stack
                add eax, r15d ; adds the int saved in lower r15

                ;mov dword [iNum1], eax 	; place rSum+int into iNum1
                mov r11d, eax   ; r11d is iNum1 now
                mov r10d , eax		; update rSum

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

        verifyRange:
        ; r11d-> converted number
            cmp r11d, MIN
            jb badRange ; x < Min
            cmp r11d, MAX  
            ja badRange    ; x > Max
            
            ; after error checking, Valid Number
            jmp Done
        badRange:
            mov rax, OUTOFRANGE
            pop r15 ; if it makes it here, still need to pop r15, never makes it to 'Done'
            jmp readFuncDone

        Done:
        ; how do i pass by reference?
            ; back up rdi
            

            mov dword [r12], r11d   ; move Number into edi, pass by reference?

            pop r15
            mov rax, SUCCESS
            jmp readFuncDone
            
            ; Do nothing 



    ; return value via reference & set status = SUCCESS

    readFuncDone:
    ; terminate program 
        pop r13
        pop r12
        pop rbx
        mov rsp, rbp 
        pop rbp
        
        ret

; ********************************************************************
;  Gnome sort function.

; -----
;  HLL Call:
;	call gnomeSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)



;	YOUR CODE GOES HERE
global gnomeSort
gnomeSort:
    ; function body
        push rbp
        mov rbp, rsp
        push r14
        push r15

        ; place size value in register
        ; Set counters i & j
        ;mov rcx, 0 			; clear garbage data

        mov r15, 1 ; i = 1 
        mov r14, 2 ; j = 2

        ; while loop
        whileLoop:

        ;check if i< size
        ;cmp i, size
        ;jge exitWhile
        cmp r15 , rsi
        jge exitWhile


        mov eax, dword [rdi + r15 * 4]; lst[i]
        mov r8d, dword [rdi + (r15 * 4) - 4] ;lst[i-1]

        cmp eax, r8d
        ;lst[i] < lst[i-1]
        ; if lst[i] < lst[i-1]: need to swap
        ; Ascending for ASST 9
        jl elseLoop
        ; greater than , continue & dont swap
        mov r15, r14 		; i = j
        inc r14 ; j += 1
        jmp whileLoop		; jump back to while Loop

        elseLoop: 

        ;else loop
            ;swap values 
            
            ; SWAP:
            ; r8d == lst[i-1]
            ; eax == lst [i]
            mov dword [rdi + (r15 * 4) - 4], eax
            mov dword [rdi + r15 * 4], r8d


            
            ; decrement i
            ; cmp i , 0
            ; not equal jump back to while loop (jne)
            ;else overwrite i

            dec r15 ; i-=1
            cmp r15, 0
            jne whileLoop
            mov r15, 1 ; i = 1
            jmp whileLoop


        ; exit while loop
        exitWhile:
        ; do nothing
        ;loop is terminated
        pop r14
        pop r15
        pop rbp
        ret


; ********************************************************************
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, must call the lesitMedian function.

; -----
;  HLL Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)



;	YOUR CODE GOES HERE

global basicStats
basicStats:
    push rbp            ; prologue
    mov rbp, rsp        ; rsp -> rbp
    push r12            ; reserved register
    push r13

    ;---- 
    ;min & max need to be swapped

    ; min -> last item in sorted list
    mov r12, rsi    ; get length
    dec r12         ; set len-1
    mov eax, dword [rdi + r12 * 4]  ;get min 
    ;mov dword [rdx], eax        ; return min
    mov dword [r8], eax 

    ; max -> first item in sorted list
    mov eax, dword [rdi]    ; get max
    ;mov dword [r8], eax     ; return max 
    mov dword [rdx], eax
    ;----
    ; SUM
    mov r12, 0      ; counter/index
    ;push rcx
    mov eax, 0      ; running sum
    mov r11, rsi    ; len
    ;dec r11         ; len-1
    sumLoop:
        add eax, dword [rdi + r12 * 4]      ; sum += lst[i]
        inc r12    ; increment index
        cmp r12, r11    ;check index 
        jl sumLoop      ; index < length: keep incrementing

        ;end of list
        mov dword [r9], eax     ; return sum
        ;pop rcx     ; restores rcx-> address for median

    ; ----
    ; Average
    ; sum in eax register
    push rdx 
    mov edx, 0  ; unsigned division
    div rsi     ; average = sum/len
    mov r12, qword [rbp + 16]   ; get ave address
    mov dword [r12], eax        ; return ave

    pop rdx     ; restore rdx, -> address for minimum
    
    mov rax, 0
    call listMedian     ; eax = Median 
    mov dword [rcx], eax
    
    ; ----
    pop r13
    pop r12     ; epilogue
    pop rbp
    ret



; ********************************************************************
;  Function to calculate the estimated median of an unsorted list.

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

; -----
;  HLL Call:
;	ans = listMedian(lst, len)

;  Arguments Passed:
;	- list, address
;	- length, value

;  Returns:
;	median (in eax)


;	YOUR CODE GOES HERE

global listMedian
listMedian:
    push rbp            ; prologue
    mov rbp, rsp        ; rsp -> rbp
    push r12            ; reserved register


    ;mov eax, dword [rdi]    ; get list
    mov rax , rsi       ; get length
    mov rdx, 0          ; unsigned division
    mov r12, 2
    div r12             ; rax = len/2 rdx = remainder

    
    
    mov r12d, dword [rdi + rax * 4]     ; lst[len/2]
    
    
    ;check even/odd
    cmp rdx, 0          ; if 0 remainder-> even
    je evenLength

    ; if it isnt even, then return and finish
    mov eax, r12d               ; return median
   
    jmp medianDone
    evenLength:
        ; if even, median = (lst[len/2]+ lst[len/2-1])/2
        ;mov r12d, dword [rdi + rax * 4]     ; lst[len/2]
        dec rax                             ; len/2 - 1
        mov r13d, dword [rdi + rax * 4]     ;lst[len/2-1]
        add r12d, r13d                      ; (lst[len/2]+ lst[len/2-1])
        ; need to divide r12d, by two
        mov eax, r12d                       ; move r12d, to then divide
        mov edx, 0
        mov r9d, 2
        div r9d                              ; eax = median
       
        jmp medianDone
    
    medianDone:
    ;terminate , do nothing
        pop r12     ; epilogue
        pop rbp
        ret
    

; ********************************************************************
;  Function to calculate the correlation coefficient
;  between two lists (of equal size).

; -----
;  HLL Call:
;	r = corrCoefficient(xList, yList, len)

;  Arguments Passed:
;	1) xList, addr - rdi
;	2) yList, addr - rsi
;	3) length, value - rdx

;  Returns:
;	r value (in xmm0)



;	YOUR CODE GOES HERE
global corrCoefficient
corrCoefficient:
    push rbp            ; prologue
    mov rbp, rsp        ; rsp -> rbp
    push r12            ; reserved register
    push r14

    ;zero out variables
    ;mov dword [xySum], 0
    mov r8d, 0      ; xySum
    ;mov dword [x2Sum], 0
    mov r9d, 0
    ;mov dword [y2Sum], 0
    mov r14d, 0

    mov rcx, rdx   ; initialize length
    mov r10, 0              ; counter/index
    ; save length for letter b/c it is overwritten
    mov r11, rdx

    ; iterate & sum  x[i] * y[i]
    
    xyLoop:
        mov eax, dword [rdi + r10 * 4]  ;x[i]
        mov ebx, dword [rsi + r10 * 4]  ; y[i]
        ; multipy them together and add to summ
        mul ebx                 ;eax*ebx = x[i]*y[i] => edx:eax
        ;add dword[xySum], eax          ; xySum += x[i]*y[i]
        add r8d, eax ; xySum += x[i]*y[i]
        inc r10
        loop xyLoop


    
    mov rcx, r11 ; initalize length again used saved length value
    mov r10, 0      ;reset counter/index
    squareLoop:
    
       
        mov eax, dword [rdi + r10 * 4]  ;x[i]
        mov ebx, dword [rsi + r10 * 4]  ; y[i]
        
        ; square x & y
        
        ; x2sum: INT x^2 += x^2[i]
        mul eax                         ; x^2
        ;add dword [x2Sum], eax                  ;x2 += x^2[i]
        add r9d, eax                  ;x2 += x^2[i]
        
        ; Square Y
        mov eax, 0          ; clear eax register
        mov eax, ebx        ; y[i]
        mul eax             ; y^2
        ;add dword [y2Sum], eax      ; y2 += y^2[i]
        add r14d, eax
        inc r10
        loop squareLoop

    
    ; once loops are done
    ; we have all the three sums
    
    ; convert sum to float 
    ;mov r12d, dword [xySum]
    mov r12d, r8d
    cvtsi2sd xmm0, r12
    
    mov rax, 0 
    ;mov eax, dword [x2Sum]
    mov eax, r9d

    mov rbx, 0
    ;mov ebx, dword [y2Sum]
    mov ebx, r14d

    mul rbx
    cvtsi2sd xmm1, rax
    sqrtsd xmm1, xmm1

    divsd xmm0, xmm1    ; answer in xmm0
    
    pop r14
    pop r12     ; epilogue
    pop rbp
    
    ret




; ********************************************************************************

