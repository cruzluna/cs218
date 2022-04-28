###########################################################################

#  Assignment: MIPS #5
#  Description:  Recursion

#  CS 218, MIPS Assignment #5


###########################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0

# -----
#  Variables for main

hdr:		.ascii	"\nMIPS Assignment #5\n"
		.asciiz	"Titanium Rod Cut Maximum Value Program\n\n"

prices1:	.word	1, 5, 8, 9, 10, 17, 17, 20
maxLen1:	.word	8

prices2:	.word	3, 5, 8, 9, 10, 17, 17, 20, 24, 30
maxLen2:	.word	10

userPrompt:	.asciiz	"Enter another length (y/n)? "

endMsg:		.ascii	"\nYou have reached recursive nirvana.\n"
		.asciiz	"Program Terminated.\n"

# -----
#  Local variables for prtNewline function.

newLine:	.asciiz	"\n"

# -----
#  Local variables for displayResults() function.

msgMax:		.asciiz	"Maximum obtainable value is: "

# -----
#  Local variables for showPrices() function.

stars:		.ascii	"\n*************************"
		.asciiz	"*********************************\n"
pricesMsg:	.asciiz	"Prices (max): "
dashs:		.asciiz	" ----"
xtra:		.asciiz	"-"
spc:		.asciiz " "
bar:		.asciiz	" | "
offset0:	.asciiz	"   "
offset1:	.asciiz	"  "
fourspaces:	.asciiz	"    "
Prices1:	.asciiz	"Prices"
Lengths1:	.asciiz	"Lengths"

# -----
#  Local variables for readLength() function.

strtMsg1:	.asciiz	"Enter rod length (1-"
strtMsg2:	.asciiz	"): "

errValue:	.ascii	"\nError, invalid length. "
		.asciiz	"Please re-enter.\n"


# -----
#  Local variables for askPrompt() function.

ansErr:		.asciiz	"Error, must answer with (y/n).\n"
ans:		.space	3
#ans_yes: 	.asciiz	"y"
#ans_no:		.asciiz	"n"
###########################################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  First price list.

	la	$a0, prices1
	lw	$a1, maxLen1
	jal	showPrices

tryAgain1:
	lw	$a0, maxLen1
	jal	readLength

	la	$a0, prices1
	move	$a1, $v0
	jal	cutRod

	la	$a0, prices1
	move	$a1, $v0
	jal	displayResults

	la	$a0, userPrompt
	jal	askPrompt

	beq	$v0, TRUE, tryAgain1

# -----
#  Second price list.

	la	$a0, prices2
	lw	$a1, maxLen2
	jal	showPrices

tryAgain2:
	lw	$a0, maxLen2
	jal	readLength

	la	$a0, prices2
	move	$a1, $v0
	jal	cutRod

	la	$a0, prices2
	move	$a1, $v0
	jal	displayResults

	la	$a0, userPrompt
	jal	askPrompt

	beq	$v0, TRUE, tryAgain2

# -----
#  Done, show message and terminate program.

gameOver:
	li	$v0, 4
	la	$a0, endMsg
	syscall

	li	$v0, 10
	syscall					# all done...
.end main

# =========================================================================
#  Very simple function to print a new line.
#	Note, this routine is optional.

.globl	prtNewline
.ent	prtNewline
prtNewline:
	la	$a0, newLine
	li	$v0, 4
	syscall

	jr	$ra
.end	prtNewline

# =========================================================================
#  Function to recursivly determine the maximum value
#  for cutting the titanium rod.

# -----
#  Arguments:
#	$a0 - prices array, address
#	$a1 - length, value

#  Returns:
#	$v0 - maximum price

.globl cutRod
.ent cutRod
cutRod:
# preserve registers
	subu $sp, $sp, 20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)

# max = 0
	li $s0, 0	# i = 0 
	li $s3, 0 	# max = 0

	move $s1, $a1	# len
	move $s2, $a0	# addr price array 

