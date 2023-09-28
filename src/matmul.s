.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    addi sp sp -8
    sw ra 0(sp)
    sw s0 4(sp)

    mv s0 a0
    # Error checks
    li t0 1
    li a0 38
    blt a1 t0 exception
    blt a2 t0 exception
    blt a4 t0 exception
    blt a5 t0 exception
    bne a2 a4 exception
    # Prologue
    mv a0 s0
    li t0 0 #i=0
outer_loop_start:
    beq t0 a1 outer_loop_end
    li t1 0 # j=0
inner_loop_start:
    beq t1 a5 inner_loop_end
    
    li t2 0 # k=0
    li t3 0 # sum=0
loop_k:
    beq t2 a2 loop_k_end
    #sum+=m0[i][k]*m1[k][j]
    mul t4 t0 a2
    add t4 t4 t2
    slli t4 t4 2
    add t4 t4 a0
    lw t4 0(t4)
    mul t5 t2 a5
    add t5 t5 t1
    slli t5 t5 2
    add t5 t5 a3
    lw t5 0(t5)
    mul t4 t4 t5
    add t3 t3 t4
    addi t2 t2 1
    j loop_k
loop_k_end:
#d[i][[j]=sum
    mul t4 t0 a5
    add t4 t4 t1
    slli t4 t4 2
    add t4 t4 a6
    sw t3 0(t4)
    addi t1 t1 1
    j inner_loop_start
inner_loop_end:
    addi t0 t0 1
    j outer_loop_start
exception:
    call exit
outer_loop_end:


    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    addi sp sp 8

    jr ra
