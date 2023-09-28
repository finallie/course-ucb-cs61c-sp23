# .import utils.s
.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    
    mv s0 a0
    mv s1 x0
    mv s2 a1
    li t0 1
    bge a1 t0 loop_start
    li a0 36
    call exit
    
loop_start:
    beq s1 s2 loop_end
    slli t0 s1 2
    add t0 t0 s0
    lw t1 0(t0)
    bge t1 x0 loop_continue
    sw zero 0(t0)
loop_continue:
    addi s1 s1 1
    j loop_start
loop_end:


    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    addi sp sp 16
    jr ra
