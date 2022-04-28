###########################################################################
#  Assignment: MIPS #1
#  Description: basic mips 

#  CS 218, MIPS Assignment #1
#  Template

###########################################################################
#  data segment

.data

aSides:	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	  15,   25,   33,   44,   58,   69,   72,   86,   99,  101
	.word	 107,  121,  137,  141,  157,  167,  177,  181,  191,  199
	.word	 202,  209,  215,  219,  223,  225,  231,  242,  244,  249
	.word	 251,  253,  266,  269,  271,  272,  280,  288,  291,  299
	.word	 369,  374,  377,  379,  382,  384,  386,  388,  392,  393
	.word	1469, 2474, 3477, 4479, 5482, 5484, 6486, 7788, 8492, 1493

cSides:	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	  32,   51,   76,   87,   90,  100,  111,  123,  132,  145
	.word	 206,  212,  222,  231,  246,  250,  254,  278,  288,  292
	.word	 332,  351,  376,  387,  390,  400,  411,  423,  432,  445
	.word	 457,  487,  499,  501,  523,  524,  525,  526,  575,  594
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	1782, 2795, 3807, 3812, 4827, 5847, 6867, 7879, 7888, 1894

heights:
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	 203,  215,  221,  239,  248,  259,  262,  274,  280,  291
	.word	 400,  404,  406,  407,  424,  425,  426,  429,  448,  492
	.word	 501,  513,  524,  536,  540,  556,  575,  587,  590,  596
	.word	 782,  795,  807,  812,  827,  847,  867,  879,  888,  894
	.word	1912, 2925, 3927, 4932, 5447, 5957, 6967, 7979, 7988, 1994

tAreas:	.space	280

len:	.word	70
#len:	.word	6

taMin:	.word	0
taMid:	.word	0
taMax:	.word	0
taSum:	.word	0
taAve:	.word	0

LN_CNTR	= 8

# -----

hdr:	.ascii	"MIPS Assignment #1 \n"
	.ascii	"Program to calculate area of each trapezoid in a series "
	.ascii	"of trapezoids. \n"
	.ascii	"Also finds min, mid, max, sum, and average for the "
	.asciiz	"trapezoid areas. \n\n"

new_ln:	.asciiz	"\n"
blnks:	.asciiz	"  "

a1_st:	.asciiz	"\nTrapezoid min = "
a2_st:	.asciiz	"\nTrapezoid med = "
a3_st:	.asciiz	"\nTrapezoid max = "
a4_st:	.asciiz	"\nTrapezoid sum = "
a5_st:	.asciiz	"\nTrapezoid ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# --------------------------------------------------------



#	YOUR CODE GOES HERE

# calculate Trapezoid Areas

# load addres of heights, aSides, cSides, tAreas
	la $t0, tAreas
	la $t1, aSides
	la $t2, cSides
	la $t3, heights
	
	lw $s0, len	# array Length
	#subu $t8, $t8, 1

	li $t9, 0 	#sum = 0
	li $t7, 0	# set register to zero
# Area Loop:
areaLoop:
	lw $t4, ($t0) 	# get tAreas[n]
	lw $t5, ($t1)	# aSides[n]
	lw $t6, ($t2)	# cSides[n]
	lw $t8, ($t3)	# heights[n]
# aSides[n] + cSides[n]
	addu $t7, $t5, $t6
#divide by two
	divu $t7, $t7, 2
# tAreas[n] = heights[n] * ((aSides+cSides)/2)
	mul $t4, $t8, $t7 
#save the area
	sw $t4, ($t0)
# sum += tAreas[n]
	addu $t9, $t9, $t4	

# update addresses
	addu $t0, $t0, 4	#tAreas
	addu $t1, $t1, 4	#aSides
	addu $t2, $t2, 4 	#cSides
	addu $t3, $t3, 4	#heights

#reset tempNum
	li $t7, 0

	sub $s0, $s0, 1 # len - 1
	bnez $s0, areaLoop

#save sum
	sw $t9, taSum
#load length
	lw $t7, len
#calculate average = sum/length
	div $t9, $t9, $t7
#save average
	sw $t9, taAve


#Find Min & Max
	la $t0, tAreas # get tAreas addr
	li $t1, 0 	#index = 0
	lw $t2, ($t0)   # min = tAreas[0]
	lw $t3, ($t0)	# max = tAreas [0]
	lw $t8, len	# array Length
statsLoop:
	lw $t4, ($t0) # get tAreas[n]
	bge $t4, $t2, notNewMin	# if tArea[i] >= min 
	move $t2, $t0	#set new min value

notNewMin:
	ble $t4, $t3, notNewMax	# if tArea[i] <= max : skip
	move $t3, $t4	#set new max value

notNewMax:
	addu $t0,$t0, 4 #update tAreas addr
	addu $t1, $t1, 1	#increment index
	blt $t1, $t8, statsLoop #if indx < len: loop

#save Min and Max
	sw $t2, taMin
	sw $t3, taMax

# Load tAreas address
	la $t0, tAreas
	lw $t1, len	# array Length
# len/2	
	div $t2, $t1, 2 # $t1 = len/2

# x = tAreas[len/2]
	mul $t3, $t2, 4 #cvt index into offset
	add $t4, $t0, $t3	# add base addr of array 

	lw $t5, ($t4)	#t4 = arr[len/2]
	sub $t4, $t4, 4	# addr of prev valu

	lw $t6, ($t4) # y = tAreas[len/2-1]

	add $t7, $t6, $t5 # a[len/2] + a[len/2-1]
	div $t8, $t7, 2	# /2

#save median
	sw $t8, taMid

# Need to Display the Areas to console window

	la $s0, tAreas # get tAreas
	lw $s1 , len	# counter
	li $s2, 0 	# counter for column

printLoop:
	li $v0, 1	# call code for print int
	lw $a0, ($s0)	# get tArea[i]
	syscall 

	li $v0, 4	 #print spaces
	la $a0, blnks
	syscall


	addu $s0, $s0, 4 # update address
	add $s2, $s2, 1 # increment counter

	rem $t0, $s2, 8
	bnez $t0, skipNewLine
	
	li $v0, 4 	#print new Line
	la $a0, new_ln
	syscall
	
	skipNewLine:
	bne $s2, $s1, printLoop #if counter < Len: loop

	#increment counter for column
	# check if counter < 8
	#if counter < 8:
	#	jmp back to printLoop
	#else:
	#	print \n
	#	jump back to print loop







# --------------------------------------------------------
#  Display results.

	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, taMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, taMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, taMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, taSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, taAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

