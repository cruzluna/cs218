; *****************************************************************
;  Name: <Cruz Luna>
;  NSHE ID: <2001582775>
;  Section: <section 1002>
;  Assignment: 8
;  Description: <learn to use functions>

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
;  Due to the data sizes, the summation for the dividend (top)
;  must be performed as a quad-word.


; ********************************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Variables for gnomeSort() function (if any).


; -----
;  Variables for basicStats() function (if any).


; -----
;  Variables for corrCoefficient() function (in any).
xySum       dd  0
x2Sum       dd  0
y2Sum       dd  0




; ********************************************************************************

section	.text

; ********************************************************************
;  gnome sort function.

; -----
;  Call:
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
        ;lst[i] > lst[i-1]
        ; Descending NOW FOR ASST 8
        ; if lst[i] > lst[i-1]: need to swap
        jg elseLoop
        ; less than , continue & dont swap
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

        ret

; ********************************************************************
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  Note, the list is already sorted.

; -----
;  Call:
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
; using Textbook
global basicStats
basicStats:
    push rbp            ; prologue
    mov rbp, rsp        ; rsp -> rbp
    push r12            ; reserved register
    push r13

    ;---- 
    ; min -> last item in sorted list
    mov r12, rsi    ; get length
    dec r12         ; set len-1
    mov eax, dword [rdi + r12 * 4]  ;get min 
    mov dword [rdx], eax        ; return min

    ; max -> first item in sorted list
    mov eax, dword [rdi]    ; get max
    mov dword [r8], eax     ; return max 

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
;  Function to calculate the median of an sorted list.

; -----
;  Call:
;	ans = listMedian(lst, len)

;  Arguments Passed:
;	- list, address -> rdi  (dd)
;	- length, value -> rsi (dd)

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

    ;zero out variables
    mov dword [xySum], 0
    mov dword [x2Sum], 0
    mov dword [y2Sum], 0
    
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
        add dword[xySum], eax          ; xySum += x[i]*y[i]
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
        add dword [x2Sum], eax                  ;x2 += x^2[i]
        
        ; Square Y
        mov eax, 0          ; clear eax register
        mov eax, ebx        ; y[i]
        mul eax             ; y^2
        add dword [y2Sum], eax      ; y2 += y^2[i]

        inc r10
        loop squareLoop

    
    ; once loops are done
    ; we have all the three sums
    
    ; convert sum to float 
    mov r12d, dword [xySum]
    cvtsi2sd xmm0, r12
    
    mov rax, 0 
    mov eax, dword [x2Sum]
    
    mov rbx, 0
    mov ebx, dword [y2Sum]
    mul rbx
    cvtsi2sd xmm1, rax
    sqrtsd xmm1, xmm1

    divsd xmm0, xmm1    ; answer in xmm0
    
    
    pop r12     ; epilogue
    pop rbp
    
    ret



; ********************************************************************************

