###########################################################################
#  Name: Cruz Luna
#  NSHE ID: 2001582775
#  Section: 1002
#  Assignment: MIPS #3
#  Description: multi-dimensional array
#  CS 218
#  MIPS Assignment #4

#  MIPS assembly language program to simulate the rolling of two dice.


###########################################################
#  data segment

.data

hdr:		.ascii	"MIPS Assignment #4 \n"
		.asciiz	"Program to Simulate Rolling Two Dice. \n\n"

# -----
#  Dice Results Matrix

dice:	.word	0, 0, 0, 0, 0, 0
	.word	0, 0, 0, 0, 0, 0
	.word	0, 0, 0, 0, 0, 0
	.word	0, 0, 0, 0, 0, 0
	.word	0, 0, 0, 0, 0, 0
	.word	0, 0, 0, 0, 0, 0

rolls:	.word	0

# -----
#  Local variables for GetInput function.

MIN = 1
MAX = 100000

rd_hdr:	.asciiz	"\nDice Rolls Simulation Input Routine\n\n"
rd_rolls:	.asciiz	"Enter Number of Dice Rolls to Simulate: "
er_rolls:	.ascii	"\nError, rolls must be between 1 and 100000\n"
		.asciiz	"Please re-enter\n\n"

# -----
#  Local variables for random function.

s_tbl:	.word	47174, 64426, 21990, 28426, 63878
	.word	52330, 17190, 29642, 53958, 50474
	.word	18535,  8330, 17414, 58858, 26022
	.word	30026,     0

jptr:	.word	16
kptr:	.word	4

ltmp:	.word	0

# -----
#  Local variables for Result procedure.

NUMS_PER_ROW = 6

r_hdr:	.ascii	"\n\n************************************\n\n"
		.asciiz	"Rolls: "

r_top:	.asciiz	"  ------- ------- ------- ------- ------- -------\n"
new_ln:	.asciiz	"\n"
bar:		.asciiz	" |"

blnks1:	.asciiz	" "
blnks2:	.asciiz	" "
blnks3:	.asciiz	"  "
blnks4:	.asciiz	"   "
blnks5:	.asciiz	"    "
blnks6:	.asciiz	"     "


colon:	.asciiz	":   "
colon2:	.asciiz	":  "

pctHdr:	.asciiz	"\n\nPercentages:\n"

hundred:	.float	100.0

sums:	.word	0		# 2s
	.word	0		# 3s
	.word	0		# 4s
	.word	0		# 5s
	.word	0		# 6s
	.word	0		# 7s
	.word	0		# 8s
	.word	0		# 9s
	.word	0		# 10s
	.word	0		# 11s
	.word	0		# 12s


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Get user input.

	jal	getInput
	sw	$v0, rolls

# -----
#  Throw the dice 'rolls' times, track results.

	la	$a0, dice
	lw	$a1, rolls
	jal	throwDice

# -----
#  Calculate totals, compute percentages, and display results

	la	$a0, dice
	lw	$a1, rolls
	jal	results

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall

.end main


######################################################
#  Procedure to read a number between between 1 and 100,000.
#  Returns its result in $v0.

.globl getInput
.ent getInput
getInput:

# need to preserve $ra b/c syscall is a procedure
	subu $sp, $sp, 4
	sw $ra, 0($sp)	# preserve ra

	
#	YOUR CODE GOES HERE
promptUser:
# print prompt message
	li $v0, 4	# call code, print string
	la $a0, rd_hdr	# addr of string
	syscall 

	li $v0, 4	# call code, print string
	la $a0, rd_rolls	# addr of string
	syscall 	

	# read intger
	li $v0, 5	# call code for read integer
	syscall		# result in $v0

	# error checking
	# if num < MIN: error message
	blt $v0, MIN, invalidNum
	# elif num > MAX: error messge
	bgt $v0, MAX, invalidNum
	#made it here:=> valid
	b validNum

	# invalid
	invalidNum:
		li $v0, 4
		la $a0, er_rolls
		syscall
		j promptUser

	# success
validNum:
	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra 


######################################################
#  Function to generate pseudo random numbers using
#  the lagged Fibonacci generator.
#  Since function, returns result in $v0.

#  Algorithm:
#	itmp  =  s_table(jptr) + s_table(kptr)
#	s_table(jptr)  =  itmp mod 2^16
#	jptr  =  jptr - 1
#	kptr  =  kptr - 1
#	if ( jptr < 0 )  jptr = 16
#	if ( kptr < 0 )  kptr = 16
#	rand_dice = ( itmp / 100 ) mod 6

# -----
#    Arguments:
#	none

#    Returns:
#	$v0

.globl random
.ent random
random:

#	YOUR CODE GOES HERE

#	itmp  =  s_table(jptr) + s_table(kptr)
# 		S_table(jpt)
#	load stable address (dont add to this reg so we can reuse)
	la $t0, s_tbl
# 	add the jptr offset & store in register to get the address
	lw $t1, jptr
	mul $t1, $t1, 4
	add $t2, $t0, $t1
