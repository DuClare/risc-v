# this is a simple assembly program to test the rv32i hardware
# sum of 1 to 4, store to memory, load back
# expected: x1=10, x2=5, x3=5, x4=1, x5=10

addi x1, x0, 0      # x1 = 0        (sum)
addi x2, x0, 1      # x2 = 1        (counter)
addi x3, x0, 5      # x3 = 5        (limit)
addi x4, x0, 1      # x4 = 1        (increment)

# loop:
add  x1, x1, x2     # sum += counter
add  x2, x2, x4     # counter++
bne  x2, x3, -8     # if counter != limit, jump back 2 instructions

sw   x1, 0(x0)      # store sum to data memory address 0
lw   x5, 0(x0)      # load it back into x5
jal  x0, 0          # halt (jump to self)