# for(i = 0, i < len; i++)
forLoop:
	# if i >= len: exit loop
	bge $s0, $s1, forDone	

#	thisMax = cutRod(prices[], len-i-1)
	subu $a1, $s1, $s0	# len - i
	subu $a1, $a1, 1	# (len-i) - 1
	move $a0, $s2
	jal cutRod 
	move $t0, $v0	# $t0 => thisMax
#	tmp = thisMax + prices[i]
	# offset for prices
	mul $t1, $s0, 4		# i * DATASIZE
	addu $t1, $s2, $t1	# add offset for addr

	lw $t2, ($t1)		# get prices[i]

	add $t0, $t0, $t2	# tmp = thisMax + prices[i]

#	if (tmp > max): max = tmp
	ble $t0, $s3, skip	
	move $s3, $t0	# max = tmp
	
skip:
	addu $s0, $s0, 1	# increment index
	b forLoop

forDone:
# save max in $v0
	move $v0, $s3	

# ----
# Done, restore registers and return to calling routine

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addu $sp, $sp, 20

	jr $ra
.end cutRod
# =========================================================================
#  Function to display formatted final result.

# -----
#    Arguments:
#	$a0 - prices array, address
#	$a1 - max value

#    Returns:
#	n/a

.globl	displayResults
.ent	displayResults
displayResults:
	subu	$sp, $sp, 12			#  Save registers
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$ra, 8($sp)

	# save arguments
	move	$s0, $a0
	move	$s1, $a1

	# display message
	la	$a0, msgMax
	li	$v0, 4
	syscall

	# display value
	move	$a0, $s1
	li	$v0, 1
	syscall

	# do new line for formatting
	jal	prtNewline

# -----
#  Restore registers and return.

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	add	$sp, $sp, 16
	jr	$ra
.end	displayResults

# =========================================================================
#  Function to display formatted price list
#  See example for formatting (must match)

# -----
#    Arguments:
#	$a0 - prices array, address
#	$a1 - length, value

#    Returns:
#	n/a

.globl showPrices
.ent showPrices
showPrices:
#	YOUR CODE GOES HERE
	subu $sp, $sp, 20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)

	move $s0, $a0	# prices
	move $s1, $a1	# length
	li $s2, 0 		# counter  (for lengths)

# print stars 
	la	$a0, stars
	li	$v0, 4
	syscall
# print the prices message
	la	$a0, pricesMsg
	li	$v0, 4
	syscall

# print prices int
	li $v0, 1	# call code for int
	move $a0, $s1	# length int
	syscall

# print newline
	la	$a0, newLine
	li	$v0, 4
	syscall

	# print two spaces
	li $v0, 4
	la $a0, fourspaces
	syscall

	li $v0, 4
	la $a0, offset0
	syscall

	li $v0, 4
	la $a0, spc
	syscall
# Print top dashes Length times
printDashes:
	li $v0, 4
	la $a0, dashs
	syscall

	addu $s2, $s2, 1
	blt $s2, $s1, printDashes


# print new line
	la	$a0, newLine
	li	$v0, 4
	syscall

#print Lengths string
	la	$a0, Lengths1
	li	$v0, 4
	syscall

# print bar
	li $v0, 4
	la $a0, bar
	syscall

# print lengths grid 
	li $s2, 1	# starting lengths grid value
lengthsLoop:
	# print  space
	li $v0, 4
	la $a0, spc
	syscall

	# print length value
	li $v0, 1
	move $a0, $s2
	syscall

	li $v0, 4
	la $a0, bar
	syscall

	# increment length value
	addu $s2, $s2, 1
	ble $s2, $s1, lengthsLoop

# print new line
	la	$a0, newLine
	li	$v0, 4
	syscall


	# print two spaces
	li $v0, 4
	la $a0, fourspaces
	syscall

	li $v0, 4
	la $a0, offset0
	syscall

	li $v0, 4
	la $a0, spc
	syscall

# print bottom dashes
	li $s2, 0

