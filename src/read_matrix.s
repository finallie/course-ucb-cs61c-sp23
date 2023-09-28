.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)

    # Prologue
    mv s1 a1 # &rows
    mv s2 a2 # &columns
    li a1 0
    call fopen
    blt a0 zero fopen_fail
# read_row_num
    mv s0 a0 # s0 fd
    mv a1 s1
    li a2 4
    call fread
    li t0 4
    bne a0 t0 fread_fail
# read_column_num
    mv a0 s0
    mv a1 s2
    li a2 4
    call fread
    li t0 4
    bne a0 t0 fread_fail
# cal_size
    lw s3 0(s1) # s3=rows*coloums*4
    lw t0 0(s2)
    mul s3 t0 s3
    slli s3 s3 2
# malloc buffer
    mv a0 s3
    call malloc
    beqz a0 malloc_fail
    mv s4 a0 # s4=&buffer
# fill buffer
    mv a0 s0
    mv a1 s4
    mv a2 s3
    call fread
    bne a0 s3 fread_fail
# fclose
    mv a0 s0
    call fclose
    bnez a0 fclose_fail

    mv a0 s4
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24

    jr ra
fopen_fail:
    li a0 27
    j exit
malloc_fail:
    li a0 26
    j exit
fclose_fail:
    li a0 28
    j exit
fread_fail:
    li a0 29
    j exit