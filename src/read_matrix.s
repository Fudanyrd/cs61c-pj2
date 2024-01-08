.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)  # the matrix
    sw s1, 4(sp)  # pointer to # of row
    sw s2, 8(sp)  # pointer to # of col
    sw s3, 12(sp) # descriptor code of file
    sw s4, 16(sp) # number of elements
    sw s5, 20(sp) # the first 8 bytes of the file
    sw s6, 24(sp) # the entire file
    add s1, a1, x0
    add s2, a2, x0

# Task: open the file : error code 50
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    add a1, a0, x0
    addi a2, x0, 0
    jal ra, fopen      ### function call
    add s3, a0, x0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    addi t0, x0, -1
    beq t0, s3, err50

# Task: allocate 8 bytes for s5 : error code 48
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)
    addi a0, x0, 8
    jal ra, malloc     ### function call
    beq x0, a0, err48
    add s5, a0, x0
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

# Task: read 8 bytes from file, 0(s5) and 4(s5) are # of rows and cols.
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw ra, 16(sp)
    add a1, s3, x0
    add a2, s5, x0
    addi a3, x0, 8
    jal ra, fread  ### function call
    addi t0, x0, 8
    bne a0, t0, err51
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    lw t1, 0(s5) # t1 = # of rows
    lw t2, 4(s5) # t2 = # of cols
    sw t1, 0(s1)
    sw t2, 0(s2)
    mul s4, t1, t2
# Task: free s5
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)
    add a0, s5, x0
    jal ra, free
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

# Task: load the entire file into s6, error 48, 51.
## first allocate memory for s6, error 48
    addi t1, x0, 0
    add t1, t1, s4
    slli t1, t1, 2 # t1 = # of bytes to read
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)
    add a0, t1, x0
    jal ra, malloc
    beq a0, x0, err48
    add s6, a0, x0
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
## second, fread again, error 51.
    add t1, x0, s4
    slli t1, t1, 2
    addi sp, sp, -24
    sw a0, 0(sp) 
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw ra, 16(sp)
    sw t1, 20(sp)
    add a1, s3, x0
    add a2, s6, x0
    add a3, t1, x0
    jal ra, fread
    lw t1, 20(sp)
    bne t1, a0, err51 # t1 = # of bytes
    lw a0, 0(sp) 
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 24
# Task: copy s6[2:-1] into s0.
## first, allocate memory for s0.
    add t0, s4, x0 # t0 = # of bytes of matrix
    slli t0, t0, 2
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    sw ra, 12(sp)
    add a0, t0, x0
    jal ra, malloc
    beq a0, x0, err48
    add s0, a0, x0
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
## second, copy the contents of s6[2:] into s0.
    add t2, x0, x0
    addi t3, x0, 0
loop:
    beq t2, s4, loop_end
    add t4, t2, x0
    slli t4, t4, 2
    add t4, s0, t4
    add t5, t3, x0
    slli t5, t5, 2
    add t5, s6, t5
    lw t6, 0(t5)
    sw t6, 0(t4)

    addi t2, t2, 1
    addi t3, t3, 1
    jal x0, loop
loop_end:
## third, free s6.
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)
    add a0, s6, x0
    jal ra, free
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

# Task: close the file, error 52.
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)
    add a1, s3, x0
    jal ra, fclose
    bne x0, a0, err52
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

# Epilogue
# Task: free s5, s6
    add a0, s0, x0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28
    ret
err48:
    addi a0, x0, 17
    addi a1, x0, 48
    ecall
err50:
    addi a0, x0, 17
    addi a1, x0, 50
    ecall
err51:
    addi a0, x0, 17
    addi a1, x0, 51
    ecall
err52:
    addi a0, x0, 17
    addi a1, x0, 52
    ecall