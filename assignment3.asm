# As per the usual, no AI was used to create this, either for assistance or code completion.
# I found this MIPS Reference Sheet useful. https://github.com/TheIcyStar/MIPS-reference 

.data
    cardDeck:    .space  416
    deckRange:	 .word	 51
    
    greeting:    .asciiz "This program generates and shuffles a deck of cards, then deals a deck of five."
    contPrompt:  .asciiz "Press ENTER to continue."
    
    genID:	 .word	1
    genSeed:	 .word	1235



.text
main:
    li $s0, 'H'
    li $s1, 'S'
    li $s2, 'C'
    li $s3, 'D'

    li $v0, 4
    la $a0, greeting
    syscall

    li $v0, 11
    la $a0, '\n'
    syscall
    
    # Index $t9 will increment
    addi $t9, $t9, 0
    
    # Setting $t7 to 0. It's the counter we'll be using for the shuffling logic
    addi $t7, $zero, 0

    # I used the following code as a way to implement the "Press ENTER to continue subroutine:
    # https://stackoverflow.com/questions/49722074/ddg#55756567
    jal continuePrompt
    
    jal generateDeck
    
    jal shuffleDeck

    j end
    
generateDeck:
    
    #Initially adding 1 to $t1 for card numbers since the first card starts at 1, not 0
    addi $t1, $zero, 1
    li $t0, 0
    
    #calling subroutines from subroutines causes an infinite loop of jumping because the $ra isn't preserved here.
    #I found this solution from https://stackoverflow.com/questions/15702910/nested-subroutine-calls-on-mips.
    move $s4, $ra
    
    #After each jal, the index is reset back to 1 for proper counting of each deck to 13.
    jal generateHearts
    addi $t1, $zero, 1
   
    jal generateSpades
    addi $t1, $zero, 1
   
    jal generateClubs
    addi $t1, $zero, 1
   
    jal generateDiamonds
    addi $t1, $zero, 1
   
    move $ra, $s4
    jr $ra
   
generateHearts:
    
    
    # Card Number will be $t1
    addi $t1, $t1, 1
    
    #stores card number as int
    #In trying to find a solution for storing ints and chars, I was looking for a way to combine the
    #suit and number into one array. I was considering using sb to store individual bytes, but thought that
    #might be putting too much on my plate so I decided to use 4 bytes per char instead. Big waste of space but
    #simpler for the scope of the project.
    sw $t1, cardDeck($t0)
    addi $t0, $t0, 4
    
    #Stores card suit as a char
    sw $s0, cardDeck($t0)
    addi $t0, $t0, 4
    

    ble $t1, 13, generateHearts
    
    jr $ra
   


generateSpades:

    # Card Number will be $t1
    addi $t1, $t1, 1
    
    #stores card number as int
    sw $t1, cardDeck($t0)
    addi $t0, $t0, 4
    
    #Stores card suit as a char
    sw $s1, cardDeck($t0)
    addi $t0, $t0, 4
    

    ble $t1, 13, generateSpades
    
    jr $ra


generateClubs:

    # Card Number will be $t1
    addi $t1, $t1, 1
    
    #stores card number as int
    sw $t1, cardDeck($t0)
    addi $t0, $t0, 4
    
    #Stores card suit as a char
    sw $s2, cardDeck($t0)
    addi $t0, $t0, 4
    

    ble $t1, 13, generateClubs
    
    jr $ra



generateDiamonds:

    # Card Number will be $t1
    addi $t1, $t1, 1
    
    #stores card number as int
    sw $t1, cardDeck($t0)
    addi $t0, $t0, 4
    
    #Stores card suit as a char
    sw $s3, cardDeck($t0)
    addi $t0, $t0, 4
    

    ble $t1, 13, generateDiamonds
    
    jr $ra
    
    

shuffleDeck:

    # Make an index of 0-52. Sll on that resulting value to get the multiple of 8, then swap the number value, and swap its suit (offset +4).
    beq $t7, 1000, shuffleEnd
    li $v0, 42
    li $a1, 52
    syscall
    move $t0, $a0
    
    li $v0, 42
    li $a1, 51
    syscall
    move $t1, $a0
    
    # Multiplies the index to a multiple of 8. Since there are 416 bytes in the array, this should be able to hit every value.
    sll $t0, $t0, 3
    sll $t1, $t1, 3
    
    # All the swaps we need here. Will loop until a counter on $t7 reaches 1000
    lw $t2, cardDeck($t0)
    lw $t3, cardDeck+4($t0)
    
    lw $t4, cardDeck($t1)
    lw $t5, cardDeck+4($t1)
    
    sw $t2, cardDeck($t1)
    sw $t3, cardDeck+4($t1)
    
    sw $t4, cardDeck($t0)
    sw $t5, cardDeck+4($t0)
    
    addi $t7, $t7, 1
    
    j shuffleDeck
	
shuffleEnd:

    jr $ra


dealCards:


continuePrompt:
    li $v0, 4
    la $a0, contPrompt
    syscall

    # When assembling via the CLI, there's a known issue where newline characters 
    # Cause the entire program to terminate due to an invalid char input. This issue
    # doesn't exist in the GUI, but was incredibly annoying and the fix wasn't worth
    # the implementation.
    li $v0, 12
    syscall

    move $t0, $v0

    li $v0, 11
    la $a0, '\n'
    syscall
      
    bne $t0, 10, continuePrompt

    jr $ra

end:
    li $v0, 10
    syscall