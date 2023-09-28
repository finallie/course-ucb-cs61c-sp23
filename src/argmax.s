.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    
    # Prologue
    mv s0 a0
    mv s1 a1
    mv s2 zero
    li t0 1
    bge a1 t0 no_exception
    li a0 36
    call exit
no_exception:
    lw t1 0(s0)
    li a0 0
loop_start:
    beq s1 s2 loop_end
    slli t0 s2 2
    add t0 t0 s0
    lw t0 0(t0)
    bge t1 t0 loop_continue
    mv t1 t0
    mv a0 s2
loop_continue:
    addi s2 s2 1
    j loop_start
loop_end:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    addi sp sp 16
    jr ra