printBottomDashes:
	li $v0, 4
	la $a0, dashs
	syscall

	addu $s2, $s2, 1
	blt $s2, $s1, printBottomDashes


# print new line
	la	$a0, newLine
	li	$v0, 4
	syscall

#print prices string
	la	$a0, Prices1
	li	$v0, 4
	syscall

# print bar
	li $v0, 4
	la $a0, bar
	syscall


# print prices string

	li $s2, 0
pricesPrintLoop:

	# print  space
	li $v0, 4
	la $a0, spc
	syscall

	li $v0, 1
	lw $a0, ($s0)
	syscall

	li $v0, 4
	la $a0, bar
	syscall

	addu $s0, $s0, 4 	# update address
	addu $s2, $s2, 1	# increment counter
	blt $s2, $s1, pricesPrintLoop

# print new line
	la	$a0, newLine
	li	$v0, 4
	syscall

	# print two spaces
	li $v0, 4
	la $a0, fourspaces
	syscall

	li $v0, 4
	la $a0, offset0
	syscall

	li $v0, 4
	la $a0, spc
	syscall

#print bottom dashes
# print bottom dashes
	li $s2, 0

printBottomDashes2:
	li $v0, 4
	la $a0, dashs
	syscall

	addu $s2, $s2, 1
	blt $s2, $s1, printBottomDashes2

# print new line
	la	$a0, newLine
	li	$v0, 4
	syscall

# ------
# Done
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)

	jr $ra
.end showPrices

# =========================================================================
#  Function to prompt for, read, and check starting position.
#	must be > 0 and <= length

# -----
#    Arguments:
#	$a0 - max length, value

#    Returns:
#	$v0, length


.globl readLength
.ent readLength
readLength:
#	YOUR CODE GOES HERE
	subu	$sp, $sp, 4
	sw	$s0, 0($sp)

	move	$s0, $a0

	li	$v0, 4
	la	$a0, newLine
	syscall
rePrompt:
#print intial message
	li	$v0, 4
	la	$a0, strtMsg1
	syscall

	li $v0, 1 # print max
	move $a0, $s0
	syscall

	li	$v0, 4
	la	$a0, strtMsg2
	syscall
# read int
	li $v0, 5	# call code for read integer
	syscall
# validate int
	blt $v0, $zero, invalidAns
	bgt $v0, $s0, invalidAns

	j answerValid

invalidAns:
	li	$v0, 4
	la	$a0, errValue
	syscall
	j rePrompt

answerValid:
	# save value to $v0
	

# ----
# Done
	lw	$s0, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
.end readLength


# =========================================================================
#  Function to ask user if they want to do another start position.

#  Basic flow:
#	prompt user
#	read user answer (as character)
#		if y/Y -> return TRUE
#		if n/N -> return FALSE
#	otherwise, display error and re-prompt
#  Note, uses read string syscall.

# -----
#  Arguments:
#	$a0 - prompt string
#  Returns:
#	$v0 - TRUE/FALSE

.globl	askPrompt
.ent	askPrompt
askPrompt:
	subu	$sp, $sp, 4
	sw	$s0, 0($sp)

	move	$s0, $a0

	li	$v0, 4
	la	$a0, newLine
	syscall

re_pmt_ans:
	move	$a0, $s0
	li	$v0, 4
	syscall

	li	$v0, 8
	la	$a0, ans
	li	$a1, 3
	syscall

	lb	$t1, ans
	beq	$t1, 89, ans_yes
	beq	$t1, 121, ans_yes
	beq	$t1, 78, ans_no
	beq	$t1, 110, ans_no

	li	$v0, 4
	la	$a0, ansErr
	syscall

	b	re_pmt_ans

ans_no:
	li	$v0, 4
	la	$a0, newLine
	syscall

	li	$v0, FALSE
	b	continue_done

ans_yes:
	li	$v0, 4
	la	$a0, newLine
	syscall

	li	$v0, TRUE

continue_done:
	lw	$s0, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
.end	askPrompt

#####################################################################

