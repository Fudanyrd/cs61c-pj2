.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    #                a0[3]      a0[4]     a0[5]        a0[6]
    # M0 -> s0: s1 * s2
    # INPUT -> s3: s2 * s4
    # hidden -> s5: s1 * s4
    # m1 -> s6: s7 * s1
    # scores -> s9: s7 * s4
    # s8 : the index of maximum value.

    addi t0, x0, 5
    bne a0, t0, err49
	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    # allocate memory for s1, s2, s4, s7.
    ## allocate for s1
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, err20
    add s1, a0, x0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ## allocate for s2
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, err20
    add s2, a0, x0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ## allocate for s4
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, err20
    add s4, a0, x0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ## allocate for s7
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    addi a0, x0, 4
    jal ra, malloc
    beq a0, x0, err20
    add s7, a0, x0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Load pretrained m0
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    addi t0, x0, 1
    slli t0, t0, 2
    # add a0, a1, t0
    add t2, a1, t0
    lw a0, 0(t2)
    add a1, s1, x0
    add a2, s2, x0
    jal ra, read_matrix
    add s0, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Load pretrained m1
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    addi t0, x0, 2
    slli t0, t0, 2
    # add a0, a1, t0
    add t2, a1, t0
    lw a0, 0(t2)
    add a1, s7, x0
    add a2, s1, x0
    jal ra, read_matrix
    add s6, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Load input matrix
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    addi t0, x0, 3
    slli t0, t0, 2
    # add a0, a1, t0
    add t2, a1, t0
    lw a0, 0(t2)
    add a1, s2, x0
    add a2, s4, x0
    jal ra, read_matrix
    add s3, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # Note: hidden -> s5
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    
    lw t1, 0(s1)
    lw t2, 0(s4)
    mul t0, t1, t2
    add a0, t0, x0
    jal ra, malloc
    beq a0, x0, err20
    add s5, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    add a0, s0, x0
    lw a1, 0(s1)
    lw a2, 0(s2)
    add a3, s3, x0
    lw a4, 0(s2)
    lw a5, 0(s4)
    add a6, s5, x0
    jal ra, matmul

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # Note: hidden -> s5 : s1 * s4
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    add a0, s5, x0
    lw t1, 0(s1)
    lw t2, 0(s4)
    mul a1, t1, t2
    jal ra, relu

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # Note: score -> s9 : s7 * s4
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    lw t1, 0(s7)
    lw t2, 0(s4)
    mul t0, t1, t2
    add a0, t0, x0
    jal ra, malloc
    beq a0, x0, err20
    add s9, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    add a0, s6, x0
    lw a1, 0(s7)
    lw a2, 0(s1)
    add a3, s5, x0
    lw a4, 0(s1)
    lw a5, 0(s4)
    add a6, s9, x0
    jal ra, matmul

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix -> s9: s7 * s4
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    addi t0, x0, 4
    slli t0, t0, 2
    # add a0, a1, t0
    add t2, a1, t0
    lw a0, 0(t2)
    add a1, s9, x0
    lw a2, 0(s7)
    lw a3, 0(s4)
    jal ra, write_matrix

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    
    add a0, s9, x0
    lw t1, 0(s7)
    lw t2, 0(s4)
    mul a1, t1, t2
    jal ra, argmax
    add s8, a0, x0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Print classification
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    
    addi a0, x0, 1
    add a1, s8, x0
    ecall

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Print newline afterwards for clarity
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)
    
    addi a0, x0, 11
    addi a1, x0, '\n'
    ecall

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    # Deallocate memory of s1, s2, s4, s7, s5, s0, s3, s9, s6
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw ra, 12(sp)

    add a0, s1, x0
    jal ra, free
    add a0, s2, x0
    jal ra, free
    add a0, s4, x0
    jal ra, free
    add a0, s7, x0
    jal ra, free
    add a0, s5, x0
    jal ra, free
    add a0, s0, x0
    jal ra, free
    add a0, s3, x0
    jal ra, free
    add a0, s9, x0
    jal ra, free
    add a0, s6, x0
    jal ra, free

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    add a0, s8, x0

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    addi sp, sp, 40
    ret
err49:
    addi a0, x0, 17
    addi a1, x0, 49
    ecall
err20:
    addi a0, x0, 17
    addi a1, x0, 20
    ecall