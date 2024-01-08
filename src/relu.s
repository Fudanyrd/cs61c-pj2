.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)

    mv s0, a0
    addi t0, x0, 1
    blt a1, t0, err
loop_start:
    addi t0, x0, 0
loop_continue:
    beq t0, a1, loop_end
    slli t1, t0, 2
    add t1, s0, t1
    lw t2, 0(t1)
    bge t2, x0, next 
    addi t2, x0, 0
    sw t2, 0(t1)
next:
    addi t0, t0, 1
    jal x0, loop_continue
loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
	ret
err:
    li a0, 17
    li a1, 8
    ecall