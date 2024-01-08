.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    addi a2, x0, 5
    add a0, x0, s0
    add a1, x0, s1
    addi a3, x0, 1
    addi a4, x0, 2
    # Call dot function
    jal ra, dot 


    # Print integer result
    add a1, x0, a0
    addi a0, x0, 1
    ecall

    # Print newline
    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall

    # Exit
    jal exit
