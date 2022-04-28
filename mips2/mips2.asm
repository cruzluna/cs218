###########################################################################
#  Assignment: MIPS #2
#  Description: easy mips asst 

#  CS 218, MIPS Assignment #2
#  Provided Template

###########################################################
#  data segment

.data

aSides:		.word	   10,    14,    13,    37,    54
		.word	   31,    13,    20,    61,    36
		.word	   14,    53,    44,    19,    42
		.word	   27,    41,    53,    62,    10
		.word	   19,    28,    14,    10,    15
		.word	   15,    11,    22,    33,    70
		.word	   15,    23,    15,    63,    26
		.word	   24,    33,    10,    61,    15
		.word	   14,    34,    13,    71,    81
		.word	   38,    73,    29,    17,    93

bSides:		.word	  233,   214,   273,   231,   215
		.word	  264,   273,   274,   223,   256
		.word	  244,   252,   231,   242,   256
		.word	  215,   224,   236,   275,   246
		.word	  213,   223,   253,   267,   235
		.word	  204,   229,   264,   267,   234
		.word	  216,   213,   264,   253,   265
		.word	  226,   212,   257,   267,   234
		.word	  217,   214,   217,   225,   253
		.word	  223,   273,   215,   206,   213

cSides:		.word	  125,   124,   113,   117,   123
		.word	  134,   134,   156,   164,   142
		.word	  206,   212,   112,   131,   246
		.word	  150,   154,   178,   188,   192
		.word	  182,   195,   117,   112,   127
		.word	  117,   167,   179,   188,   194
		.word	  134,   152,   174,   186,   197
		.word	  104,   116,   112,   136,   153
		.word	  132,   151,   136,   187,   190
		.word	  120,   111,   123,   132,   145

dSides:		.word	  157,   187,   199,   111,   123
		.word	  124,   125,   126,   175,   194
		.word	  149,   126,   162,   131,   127
		.word	  177,   199,   197,   175,   114
		.word	  164,   141,   142,   173,   166
		.word	  104,   146,   123,   156,   163
		.word	  121,   118,   177,   143,   178
		.word	  112,   111,   110,   135,   110
		.word	  127,   144,   210,   172,   124
		.word	  125,   116,   162,   128,   192

heights:	.word	  117,   114,   115,   172,   124
		.word	  125,   116,   162,   138,   192
		.word	  111,   183,   133,   130,   127
		.word	  111,   115,   158,   113,   115
		.word	  117,   126,   116,   117,   227
		.word	  177,   199,   177,   175,   114
		.word	  194,   124,   112,   143,   176
		.word	  134,   126,   132,   156,   163
		.word	  124,   119,   122,   183,   110
		.word	  191,   192,   129,   129,   122

lengths:	.word	  135,   226,   162,   137,   127
		.word	  127,   159,   177,   175,   144
		.word	  179,   153,   136,   140,   235
		.word	  112,   154,   128,   113,   132
		.word	  161,   192,   151,   213,   126
		.word	  169,   114,   122,   115,   131
		.word	  194,   124,   114,   143,   176
		.word	  134,   126,   122,   156,   163
		.word	  149,   144,   114,   134,   167
		.word	  143,   129,   161,   165,   136

surfaceAreas:	.space	200

len:		.word	50

saMin:		.word	0 
saMid:		.word	0 
saMax:		.word	0 
saSum:		.word	0 
saAve:		.word	0 


# -----

hdr:	.ascii	"MIPS Assignment #2 \n"
	.ascii	"  3D Trapezoid Total Surface Areas Program:\n"
	.ascii	"  Also finds minimum, middle value, maximum, \n"
	.asciiz	"  sum, and average for the surface areas.\n\n"

a1_st:	.asciiz	"\nSurface Areas Minimum = "
a2_st:	.asciiz	"\nSurface Areas Middle  = "
a3_st:	.asciiz	"\nSurface Areas Maximum = "
a4_st:	.asciiz	"\nSurface Areas Sum     = "
a5_st:	.asciiz	"\nSurface Areas Average = "

