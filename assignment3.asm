# As per the usual, no AI was used to create this, either for assistance or code completion.
# I found this MIPS Reference Sheet useful. https://github.com/TheIcyStar/MIPS-reference 

.data
    greeting:    .asciiz "This program generates and shuffles a deck of cards, then deals a deck of five."
    contPrompt:  .asciiz "Press ENTER to continue."
    cardDeck:    .space  260
    
    suitSize:	 .word	 13

.text
main:
    li $s0, 'H'
    li $s1, 'S'
    li $s2, 'C'
    li $s3, 'A'

    li $v0, 4
    la $a0, greeting
    syscall

    li $v0, 11
    la $a0, '\n'
    syscall

    # I used the following code as a way to implement the "Press ENTER to continue subroutine:
    # https://stackoverflow.com/questions/49722074/ddg#55756567
    jal continuePrompt
    
    jal generateDeck

    li $v0, 10
    syscall

generateDeck:
    
    #Initially adding 1 to $t1 for card numbers
    addi $t1, $zero, 1
   
    jal generateHearts
   
    # jal generateSpades
   
    # jal generateClubs
   
    # jal generateAces
   
    jr $ra
   
generateHearts:
    
    # Index will be $t0
    addi $t0, $zero, 0
    
    # Card Number will be $t1
    addi $t1, $t1, 1
    
    #stores card number as int
    sw $t1, cardDeck($t0)
    addi $t0, $t0, 4
    
    #Stores card suit as a char
    sw $s0, cardDeck($t0)
    addi $t0, $t0, 4
    
    jr $ra
    
    
   


generateSpades:


generateClubs:


generateAces:
    

shuffleDeck:


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
