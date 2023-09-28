.import utils.s
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
    li t0 1
    blt a1 t0 l_exit

loop_start:








loop_continue:



loop_end:


    # Epilogue


    jr ra
l_exit:
    li a0 36
    call exit