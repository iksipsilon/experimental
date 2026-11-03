# first flash from the last day in the hospital

	.text
	.globl _start

_start:

li t0, 0x00080000   # set the 12th bit
li t0, (1 << 8)		# set the 8th bit and clear all the others

