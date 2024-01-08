.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
# int dot(int* a0, int* a1, int a2, int a3, int a4) {
#     if (a2 < 1) {
#         exit(5);
#     } 
#     if(a3 < 1 || a4 < 1) {
#         exit(6);
#     }
#     int t0 = 0, t1 = 0;
#     while(t1 < a2) {
#         t0 += a0[t1 * a3] * a1[t1 * a4];
#         ++t1;
#     }
#     return t0;
# }
dot:
    addi t0, x0, 1
    blt a2, t0, err5
    blt a3, t0, err6
    blt a4, t0, err6
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    add s0, a0, x0
    add s1, a1, x0
    addi t0, x0, 0
    addi t1, x0, 0
loop_start:
    beq t1, a2, loop_end
    # t3 = s0[t1 * a3]
    mul t3, t1, a3
    slli t3, t3, 2
    add t3, s0, t3 
    lw t3, 0(t3)

    # t4 = s1[t1 * a4]
    mul t4, t1, a4
    slli t4, t4, 2
    add t4, s1, t4
    lw t4, 0(t4)
    # t2 = t3 * t4
    # t0 += t2
    mul t2, t3, t4
    add t0, t0, t2
    addi t1, t1, 1

    jal x0, loop_start
loop_end:

    add a0, t0, x0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp) 
    lw ra, 8(sp)
    addi sp, sp, -12
    ret
err5:
    addi a0, x0, 17
    addi a1, x0, 5
    ecall
err6:
    addi a0, x0, 17
    addi a1, x0, 6
    ecall