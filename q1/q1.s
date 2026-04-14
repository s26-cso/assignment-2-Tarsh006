.text
#all the functions:
.globl make_node
.globl insert
.globl get
.globl getAtMost
make_node:
    #we r gonna using another function so we need to store the ra for it to work
    #and we store val too obv.
    #stacks only grows by 16 bytes
    addi sp, sp, -16
    #we throw the ra in the newly created space and sincie it is only 8 bytes we also put the val there also
    sd ra, 0(sp)
    sd a0, 8(sp)
    #calling malloc to create space of 24 bytes
    li a0, 24
    call malloc
    #so a0 now has adress of our newly created space
    #he is backkkkk
    ld t0, 8(sp)
    #loading up the value in
    sw t0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)
    #we want to return adress and a0 already has a0
    ld ra, 0(sp)
    #returning the space back to stack
    addi sp, sp, 16
    ret
insert:
    #no matter we gonna use make node so we will have to store the ra and everything else for the
    #recursive thing
    addi sp, sp, -32
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd a1, 16(sp)
    #base case
    bne a0, zero, rec
    #moving val to a0 for make node
    mv a0, a1
    call make_node
    #getting ra back
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
rec:
    #recurisve
    #loading the current value & deciding whther i should go left or right
    lw t0, 0(a0)
    ble t0, a1, case0
    bgt t0, a1, case1
case0:
    #going right
    ld t1, 16(a0)
    beq t1, zero, case00
    beq zero, zero, case01
case00:
    #so nothing is there so we put something there and then kuch toh hota hai
    #-rohit sharma
    sd a0, 24(sp)
    mv a0, a1
    call make_node
    ld t2, 24(sp)
    sd a0, 16(t2)
    j kms

case01:
    #contnuing recursion
    ld a0, 16(a0)
    j rec

case1:
    #hard to port
    ld t1, 8(a0)
    beq t1, zero, case10
    beq zero, zero, case11

case10:
    sd a0, 24(sp)
    mv a0, a1
    call make_node
    ld t2, 24(sp)
    sd a0, 8(t2)
    j kms
case11:
    ld a0, 8(a0)
    j rec
kms:
    #restoring shite
    ld a0, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
get:
    #so insert-actually changing anything
    addi sp, sp, -32
    sd ra, 0(sp)
    sd a0, 8(sp)
    sd a1, 16(sp)
    bne a0, zero, idontknowanymorewords
    mv a0, zero
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
idontknowanymorewords:
    lw t0, 0(a0)
    blt t0, a1, starboard
    bgt t0, a1, port
    beq t0, a1, donk
starboard:
    ld t1, 16(a0)
    beq t1, zero, iamsodone
    ld a0, 16(a0)
    j idontknowanymorewords
port:
    ld t1, 8(a0)
    beq t1, zero, iamsodone
    ld a0, 8(a0)
    j idontknowanymorewords
iamsodone:
    mv a0, zero
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
donk:
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
getAtMost:
    #we just go through the thing binary searching while updating varaible when it is less then target
    addi sp, sp, -32
    sd ra, 0(sp)
    #we will use s1 as the variable
    sd s1, 24(sp)
    li s1, -1
    beq a1, zero, done
meow:
    lw t0, 0(a1)
    bgt t0, a0, southpaw
    #ngl got the idea of putting this here from ai or else i was about to make 10 functions to deal with this
    mv s1, t0
    #nothing is between two equal numbers
    #ra might disagree but i wouldnt know
    beq t0, a0, done
    ld t1, 16(a1)
    beq t1, zero, done
    mv a1, t1
    j meow
southpaw:
    # We go left (offset 8)
    ld t1, 8(a1)
    beq t1, zero, done
    mv a1, t1
    j meow
done:
    mv a0, s1
    ld s1, 24(sp)
    ld ra, 0(sp)
    addi sp, sp, 32
    ret
