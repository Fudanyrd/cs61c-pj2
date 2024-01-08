.globl argmax
.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================

# pseudo c code:
# int argmax(int* a0, int a1) {
#     int t0 = 0;
#     int* s0 = a0;
#     while (t0 != a1) {
#         if (s0[a0] < s0[t0]) {
#             a0 = t0;
#         }
#         ++t0;
#     }
#     return a0;
# }
argmax:
    addi t0, x0, 1
    blt a1, t0, err
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw ra, 4(sp)
    add s0, a0, x0
loop_start:
    addi t0, x0, 0
    addi a0, x0, 0
loop_continue:
    beq t0, a1, loop_end
    # t1 = s0[a0]
    # t2 = s0[t0]
    slli t1, a0, 2
    add t1, s0, t1
    lw t1, 0(t1)
    slli t2, t0, 2
    add t2, s0, t2
    lw t2, 0(t2)
    blt t1, t2, modify
    addi t0, t0, 1
    jal x0, loop_continue
modify:
    add a0, t0, x0
    addi t0, t0, 1
    jal x0, loop_continue
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
err:
    addi a0, x0, 17
    addi a1, x0, 7
    ecall
    ret