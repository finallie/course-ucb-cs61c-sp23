.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -28
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    

    li t0 5
    bne a0 t0 wrong_args
    lw s1 4(a1) # m0
    lw s2 8(a1) # m1
    lw s3 12(a1) # input
    lw s4 16(a1) # output
    mv s0 a2
    # Read pretrained m0
    addi sp sp -8
    mv a0 s1
    mv a1 sp
    addi a2 sp 4
    call read_matrix
    mv s1 a0
    # Read pretrained m1
    addi sp sp -8
    mv a0 s2
    mv a1 sp
    addi a2 sp 4
    call read_matrix
    mv s2 a0
    # Read input matrix
    addi sp sp -8
    mv a0 s3
    mv a1 sp
    addi a2 sp 4
    call read_matrix
    mv s3 a0
    # Compute h = matmul(m0, input)
    lw a1 16(sp) #m0_r
    lw a5 4(sp)
    mul a0 a1 a5
    slli a0 a0 2
    call malloc
    beqz a0 malloc_fail
    
    mv s5 a0 # h
    
    mv a6 a0
    lw a1 16(sp) #m0_r
    lw a2 20(sp) #m0_c
    mv a0 s1
    mv a3 s3
    lw a4 0(sp)
    lw a5 4(sp)
    call matmul
    
    mv a0 s1
    call free
    mv a0 s3
    call free
    
    # Compute h = relu(h)
    mv a0 s5
    lw a1 16(sp)
    lw t0 4(sp)
    mul a1 a1 t0
    call relu

    # Compute o = matmul(m1, h)
    lw a1 8(sp) #m1_r
    lw a5 4(sp)
    mul a0 a1 a5
    slli a0 a0 2
    call malloc
    beqz a0 malloc_fail
    
    mv s1 a0 # o
    
    mv a6 a0
    lw a1 8(sp) #m1_r
    lw a2 12(sp) #m1_c
    mv a0 s2
    mv a3 s5
    lw a4 16(sp)
    lw a5 4(sp)
    call matmul
    
    mv a0 s2
    call free
    mv a0 s5
    call free

    # Write output matrix o
    mv a0 s4
    mv a1 s1
    lw a2 8(sp)
    lw a3 4(sp)
    call write_matrix


    # Compute and return argmax(o)
    mv a0 s1
    lw a2 8(sp)
    lw a3 4(sp)
    mul a1 a2 a3
    call argmax
    
    mv s2 a0
    
    mv a0 s1
    call free
    # If enabled, print argmax(o) and newline
    li t0 1
    beq t0 s0 finish
    mv a0 s2
    call print_int
    li a0 '\n'
    call print_char

finish:
    mv a0 s2
    
    addi sp sp 24
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    addi sp sp 28
    
    jr ra
wrong_args:
    li a0 31
    j exit
malloc_fail:
    li a0 26
    j exit