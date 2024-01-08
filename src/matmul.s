.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    addi t0, x0, 1 # t0 = 1
    blt a1, t0, err2
    blt a2, t0, err2
    blt a4, t0, err3
    blt a5, t0, err3
    bne a2, a4, err4
    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)

    add s0, a0, x0
    add s1, a3, x0
    add s2, a6, x0
    # s3 = 1
    addi s3, x0, 1
    # r -> t0
    addi t0, x0, 0
    # c -> t1
outer_loop_start:
    beq t0, a1, outer_loop_end    
    addi t1, x0, 0
inner_loop_start:
    beq t1, a5, inner_loop_end

    # store a0-a6, ra
    addi sp, sp, -40
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw ra, 28(sp)
    sw t0, 32(sp)
    sw t1, 36(sp)
    # s2[r * a5 + c] = dot((s0 + a2 * r), (s1 + c), a2, 1, a5);
    # param a0
    add a0, s0, x0
    mul t2, a2, t0
    slli t2, t2, 2
    add a0, a0, t2
    # param a1
    add a1, s1, x0
    add t3, t1, x0
    slli t3, t3, 2
    add a1, a1, t3
    # param a2-a4
    add a2, a2, x0
    add a3, s3, x0
    add a4, a5, x0
    jal ra, dot # return result in a0
    add t2, a0, x0 # return result in t2
    # reload a0-a6, ra
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw ra, 28(sp)
    lw t0, 32(sp)
    lw t1, 36(sp)
    addi sp, sp, 40
    # s2[r * a5 + c] = t2
    mul t3, a5, t0
    add t3, t3, t1
    slli t3, t3, 2
    add t3, s2, t3
    sw t2, 0(t3)

    addi t1, t1, 1
    jal x0, inner_loop_start
inner_loop_end:
    addi t0, t0, 1
    jal x0, outer_loop_start
outer_loop_end:
    nop

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp) 
    lw s2, 8(sp)
    lw s3, 12(sp)
    addi sp, sp, 16
    ret
err2:
    addi a0, x0, 17
    addi a1, x0, 2
    ecall
err3:
    addi a0, x0, 17
    addi a1, x0, 3
    ecall
err4:
    addi a0, x0, 17
    addi a1, x0, 4
    ecall