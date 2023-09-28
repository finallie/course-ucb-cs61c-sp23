.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)

    # Prologue
    mv s1 a1
    mv s2 a2
    mv s3 a3
#fopen
    li a1 1
    call fopen
    blt a0 zero fopen_fail
    mv s0 a0
#fwrite
    addi sp sp -4
    
    sw s2 0(sp)
    mv a0 s0
    mv a1 sp
    li a2 1
    li a3 4
    call fwrite
    li a2 1
    bne a2 a0 fwrite_fail
    
    sw s3 0(sp)
    mv a0 s0
    mv a1 sp
    li a2 1
    li a3 4
    call fwrite
    li a2 1
    bne a2 a0 fwrite_fail
    
    addi sp sp 4
    
    mv a0 s0
    mv a1 s1
    mul s2 s2 s3
    mv a2 s2
    li a3 4
    call fwrite
    bne s2 a0 fwrite_fail
#fclose
    mv a0 s0
    call fclose
    bnez a0 fclose_fail


    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    addi sp sp 20

    jr ra
fopen_fail:
    li a0 27
    j exit
fclose_fail:
    li a0 28
    j exit
fwrite_fail:
    li a0 30
    j exit