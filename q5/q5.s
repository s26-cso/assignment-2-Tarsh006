.section .rodata
f: .string "input.txt"
m: .string "r"
y: .string "Yes\n"
n: .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -48
    sd s5, 0(sp)
    sd ra, 40(sp)
    sd s1, 32(sp)
    sd s2, 24(sp)
    sd s3, 16(sp)
    sd s4,  8(sp)
    la a0, f
    la a1, m
    call fopen
    #now we have the files start pointer in a0 so we store it
    mv s1, a0
    mv   a0, s1
    li   a1, 0  #offset
    li   a2, 2  #to tell where one shall seek
    call fseek
    mv   a0, s1
    call ftell
    mv   s2, a0
    #we first put the pointer to eof using fseek
    #and then we use ftell to ask for its position relative to start
    #so now s2 has file size
    beq s2, zero, done #special case
    li s3, 0    #front pointer
    addi s4, s2, -1 #back pointer
loop:
    #if pointer cross or meet we good
    bge  s3, s4, done
    #first we pointer there with fseek and then kidnap it
    mv   a0, s1
    mv   a1, s3
    li   a2, 0
    call fseek
    mv   a0, s1
    call fgetc
    mv   s5, a0
    #same thing with end pointer
    mv   a0, s1
    mv   a1, s4
    li   a2, 0
    call fseek
    mv   a0, s1
    call fgetc  #back char sits in a0
    bne  s5, a0, nope
    #else we move on
    addi s3, s3, 1  # front++
    addi s4, s4, -1 # back--
    j loop
nope:
    la a0, n
    call printf
    j donee
done:
    la   a0, y
    call printf
donee:
    mv   a0, s1
    call fclose
    ld s5, 0(sp)
    ld ra, 40(sp)
    ld s1, 32(sp)
    ld s2, 24(sp)
    ld s3, 16(sp)
    ld s4,  8(sp)
    addi sp, sp, 48
    li a0, 0
    ret
