.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)

    # Prologue
    mv s0 a0
    li a0 36
    li t0 1
    blt a2 t0 exception
    li a0 37
    blt a3 t0 exception
    blt a4 t0 exception
    mv a0 s0
    slli a3 a3 2
    slli a4 a4 2
    li s1 0
    j loop_start
loop_start:
    beq a2 zero loop_end
    lw t3 0(a0)
    lw t4 0(a1)
    mul t3 t3 t4
    add s1 s1 t3
    add a0 a0 a3
    add a1 a1 a4
    addi a2 a2 -1
    j loop_start
exception:
    call exit
loop_end:
    mv a0 s1

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    addi sp sp 12

    jr ra