#	load the value from the address into another register
	lw $t3, ($t2)	# t3 => s_tbl(jptr)

#		s_table(kptr)
# 	load s table address => $t0
# 	add the kptr offset & store in reg to get address
	lw $t4, kptr
	mul $t4, $t4, 4
	add $t5, $t0, $t4
#	load the value from the address into another register
	lw $t6, ($t5)

# now add the two registers for itmp
	add $t6, $t3, $t6
	# t6 => itemp

#	s_table(jptr)  =  itmp mod 2^16
	rem $t7, $t6, 65536 	# itmp mod 2^16

	#add $t0, $t0, $t1	# add jptr offset
	sw $t7, ($t2)	# set sTable(jptr) = itmp mod 2^16

# Decrement pointers by 1
#	jptr  =  jptr - 1
	lw $t1, jptr	# loadk jptr value
	sub $t1, $t1, 1	# decrement
	sw $t1, jptr	#save jptr value

#	kptr  =  kptr - 1
	lw $t4, kptr	#load kptr value
	sub $t4, $t4, 1	# decrement
	sw $t4, kptr	# save kptr value 

# check the pointer ranges
#	if ( jptr < 0 ):  jptr = 16
	lw $t1, jptr
	bgez $t1, kCheck
	li $t8, 16
	sw $t8, jptr
kCheck:
#	if ( kptr < 0 ):  kptr = 16
	lw $t4, kptr
	bgez $t4, randCalc
	li $t8, 16
	sw $t8, kptr

randCalc:
#	rand_dice = ( itmp / 100 ) mod 6
	# itemp / 100
	divu $t8, $t6, 100
	rem $v0, $t8, 6
	#add $v0, $t8, 1	# rand_dict += 1
# put rand dict in $v0

	jr $ra

.end random




######################################################
#  Procedure to simulate the rolling of two dice n times.
#    Each die can show an integer value from 1 to 6, so the sum of
#    the values will vary from 2 to 12.
#    The results are stored in a two-dimension array.
#    Calls the Random() function.

# -----
#  Formula for multiple dimension array indexing:
#	addr(row,col) = base_address + (rowindex * col_size + colindex) * element_size

# -----
#  Arguments
#	$a0 - address of dice two-dimension array
#	$a1 - number of 'rolls'

.globl throwDice
.ent throwDice
throwDice:
#	YOUR CODE GOES HERE
	subu $sp, $sp, 24	# preserve registers
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

# Save passed args
	move $s0, $a0	# dice array address
	move $s1, $a1	# roll number

sumLoop:
	# r = random()
	jal random
	move $s3, $v0	# get random number 
	# c = random()
	jal random
	move $s4, $v0

	#dice[r][c]+=1
	# addr = baseAddr + (rowIndex * colSize + colIndex) * dataSize
	mul $t0, $s3, 6		# rowIndex * colSize
	add $t0, $t0, $s4 	# + colIndex
	mul $t0, $t0, 4		# * dataSize
	add $t0, $t0, $s0	# baseAddr + (rightSide of equation)
	lw $t1, ($t0) 		# load value of dice[r][c]
	add $t1, $t1, 1		# += 1
	sw $t1, ($t0)		# set dice[r][c] value 

	sub $s1, $s1, 1
	bgtz $s1, sumLoop

# DEBUG -> check dice[r][c] value
	# move $s0, $a0	# dice array address
	# li $s3, 0
	# li $s4, 0
	# mul $t0, $s3, 6		# rowIndex * colSize
	# add $t0, $t0, $s4 	# + colIndex
	# mul $t0, $t0, 4		# * dataSize
	# add $t0, $t0, $s0	# baseAddr + (rightSide of equation)
	# lw $t1, ($t0) 		# load value of dice[0][0]

# Done, registers and return to calling routine 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addu $sp, $sp, 24	
	jr $ra

.end throwDice


######################################################
#  Procedure to calculate sums, percentages, and display the
#   two-dimensional matrix showing the results.

#  Arguments:
#	$a0 - starting address of dice matrix
#	$a1 - number of rolls

.globl	results
.ent	results
results:
#	YOUR CODE GOES HERE
# preserve registers because other procedures are called
#  Save registers.

	subu	$sp, $sp, 32
	sw $ra, 28($sp)
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$fp, ($sp)
	#addu	$fp, $sp, 32

# print matrix 
#  Initializations...


	move	$s0, $a0			# set $s0 addr of list
	move	$s3, $a1			# set $s1 to length



# loop i = 0 to len -1 
	#li $s1, 6 	# size 
	
	la $t9, sums	# addr sum array
	li $t0, 0 		# row Index 
	li $t1, 0		# column index
	li $t2, 0 		# counter => every sixth iteration reset
	li $t3, 36		# number of elements in matrix
	li $t4, 0		# index 
	# $s3 => Number of rolls
	# $s0 => Address of dice array
