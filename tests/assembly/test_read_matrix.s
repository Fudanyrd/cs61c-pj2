.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "tests/inputs/test_read_matrix/test_input2.bin"

.text
main:
    # Read matrix into memory
    la s0, file_path
    addi a0, x0, 4
    jal ra, malloc
    add s1, a0, x0
    addi a0, x0, 4
    jal ra, malloc
    add s2, a0, x0

    add a0, s0, x0
    add a1, s1, x0
    add a2, s2, x0
    jal ra, read_matrix
    add s0, a0, x0

    # Print out elements of matrix
    lw a1, 0(s1)
    lw a2, 0(s2)
    add a0, s0, x0
    jal ra, print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall