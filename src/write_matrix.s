.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# If this function returns improperly,
# you'll receive an error code 25.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp) # num of elements in the matrix
    sw s1, 4(sp) # pointer to the matrix
    sw s2, 8(sp) # number of rows
    sw s3, 12(sp) # number of columns
    sw s4, 16(sp) # descriptor code of file
    sw s5, 20(sp) # path
    sw s6, 24(sp) # auxiliary
    add s5, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    mul s0, s2, s3
    addi a0, x0, 4
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, malloc
    beq a0, x0, err1
    add s6, a0, x0
    lw ra, 0(sp)
    addi sp, sp, 4
# Task: open the file, exit 1.
# no need to store A register in stack this time(why ?)
    add a1, s5, x0
    addi a2, x0, 1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fopen
    addi t0, x0, -1
    beq a0, t0, err53
    add s4, a0, x0
    lw ra, 0(sp)
    addi sp, sp, 4
# Task: write row, column into file
## row
    add a1, s4, x0
    # la a2, s2
    sw s2, 0(s6)
    add a2, s6, x0
    addi a3, x0, 1
    addi a4, x0, 4
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fwrite
    lw ra, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err54
## column
    add a1, s4, x0
    # la a2, s3
    sw s3, 0(s6)
    add a2, s6, x0
    addi a3, x0, 1
    addi a4, x0, 4
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fwrite
    lw ra, 0(sp)
    addi sp, sp, 4
    bne a0, a3, err54

# Task: write the matrix into the file.
    add a1, s4, x0
    add a2, s1, x0
    add a3, s0, x0
    addi a4, x0, 4
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fwrite
    lw ra, 0(sp)
    addi sp, sp, 4
    bne a0, s0, err54
# Task: close the file.
    add a1, s4, x0
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fclose
    bne a0, x0, err55
    lw ra, 0(sp)
    addi sp, sp, 4

# Epilogue
    addi sp, sp, -4
    sw ra, 0(sp)
    add a0, s6, x0
    jal ra, free
    lw ra, 0(sp)
    addi sp, sp, 4
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28
    ret
    addi a0, x0, 17
    addi a1, a1, 25
    ecall
err1:
    addi a0, x0, 17
    addi a1, x0, 1
    ecall
err53:
    addi a0, x0, 17
    addi a1, x0, 53
    ecall
err54:
    addi a0, x0, 17
    addi a1, x0, 54
    ecall
err55:
    addi a0, x0, 17
    addi a1, x0, 55
    ecall