# diagSum loop 
diagSumLoop:
	
	# linearly iterate through array and check the row+COl index
	mul $t8, $t4, 4		# offset
	add $t5, $t8, $s0	# baseAddress + offest
	lw $t6, ($t5) 		# get dice[row][col]
	
	# # Get offset for sums array 
	add $t7, $t0, $t1 	# offset = rowIndex + colIndex
	mul $t7, $t7, 4		# offset * dataSize
	add $t5, $t9, $t7	# address of sums[offset] 
	lw $t7, ($t5)		# load sums[offset] value

	add $t7, $t7, $t6 	# sums[counter] += dice[row][col]
	sw $t7, ($t5) 		# save the value to the sums[offset] address

	add $t2, $t2, 1		#increment counter 
	add $t1, $t1, 1		# increment column Index

	#Determine if we need to go to next row
	rem $t5, $t2, 6
	bnez $t5, elementCheck

	# if mod(counter,6) == 0:
	#		row += 1
	#		col = 0 
	add $t0, $t0, 1
	li $t1, 0

	elementCheck:
		#decrement number of elements
		subu $t3, $t3, 1
	# if number of elements != 0: loop
		# increment index
		addu $t4, $t4, 1
		bnez $t3, diagSumLoop

#convert rolls to a float 
# $s3 => rolls
	mtc1 $s3, $f6		# move to float register
	cvt.s.w $f6, $f6	# cvt to float format
	
	la $t9, sums
	li $t0, 0	# index
	li $t2, 11	# sum length
# iterate through sums 
percentLoop:
	mul $t1, $t0, 4 	# index * DataSize
	add $t1, $t1, $t9 	# add offset
	lw $t3, ($t1) 		# get sums[index]
	
	mtc1 $t3, $f2			# move to float register
	cvt.s.w $f2, $f2		# convert to float format
	
	div.s $f2, $f2, $f6		# divide by roll count ($f6)
	l.s $f4, hundred
	mul.s $f2, $f2, $f4	# multiply by 100.0
	

	s.s $f2, ($t1) 			# save sum s.s 

	# increment to the next sum 
	addu $t0, $t0, 1	#increment index
	bne $t0, $t2, percentLoop


# -----------------------------------
# Print board
	# print stars
	li $v0, 4
	la $a0, r_hdr
	syscall

	#print roll number
	li $v0, 1
	move $a0, $s3
	syscall

	li $v0, 4 	# prnt new line
	la $a0, new_ln
	syscall
# print top of array 
	li $v0, 4
	la $a0, r_top
	syscall



# Print dice matrix contents
	la $s0, dice
	li $s1, 0 
	li $s2, 36
	li $s3, 0 # counter for first var
printLoop:

	li $v0, 4
	la $a0, bar 
	syscall 

	addu $s3, $s3, 1
	li $t1, 5
	bne $s3, $t1, skipBar



	li $s3, 0

skipBar:
	li $v0, 4
	la $a0, blnks3
	syscall

	li $v0, 1	# call code for print int
	lw $a0, ($s0)	# dice[i]
	syscall

	# # print small space and bar
	#wrong placement of bar
	# li $v0, 4
	# la $a0, bar 
	# syscall 

	li $v0, 4
	la $a0, blnks1
	syscall

	addu $s0, $s0, 4 	# update address
	add $s1, $s1, 1 	# increment counter

	rem $t0, $s1, 6
	bnez $t0, skipNewLine

	# print small space and bar
	li $v0, 4
	la $a0, bar 
	syscall 

	li $v0, 4 	# prnt new line
	la $a0, new_ln
	syscall

skipNewLine:
	bne $s1, $s2, printLoop	
# print bottom of array
	li $v0, 4
	la $a0, r_top
	syscall

# # -----------------------------
#print Percentages
	li $v0, 4	# call code, print string
	la $a0, pctHdr	# addr of string
	syscall 

	la $s0, sums
	li $s1, 0 
	li $s3, 11 	# length
	li $s4, 2	# number for percentages
printPercentages:
	#print spaces
	li $v0, 4
	la $a0, blnks3
	syscall
	# print number
	li $v0, 1	
	move $a0, $s4
	syscall	
	addu $s4, $s4, 1

	# print colon
	li $v0, 4	# call code, print string
	la $a0, colon	# addr of string
	syscall 
	
	#print sums value
	li $v0, 2	# call code for print int
	l.s $f12, ($s0)
	#lw $a0, ($s0)	# sum[i]
	syscall

	#print newline
	li $v0, 4	# call code, print string
	la $a0, new_ln	# addr of string
	syscall 

	addu $s0, $s0, 4
	add $s1, $s1, 1 #increment counter

	bne $s1, $s3, printPercentages

# Done, registers and return to calling routine 
#  Restore registers.
	lw $ra, 28($sp)
	lw	$s0, 24($sp)
	lw	$s1, 20($sp)
	lw	$s2, 16($sp)
	lw	$s3, 12($sp)
	lw	$s4, 8($sp)
	lw	$s5, 4($sp)
	lw	$fp, ($sp)
	addu	$sp, $sp, 32	
	jr $ra


.end results
######################################################

