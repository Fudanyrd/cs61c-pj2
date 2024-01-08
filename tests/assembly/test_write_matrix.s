.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, -5, 6, 7, 8, 9, -10, 11, 12, 13, 14, -15 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "output.bin"

.text
main:
    # Write the matrix to a file
    la a1, m0
    la a0, file_path
    addi a2, x0, 3
    addi a3, x0, 5
    jal ra, write_matrix

    # Exit the program
    addi a0, x0, 10
    ecall