newLn:	.asciiz	"\n"
blnks:	.asciiz	"  "


###########################################################
#  text/code segment

# --------------------
#  MIPS Assignment #2, compute total surface areas.
#  Also finds min, middle, max, sum, and average.

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

##########################################################



#	YOUR CODE GOES HERE
# Load addresses of sides and heights
	la $t0, surfaceAreas
	la $t1, aSides
	la $t2, bSides
	la $t3, cSides
	la $t4, dSides
	la $t5, heights
	la $t6, lengths

	lw $t7, len
	li $t8, 0 # Initialize sum = 0
	li $t9, 0 # i (checks boundary exit condition)

areaLoop:
	lw $s0, ($t0)	# get surfaceAreas[n]
	lw $s1, ($t1)	# aSides[n]
	lw $s2, ($t2)	# bSides[n]
	lw $s3, ($t3)	# cSides[n]
	lw $s4, ($t4)	# dSides[n]
	lw $s5, ($t5)	# heights[n]
	lw $s6, ($t6)	# lengths[n]

# length[n] * [(heights[n]* (aSides[n] + bSides[n])
# + cSides[n] + dSides[n])]
	#keep all calculations in $s7 
# aSides[n] + bSides[n]
	addu $s7, $s1, $s2 	
# heights[n]* (a+b)
	mul $s7, $s5, $s7

# cSides[n] + dSides[n]
	addu $s7, $s7, $s3 # cSides
	addu $s7, $s7, $s4 # dSides
#multiply expression by lengths
	mul $s7, $s6, $s7

# save the area
	sw $s7, ($t0) 
# sum += sAreas[n]
	addu $t8, $t8, $s7


# update addresses
	addu $t0, $t0, 4	#surfaceAreas
	addu $t1, $t1, 4	#aSides
	addu $t2, $t2, 4 	#bSides
	addu $t3, $t3, 4	#cSides
	addu $t4, $t4, 4	#dSides
	addu $t5, $t5, 4	#heights
	addu $t6, $t6, 4 	#lengths
	
# reset reg with calculations
	li $s7, 0
# decrement index
	sub $t7, $t7, 1 # len-= 1
	bnez $t7, areaLoop

# save sum 
	sw $t8, saSum
# load length 
	lw $t7, len
# average = sum / length
	div $t8, $t8, $t7
# save average
	sw $t8, saAve

#Find Min & Max
	la $t0, surfaceAreas # get tAreas addr
	li $t1, 0 	#index = 0
	lw $t2, ($t0)   # min = sAreas[0]
	lw $t3, ($t0)	# max = sAreas [0]
	lw $t8, len	# array Length
statsLoop:
	lw $t4, ($t0) # get tAreas[n]
	bge $t4, $t2, notNewMin	# if tArea[i] >= min 
	move $t2, $t4	#set new min value

notNewMin:
	ble $t4, $t3, notNewMax	# if tArea[i] <= max : skip
	move $t3, $t4	#set new max value

notNewMax:
	addu $t0,$t0, 4 #update tAreas addr
	addu $t1, $t1, 1	#increment index
	blt $t1, $t8, statsLoop #if indx < len: loop

# save min and max
	sw $t2, saMin
	sw $t3, saMax

# Load tAreas address
	la $t0, surfaceAreas
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
	sw $t8, saMid

# Need to Display the Areas to console window

	la $s0, surfaceAreas # get tAreas
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

	rem $t0, $s2, 5
	bnez $t0, skipNewLine
	
	li $v0, 4 	#print new Line
	la $a0, newLn
	syscall
	
	skipNewLine:
	bne $s2, $s1, printLoop #if counter < Len: loop





##########################################################
#  Display results.

	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, saMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, saMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, saMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, saSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, saAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

