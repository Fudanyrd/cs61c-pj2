.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9 10 11 12
m1: .word 1 5 9 2 6 10 3 7 11 4 8 12
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0, m0
    addi s1, x0, 3    
    addi s2, x0, 4
    la s3, m1
    addi s4, x0, 4
    addi s5, x0, 3
    la s6, d
    # Call matrix multiply, m0 * m1
    add a0, s0, x0
    add a1, s1, x0
    add a2, s2, x0
    add a3, s3, x0
    add a4, s4, x0
    add a5, s5, x0
    add a6, s6, x0
    jal ra, matmul
    # Print the output (use print_int_array in utils.s)
    add a0, s6, x0
    addi a1, x0, 3
    addi a2, x0, 3
    jal ra, print_int_array
    add a0, s0, x0
    addi a1, x0, 3
    addi a2, x0, 4
    jal ra, print_int_array
    add a0, s3, x0
    addi a1, x0, 4
    addi a2, x0, 3
    jal ra, print_int_array

    # Exit the program
    jal exit